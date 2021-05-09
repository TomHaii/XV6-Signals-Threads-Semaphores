#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"

struct cpu cpus[NCPU];

struct proc proc[NPROC];

struct binSemaphore bsemaphores[MAX_BSEM];

struct proc *initproc;

int nextpid = 1;
int nexttid = 1;
int bsemid = 0;
struct spinlock pid_lock;
struct spinlock tid_lock;
//struct spinlock bsemid_lock;
extern void forkret(void);
static void freeproc(struct proc *p);
static void freethread(struct thread *tr);


extern char trampoline[]; // trampoline.S

// helps ensure that wakeups of wait()ing
// parents are not lost. helps obey the
// memory model when using p->parent.
// must be acquired before any p->lock.
struct spinlock wait_lock;

//struct spinlock join_lock;
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    struct thread *tr;
    for(tr = p->threads; tr < &p->threads[NTHREAD]; tr++){
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    int t_index = (int)(tr - p->threads);
    int p_index = (int)(p - proc); 
    uint64 va = KSTACK(p_index*NTHREAD + t_index);
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    }
  }
}

// initialize the proc table at boot time.
void
procinit(void)
{
  struct proc *p;
  initlock(&pid_lock, "nextpid");
  initlock(&tid_lock, "nexttid");
  initlock(&wait_lock, "wait_lock");
 // initlock(&bsemid_lock, "bsemid");
//  initlock(&join_lock, "join_lock");
  for(p = proc; p < &proc[NPROC]; p++) {
      initlock(&p->lock, "proc");
      struct thread* tr;
      for(tr = p->threads; tr < &p->threads[NTHREAD]; tr++) {
        int t_index = (int)(tr - p->threads);
        int p_index = (int)(p - proc); 
        tr->kstack = KSTACK(p_index*NTHREAD + t_index);
        initlock(&tr->lock, "thread");
      }
  }
}

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
  int id = r_tp();
  return id;
}

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
  int id = cpuid();
  struct cpu *c = &cpus[id];
  return c;
}

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
  push_off();
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
  pop_off();
  return p;
}

//Return the current struct thread*, or zero if none
struct thread*
mythread(void){
  push_off();
  struct cpu *c = mycpu();
  struct thread *tr = c->thread;
  pop_off();
  return tr;
}

int
allocpid() {
  int pid;
  
  acquire(&pid_lock);
  pid = nextpid;
  nextpid = nextpid + 1;
  release(&pid_lock);

  return pid;
}

int
alloctid(){
  int tid;
  
  acquire(&tid_lock);
  tid = nexttid;
  nexttid = nexttid + 1;

  release(&tid_lock);
  return tid;
}



//Allocate a new thread
static struct thread*
allocthread(struct proc *p)
{
  struct thread* tr;
  int found = 0;
  for(tr = p->threads; !found && tr < &p->threads[NTHREAD]; tr++) {
    acquire(&tr->lock);
    if(tr->state == TUNUSED) {
      found = 1;
      break;
    }
    else if (tr->state == TZOMBIE)
    {
      freethread(tr);
      found = 1;
      break;
    }
    else
      release(&tr->lock);

    // if(tr->state == ZOMBIE){
    //   found = 1;
    //   break;
    // }
  }

  if(found){
    tr->parent = p;
    tr->tid = alloctid();
   // printf("initatilzing thread %d tid %d\n", (tr-p->threads), tr->tid);
   // p->threads[tr - p->threads] = *tr;
    tr->state = TUSED;
    tr->killed = 0;

    //tr->trapframe = (struct trapframe*)(p->trapframes + (tr->index*sizeof(struct trapframe))); 
    // Set up new context to start executing at forkret,
    // which returns to user space.
    tr->trapframe = p->trapframes + ((tr - p->threads) * sizeof(struct trapframe));
   // tr->userTrapFrameBackup = p->trapframes + ((tr - p->threads) * sizeof(struct trapframe));
    memset(&(tr->context), 0, sizeof(tr->context));
    tr->context.ra = (uint64)forkret;
    tr->context.sp = tr->kstack + PGSIZE;
    release(&tr->lock);
    
    return tr;
  }
  else
  {
    return 0;
  }
}

// Look in the process table for an UNUSED proc.
// If found, initialize state required to run in the kernel,
// and return with p->lock held.
// If there are no free procs, or a memory allocation fails, return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  for(p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if(p->state == UNUSED) {
      goto found;
    } else {

      release(&p->lock);
    }
  }
  return 0;

found:
  p->pid = allocpid();
  p->state = USED;
  p->stopped = 0;

  // // Allocate a trapframe page.
  if((p->trapframes = kalloc()) == 0){
      freeproc(p);
      release(&p->lock);
      return 0;
  }

  for(int i = 0; i < NTHREAD;i++){
    p->threads[i].state = TUNUSED;
  }

   for(int i = 0; i < 32;i++){
    p->signalHandlers[i] = (void *)SIG_DFL;
    p->signalHandlersMasks[i] = 0;
  }
  p->pendingSignals= 0;
  p->pagetable = proc_pagetable(p);
  if(p->pagetable == 0){
    freeproc(p);
    release(&p->lock);
    return 0;
  }

  // tr = &p->threads[0];

  // if((tr = allocthread(p)) == 0){
  //   p->state = UNUSED;
  //   return 0;
  // }


  return p;
}

// free a proc structure and the data hanging from it,
// including user pages.
// p->lock must be held.
static void
freeproc(struct proc *p)
{
  if(p->trapframes)
    kfree((struct trapframe*)p->trapframes);
  p->trapframes = 0;
  if(p->pagetable)
    proc_freepagetable(p->pagetable, p->sz);
  p->pagetable = 0;
  p->sz = 0;
  p->pid = 0;
  p->parent = 0;
  p->name[0] = 0;
  p->killed = 0;
  p->xstate = 0;
  p->state = UNUSED;
}

// free a thread structure and the data hanging from it,
// p->lock must be held.
static void
freethread(struct thread *tr)
{
  tr->trapframe = 0;
  tr->userTrapFrameBackup = 0;
  tr->xstate = 0;
  tr->tid = 0;
  tr->parent = 0;
  tr->chan = 0;
  tr->killed = 0;
  tr->state = TUNUSED;
}


// Create a user page table for a given process,
// with no user memory, but with trampoline pages.
pagetable_t
proc_pagetable(struct proc *p)
{
  pagetable_t pagetable;

  // An empty page table.
  pagetable = uvmcreate();
  if(pagetable == 0)
    return 0;

  // map the trampoline code (for system call return)
  // at the highest user virtual address.
  // only the supervisor uses it, on the way
  // to/from user space, so not PTE_U.
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
              (uint64)trampoline, PTE_R | PTE_X) < 0){
    uvmfree(pagetable, 0);
    return 0;
  }
  // map the trapframe just below TRAMPOLINE, for trampoline.S.
  //for(struct thread* tr = p->threads; tr < &p->threads[NTHREAD]; tr++) {
    if(mappages(pagetable, TRAPFRAME, PGSIZE,
                (uint64)(p->trapframes), PTE_R | PTE_W) < 0){
      uvmunmap(pagetable, TRAMPOLINE, 1, 0);
      uvmfree(pagetable, 0);
      return 0;
    }
  //}

  return pagetable;
}

// Free a process's page table, and free the
// physical memory it refers to.
void
proc_freepagetable(pagetable_t pagetable, uint64 sz)
{
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
  uvmfree(pagetable, sz);
}

// a user program that calls exec("/init")
// od -t xC initcode
uchar initcode[] = {
  0x17, 0x05, 0x00, 0x00, 0x13, 0x05, 0x45, 0x02,
  0x97, 0x05, 0x00, 0x00, 0x93, 0x85, 0x35, 0x02,
  0x93, 0x08, 0x70, 0x00, 0x73, 0x00, 0x00, 0x00,
  0x93, 0x08, 0x20, 0x00, 0x73, 0x00, 0x00, 0x00,
  0xef, 0xf0, 0x9f, 0xff, 0x2f, 0x69, 0x6e, 0x69,
  0x74, 0x00, 0x00, 0x24, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00
};

// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  struct thread* t;
  p = allocproc();
  t = allocthread(p);
  initproc = p;
  
  // allocate one user page and copy init's instructions
  // and data into it.
  uvminit(p->pagetable, initcode, sizeof(initcode));
  p->sz = PGSIZE;
  acquire(&t->lock);
  // prepare for the very first "return" from kernel to user.
  t->trapframe->epc = 0;      // user program counter
  t->trapframe->sp = PGSIZE;  // user stack pointer
  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");
 // p->state = RUNNABLE;
  t->state = TRUNNABLE;
  release(&t->lock);

  release(&p->lock);
}

// Grow or shrink user memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *p = myproc();
  sz = p->sz;
  if(n > 0){
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
      return -1;
    }
  } else if(n < 0){
    sz = uvmdealloc(p->pagetable, sz, sz + n);
  }
  p->sz = sz;
  return 0;
}

// Create a new process, copying the parent.
// Sets up child kernel stack to return as if from fork() system call.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct thread *nt;
  struct proc *p = myproc();
  struct thread *t = mythread();
  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }
  //Allocate thread.
  if((nt = allocthread(np)) == 0){
    return -1;
  }
  
  //np->threads[0]=*nt;
  // Copy user memory from parent to child.
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    freeproc(np);
    freethread(nt);

    release(&np->lock);
    return -1;
  }
  np->sz = p->sz;
  np->signalMask = p->signalMask;
  for (int i = 0; i < 32; i++)
  {
    np->signalHandlers[i] = p->signalHandlers[i];
  }

  // copy saved user registers.
  *(nt->trapframe) = *(t->trapframe);
  

 // np->trapframes = p->trapframes;

  // Cause fork to return 0 in the child.
  //np->trapframe->a0 = 0;
  nt->trapframe->a0 = 0;

  // increment reference counts on open file descriptors.
  for(i = 0; i < NOFILE; i++)
    if(p->ofile[i])
      np->ofile[i] = filedup(p->ofile[i]);
  np->cwd = idup(p->cwd);

  safestrcpy(np->name, p->name, sizeof(p->name));
  pid = np->pid;

  release(&np->lock); 

  acquire(&wait_lock);
  np->parent = p;

  release(&wait_lock);

  acquire(&np->lock);
  acquire(&nt->lock);
  nt->state = TRUNNABLE;
  nt->parent = np;
  release(&nt->lock);
  release(&np->lock);
 // printf("done forking tid %d pid %d\n", nt->tid, pid);
  return pid;
}

// Pass p's abandoned children to init.
// Caller must hold wait_lock.
void
reparent(struct proc *p)
{
  struct proc *pp;

  for(pp = proc; pp < &proc[NPROC]; pp++){
    if(pp->parent == p){
      pp->parent = initproc;
      wakeup(initproc);
    }
  }
}

//Sigprocmask system call
uint
sigprocmask(uint mask)
{
  struct proc *p = myproc();
  acquire(&p->lock);
  uint old_mask = p->signalMask;
  p->signalMask = mask;
  release(&p->lock);
  return old_mask;

}

//Sigaction system call
int 
sigaction(int signum, uint64 act, uint64 oldact)
{
  // if(act == 0)
  //   return -1;
  struct proc* p = myproc();
  int sigmask;
  void* handler;
  if(copyin(p->pagetable, (char*)&handler, act, sizeof(void*)) < 0) {
    return -1;
  }
  if(copyin(p->pagetable, (char*)&sigmask, act + sizeof(void*), sizeof(int)) < 0) {
    return -1;
  }
  if(act == 0 || sigmask < 0 || signum == SIGKILL || signum == SIGSTOP || (sigmask & (1 << SIGKILL)) || (sigmask & (1 << SIGSTOP)))
    return -1;

  if(oldact != 0)
  {
    if(copyout(p->pagetable, oldact, (char*)&p->signalHandlers[signum], sizeof(void*)) < 0){
      return -1;
    }
    if(copyout(p->pagetable, oldact + sizeof(void*), (char*)&p->signalHandlersMasks[signum], sizeof(uint)) < 0){
      return -1;
    }
  }
  acquire(&p->lock);
  p->signalHandlers[signum] = (void*)handler;
  p->signalHandlersMasks[signum] = sigmask;
  release(&p->lock);
  return 0;
}

//Sigret
void
sigret(void){
    struct proc *p = myproc();
    struct thread *t = mythread();
    copyin(p->pagetable, (char*)t->trapframe, (uint64)t->userTrapFrameBackup, sizeof(struct trapframe));
 //  copyout(p->pagetable, (uint64)p->trapframe, (char *)&p->userTrapFrameBackup->sp, sizeof(struct trapframe));
   //   memmove((void*)p->trapframe, (void*)p->userTrapFrameBackup->sp, sizeof(struct trapframe));
  //  t->trapframe->sp += sizeof(struct trapframe);
  //  p->userTrapFrameBackup = 0;
    p->signalMask = p->oldSignalMask;
    p->handlesUserSignalHandler = 0;
}


//SIGKILL handler
void 
SIGKILL_handler(struct proc * p)
{
  p->killed = 1;
}

void
SIGSTOP_handler(struct proc * p)
{  
  // p->stopped = 1;
  // while (((p->pendingSignals & (1 << SIGCONT)) == 0) && p->stopped){
  //   if(p->pendingSignals & (1 << SIGKILL))
  //     break;
  //   yield();
  // }

    p->stopped=1;
    while(((p->pendingSignals&(1<<SIGCONT))==0) && p->stopped){
        yield();
      }
    p->stopped=0;
    p->pendingSignals &= ~(1 << SIGSTOP);
    p->pendingSignals &= ~(1 << SIGCONT);
//      }   
}


//SIGCONT handler
void
SIGCONT_handler(struct proc * p)
{
  if(p->stopped){
    p->stopped = 0;
    p->pendingSignals &= ~(1 << SIGCONT);
  }
}


void
killOtherThreads(){
  struct proc *p = myproc();
  struct thread* t = mythread();
  int threadStillAlive;
 // acquire(&p->lock);
  if(t->killed) {
   // wakeup(t->parent);
    wakeup(t);
    t->state = DYING;
  //  release(&t->lock);
    acquire(&t->lock);
    sched();
  }
  else {
    for(struct thread* tr = p->threads;tr < &p->threads[NTHREAD]; tr++) {
      acquire(&tr->lock);
      if(tr->tid != t->tid){
        tr->killed = 1;
      }
      release(&tr->lock);
    }
  }
  //release(&p->lock);

  for(;;){
    threadStillAlive = 0;
    //acquire(&p->lock);
    for(struct thread* tr = p->threads;tr < &p->threads[NTHREAD]; tr++) {
      if(tr->tid != t->tid && tr->state != TUNUSED && tr->state != DYING && tr->state != TZOMBIE){
        threadStillAlive = 1;
      }
    }
    //release(&p->lock);
    if(threadStillAlive){
      yield();
    }
    else
      return;
  }
}

//Kill Current Running Thread
void
killCurThread()
{
 // acquire(&myproc()->lock);
  struct thread* t = mythread();
    //  wakeup(t->parent);
  wakeup(t);

 // wakeup(t);
  acquire(&t->lock);
  t->state = DYING;
  //t->state = TZOMBIE;
  sched();
}

int
kthread_create(void (* start_func)(), void *stack){
  if(stack == 0)
    return -1;
  struct proc* p = myproc();
  int tid;
  acquire(&p->lock);
  struct thread* t;
  if((t = allocthread(p)) == 0){
    release(&p->lock);
    return -1;
  }
  release(&p->lock);

  acquire(&t->lock);  
  *(t->trapframe) = *(mythread()->trapframe);
  t->trapframe->epc = (uint64)(start_func);
  t->trapframe->sp = (uint64)stack + MAX_STACK_SIZE - 16;
  t->state = TRUNNABLE;
  tid = t->tid;
  //printf("finished making thread\n");
  release(&t->lock);


  return tid;
}

int
kthread_id(){
  struct thread* t = mythread();
  if(!t->tid)
    return -1;
  return t->tid;
}

void
kthread_exit(int status){
  struct thread* t = mythread();
  struct proc* p = myproc();

  acquire(&t->lock);
  int threadStillAlive = 0;
    for(struct thread* tr = p->threads;tr < &p->threads[NTHREAD]; tr++) {
      if(tr->tid != t->tid && tr->state != TUNUSED && tr->state != DYING && tr->state != TZOMBIE){
        //printf("DEBUG tid %d, STATE %d\n", tr->tid, tr->state);
        threadStillAlive = 1;
        break;
      }
    }
    t->xstate = status;
    if(threadStillAlive){
      t->state = TZOMBIE;
      release(&t->lock);
      wakeup(t);
      acquire(&t->lock);
      sched();
    }
    else {
      release(&t->lock);
      exit(status);
    }
}

int             
kthread_join(int thread_id, int* status) {
  struct proc* p = myproc();
  struct thread* cr = mythread();
  int foundThread = 0;

  if(thread_id == cr->tid)
    return -1;
  
  //look for the thread we want to join with
  struct thread* t;
  for(t = p->threads; t < &p->threads[NTHREAD]; t++){
    acquire(&t->lock);
    if(t->tid == thread_id && t->state != DYING && t->state != TUNUSED){
      foundThread = 1;
      break;
    }
    release(&t->lock);
  }

  //didn't found the thread to join with
  if(!foundThread)
    return -1;
  

  while(t->tid == thread_id && t->state != TUNUSED && t->state != TZOMBIE){
    sleep(t, &t->lock);
  }


  if(status != 0 && copyout(p->pagetable, (uint64)status, (char *)&t->xstate, sizeof(int)) < 0){
    release(&t->lock);
    return -1;
  }
  //*stat = t->xstate;
  if(t->state == TZOMBIE)
    freethread(t);
  
  release(&t->lock);
  return 0;
}

int
bsem_alloc() {

  int free_id = -1;
  for(int i = 0; i < MAX_BSEM; i++){
    if(!bsemaphores[i].active)
      free_id = i;
  }
  
  if(free_id == -1)
    return -1;
  
  initlock(&bsemaphores[free_id].lock, "bsem_lock");
  
  acquire(&bsemaphores[free_id].lock);
  bsemaphores[free_id].active = 1;
  bsemaphores[free_id].value = 1;
  release(&bsemaphores[free_id].lock);


  return free_id;
}

void
bsem_free(int descriptor) {

  acquire(&bsemaphores[descriptor].lock);
  bsemaphores[descriptor].active = 0;
  bsemaphores[descriptor].value = 1;
  release(&bsemaphores[descriptor].lock);
}

void
bsem_down(int descriptor) {
  acquire(&bsemaphores[descriptor].lock);
  while(bsemaphores[descriptor].value == 0){
    sleep(&bsemaphores[descriptor], &bsemaphores[descriptor].lock);
  }
  bsemaphores[descriptor].value = 0;
  release(&bsemaphores[descriptor].lock);
}


void
bsem_up(int descriptor) {
  acquire(&bsemaphores[descriptor].lock);
  bsemaphores[descriptor].value = 1;
  release(&bsemaphores[descriptor].lock);  
  wakeup(&bsemaphores[descriptor]);
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait().
void
exit(int status)
{
  struct proc *p = myproc();
  killOtherThreads();
  if(p == initproc)
    panic("init exiting");
  // Close all open files.
  for(int fd = 0; fd < NOFILE; fd++){
    if(p->ofile[fd]){
      struct file *f = p->ofile[fd];
      fileclose(f);
      p->ofile[fd] = 0;
    }
  }
  begin_op();
  iput(p->cwd);
  end_op();
  p->cwd = 0;
  acquire(&wait_lock);
  // Give any children to init.
  reparent(p);

  // Parent might be sleeping in wait().
  wakeup(p->parent);
  
  acquire(&p->lock);
  
  p->xstate = status;
  acquire(&mythread()->lock);
  mythread()->state = DYING;
//  release(&mythread()->lock);
  
  p->state = ZOMBIE;
  release(&p->lock);
  release(&wait_lock);

  // Jump into the scheduler, never to return.
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(uint64 addr)
{
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();
  struct thread * t;

  acquire(&wait_lock);

  for(;;){

    // Scan through table looking for exited children.
    havekids = 0;
    for(np = proc; np < &proc[NPROC]; np++){
      if(np->parent == p){
        // make sure the child isn't still in exit() or swtch().
        acquire(&np->lock);
        havekids = 1;
        if(np->state == ZOMBIE){
          // Found one.
          pid = np->pid;
          for(t = np->threads; t < &np->threads[NTHREAD]; t++)
            freethread(t);
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
                                  sizeof(np->xstate)) < 0) {

            release(&np->lock);
            release(&wait_lock);
            return -1;
          }
          freeproc(np);
          release(&np->lock);
          release(&wait_lock);
          return pid;
        }
        release(&np->lock);
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || p->killed){
      release(&wait_lock);
      return -1;
    }
                 // printf("Waiting address %d\n", addr);

    // Wait for a child to exit.
  // printf("go to sleep loser %d\n",p);
    sleep(p, &wait_lock);  //DOC: wait-sleep
  }
}

// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run.
//  - swtch to start running that process.
//  - eventually that process transfers control
//    via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  c->thread = 0;
  for(;;){
    // Avoid deadlock by ensuring that devices can interrupt.
    intr_on();
    for(p = proc; p < &proc[NPROC]; p++) {
        //procdump();
      //acquire(&p->lock);
      if(p->state == USED) {
        struct thread *tr;
      //  printf("proc pid %d state %d\n", p->pid,p->state);
        // Switch to chosen process.  It is the process's job
        // to release its lock and then reacquire it
        // before jumping back to us.
        // if(p->stopped)
        //   continue;
        // int foundRunnableThread = 0;
        for(tr = p->threads;tr < &p->threads[NTHREAD]; tr++) {
          //if(tr->state != TUNUSED)  
          acquire(&tr->lock);
          if(tr->state == TRUNNABLE){
            // printf("thread tid %d thread index in process %d\n", tr->tid,(tr - p->threads));
            // foundRunnableThread = 1;
            tr->state = TRUNNING;
            //   p->state = RUNNING;
            c->thread = tr;
            c->proc = p;
            swtch(&c->context, &tr->context);
            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->thread = 0;
            c->proc = 0;
            release(&tr->lock);
          } else
            release(&tr->lock);
        }
      }
      //release(&p->lock);
    }
  }
}

// Switch to scheduler.  Must hold only p->lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct thread *t = mythread();
  //struct proc *p = myproc();
  if(!holding(&t->lock))
    panic("sched p->lock");
  if(mycpu()->noff != 1)
    panic("sched locks");
  if(t->state == TRUNNING)
    panic("sched running");
  if(intr_get())
    panic("sched interruptible");

  intena = mycpu()->intena;
  swtch(&t->context, &mycpu()->context);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
 // struct proc *p = myproc();
  struct thread *tr = mythread();
  acquire(&tr->lock);
// p->state = RUNNABLE;
  tr->state = TRUNNABLE;
  sched();

  release(&tr->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
  static int first = 1;
  // Still holding p->lock from scheduler.
  release(&mythread()->lock);
  if (first) {
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }
  usertrapret();
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  //printf("hi chan:%d    proc:%d    tr:%d\n",chan,myproc(),mythread());
  //struct proc *p = myproc();
  struct thread *t = mythread();
  // Must acquire p->lock in order to
  // change p->state and then call sched.
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.
  acquire(&t->lock);  //DOC: sleeplock1
  release(lk);
  // Go to sleep.
  t->chan = chan;
  t->state = TSLEEPING;
  sched();
  // Tidy up.
  t->chan = 0;
  // Reacquire original lock.
  release(&t->lock);
  acquire(lk);
}


// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
  struct proc *p;
  struct thread *tr;
  for(p = proc; p < &proc[NPROC]; p++) {
      acquire(&p->lock);
      for(tr = p->threads;tr < &p->threads[NTHREAD]; tr++) {
        acquire(&tr->lock);
        
        if(tr->state == TSLEEPING && tr->chan == chan) {
          tr->state = TRUNNABLE;
        }
        release(&tr->lock);
      }
      release(&p->lock);
    }
}

int
kill(int pid, int signum)
{
  if (signum < 0 || signum > 31)
  {
    return -1;
  }
  struct proc *p;
  struct thread *t;

  for(p = proc; p < &proc[NPROC]; p++){
    acquire(&p->lock);
    if(p->pid == pid){
      p->pendingSignals = p->pendingSignals | (1 << signum);
      if(signum == SIGKILL || (p->signalHandlers[signum] == (void*)SIGKILL && ((p->signalMask & (1 << signum)) == 0))) {
        p->killed = 1;
      //Wake process from sleep if necessary.
      for(t = p->threads; t < &p->threads[NTHREAD]; t++){
        acquire(&t->lock);
        if(t->state == TSLEEPING){
          t->state = TRUNNABLE;
        }
        release(&t->lock);
        }
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
  }
  return -1;
}



// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
  struct proc *p = myproc();
  if(user_dst){
    return copyout(p->pagetable, dst, src, len);
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
  struct proc *p = myproc();
  if(user_src){
    return copyin(p->pagetable, dst, src, len);
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [USED]  "used",
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    printf("%d %s %s", p->pid, state, p->name);
    printf("\n");
  }
}
