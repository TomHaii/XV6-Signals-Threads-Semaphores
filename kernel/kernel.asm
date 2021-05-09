
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	18010113          	addi	sp,sp,384 # 8000a180 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	ra,8000008e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	95b2                	add	a1,a1,a2
    80000046:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00269713          	slli	a4,a3,0x2
    8000004c:	9736                	add	a4,a4,a3
    8000004e:	00371693          	slli	a3,a4,0x3
    80000052:	0000a717          	auipc	a4,0xa
    80000056:	fee70713          	addi	a4,a4,-18 # 8000a040 <timer_scratch>
    8000005a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005e:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000060:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000064:	00007797          	auipc	a5,0x7
    80000068:	d3c78793          	addi	a5,a5,-708 # 80006da0 <timervec>
    8000006c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000070:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000074:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000078:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000080:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000084:	30479073          	csrw	mie,a5
}
    80000088:	6422                	ld	s0,8(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffb97ff>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	dcc78793          	addi	a5,a5,-564 # 80000e7a <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d4:	10479073          	csrw	sie,a5
  timerinit();
    800000d8:	00000097          	auipc	ra,0x0
    800000dc:	f44080e7          	jalr	-188(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000e0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000e4:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000e6:	823e                	mv	tp,a5
  asm volatile("mret");
    800000e8:	30200073          	mret
}
    800000ec:	60a2                	ld	ra,8(sp)
    800000ee:	6402                	ld	s0,0(sp)
    800000f0:	0141                	addi	sp,sp,16
    800000f2:	8082                	ret

00000000800000f4 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000f4:	715d                	addi	sp,sp,-80
    800000f6:	e486                	sd	ra,72(sp)
    800000f8:	e0a2                	sd	s0,64(sp)
    800000fa:	fc26                	sd	s1,56(sp)
    800000fc:	f84a                	sd	s2,48(sp)
    800000fe:	f44e                	sd	s3,40(sp)
    80000100:	f052                	sd	s4,32(sp)
    80000102:	ec56                	sd	s5,24(sp)
    80000104:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000106:	04c05663          	blez	a2,80000152 <consolewrite+0x5e>
    8000010a:	8a2a                	mv	s4,a0
    8000010c:	84ae                	mv	s1,a1
    8000010e:	89b2                	mv	s3,a2
    80000110:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000112:	5afd                	li	s5,-1
    80000114:	4685                	li	a3,1
    80000116:	8626                	mv	a2,s1
    80000118:	85d2                	mv	a1,s4
    8000011a:	fbf40513          	addi	a0,s0,-65
    8000011e:	00003097          	auipc	ra,0x3
    80000122:	03e080e7          	jalr	62(ra) # 8000315c <either_copyin>
    80000126:	01550c63          	beq	a0,s5,8000013e <consolewrite+0x4a>
      break;
    uartputc(c);
    8000012a:	fbf44503          	lbu	a0,-65(s0)
    8000012e:	00000097          	auipc	ra,0x0
    80000132:	77a080e7          	jalr	1914(ra) # 800008a8 <uartputc>
  for(i = 0; i < n; i++){
    80000136:	2905                	addiw	s2,s2,1
    80000138:	0485                	addi	s1,s1,1
    8000013a:	fd299de3          	bne	s3,s2,80000114 <consolewrite+0x20>
  }

  return i;
}
    8000013e:	854a                	mv	a0,s2
    80000140:	60a6                	ld	ra,72(sp)
    80000142:	6406                	ld	s0,64(sp)
    80000144:	74e2                	ld	s1,56(sp)
    80000146:	7942                	ld	s2,48(sp)
    80000148:	79a2                	ld	s3,40(sp)
    8000014a:	7a02                	ld	s4,32(sp)
    8000014c:	6ae2                	ld	s5,24(sp)
    8000014e:	6161                	addi	sp,sp,80
    80000150:	8082                	ret
  for(i = 0; i < n; i++){
    80000152:	4901                	li	s2,0
    80000154:	b7ed                	j	8000013e <consolewrite+0x4a>

0000000080000156 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000156:	7159                	addi	sp,sp,-112
    80000158:	f486                	sd	ra,104(sp)
    8000015a:	f0a2                	sd	s0,96(sp)
    8000015c:	eca6                	sd	s1,88(sp)
    8000015e:	e8ca                	sd	s2,80(sp)
    80000160:	e4ce                	sd	s3,72(sp)
    80000162:	e0d2                	sd	s4,64(sp)
    80000164:	fc56                	sd	s5,56(sp)
    80000166:	f85a                	sd	s6,48(sp)
    80000168:	f45e                	sd	s7,40(sp)
    8000016a:	f062                	sd	s8,32(sp)
    8000016c:	ec66                	sd	s9,24(sp)
    8000016e:	e86a                	sd	s10,16(sp)
    80000170:	1880                	addi	s0,sp,112
    80000172:	8aaa                	mv	s5,a0
    80000174:	8a2e                	mv	s4,a1
    80000176:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000178:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000017c:	00012517          	auipc	a0,0x12
    80000180:	00450513          	addi	a0,a0,4 # 80012180 <cons>
    80000184:	00001097          	auipc	ra,0x1
    80000188:	a46080e7          	jalr	-1466(ra) # 80000bca <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000018c:	00012497          	auipc	s1,0x12
    80000190:	ff448493          	addi	s1,s1,-12 # 80012180 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000194:	00012917          	auipc	s2,0x12
    80000198:	08490913          	addi	s2,s2,132 # 80012218 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    8000019c:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000019e:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001a0:	4ca9                	li	s9,10
  while(n > 0){
    800001a2:	07305863          	blez	s3,80000212 <consoleread+0xbc>
    while(cons.r == cons.w){
    800001a6:	0984a783          	lw	a5,152(s1)
    800001aa:	09c4a703          	lw	a4,156(s1)
    800001ae:	02f71463          	bne	a4,a5,800001d6 <consoleread+0x80>
      if(myproc()->killed){
    800001b2:	00002097          	auipc	ra,0x2
    800001b6:	8b4080e7          	jalr	-1868(ra) # 80001a66 <myproc>
    800001ba:	4d5c                	lw	a5,28(a0)
    800001bc:	e7b5                	bnez	a5,80000228 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001be:	85a6                	mv	a1,s1
    800001c0:	854a                	mv	a0,s2
    800001c2:	00002097          	auipc	ra,0x2
    800001c6:	692080e7          	jalr	1682(ra) # 80002854 <sleep>
    while(cons.r == cons.w){
    800001ca:	0984a783          	lw	a5,152(s1)
    800001ce:	09c4a703          	lw	a4,156(s1)
    800001d2:	fef700e3          	beq	a4,a5,800001b2 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001d6:	0017871b          	addiw	a4,a5,1
    800001da:	08e4ac23          	sw	a4,152(s1)
    800001de:	07f7f713          	andi	a4,a5,127
    800001e2:	9726                	add	a4,a4,s1
    800001e4:	01874703          	lbu	a4,24(a4)
    800001e8:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800001ec:	077d0563          	beq	s10,s7,80000256 <consoleread+0x100>
    cbuf = c;
    800001f0:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001f4:	4685                	li	a3,1
    800001f6:	f9f40613          	addi	a2,s0,-97
    800001fa:	85d2                	mv	a1,s4
    800001fc:	8556                	mv	a0,s5
    800001fe:	00003097          	auipc	ra,0x3
    80000202:	f02080e7          	jalr	-254(ra) # 80003100 <either_copyout>
    80000206:	01850663          	beq	a0,s8,80000212 <consoleread+0xbc>
    dst++;
    8000020a:	0a05                	addi	s4,s4,1
    --n;
    8000020c:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    8000020e:	f99d1ae3          	bne	s10,s9,800001a2 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000212:	00012517          	auipc	a0,0x12
    80000216:	f6e50513          	addi	a0,a0,-146 # 80012180 <cons>
    8000021a:	00001097          	auipc	ra,0x1
    8000021e:	a6a080e7          	jalr	-1430(ra) # 80000c84 <release>

  return target - n;
    80000222:	413b053b          	subw	a0,s6,s3
    80000226:	a811                	j	8000023a <consoleread+0xe4>
        release(&cons.lock);
    80000228:	00012517          	auipc	a0,0x12
    8000022c:	f5850513          	addi	a0,a0,-168 # 80012180 <cons>
    80000230:	00001097          	auipc	ra,0x1
    80000234:	a54080e7          	jalr	-1452(ra) # 80000c84 <release>
        return -1;
    80000238:	557d                	li	a0,-1
}
    8000023a:	70a6                	ld	ra,104(sp)
    8000023c:	7406                	ld	s0,96(sp)
    8000023e:	64e6                	ld	s1,88(sp)
    80000240:	6946                	ld	s2,80(sp)
    80000242:	69a6                	ld	s3,72(sp)
    80000244:	6a06                	ld	s4,64(sp)
    80000246:	7ae2                	ld	s5,56(sp)
    80000248:	7b42                	ld	s6,48(sp)
    8000024a:	7ba2                	ld	s7,40(sp)
    8000024c:	7c02                	ld	s8,32(sp)
    8000024e:	6ce2                	ld	s9,24(sp)
    80000250:	6d42                	ld	s10,16(sp)
    80000252:	6165                	addi	sp,sp,112
    80000254:	8082                	ret
      if(n < target){
    80000256:	0009871b          	sext.w	a4,s3
    8000025a:	fb677ce3          	bgeu	a4,s6,80000212 <consoleread+0xbc>
        cons.r--;
    8000025e:	00012717          	auipc	a4,0x12
    80000262:	faf72d23          	sw	a5,-70(a4) # 80012218 <cons+0x98>
    80000266:	b775                	j	80000212 <consoleread+0xbc>

0000000080000268 <consputc>:
{
    80000268:	1141                	addi	sp,sp,-16
    8000026a:	e406                	sd	ra,8(sp)
    8000026c:	e022                	sd	s0,0(sp)
    8000026e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000270:	10000793          	li	a5,256
    80000274:	00f50a63          	beq	a0,a5,80000288 <consputc+0x20>
    uartputc_sync(c);
    80000278:	00000097          	auipc	ra,0x0
    8000027c:	55e080e7          	jalr	1374(ra) # 800007d6 <uartputc_sync>
}
    80000280:	60a2                	ld	ra,8(sp)
    80000282:	6402                	ld	s0,0(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000288:	4521                	li	a0,8
    8000028a:	00000097          	auipc	ra,0x0
    8000028e:	54c080e7          	jalr	1356(ra) # 800007d6 <uartputc_sync>
    80000292:	02000513          	li	a0,32
    80000296:	00000097          	auipc	ra,0x0
    8000029a:	540080e7          	jalr	1344(ra) # 800007d6 <uartputc_sync>
    8000029e:	4521                	li	a0,8
    800002a0:	00000097          	auipc	ra,0x0
    800002a4:	536080e7          	jalr	1334(ra) # 800007d6 <uartputc_sync>
    800002a8:	bfe1                	j	80000280 <consputc+0x18>

00000000800002aa <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002aa:	1101                	addi	sp,sp,-32
    800002ac:	ec06                	sd	ra,24(sp)
    800002ae:	e822                	sd	s0,16(sp)
    800002b0:	e426                	sd	s1,8(sp)
    800002b2:	e04a                	sd	s2,0(sp)
    800002b4:	1000                	addi	s0,sp,32
    800002b6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002b8:	00012517          	auipc	a0,0x12
    800002bc:	ec850513          	addi	a0,a0,-312 # 80012180 <cons>
    800002c0:	00001097          	auipc	ra,0x1
    800002c4:	90a080e7          	jalr	-1782(ra) # 80000bca <acquire>

  switch(c){
    800002c8:	47d5                	li	a5,21
    800002ca:	0af48663          	beq	s1,a5,80000376 <consoleintr+0xcc>
    800002ce:	0297ca63          	blt	a5,s1,80000302 <consoleintr+0x58>
    800002d2:	47a1                	li	a5,8
    800002d4:	0ef48763          	beq	s1,a5,800003c2 <consoleintr+0x118>
    800002d8:	47c1                	li	a5,16
    800002da:	10f49a63          	bne	s1,a5,800003ee <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002de:	00003097          	auipc	ra,0x3
    800002e2:	eda080e7          	jalr	-294(ra) # 800031b8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002e6:	00012517          	auipc	a0,0x12
    800002ea:	e9a50513          	addi	a0,a0,-358 # 80012180 <cons>
    800002ee:	00001097          	auipc	ra,0x1
    800002f2:	996080e7          	jalr	-1642(ra) # 80000c84 <release>
}
    800002f6:	60e2                	ld	ra,24(sp)
    800002f8:	6442                	ld	s0,16(sp)
    800002fa:	64a2                	ld	s1,8(sp)
    800002fc:	6902                	ld	s2,0(sp)
    800002fe:	6105                	addi	sp,sp,32
    80000300:	8082                	ret
  switch(c){
    80000302:	07f00793          	li	a5,127
    80000306:	0af48e63          	beq	s1,a5,800003c2 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000030a:	00012717          	auipc	a4,0x12
    8000030e:	e7670713          	addi	a4,a4,-394 # 80012180 <cons>
    80000312:	0a072783          	lw	a5,160(a4)
    80000316:	09872703          	lw	a4,152(a4)
    8000031a:	9f99                	subw	a5,a5,a4
    8000031c:	07f00713          	li	a4,127
    80000320:	fcf763e3          	bltu	a4,a5,800002e6 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000324:	47b5                	li	a5,13
    80000326:	0cf48763          	beq	s1,a5,800003f4 <consoleintr+0x14a>
      consputc(c);
    8000032a:	8526                	mv	a0,s1
    8000032c:	00000097          	auipc	ra,0x0
    80000330:	f3c080e7          	jalr	-196(ra) # 80000268 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000334:	00012797          	auipc	a5,0x12
    80000338:	e4c78793          	addi	a5,a5,-436 # 80012180 <cons>
    8000033c:	0a07a703          	lw	a4,160(a5)
    80000340:	0017069b          	addiw	a3,a4,1
    80000344:	0006861b          	sext.w	a2,a3
    80000348:	0ad7a023          	sw	a3,160(a5)
    8000034c:	07f77713          	andi	a4,a4,127
    80000350:	97ba                	add	a5,a5,a4
    80000352:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000356:	47a9                	li	a5,10
    80000358:	0cf48563          	beq	s1,a5,80000422 <consoleintr+0x178>
    8000035c:	4791                	li	a5,4
    8000035e:	0cf48263          	beq	s1,a5,80000422 <consoleintr+0x178>
    80000362:	00012797          	auipc	a5,0x12
    80000366:	eb67a783          	lw	a5,-330(a5) # 80012218 <cons+0x98>
    8000036a:	0807879b          	addiw	a5,a5,128
    8000036e:	f6f61ce3          	bne	a2,a5,800002e6 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000372:	863e                	mv	a2,a5
    80000374:	a07d                	j	80000422 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000376:	00012717          	auipc	a4,0x12
    8000037a:	e0a70713          	addi	a4,a4,-502 # 80012180 <cons>
    8000037e:	0a072783          	lw	a5,160(a4)
    80000382:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80000386:	00012497          	auipc	s1,0x12
    8000038a:	dfa48493          	addi	s1,s1,-518 # 80012180 <cons>
    while(cons.e != cons.w &&
    8000038e:	4929                	li	s2,10
    80000390:	f4f70be3          	beq	a4,a5,800002e6 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80000394:	37fd                	addiw	a5,a5,-1
    80000396:	07f7f713          	andi	a4,a5,127
    8000039a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000039c:	01874703          	lbu	a4,24(a4)
    800003a0:	f52703e3          	beq	a4,s2,800002e6 <consoleintr+0x3c>
      cons.e--;
    800003a4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003a8:	10000513          	li	a0,256
    800003ac:	00000097          	auipc	ra,0x0
    800003b0:	ebc080e7          	jalr	-324(ra) # 80000268 <consputc>
    while(cons.e != cons.w &&
    800003b4:	0a04a783          	lw	a5,160(s1)
    800003b8:	09c4a703          	lw	a4,156(s1)
    800003bc:	fcf71ce3          	bne	a4,a5,80000394 <consoleintr+0xea>
    800003c0:	b71d                	j	800002e6 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003c2:	00012717          	auipc	a4,0x12
    800003c6:	dbe70713          	addi	a4,a4,-578 # 80012180 <cons>
    800003ca:	0a072783          	lw	a5,160(a4)
    800003ce:	09c72703          	lw	a4,156(a4)
    800003d2:	f0f70ae3          	beq	a4,a5,800002e6 <consoleintr+0x3c>
      cons.e--;
    800003d6:	37fd                	addiw	a5,a5,-1
    800003d8:	00012717          	auipc	a4,0x12
    800003dc:	e4f72423          	sw	a5,-440(a4) # 80012220 <cons+0xa0>
      consputc(BACKSPACE);
    800003e0:	10000513          	li	a0,256
    800003e4:	00000097          	auipc	ra,0x0
    800003e8:	e84080e7          	jalr	-380(ra) # 80000268 <consputc>
    800003ec:	bded                	j	800002e6 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800003ee:	ee048ce3          	beqz	s1,800002e6 <consoleintr+0x3c>
    800003f2:	bf21                	j	8000030a <consoleintr+0x60>
      consputc(c);
    800003f4:	4529                	li	a0,10
    800003f6:	00000097          	auipc	ra,0x0
    800003fa:	e72080e7          	jalr	-398(ra) # 80000268 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800003fe:	00012797          	auipc	a5,0x12
    80000402:	d8278793          	addi	a5,a5,-638 # 80012180 <cons>
    80000406:	0a07a703          	lw	a4,160(a5)
    8000040a:	0017069b          	addiw	a3,a4,1
    8000040e:	0006861b          	sext.w	a2,a3
    80000412:	0ad7a023          	sw	a3,160(a5)
    80000416:	07f77713          	andi	a4,a4,127
    8000041a:	97ba                	add	a5,a5,a4
    8000041c:	4729                	li	a4,10
    8000041e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000422:	00012797          	auipc	a5,0x12
    80000426:	dec7ad23          	sw	a2,-518(a5) # 8001221c <cons+0x9c>
        wakeup(&cons.r);
    8000042a:	00012517          	auipc	a0,0x12
    8000042e:	dee50513          	addi	a0,a0,-530 # 80012218 <cons+0x98>
    80000432:	00002097          	auipc	ra,0x2
    80000436:	790080e7          	jalr	1936(ra) # 80002bc2 <wakeup>
    8000043a:	b575                	j	800002e6 <consoleintr+0x3c>

000000008000043c <consoleinit>:

void
consoleinit(void)
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e406                	sd	ra,8(sp)
    80000440:	e022                	sd	s0,0(sp)
    80000442:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000444:	00009597          	auipc	a1,0x9
    80000448:	bcc58593          	addi	a1,a1,-1076 # 80009010 <etext+0x10>
    8000044c:	00012517          	auipc	a0,0x12
    80000450:	d3450513          	addi	a0,a0,-716 # 80012180 <cons>
    80000454:	00000097          	auipc	ra,0x0
    80000458:	6de080e7          	jalr	1758(ra) # 80000b32 <initlock>

  uartinit();
    8000045c:	00000097          	auipc	ra,0x0
    80000460:	32a080e7          	jalr	810(ra) # 80000786 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000464:	00040797          	auipc	a5,0x40
    80000468:	30c78793          	addi	a5,a5,780 # 80040770 <devsw>
    8000046c:	00000717          	auipc	a4,0x0
    80000470:	cea70713          	addi	a4,a4,-790 # 80000156 <consoleread>
    80000474:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000476:	00000717          	auipc	a4,0x0
    8000047a:	c7e70713          	addi	a4,a4,-898 # 800000f4 <consolewrite>
    8000047e:	ef98                	sd	a4,24(a5)
}
    80000480:	60a2                	ld	ra,8(sp)
    80000482:	6402                	ld	s0,0(sp)
    80000484:	0141                	addi	sp,sp,16
    80000486:	8082                	ret

0000000080000488 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80000488:	7179                	addi	sp,sp,-48
    8000048a:	f406                	sd	ra,40(sp)
    8000048c:	f022                	sd	s0,32(sp)
    8000048e:	ec26                	sd	s1,24(sp)
    80000490:	e84a                	sd	s2,16(sp)
    80000492:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80000494:	c219                	beqz	a2,8000049a <printint+0x12>
    80000496:	08054663          	bltz	a0,80000522 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    8000049a:	2501                	sext.w	a0,a0
    8000049c:	4881                	li	a7,0
    8000049e:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004a2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004a4:	2581                	sext.w	a1,a1
    800004a6:	00009617          	auipc	a2,0x9
    800004aa:	b9a60613          	addi	a2,a2,-1126 # 80009040 <digits>
    800004ae:	883a                	mv	a6,a4
    800004b0:	2705                	addiw	a4,a4,1
    800004b2:	02b577bb          	remuw	a5,a0,a1
    800004b6:	1782                	slli	a5,a5,0x20
    800004b8:	9381                	srli	a5,a5,0x20
    800004ba:	97b2                	add	a5,a5,a2
    800004bc:	0007c783          	lbu	a5,0(a5)
    800004c0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004c4:	0005079b          	sext.w	a5,a0
    800004c8:	02b5553b          	divuw	a0,a0,a1
    800004cc:	0685                	addi	a3,a3,1
    800004ce:	feb7f0e3          	bgeu	a5,a1,800004ae <printint+0x26>

  if(sign)
    800004d2:	00088b63          	beqz	a7,800004e8 <printint+0x60>
    buf[i++] = '-';
    800004d6:	fe040793          	addi	a5,s0,-32
    800004da:	973e                	add	a4,a4,a5
    800004dc:	02d00793          	li	a5,45
    800004e0:	fef70823          	sb	a5,-16(a4)
    800004e4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004e8:	02e05763          	blez	a4,80000516 <printint+0x8e>
    800004ec:	fd040793          	addi	a5,s0,-48
    800004f0:	00e784b3          	add	s1,a5,a4
    800004f4:	fff78913          	addi	s2,a5,-1
    800004f8:	993a                	add	s2,s2,a4
    800004fa:	377d                	addiw	a4,a4,-1
    800004fc:	1702                	slli	a4,a4,0x20
    800004fe:	9301                	srli	a4,a4,0x20
    80000500:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000504:	fff4c503          	lbu	a0,-1(s1)
    80000508:	00000097          	auipc	ra,0x0
    8000050c:	d60080e7          	jalr	-672(ra) # 80000268 <consputc>
  while(--i >= 0)
    80000510:	14fd                	addi	s1,s1,-1
    80000512:	ff2499e3          	bne	s1,s2,80000504 <printint+0x7c>
}
    80000516:	70a2                	ld	ra,40(sp)
    80000518:	7402                	ld	s0,32(sp)
    8000051a:	64e2                	ld	s1,24(sp)
    8000051c:	6942                	ld	s2,16(sp)
    8000051e:	6145                	addi	sp,sp,48
    80000520:	8082                	ret
    x = -xx;
    80000522:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000526:	4885                	li	a7,1
    x = -xx;
    80000528:	bf9d                	j	8000049e <printint+0x16>

000000008000052a <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000052a:	1101                	addi	sp,sp,-32
    8000052c:	ec06                	sd	ra,24(sp)
    8000052e:	e822                	sd	s0,16(sp)
    80000530:	e426                	sd	s1,8(sp)
    80000532:	1000                	addi	s0,sp,32
    80000534:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000536:	00012797          	auipc	a5,0x12
    8000053a:	d007a523          	sw	zero,-758(a5) # 80012240 <pr+0x18>
  printf("panic: ");
    8000053e:	00009517          	auipc	a0,0x9
    80000542:	ada50513          	addi	a0,a0,-1318 # 80009018 <etext+0x18>
    80000546:	00000097          	auipc	ra,0x0
    8000054a:	02e080e7          	jalr	46(ra) # 80000574 <printf>
  printf(s);
    8000054e:	8526                	mv	a0,s1
    80000550:	00000097          	auipc	ra,0x0
    80000554:	024080e7          	jalr	36(ra) # 80000574 <printf>
  printf("\n");
    80000558:	00009517          	auipc	a0,0x9
    8000055c:	eb050513          	addi	a0,a0,-336 # 80009408 <states.0+0x150>
    80000560:	00000097          	auipc	ra,0x0
    80000564:	014080e7          	jalr	20(ra) # 80000574 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000568:	4785                	li	a5,1
    8000056a:	0000a717          	auipc	a4,0xa
    8000056e:	a8f72b23          	sw	a5,-1386(a4) # 8000a000 <panicked>
  for(;;)
    80000572:	a001                	j	80000572 <panic+0x48>

0000000080000574 <printf>:
{
    80000574:	7131                	addi	sp,sp,-192
    80000576:	fc86                	sd	ra,120(sp)
    80000578:	f8a2                	sd	s0,112(sp)
    8000057a:	f4a6                	sd	s1,104(sp)
    8000057c:	f0ca                	sd	s2,96(sp)
    8000057e:	ecce                	sd	s3,88(sp)
    80000580:	e8d2                	sd	s4,80(sp)
    80000582:	e4d6                	sd	s5,72(sp)
    80000584:	e0da                	sd	s6,64(sp)
    80000586:	fc5e                	sd	s7,56(sp)
    80000588:	f862                	sd	s8,48(sp)
    8000058a:	f466                	sd	s9,40(sp)
    8000058c:	f06a                	sd	s10,32(sp)
    8000058e:	ec6e                	sd	s11,24(sp)
    80000590:	0100                	addi	s0,sp,128
    80000592:	8a2a                	mv	s4,a0
    80000594:	e40c                	sd	a1,8(s0)
    80000596:	e810                	sd	a2,16(s0)
    80000598:	ec14                	sd	a3,24(s0)
    8000059a:	f018                	sd	a4,32(s0)
    8000059c:	f41c                	sd	a5,40(s0)
    8000059e:	03043823          	sd	a6,48(s0)
    800005a2:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005a6:	00012d97          	auipc	s11,0x12
    800005aa:	c9adad83          	lw	s11,-870(s11) # 80012240 <pr+0x18>
  if(locking)
    800005ae:	020d9b63          	bnez	s11,800005e4 <printf+0x70>
  if (fmt == 0)
    800005b2:	040a0263          	beqz	s4,800005f6 <printf+0x82>
  va_start(ap, fmt);
    800005b6:	00840793          	addi	a5,s0,8
    800005ba:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005be:	000a4503          	lbu	a0,0(s4)
    800005c2:	14050f63          	beqz	a0,80000720 <printf+0x1ac>
    800005c6:	4981                	li	s3,0
    if(c != '%'){
    800005c8:	02500a93          	li	s5,37
    switch(c){
    800005cc:	07000b93          	li	s7,112
  consputc('x');
    800005d0:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005d2:	00009b17          	auipc	s6,0x9
    800005d6:	a6eb0b13          	addi	s6,s6,-1426 # 80009040 <digits>
    switch(c){
    800005da:	07300c93          	li	s9,115
    800005de:	06400c13          	li	s8,100
    800005e2:	a82d                	j	8000061c <printf+0xa8>
    acquire(&pr.lock);
    800005e4:	00012517          	auipc	a0,0x12
    800005e8:	c4450513          	addi	a0,a0,-956 # 80012228 <pr>
    800005ec:	00000097          	auipc	ra,0x0
    800005f0:	5de080e7          	jalr	1502(ra) # 80000bca <acquire>
    800005f4:	bf7d                	j	800005b2 <printf+0x3e>
    panic("null fmt");
    800005f6:	00009517          	auipc	a0,0x9
    800005fa:	a3250513          	addi	a0,a0,-1486 # 80009028 <etext+0x28>
    800005fe:	00000097          	auipc	ra,0x0
    80000602:	f2c080e7          	jalr	-212(ra) # 8000052a <panic>
      consputc(c);
    80000606:	00000097          	auipc	ra,0x0
    8000060a:	c62080e7          	jalr	-926(ra) # 80000268 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000060e:	2985                	addiw	s3,s3,1
    80000610:	013a07b3          	add	a5,s4,s3
    80000614:	0007c503          	lbu	a0,0(a5)
    80000618:	10050463          	beqz	a0,80000720 <printf+0x1ac>
    if(c != '%'){
    8000061c:	ff5515e3          	bne	a0,s5,80000606 <printf+0x92>
    c = fmt[++i] & 0xff;
    80000620:	2985                	addiw	s3,s3,1
    80000622:	013a07b3          	add	a5,s4,s3
    80000626:	0007c783          	lbu	a5,0(a5)
    8000062a:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000062e:	cbed                	beqz	a5,80000720 <printf+0x1ac>
    switch(c){
    80000630:	05778a63          	beq	a5,s7,80000684 <printf+0x110>
    80000634:	02fbf663          	bgeu	s7,a5,80000660 <printf+0xec>
    80000638:	09978863          	beq	a5,s9,800006c8 <printf+0x154>
    8000063c:	07800713          	li	a4,120
    80000640:	0ce79563          	bne	a5,a4,8000070a <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000644:	f8843783          	ld	a5,-120(s0)
    80000648:	00878713          	addi	a4,a5,8
    8000064c:	f8e43423          	sd	a4,-120(s0)
    80000650:	4605                	li	a2,1
    80000652:	85ea                	mv	a1,s10
    80000654:	4388                	lw	a0,0(a5)
    80000656:	00000097          	auipc	ra,0x0
    8000065a:	e32080e7          	jalr	-462(ra) # 80000488 <printint>
      break;
    8000065e:	bf45                	j	8000060e <printf+0x9a>
    switch(c){
    80000660:	09578f63          	beq	a5,s5,800006fe <printf+0x18a>
    80000664:	0b879363          	bne	a5,s8,8000070a <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80000668:	f8843783          	ld	a5,-120(s0)
    8000066c:	00878713          	addi	a4,a5,8
    80000670:	f8e43423          	sd	a4,-120(s0)
    80000674:	4605                	li	a2,1
    80000676:	45a9                	li	a1,10
    80000678:	4388                	lw	a0,0(a5)
    8000067a:	00000097          	auipc	ra,0x0
    8000067e:	e0e080e7          	jalr	-498(ra) # 80000488 <printint>
      break;
    80000682:	b771                	j	8000060e <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000684:	f8843783          	ld	a5,-120(s0)
    80000688:	00878713          	addi	a4,a5,8
    8000068c:	f8e43423          	sd	a4,-120(s0)
    80000690:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80000694:	03000513          	li	a0,48
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	bd0080e7          	jalr	-1072(ra) # 80000268 <consputc>
  consputc('x');
    800006a0:	07800513          	li	a0,120
    800006a4:	00000097          	auipc	ra,0x0
    800006a8:	bc4080e7          	jalr	-1084(ra) # 80000268 <consputc>
    800006ac:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006ae:	03c95793          	srli	a5,s2,0x3c
    800006b2:	97da                	add	a5,a5,s6
    800006b4:	0007c503          	lbu	a0,0(a5)
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	bb0080e7          	jalr	-1104(ra) # 80000268 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006c0:	0912                	slli	s2,s2,0x4
    800006c2:	34fd                	addiw	s1,s1,-1
    800006c4:	f4ed                	bnez	s1,800006ae <printf+0x13a>
    800006c6:	b7a1                	j	8000060e <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006c8:	f8843783          	ld	a5,-120(s0)
    800006cc:	00878713          	addi	a4,a5,8
    800006d0:	f8e43423          	sd	a4,-120(s0)
    800006d4:	6384                	ld	s1,0(a5)
    800006d6:	cc89                	beqz	s1,800006f0 <printf+0x17c>
      for(; *s; s++)
    800006d8:	0004c503          	lbu	a0,0(s1)
    800006dc:	d90d                	beqz	a0,8000060e <printf+0x9a>
        consputc(*s);
    800006de:	00000097          	auipc	ra,0x0
    800006e2:	b8a080e7          	jalr	-1142(ra) # 80000268 <consputc>
      for(; *s; s++)
    800006e6:	0485                	addi	s1,s1,1
    800006e8:	0004c503          	lbu	a0,0(s1)
    800006ec:	f96d                	bnez	a0,800006de <printf+0x16a>
    800006ee:	b705                	j	8000060e <printf+0x9a>
        s = "(null)";
    800006f0:	00009497          	auipc	s1,0x9
    800006f4:	93048493          	addi	s1,s1,-1744 # 80009020 <etext+0x20>
      for(; *s; s++)
    800006f8:	02800513          	li	a0,40
    800006fc:	b7cd                	j	800006de <printf+0x16a>
      consputc('%');
    800006fe:	8556                	mv	a0,s5
    80000700:	00000097          	auipc	ra,0x0
    80000704:	b68080e7          	jalr	-1176(ra) # 80000268 <consputc>
      break;
    80000708:	b719                	j	8000060e <printf+0x9a>
      consputc('%');
    8000070a:	8556                	mv	a0,s5
    8000070c:	00000097          	auipc	ra,0x0
    80000710:	b5c080e7          	jalr	-1188(ra) # 80000268 <consputc>
      consputc(c);
    80000714:	8526                	mv	a0,s1
    80000716:	00000097          	auipc	ra,0x0
    8000071a:	b52080e7          	jalr	-1198(ra) # 80000268 <consputc>
      break;
    8000071e:	bdc5                	j	8000060e <printf+0x9a>
  if(locking)
    80000720:	020d9163          	bnez	s11,80000742 <printf+0x1ce>
}
    80000724:	70e6                	ld	ra,120(sp)
    80000726:	7446                	ld	s0,112(sp)
    80000728:	74a6                	ld	s1,104(sp)
    8000072a:	7906                	ld	s2,96(sp)
    8000072c:	69e6                	ld	s3,88(sp)
    8000072e:	6a46                	ld	s4,80(sp)
    80000730:	6aa6                	ld	s5,72(sp)
    80000732:	6b06                	ld	s6,64(sp)
    80000734:	7be2                	ld	s7,56(sp)
    80000736:	7c42                	ld	s8,48(sp)
    80000738:	7ca2                	ld	s9,40(sp)
    8000073a:	7d02                	ld	s10,32(sp)
    8000073c:	6de2                	ld	s11,24(sp)
    8000073e:	6129                	addi	sp,sp,192
    80000740:	8082                	ret
    release(&pr.lock);
    80000742:	00012517          	auipc	a0,0x12
    80000746:	ae650513          	addi	a0,a0,-1306 # 80012228 <pr>
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	53a080e7          	jalr	1338(ra) # 80000c84 <release>
}
    80000752:	bfc9                	j	80000724 <printf+0x1b0>

0000000080000754 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000754:	1101                	addi	sp,sp,-32
    80000756:	ec06                	sd	ra,24(sp)
    80000758:	e822                	sd	s0,16(sp)
    8000075a:	e426                	sd	s1,8(sp)
    8000075c:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000075e:	00012497          	auipc	s1,0x12
    80000762:	aca48493          	addi	s1,s1,-1334 # 80012228 <pr>
    80000766:	00009597          	auipc	a1,0x9
    8000076a:	8d258593          	addi	a1,a1,-1838 # 80009038 <etext+0x38>
    8000076e:	8526                	mv	a0,s1
    80000770:	00000097          	auipc	ra,0x0
    80000774:	3c2080e7          	jalr	962(ra) # 80000b32 <initlock>
  pr.locking = 1;
    80000778:	4785                	li	a5,1
    8000077a:	cc9c                	sw	a5,24(s1)
}
    8000077c:	60e2                	ld	ra,24(sp)
    8000077e:	6442                	ld	s0,16(sp)
    80000780:	64a2                	ld	s1,8(sp)
    80000782:	6105                	addi	sp,sp,32
    80000784:	8082                	ret

0000000080000786 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000786:	1141                	addi	sp,sp,-16
    80000788:	e406                	sd	ra,8(sp)
    8000078a:	e022                	sd	s0,0(sp)
    8000078c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000078e:	100007b7          	lui	a5,0x10000
    80000792:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000796:	f8000713          	li	a4,-128
    8000079a:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000079e:	470d                	li	a4,3
    800007a0:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007a4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007a8:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007ac:	469d                	li	a3,7
    800007ae:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007b2:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007b6:	00009597          	auipc	a1,0x9
    800007ba:	8a258593          	addi	a1,a1,-1886 # 80009058 <digits+0x18>
    800007be:	00012517          	auipc	a0,0x12
    800007c2:	a8a50513          	addi	a0,a0,-1398 # 80012248 <uart_tx_lock>
    800007c6:	00000097          	auipc	ra,0x0
    800007ca:	36c080e7          	jalr	876(ra) # 80000b32 <initlock>
}
    800007ce:	60a2                	ld	ra,8(sp)
    800007d0:	6402                	ld	s0,0(sp)
    800007d2:	0141                	addi	sp,sp,16
    800007d4:	8082                	ret

00000000800007d6 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007d6:	1101                	addi	sp,sp,-32
    800007d8:	ec06                	sd	ra,24(sp)
    800007da:	e822                	sd	s0,16(sp)
    800007dc:	e426                	sd	s1,8(sp)
    800007de:	1000                	addi	s0,sp,32
    800007e0:	84aa                	mv	s1,a0
  push_off();
    800007e2:	00000097          	auipc	ra,0x0
    800007e6:	394080e7          	jalr	916(ra) # 80000b76 <push_off>

  if(panicked){
    800007ea:	0000a797          	auipc	a5,0xa
    800007ee:	8167a783          	lw	a5,-2026(a5) # 8000a000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800007f2:	10000737          	lui	a4,0x10000
  if(panicked){
    800007f6:	c391                	beqz	a5,800007fa <uartputc_sync+0x24>
    for(;;)
    800007f8:	a001                	j	800007f8 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800007fa:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800007fe:	0207f793          	andi	a5,a5,32
    80000802:	dfe5                	beqz	a5,800007fa <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000804:	0ff4f513          	andi	a0,s1,255
    80000808:	100007b7          	lui	a5,0x10000
    8000080c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000810:	00000097          	auipc	ra,0x0
    80000814:	40e080e7          	jalr	1038(ra) # 80000c1e <pop_off>
}
    80000818:	60e2                	ld	ra,24(sp)
    8000081a:	6442                	ld	s0,16(sp)
    8000081c:	64a2                	ld	s1,8(sp)
    8000081e:	6105                	addi	sp,sp,32
    80000820:	8082                	ret

0000000080000822 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000822:	00009797          	auipc	a5,0x9
    80000826:	7e67b783          	ld	a5,2022(a5) # 8000a008 <uart_tx_r>
    8000082a:	00009717          	auipc	a4,0x9
    8000082e:	7e673703          	ld	a4,2022(a4) # 8000a010 <uart_tx_w>
    80000832:	06f70a63          	beq	a4,a5,800008a6 <uartstart+0x84>
{
    80000836:	7139                	addi	sp,sp,-64
    80000838:	fc06                	sd	ra,56(sp)
    8000083a:	f822                	sd	s0,48(sp)
    8000083c:	f426                	sd	s1,40(sp)
    8000083e:	f04a                	sd	s2,32(sp)
    80000840:	ec4e                	sd	s3,24(sp)
    80000842:	e852                	sd	s4,16(sp)
    80000844:	e456                	sd	s5,8(sp)
    80000846:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000848:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000084c:	00012a17          	auipc	s4,0x12
    80000850:	9fca0a13          	addi	s4,s4,-1540 # 80012248 <uart_tx_lock>
    uart_tx_r += 1;
    80000854:	00009497          	auipc	s1,0x9
    80000858:	7b448493          	addi	s1,s1,1972 # 8000a008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000085c:	00009997          	auipc	s3,0x9
    80000860:	7b498993          	addi	s3,s3,1972 # 8000a010 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000864:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000868:	02077713          	andi	a4,a4,32
    8000086c:	c705                	beqz	a4,80000894 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000086e:	01f7f713          	andi	a4,a5,31
    80000872:	9752                	add	a4,a4,s4
    80000874:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80000878:	0785                	addi	a5,a5,1
    8000087a:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000087c:	8526                	mv	a0,s1
    8000087e:	00002097          	auipc	ra,0x2
    80000882:	344080e7          	jalr	836(ra) # 80002bc2 <wakeup>
    
    WriteReg(THR, c);
    80000886:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000088a:	609c                	ld	a5,0(s1)
    8000088c:	0009b703          	ld	a4,0(s3)
    80000890:	fcf71ae3          	bne	a4,a5,80000864 <uartstart+0x42>
  }
}
    80000894:	70e2                	ld	ra,56(sp)
    80000896:	7442                	ld	s0,48(sp)
    80000898:	74a2                	ld	s1,40(sp)
    8000089a:	7902                	ld	s2,32(sp)
    8000089c:	69e2                	ld	s3,24(sp)
    8000089e:	6a42                	ld	s4,16(sp)
    800008a0:	6aa2                	ld	s5,8(sp)
    800008a2:	6121                	addi	sp,sp,64
    800008a4:	8082                	ret
    800008a6:	8082                	ret

00000000800008a8 <uartputc>:
{
    800008a8:	7179                	addi	sp,sp,-48
    800008aa:	f406                	sd	ra,40(sp)
    800008ac:	f022                	sd	s0,32(sp)
    800008ae:	ec26                	sd	s1,24(sp)
    800008b0:	e84a                	sd	s2,16(sp)
    800008b2:	e44e                	sd	s3,8(sp)
    800008b4:	e052                	sd	s4,0(sp)
    800008b6:	1800                	addi	s0,sp,48
    800008b8:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008ba:	00012517          	auipc	a0,0x12
    800008be:	98e50513          	addi	a0,a0,-1650 # 80012248 <uart_tx_lock>
    800008c2:	00000097          	auipc	ra,0x0
    800008c6:	308080e7          	jalr	776(ra) # 80000bca <acquire>
  if(panicked){
    800008ca:	00009797          	auipc	a5,0x9
    800008ce:	7367a783          	lw	a5,1846(a5) # 8000a000 <panicked>
    800008d2:	c391                	beqz	a5,800008d6 <uartputc+0x2e>
    for(;;)
    800008d4:	a001                	j	800008d4 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008d6:	00009717          	auipc	a4,0x9
    800008da:	73a73703          	ld	a4,1850(a4) # 8000a010 <uart_tx_w>
    800008de:	00009797          	auipc	a5,0x9
    800008e2:	72a7b783          	ld	a5,1834(a5) # 8000a008 <uart_tx_r>
    800008e6:	02078793          	addi	a5,a5,32
    800008ea:	02e79b63          	bne	a5,a4,80000920 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800008ee:	00012997          	auipc	s3,0x12
    800008f2:	95a98993          	addi	s3,s3,-1702 # 80012248 <uart_tx_lock>
    800008f6:	00009497          	auipc	s1,0x9
    800008fa:	71248493          	addi	s1,s1,1810 # 8000a008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008fe:	00009917          	auipc	s2,0x9
    80000902:	71290913          	addi	s2,s2,1810 # 8000a010 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000906:	85ce                	mv	a1,s3
    80000908:	8526                	mv	a0,s1
    8000090a:	00002097          	auipc	ra,0x2
    8000090e:	f4a080e7          	jalr	-182(ra) # 80002854 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000912:	00093703          	ld	a4,0(s2)
    80000916:	609c                	ld	a5,0(s1)
    80000918:	02078793          	addi	a5,a5,32
    8000091c:	fee785e3          	beq	a5,a4,80000906 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000920:	00012497          	auipc	s1,0x12
    80000924:	92848493          	addi	s1,s1,-1752 # 80012248 <uart_tx_lock>
    80000928:	01f77793          	andi	a5,a4,31
    8000092c:	97a6                	add	a5,a5,s1
    8000092e:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80000932:	0705                	addi	a4,a4,1
    80000934:	00009797          	auipc	a5,0x9
    80000938:	6ce7be23          	sd	a4,1756(a5) # 8000a010 <uart_tx_w>
      uartstart();
    8000093c:	00000097          	auipc	ra,0x0
    80000940:	ee6080e7          	jalr	-282(ra) # 80000822 <uartstart>
      release(&uart_tx_lock);
    80000944:	8526                	mv	a0,s1
    80000946:	00000097          	auipc	ra,0x0
    8000094a:	33e080e7          	jalr	830(ra) # 80000c84 <release>
}
    8000094e:	70a2                	ld	ra,40(sp)
    80000950:	7402                	ld	s0,32(sp)
    80000952:	64e2                	ld	s1,24(sp)
    80000954:	6942                	ld	s2,16(sp)
    80000956:	69a2                	ld	s3,8(sp)
    80000958:	6a02                	ld	s4,0(sp)
    8000095a:	6145                	addi	sp,sp,48
    8000095c:	8082                	ret

000000008000095e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000095e:	1141                	addi	sp,sp,-16
    80000960:	e422                	sd	s0,8(sp)
    80000962:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000964:	100007b7          	lui	a5,0x10000
    80000968:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000096c:	8b85                	andi	a5,a5,1
    8000096e:	cb91                	beqz	a5,80000982 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000970:	100007b7          	lui	a5,0x10000
    80000974:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80000978:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000097c:	6422                	ld	s0,8(sp)
    8000097e:	0141                	addi	sp,sp,16
    80000980:	8082                	ret
    return -1;
    80000982:	557d                	li	a0,-1
    80000984:	bfe5                	j	8000097c <uartgetc+0x1e>

0000000080000986 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80000986:	1101                	addi	sp,sp,-32
    80000988:	ec06                	sd	ra,24(sp)
    8000098a:	e822                	sd	s0,16(sp)
    8000098c:	e426                	sd	s1,8(sp)
    8000098e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000990:	54fd                	li	s1,-1
    80000992:	a029                	j	8000099c <uartintr+0x16>
      break;
    consoleintr(c);
    80000994:	00000097          	auipc	ra,0x0
    80000998:	916080e7          	jalr	-1770(ra) # 800002aa <consoleintr>
    int c = uartgetc();
    8000099c:	00000097          	auipc	ra,0x0
    800009a0:	fc2080e7          	jalr	-62(ra) # 8000095e <uartgetc>
    if(c == -1)
    800009a4:	fe9518e3          	bne	a0,s1,80000994 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009a8:	00012497          	auipc	s1,0x12
    800009ac:	8a048493          	addi	s1,s1,-1888 # 80012248 <uart_tx_lock>
    800009b0:	8526                	mv	a0,s1
    800009b2:	00000097          	auipc	ra,0x0
    800009b6:	218080e7          	jalr	536(ra) # 80000bca <acquire>
  uartstart();
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	e68080e7          	jalr	-408(ra) # 80000822 <uartstart>
  release(&uart_tx_lock);
    800009c2:	8526                	mv	a0,s1
    800009c4:	00000097          	auipc	ra,0x0
    800009c8:	2c0080e7          	jalr	704(ra) # 80000c84 <release>
}
    800009cc:	60e2                	ld	ra,24(sp)
    800009ce:	6442                	ld	s0,16(sp)
    800009d0:	64a2                	ld	s1,8(sp)
    800009d2:	6105                	addi	sp,sp,32
    800009d4:	8082                	ret

00000000800009d6 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009d6:	1101                	addi	sp,sp,-32
    800009d8:	ec06                	sd	ra,24(sp)
    800009da:	e822                	sd	s0,16(sp)
    800009dc:	e426                	sd	s1,8(sp)
    800009de:	e04a                	sd	s2,0(sp)
    800009e0:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009e2:	03451793          	slli	a5,a0,0x34
    800009e6:	ebb9                	bnez	a5,80000a3c <kfree+0x66>
    800009e8:	84aa                	mv	s1,a0
    800009ea:	00044797          	auipc	a5,0x44
    800009ee:	61678793          	addi	a5,a5,1558 # 80045000 <end>
    800009f2:	04f56563          	bltu	a0,a5,80000a3c <kfree+0x66>
    800009f6:	47c5                	li	a5,17
    800009f8:	07ee                	slli	a5,a5,0x1b
    800009fa:	04f57163          	bgeu	a0,a5,80000a3c <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    800009fe:	6605                	lui	a2,0x1
    80000a00:	4585                	li	a1,1
    80000a02:	00000097          	auipc	ra,0x0
    80000a06:	2ca080e7          	jalr	714(ra) # 80000ccc <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a0a:	00012917          	auipc	s2,0x12
    80000a0e:	87690913          	addi	s2,s2,-1930 # 80012280 <kmem>
    80000a12:	854a                	mv	a0,s2
    80000a14:	00000097          	auipc	ra,0x0
    80000a18:	1b6080e7          	jalr	438(ra) # 80000bca <acquire>
  r->next = kmem.freelist;
    80000a1c:	01893783          	ld	a5,24(s2)
    80000a20:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a22:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a26:	854a                	mv	a0,s2
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	25c080e7          	jalr	604(ra) # 80000c84 <release>
}
    80000a30:	60e2                	ld	ra,24(sp)
    80000a32:	6442                	ld	s0,16(sp)
    80000a34:	64a2                	ld	s1,8(sp)
    80000a36:	6902                	ld	s2,0(sp)
    80000a38:	6105                	addi	sp,sp,32
    80000a3a:	8082                	ret
    panic("kfree");
    80000a3c:	00008517          	auipc	a0,0x8
    80000a40:	62450513          	addi	a0,a0,1572 # 80009060 <digits+0x20>
    80000a44:	00000097          	auipc	ra,0x0
    80000a48:	ae6080e7          	jalr	-1306(ra) # 8000052a <panic>

0000000080000a4c <freerange>:
{
    80000a4c:	7179                	addi	sp,sp,-48
    80000a4e:	f406                	sd	ra,40(sp)
    80000a50:	f022                	sd	s0,32(sp)
    80000a52:	ec26                	sd	s1,24(sp)
    80000a54:	e84a                	sd	s2,16(sp)
    80000a56:	e44e                	sd	s3,8(sp)
    80000a58:	e052                	sd	s4,0(sp)
    80000a5a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a5c:	6785                	lui	a5,0x1
    80000a5e:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000a62:	94aa                	add	s1,s1,a0
    80000a64:	757d                	lui	a0,0xfffff
    80000a66:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a68:	94be                	add	s1,s1,a5
    80000a6a:	0095ee63          	bltu	a1,s1,80000a86 <freerange+0x3a>
    80000a6e:	892e                	mv	s2,a1
    kfree(p);
    80000a70:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a72:	6985                	lui	s3,0x1
    kfree(p);
    80000a74:	01448533          	add	a0,s1,s4
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	f5e080e7          	jalr	-162(ra) # 800009d6 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a80:	94ce                	add	s1,s1,s3
    80000a82:	fe9979e3          	bgeu	s2,s1,80000a74 <freerange+0x28>
}
    80000a86:	70a2                	ld	ra,40(sp)
    80000a88:	7402                	ld	s0,32(sp)
    80000a8a:	64e2                	ld	s1,24(sp)
    80000a8c:	6942                	ld	s2,16(sp)
    80000a8e:	69a2                	ld	s3,8(sp)
    80000a90:	6a02                	ld	s4,0(sp)
    80000a92:	6145                	addi	sp,sp,48
    80000a94:	8082                	ret

0000000080000a96 <kinit>:
{
    80000a96:	1141                	addi	sp,sp,-16
    80000a98:	e406                	sd	ra,8(sp)
    80000a9a:	e022                	sd	s0,0(sp)
    80000a9c:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000a9e:	00008597          	auipc	a1,0x8
    80000aa2:	5ca58593          	addi	a1,a1,1482 # 80009068 <digits+0x28>
    80000aa6:	00011517          	auipc	a0,0x11
    80000aaa:	7da50513          	addi	a0,a0,2010 # 80012280 <kmem>
    80000aae:	00000097          	auipc	ra,0x0
    80000ab2:	084080e7          	jalr	132(ra) # 80000b32 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ab6:	45c5                	li	a1,17
    80000ab8:	05ee                	slli	a1,a1,0x1b
    80000aba:	00044517          	auipc	a0,0x44
    80000abe:	54650513          	addi	a0,a0,1350 # 80045000 <end>
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	f8a080e7          	jalr	-118(ra) # 80000a4c <freerange>
}
    80000aca:	60a2                	ld	ra,8(sp)
    80000acc:	6402                	ld	s0,0(sp)
    80000ace:	0141                	addi	sp,sp,16
    80000ad0:	8082                	ret

0000000080000ad2 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ad2:	1101                	addi	sp,sp,-32
    80000ad4:	ec06                	sd	ra,24(sp)
    80000ad6:	e822                	sd	s0,16(sp)
    80000ad8:	e426                	sd	s1,8(sp)
    80000ada:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000adc:	00011497          	auipc	s1,0x11
    80000ae0:	7a448493          	addi	s1,s1,1956 # 80012280 <kmem>
    80000ae4:	8526                	mv	a0,s1
    80000ae6:	00000097          	auipc	ra,0x0
    80000aea:	0e4080e7          	jalr	228(ra) # 80000bca <acquire>
  r = kmem.freelist;
    80000aee:	6c84                	ld	s1,24(s1)
  if(r)
    80000af0:	c885                	beqz	s1,80000b20 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000af2:	609c                	ld	a5,0(s1)
    80000af4:	00011517          	auipc	a0,0x11
    80000af8:	78c50513          	addi	a0,a0,1932 # 80012280 <kmem>
    80000afc:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000afe:	00000097          	auipc	ra,0x0
    80000b02:	186080e7          	jalr	390(ra) # 80000c84 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b06:	6605                	lui	a2,0x1
    80000b08:	4595                	li	a1,5
    80000b0a:	8526                	mv	a0,s1
    80000b0c:	00000097          	auipc	ra,0x0
    80000b10:	1c0080e7          	jalr	448(ra) # 80000ccc <memset>
  return (void*)r;
}
    80000b14:	8526                	mv	a0,s1
    80000b16:	60e2                	ld	ra,24(sp)
    80000b18:	6442                	ld	s0,16(sp)
    80000b1a:	64a2                	ld	s1,8(sp)
    80000b1c:	6105                	addi	sp,sp,32
    80000b1e:	8082                	ret
  release(&kmem.lock);
    80000b20:	00011517          	auipc	a0,0x11
    80000b24:	76050513          	addi	a0,a0,1888 # 80012280 <kmem>
    80000b28:	00000097          	auipc	ra,0x0
    80000b2c:	15c080e7          	jalr	348(ra) # 80000c84 <release>
  if(r)
    80000b30:	b7d5                	j	80000b14 <kalloc+0x42>

0000000080000b32 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b32:	1141                	addi	sp,sp,-16
    80000b34:	e422                	sd	s0,8(sp)
    80000b36:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b38:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b3a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b3e:	00053823          	sd	zero,16(a0)
}
    80000b42:	6422                	ld	s0,8(sp)
    80000b44:	0141                	addi	sp,sp,16
    80000b46:	8082                	ret

0000000080000b48 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b48:	411c                	lw	a5,0(a0)
    80000b4a:	e399                	bnez	a5,80000b50 <holding+0x8>
    80000b4c:	4501                	li	a0,0
  return r;
}
    80000b4e:	8082                	ret
{
    80000b50:	1101                	addi	sp,sp,-32
    80000b52:	ec06                	sd	ra,24(sp)
    80000b54:	e822                	sd	s0,16(sp)
    80000b56:	e426                	sd	s1,8(sp)
    80000b58:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b5a:	6904                	ld	s1,16(a0)
    80000b5c:	00001097          	auipc	ra,0x1
    80000b60:	ee6080e7          	jalr	-282(ra) # 80001a42 <mycpu>
    80000b64:	40a48533          	sub	a0,s1,a0
    80000b68:	00153513          	seqz	a0,a0
}
    80000b6c:	60e2                	ld	ra,24(sp)
    80000b6e:	6442                	ld	s0,16(sp)
    80000b70:	64a2                	ld	s1,8(sp)
    80000b72:	6105                	addi	sp,sp,32
    80000b74:	8082                	ret

0000000080000b76 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b76:	1101                	addi	sp,sp,-32
    80000b78:	ec06                	sd	ra,24(sp)
    80000b7a:	e822                	sd	s0,16(sp)
    80000b7c:	e426                	sd	s1,8(sp)
    80000b7e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b80:	100024f3          	csrr	s1,sstatus
    80000b84:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b88:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b8a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000b8e:	00001097          	auipc	ra,0x1
    80000b92:	eb4080e7          	jalr	-332(ra) # 80001a42 <mycpu>
    80000b96:	08052783          	lw	a5,128(a0)
    80000b9a:	cf99                	beqz	a5,80000bb8 <push_off+0x42>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000b9c:	00001097          	auipc	ra,0x1
    80000ba0:	ea6080e7          	jalr	-346(ra) # 80001a42 <mycpu>
    80000ba4:	08052783          	lw	a5,128(a0)
    80000ba8:	2785                	addiw	a5,a5,1
    80000baa:	08f52023          	sw	a5,128(a0)
}
    80000bae:	60e2                	ld	ra,24(sp)
    80000bb0:	6442                	ld	s0,16(sp)
    80000bb2:	64a2                	ld	s1,8(sp)
    80000bb4:	6105                	addi	sp,sp,32
    80000bb6:	8082                	ret
    mycpu()->intena = old;
    80000bb8:	00001097          	auipc	ra,0x1
    80000bbc:	e8a080e7          	jalr	-374(ra) # 80001a42 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bc0:	8085                	srli	s1,s1,0x1
    80000bc2:	8885                	andi	s1,s1,1
    80000bc4:	08952223          	sw	s1,132(a0)
    80000bc8:	bfd1                	j	80000b9c <push_off+0x26>

0000000080000bca <acquire>:
{
    80000bca:	1101                	addi	sp,sp,-32
    80000bcc:	ec06                	sd	ra,24(sp)
    80000bce:	e822                	sd	s0,16(sp)
    80000bd0:	e426                	sd	s1,8(sp)
    80000bd2:	1000                	addi	s0,sp,32
    80000bd4:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bd6:	00000097          	auipc	ra,0x0
    80000bda:	fa0080e7          	jalr	-96(ra) # 80000b76 <push_off>
  if(holding(lk))
    80000bde:	8526                	mv	a0,s1
    80000be0:	00000097          	auipc	ra,0x0
    80000be4:	f68080e7          	jalr	-152(ra) # 80000b48 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000be8:	4705                	li	a4,1
  if(holding(lk))
    80000bea:	e115                	bnez	a0,80000c0e <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bec:	87ba                	mv	a5,a4
    80000bee:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bf2:	2781                	sext.w	a5,a5
    80000bf4:	ffe5                	bnez	a5,80000bec <acquire+0x22>
  __sync_synchronize();
    80000bf6:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000bfa:	00001097          	auipc	ra,0x1
    80000bfe:	e48080e7          	jalr	-440(ra) # 80001a42 <mycpu>
    80000c02:	e888                	sd	a0,16(s1)
}
    80000c04:	60e2                	ld	ra,24(sp)
    80000c06:	6442                	ld	s0,16(sp)
    80000c08:	64a2                	ld	s1,8(sp)
    80000c0a:	6105                	addi	sp,sp,32
    80000c0c:	8082                	ret
    panic("acquire");
    80000c0e:	00008517          	auipc	a0,0x8
    80000c12:	46250513          	addi	a0,a0,1122 # 80009070 <digits+0x30>
    80000c16:	00000097          	auipc	ra,0x0
    80000c1a:	914080e7          	jalr	-1772(ra) # 8000052a <panic>

0000000080000c1e <pop_off>:

void
pop_off(void)
{
    80000c1e:	1141                	addi	sp,sp,-16
    80000c20:	e406                	sd	ra,8(sp)
    80000c22:	e022                	sd	s0,0(sp)
    80000c24:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c26:	00001097          	auipc	ra,0x1
    80000c2a:	e1c080e7          	jalr	-484(ra) # 80001a42 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c2e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c32:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c34:	eb85                	bnez	a5,80000c64 <pop_off+0x46>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c36:	08052783          	lw	a5,128(a0)
    80000c3a:	02f05d63          	blez	a5,80000c74 <pop_off+0x56>
    panic("pop_off");
  c->noff -= 1;
    80000c3e:	37fd                	addiw	a5,a5,-1
    80000c40:	0007871b          	sext.w	a4,a5
    80000c44:	08f52023          	sw	a5,128(a0)
  if(c->noff == 0 && c->intena)
    80000c48:	eb11                	bnez	a4,80000c5c <pop_off+0x3e>
    80000c4a:	08452783          	lw	a5,132(a0)
    80000c4e:	c799                	beqz	a5,80000c5c <pop_off+0x3e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c50:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c54:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c58:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c5c:	60a2                	ld	ra,8(sp)
    80000c5e:	6402                	ld	s0,0(sp)
    80000c60:	0141                	addi	sp,sp,16
    80000c62:	8082                	ret
    panic("pop_off - interruptible");
    80000c64:	00008517          	auipc	a0,0x8
    80000c68:	41450513          	addi	a0,a0,1044 # 80009078 <digits+0x38>
    80000c6c:	00000097          	auipc	ra,0x0
    80000c70:	8be080e7          	jalr	-1858(ra) # 8000052a <panic>
    panic("pop_off");
    80000c74:	00008517          	auipc	a0,0x8
    80000c78:	41c50513          	addi	a0,a0,1052 # 80009090 <digits+0x50>
    80000c7c:	00000097          	auipc	ra,0x0
    80000c80:	8ae080e7          	jalr	-1874(ra) # 8000052a <panic>

0000000080000c84 <release>:
{
    80000c84:	1101                	addi	sp,sp,-32
    80000c86:	ec06                	sd	ra,24(sp)
    80000c88:	e822                	sd	s0,16(sp)
    80000c8a:	e426                	sd	s1,8(sp)
    80000c8c:	1000                	addi	s0,sp,32
    80000c8e:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c90:	00000097          	auipc	ra,0x0
    80000c94:	eb8080e7          	jalr	-328(ra) # 80000b48 <holding>
    80000c98:	c115                	beqz	a0,80000cbc <release+0x38>
  lk->cpu = 0;
    80000c9a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c9e:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ca2:	0f50000f          	fence	iorw,ow
    80000ca6:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000caa:	00000097          	auipc	ra,0x0
    80000cae:	f74080e7          	jalr	-140(ra) # 80000c1e <pop_off>
}
    80000cb2:	60e2                	ld	ra,24(sp)
    80000cb4:	6442                	ld	s0,16(sp)
    80000cb6:	64a2                	ld	s1,8(sp)
    80000cb8:	6105                	addi	sp,sp,32
    80000cba:	8082                	ret
    panic("release");
    80000cbc:	00008517          	auipc	a0,0x8
    80000cc0:	3dc50513          	addi	a0,a0,988 # 80009098 <digits+0x58>
    80000cc4:	00000097          	auipc	ra,0x0
    80000cc8:	866080e7          	jalr	-1946(ra) # 8000052a <panic>

0000000080000ccc <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000ccc:	1141                	addi	sp,sp,-16
    80000cce:	e422                	sd	s0,8(sp)
    80000cd0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cd2:	ca19                	beqz	a2,80000ce8 <memset+0x1c>
    80000cd4:	87aa                	mv	a5,a0
    80000cd6:	1602                	slli	a2,a2,0x20
    80000cd8:	9201                	srli	a2,a2,0x20
    80000cda:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cde:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000ce2:	0785                	addi	a5,a5,1
    80000ce4:	fee79de3          	bne	a5,a4,80000cde <memset+0x12>
  }
  return dst;
}
    80000ce8:	6422                	ld	s0,8(sp)
    80000cea:	0141                	addi	sp,sp,16
    80000cec:	8082                	ret

0000000080000cee <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cee:	1141                	addi	sp,sp,-16
    80000cf0:	e422                	sd	s0,8(sp)
    80000cf2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cf4:	ca05                	beqz	a2,80000d24 <memcmp+0x36>
    80000cf6:	fff6069b          	addiw	a3,a2,-1
    80000cfa:	1682                	slli	a3,a3,0x20
    80000cfc:	9281                	srli	a3,a3,0x20
    80000cfe:	0685                	addi	a3,a3,1
    80000d00:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d02:	00054783          	lbu	a5,0(a0)
    80000d06:	0005c703          	lbu	a4,0(a1)
    80000d0a:	00e79863          	bne	a5,a4,80000d1a <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d0e:	0505                	addi	a0,a0,1
    80000d10:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d12:	fed518e3          	bne	a0,a3,80000d02 <memcmp+0x14>
  }

  return 0;
    80000d16:	4501                	li	a0,0
    80000d18:	a019                	j	80000d1e <memcmp+0x30>
      return *s1 - *s2;
    80000d1a:	40e7853b          	subw	a0,a5,a4
}
    80000d1e:	6422                	ld	s0,8(sp)
    80000d20:	0141                	addi	sp,sp,16
    80000d22:	8082                	ret
  return 0;
    80000d24:	4501                	li	a0,0
    80000d26:	bfe5                	j	80000d1e <memcmp+0x30>

0000000080000d28 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d28:	1141                	addi	sp,sp,-16
    80000d2a:	e422                	sd	s0,8(sp)
    80000d2c:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d2e:	02a5e563          	bltu	a1,a0,80000d58 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d32:	fff6069b          	addiw	a3,a2,-1
    80000d36:	ce11                	beqz	a2,80000d52 <memmove+0x2a>
    80000d38:	1682                	slli	a3,a3,0x20
    80000d3a:	9281                	srli	a3,a3,0x20
    80000d3c:	0685                	addi	a3,a3,1
    80000d3e:	96ae                	add	a3,a3,a1
    80000d40:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000d42:	0585                	addi	a1,a1,1
    80000d44:	0785                	addi	a5,a5,1
    80000d46:	fff5c703          	lbu	a4,-1(a1)
    80000d4a:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000d4e:	fed59ae3          	bne	a1,a3,80000d42 <memmove+0x1a>

  return dst;
}
    80000d52:	6422                	ld	s0,8(sp)
    80000d54:	0141                	addi	sp,sp,16
    80000d56:	8082                	ret
  if(s < d && s + n > d){
    80000d58:	02061713          	slli	a4,a2,0x20
    80000d5c:	9301                	srli	a4,a4,0x20
    80000d5e:	00e587b3          	add	a5,a1,a4
    80000d62:	fcf578e3          	bgeu	a0,a5,80000d32 <memmove+0xa>
    d += n;
    80000d66:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000d68:	fff6069b          	addiw	a3,a2,-1
    80000d6c:	d27d                	beqz	a2,80000d52 <memmove+0x2a>
    80000d6e:	02069613          	slli	a2,a3,0x20
    80000d72:	9201                	srli	a2,a2,0x20
    80000d74:	fff64613          	not	a2,a2
    80000d78:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000d7a:	17fd                	addi	a5,a5,-1
    80000d7c:	177d                	addi	a4,a4,-1
    80000d7e:	0007c683          	lbu	a3,0(a5)
    80000d82:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000d86:	fef61ae3          	bne	a2,a5,80000d7a <memmove+0x52>
    80000d8a:	b7e1                	j	80000d52 <memmove+0x2a>

0000000080000d8c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d8c:	1141                	addi	sp,sp,-16
    80000d8e:	e406                	sd	ra,8(sp)
    80000d90:	e022                	sd	s0,0(sp)
    80000d92:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d94:	00000097          	auipc	ra,0x0
    80000d98:	f94080e7          	jalr	-108(ra) # 80000d28 <memmove>
}
    80000d9c:	60a2                	ld	ra,8(sp)
    80000d9e:	6402                	ld	s0,0(sp)
    80000da0:	0141                	addi	sp,sp,16
    80000da2:	8082                	ret

0000000080000da4 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000da4:	1141                	addi	sp,sp,-16
    80000da6:	e422                	sd	s0,8(sp)
    80000da8:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000daa:	ce11                	beqz	a2,80000dc6 <strncmp+0x22>
    80000dac:	00054783          	lbu	a5,0(a0)
    80000db0:	cf89                	beqz	a5,80000dca <strncmp+0x26>
    80000db2:	0005c703          	lbu	a4,0(a1)
    80000db6:	00f71a63          	bne	a4,a5,80000dca <strncmp+0x26>
    n--, p++, q++;
    80000dba:	367d                	addiw	a2,a2,-1
    80000dbc:	0505                	addi	a0,a0,1
    80000dbe:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dc0:	f675                	bnez	a2,80000dac <strncmp+0x8>
  if(n == 0)
    return 0;
    80000dc2:	4501                	li	a0,0
    80000dc4:	a809                	j	80000dd6 <strncmp+0x32>
    80000dc6:	4501                	li	a0,0
    80000dc8:	a039                	j	80000dd6 <strncmp+0x32>
  if(n == 0)
    80000dca:	ca09                	beqz	a2,80000ddc <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000dcc:	00054503          	lbu	a0,0(a0)
    80000dd0:	0005c783          	lbu	a5,0(a1)
    80000dd4:	9d1d                	subw	a0,a0,a5
}
    80000dd6:	6422                	ld	s0,8(sp)
    80000dd8:	0141                	addi	sp,sp,16
    80000dda:	8082                	ret
    return 0;
    80000ddc:	4501                	li	a0,0
    80000dde:	bfe5                	j	80000dd6 <strncmp+0x32>

0000000080000de0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000de0:	1141                	addi	sp,sp,-16
    80000de2:	e422                	sd	s0,8(sp)
    80000de4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000de6:	872a                	mv	a4,a0
    80000de8:	8832                	mv	a6,a2
    80000dea:	367d                	addiw	a2,a2,-1
    80000dec:	01005963          	blez	a6,80000dfe <strncpy+0x1e>
    80000df0:	0705                	addi	a4,a4,1
    80000df2:	0005c783          	lbu	a5,0(a1)
    80000df6:	fef70fa3          	sb	a5,-1(a4)
    80000dfa:	0585                	addi	a1,a1,1
    80000dfc:	f7f5                	bnez	a5,80000de8 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000dfe:	86ba                	mv	a3,a4
    80000e00:	00c05c63          	blez	a2,80000e18 <strncpy+0x38>
    *s++ = 0;
    80000e04:	0685                	addi	a3,a3,1
    80000e06:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e0a:	fff6c793          	not	a5,a3
    80000e0e:	9fb9                	addw	a5,a5,a4
    80000e10:	010787bb          	addw	a5,a5,a6
    80000e14:	fef048e3          	bgtz	a5,80000e04 <strncpy+0x24>
  return os;
}
    80000e18:	6422                	ld	s0,8(sp)
    80000e1a:	0141                	addi	sp,sp,16
    80000e1c:	8082                	ret

0000000080000e1e <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e1e:	1141                	addi	sp,sp,-16
    80000e20:	e422                	sd	s0,8(sp)
    80000e22:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e24:	02c05363          	blez	a2,80000e4a <safestrcpy+0x2c>
    80000e28:	fff6069b          	addiw	a3,a2,-1
    80000e2c:	1682                	slli	a3,a3,0x20
    80000e2e:	9281                	srli	a3,a3,0x20
    80000e30:	96ae                	add	a3,a3,a1
    80000e32:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e34:	00d58963          	beq	a1,a3,80000e46 <safestrcpy+0x28>
    80000e38:	0585                	addi	a1,a1,1
    80000e3a:	0785                	addi	a5,a5,1
    80000e3c:	fff5c703          	lbu	a4,-1(a1)
    80000e40:	fee78fa3          	sb	a4,-1(a5)
    80000e44:	fb65                	bnez	a4,80000e34 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e46:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e4a:	6422                	ld	s0,8(sp)
    80000e4c:	0141                	addi	sp,sp,16
    80000e4e:	8082                	ret

0000000080000e50 <strlen>:

int
strlen(const char *s)
{
    80000e50:	1141                	addi	sp,sp,-16
    80000e52:	e422                	sd	s0,8(sp)
    80000e54:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e56:	00054783          	lbu	a5,0(a0)
    80000e5a:	cf91                	beqz	a5,80000e76 <strlen+0x26>
    80000e5c:	0505                	addi	a0,a0,1
    80000e5e:	87aa                	mv	a5,a0
    80000e60:	4685                	li	a3,1
    80000e62:	9e89                	subw	a3,a3,a0
    80000e64:	00f6853b          	addw	a0,a3,a5
    80000e68:	0785                	addi	a5,a5,1
    80000e6a:	fff7c703          	lbu	a4,-1(a5)
    80000e6e:	fb7d                	bnez	a4,80000e64 <strlen+0x14>
    ;
  return n;
}
    80000e70:	6422                	ld	s0,8(sp)
    80000e72:	0141                	addi	sp,sp,16
    80000e74:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e76:	4501                	li	a0,0
    80000e78:	bfe5                	j	80000e70 <strlen+0x20>

0000000080000e7a <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e7a:	1141                	addi	sp,sp,-16
    80000e7c:	e406                	sd	ra,8(sp)
    80000e7e:	e022                	sd	s0,0(sp)
    80000e80:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e82:	00001097          	auipc	ra,0x1
    80000e86:	bb0080e7          	jalr	-1104(ra) # 80001a32 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e8a:	00009717          	auipc	a4,0x9
    80000e8e:	18e70713          	addi	a4,a4,398 # 8000a018 <started>
  if(cpuid() == 0){
    80000e92:	c139                	beqz	a0,80000ed8 <main+0x5e>
    while(started == 0)
    80000e94:	431c                	lw	a5,0(a4)
    80000e96:	2781                	sext.w	a5,a5
    80000e98:	dff5                	beqz	a5,80000e94 <main+0x1a>
      ;
    __sync_synchronize();
    80000e9a:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e9e:	00001097          	auipc	ra,0x1
    80000ea2:	b94080e7          	jalr	-1132(ra) # 80001a32 <cpuid>
    80000ea6:	85aa                	mv	a1,a0
    80000ea8:	00008517          	auipc	a0,0x8
    80000eac:	21050513          	addi	a0,a0,528 # 800090b8 <digits+0x78>
    80000eb0:	fffff097          	auipc	ra,0xfffff
    80000eb4:	6c4080e7          	jalr	1732(ra) # 80000574 <printf>
    kvminithart();    // turn on paging
    80000eb8:	00000097          	auipc	ra,0x0
    80000ebc:	0d8080e7          	jalr	216(ra) # 80000f90 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ec0:	00002097          	auipc	ra,0x2
    80000ec4:	44a080e7          	jalr	1098(ra) # 8000330a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ec8:	00006097          	auipc	ra,0x6
    80000ecc:	f18080e7          	jalr	-232(ra) # 80006de0 <plicinithart>
  }
  scheduler();        
    80000ed0:	00001097          	auipc	ra,0x1
    80000ed4:	70a080e7          	jalr	1802(ra) # 800025da <scheduler>
    consoleinit();
    80000ed8:	fffff097          	auipc	ra,0xfffff
    80000edc:	564080e7          	jalr	1380(ra) # 8000043c <consoleinit>
    printfinit();
    80000ee0:	00000097          	auipc	ra,0x0
    80000ee4:	874080e7          	jalr	-1932(ra) # 80000754 <printfinit>
    printf("\n");
    80000ee8:	00008517          	auipc	a0,0x8
    80000eec:	52050513          	addi	a0,a0,1312 # 80009408 <states.0+0x150>
    80000ef0:	fffff097          	auipc	ra,0xfffff
    80000ef4:	684080e7          	jalr	1668(ra) # 80000574 <printf>
    printf("xv6 kernel is booting\n");
    80000ef8:	00008517          	auipc	a0,0x8
    80000efc:	1a850513          	addi	a0,a0,424 # 800090a0 <digits+0x60>
    80000f00:	fffff097          	auipc	ra,0xfffff
    80000f04:	674080e7          	jalr	1652(ra) # 80000574 <printf>
    printf("\n");
    80000f08:	00008517          	auipc	a0,0x8
    80000f0c:	50050513          	addi	a0,a0,1280 # 80009408 <states.0+0x150>
    80000f10:	fffff097          	auipc	ra,0xfffff
    80000f14:	664080e7          	jalr	1636(ra) # 80000574 <printf>
    kinit();         // physical page allocator
    80000f18:	00000097          	auipc	ra,0x0
    80000f1c:	b7e080e7          	jalr	-1154(ra) # 80000a96 <kinit>
    kvminit();       // create kernel page table
    80000f20:	00000097          	auipc	ra,0x0
    80000f24:	310080e7          	jalr	784(ra) # 80001230 <kvminit>
    kvminithart();   // turn on paging
    80000f28:	00000097          	auipc	ra,0x0
    80000f2c:	068080e7          	jalr	104(ra) # 80000f90 <kvminithart>
    procinit();      // process table
    80000f30:	00001097          	auipc	ra,0x1
    80000f34:	9d2080e7          	jalr	-1582(ra) # 80001902 <procinit>
    trapinit();      // trap vectors
    80000f38:	00002097          	auipc	ra,0x2
    80000f3c:	3aa080e7          	jalr	938(ra) # 800032e2 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f40:	00002097          	auipc	ra,0x2
    80000f44:	3ca080e7          	jalr	970(ra) # 8000330a <trapinithart>
    plicinit();      // set up interrupt controller
    80000f48:	00006097          	auipc	ra,0x6
    80000f4c:	e82080e7          	jalr	-382(ra) # 80006dca <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f50:	00006097          	auipc	ra,0x6
    80000f54:	e90080e7          	jalr	-368(ra) # 80006de0 <plicinithart>
    binit();         // buffer cache
    80000f58:	00003097          	auipc	ra,0x3
    80000f5c:	fd0080e7          	jalr	-48(ra) # 80003f28 <binit>
    iinit();         // inode cache
    80000f60:	00003097          	auipc	ra,0x3
    80000f64:	662080e7          	jalr	1634(ra) # 800045c2 <iinit>
    fileinit();      // file table
    80000f68:	00004097          	auipc	ra,0x4
    80000f6c:	614080e7          	jalr	1556(ra) # 8000557c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f70:	00006097          	auipc	ra,0x6
    80000f74:	f92080e7          	jalr	-110(ra) # 80006f02 <virtio_disk_init>
    userinit();      // first user process
    80000f78:	00001097          	auipc	ra,0x1
    80000f7c:	f8a080e7          	jalr	-118(ra) # 80001f02 <userinit>
    __sync_synchronize();
    80000f80:	0ff0000f          	fence
    started = 1;
    80000f84:	4785                	li	a5,1
    80000f86:	00009717          	auipc	a4,0x9
    80000f8a:	08f72923          	sw	a5,146(a4) # 8000a018 <started>
    80000f8e:	b789                	j	80000ed0 <main+0x56>

0000000080000f90 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f90:	1141                	addi	sp,sp,-16
    80000f92:	e422                	sd	s0,8(sp)
    80000f94:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000f96:	00009797          	auipc	a5,0x9
    80000f9a:	08a7b783          	ld	a5,138(a5) # 8000a020 <kernel_pagetable>
    80000f9e:	83b1                	srli	a5,a5,0xc
    80000fa0:	577d                	li	a4,-1
    80000fa2:	177e                	slli	a4,a4,0x3f
    80000fa4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000fa6:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000faa:	12000073          	sfence.vma
  sfence_vma();
}
    80000fae:	6422                	ld	s0,8(sp)
    80000fb0:	0141                	addi	sp,sp,16
    80000fb2:	8082                	ret

0000000080000fb4 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fb4:	7139                	addi	sp,sp,-64
    80000fb6:	fc06                	sd	ra,56(sp)
    80000fb8:	f822                	sd	s0,48(sp)
    80000fba:	f426                	sd	s1,40(sp)
    80000fbc:	f04a                	sd	s2,32(sp)
    80000fbe:	ec4e                	sd	s3,24(sp)
    80000fc0:	e852                	sd	s4,16(sp)
    80000fc2:	e456                	sd	s5,8(sp)
    80000fc4:	e05a                	sd	s6,0(sp)
    80000fc6:	0080                	addi	s0,sp,64
    80000fc8:	84aa                	mv	s1,a0
    80000fca:	89ae                	mv	s3,a1
    80000fcc:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000fce:	57fd                	li	a5,-1
    80000fd0:	83e9                	srli	a5,a5,0x1a
    80000fd2:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fd4:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000fd6:	04b7f263          	bgeu	a5,a1,8000101a <walk+0x66>
    panic("walk");
    80000fda:	00008517          	auipc	a0,0x8
    80000fde:	0f650513          	addi	a0,a0,246 # 800090d0 <digits+0x90>
    80000fe2:	fffff097          	auipc	ra,0xfffff
    80000fe6:	548080e7          	jalr	1352(ra) # 8000052a <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fea:	060a8663          	beqz	s5,80001056 <walk+0xa2>
    80000fee:	00000097          	auipc	ra,0x0
    80000ff2:	ae4080e7          	jalr	-1308(ra) # 80000ad2 <kalloc>
    80000ff6:	84aa                	mv	s1,a0
    80000ff8:	c529                	beqz	a0,80001042 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000ffa:	6605                	lui	a2,0x1
    80000ffc:	4581                	li	a1,0
    80000ffe:	00000097          	auipc	ra,0x0
    80001002:	cce080e7          	jalr	-818(ra) # 80000ccc <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001006:	00c4d793          	srli	a5,s1,0xc
    8000100a:	07aa                	slli	a5,a5,0xa
    8000100c:	0017e793          	ori	a5,a5,1
    80001010:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001014:	3a5d                	addiw	s4,s4,-9
    80001016:	036a0063          	beq	s4,s6,80001036 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000101a:	0149d933          	srl	s2,s3,s4
    8000101e:	1ff97913          	andi	s2,s2,511
    80001022:	090e                	slli	s2,s2,0x3
    80001024:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001026:	00093483          	ld	s1,0(s2)
    8000102a:	0014f793          	andi	a5,s1,1
    8000102e:	dfd5                	beqz	a5,80000fea <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001030:	80a9                	srli	s1,s1,0xa
    80001032:	04b2                	slli	s1,s1,0xc
    80001034:	b7c5                	j	80001014 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001036:	00c9d513          	srli	a0,s3,0xc
    8000103a:	1ff57513          	andi	a0,a0,511
    8000103e:	050e                	slli	a0,a0,0x3
    80001040:	9526                	add	a0,a0,s1
}
    80001042:	70e2                	ld	ra,56(sp)
    80001044:	7442                	ld	s0,48(sp)
    80001046:	74a2                	ld	s1,40(sp)
    80001048:	7902                	ld	s2,32(sp)
    8000104a:	69e2                	ld	s3,24(sp)
    8000104c:	6a42                	ld	s4,16(sp)
    8000104e:	6aa2                	ld	s5,8(sp)
    80001050:	6b02                	ld	s6,0(sp)
    80001052:	6121                	addi	sp,sp,64
    80001054:	8082                	ret
        return 0;
    80001056:	4501                	li	a0,0
    80001058:	b7ed                	j	80001042 <walk+0x8e>

000000008000105a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000105a:	57fd                	li	a5,-1
    8000105c:	83e9                	srli	a5,a5,0x1a
    8000105e:	00b7f463          	bgeu	a5,a1,80001066 <walkaddr+0xc>
    return 0;
    80001062:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001064:	8082                	ret
{
    80001066:	1141                	addi	sp,sp,-16
    80001068:	e406                	sd	ra,8(sp)
    8000106a:	e022                	sd	s0,0(sp)
    8000106c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000106e:	4601                	li	a2,0
    80001070:	00000097          	auipc	ra,0x0
    80001074:	f44080e7          	jalr	-188(ra) # 80000fb4 <walk>
  if(pte == 0)
    80001078:	c105                	beqz	a0,80001098 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000107a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000107c:	0117f693          	andi	a3,a5,17
    80001080:	4745                	li	a4,17
    return 0;
    80001082:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001084:	00e68663          	beq	a3,a4,80001090 <walkaddr+0x36>
}
    80001088:	60a2                	ld	ra,8(sp)
    8000108a:	6402                	ld	s0,0(sp)
    8000108c:	0141                	addi	sp,sp,16
    8000108e:	8082                	ret
  pa = PTE2PA(*pte);
    80001090:	00a7d513          	srli	a0,a5,0xa
    80001094:	0532                	slli	a0,a0,0xc
  return pa;
    80001096:	bfcd                	j	80001088 <walkaddr+0x2e>
    return 0;
    80001098:	4501                	li	a0,0
    8000109a:	b7fd                	j	80001088 <walkaddr+0x2e>

000000008000109c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000109c:	715d                	addi	sp,sp,-80
    8000109e:	e486                	sd	ra,72(sp)
    800010a0:	e0a2                	sd	s0,64(sp)
    800010a2:	fc26                	sd	s1,56(sp)
    800010a4:	f84a                	sd	s2,48(sp)
    800010a6:	f44e                	sd	s3,40(sp)
    800010a8:	f052                	sd	s4,32(sp)
    800010aa:	ec56                	sd	s5,24(sp)
    800010ac:	e85a                	sd	s6,16(sp)
    800010ae:	e45e                	sd	s7,8(sp)
    800010b0:	0880                	addi	s0,sp,80
    800010b2:	8aaa                	mv	s5,a0
    800010b4:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    800010b6:	777d                	lui	a4,0xfffff
    800010b8:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800010bc:	167d                	addi	a2,a2,-1
    800010be:	00b609b3          	add	s3,a2,a1
    800010c2:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800010c6:	893e                	mv	s2,a5
    800010c8:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800010cc:	6b85                	lui	s7,0x1
    800010ce:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800010d2:	4605                	li	a2,1
    800010d4:	85ca                	mv	a1,s2
    800010d6:	8556                	mv	a0,s5
    800010d8:	00000097          	auipc	ra,0x0
    800010dc:	edc080e7          	jalr	-292(ra) # 80000fb4 <walk>
    800010e0:	c51d                	beqz	a0,8000110e <mappages+0x72>
    if(*pte & PTE_V)
    800010e2:	611c                	ld	a5,0(a0)
    800010e4:	8b85                	andi	a5,a5,1
    800010e6:	ef81                	bnez	a5,800010fe <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010e8:	80b1                	srli	s1,s1,0xc
    800010ea:	04aa                	slli	s1,s1,0xa
    800010ec:	0164e4b3          	or	s1,s1,s6
    800010f0:	0014e493          	ori	s1,s1,1
    800010f4:	e104                	sd	s1,0(a0)
    if(a == last)
    800010f6:	03390863          	beq	s2,s3,80001126 <mappages+0x8a>
    a += PGSIZE;
    800010fa:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800010fc:	bfc9                	j	800010ce <mappages+0x32>
      panic("remap");
    800010fe:	00008517          	auipc	a0,0x8
    80001102:	fda50513          	addi	a0,a0,-38 # 800090d8 <digits+0x98>
    80001106:	fffff097          	auipc	ra,0xfffff
    8000110a:	424080e7          	jalr	1060(ra) # 8000052a <panic>
      return -1;
    8000110e:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001110:	60a6                	ld	ra,72(sp)
    80001112:	6406                	ld	s0,64(sp)
    80001114:	74e2                	ld	s1,56(sp)
    80001116:	7942                	ld	s2,48(sp)
    80001118:	79a2                	ld	s3,40(sp)
    8000111a:	7a02                	ld	s4,32(sp)
    8000111c:	6ae2                	ld	s5,24(sp)
    8000111e:	6b42                	ld	s6,16(sp)
    80001120:	6ba2                	ld	s7,8(sp)
    80001122:	6161                	addi	sp,sp,80
    80001124:	8082                	ret
  return 0;
    80001126:	4501                	li	a0,0
    80001128:	b7e5                	j	80001110 <mappages+0x74>

000000008000112a <kvmmap>:
{
    8000112a:	1141                	addi	sp,sp,-16
    8000112c:	e406                	sd	ra,8(sp)
    8000112e:	e022                	sd	s0,0(sp)
    80001130:	0800                	addi	s0,sp,16
    80001132:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001134:	86b2                	mv	a3,a2
    80001136:	863e                	mv	a2,a5
    80001138:	00000097          	auipc	ra,0x0
    8000113c:	f64080e7          	jalr	-156(ra) # 8000109c <mappages>
    80001140:	e509                	bnez	a0,8000114a <kvmmap+0x20>
}
    80001142:	60a2                	ld	ra,8(sp)
    80001144:	6402                	ld	s0,0(sp)
    80001146:	0141                	addi	sp,sp,16
    80001148:	8082                	ret
    panic("kvmmap");
    8000114a:	00008517          	auipc	a0,0x8
    8000114e:	f9650513          	addi	a0,a0,-106 # 800090e0 <digits+0xa0>
    80001152:	fffff097          	auipc	ra,0xfffff
    80001156:	3d8080e7          	jalr	984(ra) # 8000052a <panic>

000000008000115a <kvmmake>:
{
    8000115a:	1101                	addi	sp,sp,-32
    8000115c:	ec06                	sd	ra,24(sp)
    8000115e:	e822                	sd	s0,16(sp)
    80001160:	e426                	sd	s1,8(sp)
    80001162:	e04a                	sd	s2,0(sp)
    80001164:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001166:	00000097          	auipc	ra,0x0
    8000116a:	96c080e7          	jalr	-1684(ra) # 80000ad2 <kalloc>
    8000116e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001170:	6605                	lui	a2,0x1
    80001172:	4581                	li	a1,0
    80001174:	00000097          	auipc	ra,0x0
    80001178:	b58080e7          	jalr	-1192(ra) # 80000ccc <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000117c:	4719                	li	a4,6
    8000117e:	6685                	lui	a3,0x1
    80001180:	10000637          	lui	a2,0x10000
    80001184:	100005b7          	lui	a1,0x10000
    80001188:	8526                	mv	a0,s1
    8000118a:	00000097          	auipc	ra,0x0
    8000118e:	fa0080e7          	jalr	-96(ra) # 8000112a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001192:	4719                	li	a4,6
    80001194:	6685                	lui	a3,0x1
    80001196:	10001637          	lui	a2,0x10001
    8000119a:	100015b7          	lui	a1,0x10001
    8000119e:	8526                	mv	a0,s1
    800011a0:	00000097          	auipc	ra,0x0
    800011a4:	f8a080e7          	jalr	-118(ra) # 8000112a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800011a8:	4719                	li	a4,6
    800011aa:	004006b7          	lui	a3,0x400
    800011ae:	0c000637          	lui	a2,0xc000
    800011b2:	0c0005b7          	lui	a1,0xc000
    800011b6:	8526                	mv	a0,s1
    800011b8:	00000097          	auipc	ra,0x0
    800011bc:	f72080e7          	jalr	-142(ra) # 8000112a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011c0:	00008917          	auipc	s2,0x8
    800011c4:	e4090913          	addi	s2,s2,-448 # 80009000 <etext>
    800011c8:	4729                	li	a4,10
    800011ca:	80008697          	auipc	a3,0x80008
    800011ce:	e3668693          	addi	a3,a3,-458 # 9000 <_entry-0x7fff7000>
    800011d2:	4605                	li	a2,1
    800011d4:	067e                	slli	a2,a2,0x1f
    800011d6:	85b2                	mv	a1,a2
    800011d8:	8526                	mv	a0,s1
    800011da:	00000097          	auipc	ra,0x0
    800011de:	f50080e7          	jalr	-176(ra) # 8000112a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800011e2:	4719                	li	a4,6
    800011e4:	46c5                	li	a3,17
    800011e6:	06ee                	slli	a3,a3,0x1b
    800011e8:	412686b3          	sub	a3,a3,s2
    800011ec:	864a                	mv	a2,s2
    800011ee:	85ca                	mv	a1,s2
    800011f0:	8526                	mv	a0,s1
    800011f2:	00000097          	auipc	ra,0x0
    800011f6:	f38080e7          	jalr	-200(ra) # 8000112a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011fa:	4729                	li	a4,10
    800011fc:	6685                	lui	a3,0x1
    800011fe:	00007617          	auipc	a2,0x7
    80001202:	e0260613          	addi	a2,a2,-510 # 80008000 <_trampoline>
    80001206:	040005b7          	lui	a1,0x4000
    8000120a:	15fd                	addi	a1,a1,-1
    8000120c:	05b2                	slli	a1,a1,0xc
    8000120e:	8526                	mv	a0,s1
    80001210:	00000097          	auipc	ra,0x0
    80001214:	f1a080e7          	jalr	-230(ra) # 8000112a <kvmmap>
  proc_mapstacks(kpgtbl);
    80001218:	8526                	mv	a0,s1
    8000121a:	00000097          	auipc	ra,0x0
    8000121e:	600080e7          	jalr	1536(ra) # 8000181a <proc_mapstacks>
}
    80001222:	8526                	mv	a0,s1
    80001224:	60e2                	ld	ra,24(sp)
    80001226:	6442                	ld	s0,16(sp)
    80001228:	64a2                	ld	s1,8(sp)
    8000122a:	6902                	ld	s2,0(sp)
    8000122c:	6105                	addi	sp,sp,32
    8000122e:	8082                	ret

0000000080001230 <kvminit>:
{
    80001230:	1141                	addi	sp,sp,-16
    80001232:	e406                	sd	ra,8(sp)
    80001234:	e022                	sd	s0,0(sp)
    80001236:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001238:	00000097          	auipc	ra,0x0
    8000123c:	f22080e7          	jalr	-222(ra) # 8000115a <kvmmake>
    80001240:	00009797          	auipc	a5,0x9
    80001244:	dea7b023          	sd	a0,-544(a5) # 8000a020 <kernel_pagetable>
}
    80001248:	60a2                	ld	ra,8(sp)
    8000124a:	6402                	ld	s0,0(sp)
    8000124c:	0141                	addi	sp,sp,16
    8000124e:	8082                	ret

0000000080001250 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001250:	715d                	addi	sp,sp,-80
    80001252:	e486                	sd	ra,72(sp)
    80001254:	e0a2                	sd	s0,64(sp)
    80001256:	fc26                	sd	s1,56(sp)
    80001258:	f84a                	sd	s2,48(sp)
    8000125a:	f44e                	sd	s3,40(sp)
    8000125c:	f052                	sd	s4,32(sp)
    8000125e:	ec56                	sd	s5,24(sp)
    80001260:	e85a                	sd	s6,16(sp)
    80001262:	e45e                	sd	s7,8(sp)
    80001264:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001266:	03459793          	slli	a5,a1,0x34
    8000126a:	e795                	bnez	a5,80001296 <uvmunmap+0x46>
    8000126c:	8a2a                	mv	s4,a0
    8000126e:	892e                	mv	s2,a1
    80001270:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001272:	0632                	slli	a2,a2,0xc
    80001274:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001278:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000127a:	6b05                	lui	s6,0x1
    8000127c:	0735e263          	bltu	a1,s3,800012e0 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001280:	60a6                	ld	ra,72(sp)
    80001282:	6406                	ld	s0,64(sp)
    80001284:	74e2                	ld	s1,56(sp)
    80001286:	7942                	ld	s2,48(sp)
    80001288:	79a2                	ld	s3,40(sp)
    8000128a:	7a02                	ld	s4,32(sp)
    8000128c:	6ae2                	ld	s5,24(sp)
    8000128e:	6b42                	ld	s6,16(sp)
    80001290:	6ba2                	ld	s7,8(sp)
    80001292:	6161                	addi	sp,sp,80
    80001294:	8082                	ret
    panic("uvmunmap: not aligned");
    80001296:	00008517          	auipc	a0,0x8
    8000129a:	e5250513          	addi	a0,a0,-430 # 800090e8 <digits+0xa8>
    8000129e:	fffff097          	auipc	ra,0xfffff
    800012a2:	28c080e7          	jalr	652(ra) # 8000052a <panic>
      panic("uvmunmap: walk");
    800012a6:	00008517          	auipc	a0,0x8
    800012aa:	e5a50513          	addi	a0,a0,-422 # 80009100 <digits+0xc0>
    800012ae:	fffff097          	auipc	ra,0xfffff
    800012b2:	27c080e7          	jalr	636(ra) # 8000052a <panic>
      panic("uvmunmap: not mapped");
    800012b6:	00008517          	auipc	a0,0x8
    800012ba:	e5a50513          	addi	a0,a0,-422 # 80009110 <digits+0xd0>
    800012be:	fffff097          	auipc	ra,0xfffff
    800012c2:	26c080e7          	jalr	620(ra) # 8000052a <panic>
      panic("uvmunmap: not a leaf");
    800012c6:	00008517          	auipc	a0,0x8
    800012ca:	e6250513          	addi	a0,a0,-414 # 80009128 <digits+0xe8>
    800012ce:	fffff097          	auipc	ra,0xfffff
    800012d2:	25c080e7          	jalr	604(ra) # 8000052a <panic>
    *pte = 0;
    800012d6:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012da:	995a                	add	s2,s2,s6
    800012dc:	fb3972e3          	bgeu	s2,s3,80001280 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800012e0:	4601                	li	a2,0
    800012e2:	85ca                	mv	a1,s2
    800012e4:	8552                	mv	a0,s4
    800012e6:	00000097          	auipc	ra,0x0
    800012ea:	cce080e7          	jalr	-818(ra) # 80000fb4 <walk>
    800012ee:	84aa                	mv	s1,a0
    800012f0:	d95d                	beqz	a0,800012a6 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800012f2:	6108                	ld	a0,0(a0)
    800012f4:	00157793          	andi	a5,a0,1
    800012f8:	dfdd                	beqz	a5,800012b6 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800012fa:	3ff57793          	andi	a5,a0,1023
    800012fe:	fd7784e3          	beq	a5,s7,800012c6 <uvmunmap+0x76>
    if(do_free){
    80001302:	fc0a8ae3          	beqz	s5,800012d6 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80001306:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001308:	0532                	slli	a0,a0,0xc
    8000130a:	fffff097          	auipc	ra,0xfffff
    8000130e:	6cc080e7          	jalr	1740(ra) # 800009d6 <kfree>
    80001312:	b7d1                	j	800012d6 <uvmunmap+0x86>

0000000080001314 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001314:	1101                	addi	sp,sp,-32
    80001316:	ec06                	sd	ra,24(sp)
    80001318:	e822                	sd	s0,16(sp)
    8000131a:	e426                	sd	s1,8(sp)
    8000131c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000131e:	fffff097          	auipc	ra,0xfffff
    80001322:	7b4080e7          	jalr	1972(ra) # 80000ad2 <kalloc>
    80001326:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001328:	c519                	beqz	a0,80001336 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000132a:	6605                	lui	a2,0x1
    8000132c:	4581                	li	a1,0
    8000132e:	00000097          	auipc	ra,0x0
    80001332:	99e080e7          	jalr	-1634(ra) # 80000ccc <memset>
  return pagetable;
}
    80001336:	8526                	mv	a0,s1
    80001338:	60e2                	ld	ra,24(sp)
    8000133a:	6442                	ld	s0,16(sp)
    8000133c:	64a2                	ld	s1,8(sp)
    8000133e:	6105                	addi	sp,sp,32
    80001340:	8082                	ret

0000000080001342 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80001342:	7179                	addi	sp,sp,-48
    80001344:	f406                	sd	ra,40(sp)
    80001346:	f022                	sd	s0,32(sp)
    80001348:	ec26                	sd	s1,24(sp)
    8000134a:	e84a                	sd	s2,16(sp)
    8000134c:	e44e                	sd	s3,8(sp)
    8000134e:	e052                	sd	s4,0(sp)
    80001350:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001352:	6785                	lui	a5,0x1
    80001354:	04f67863          	bgeu	a2,a5,800013a4 <uvminit+0x62>
    80001358:	8a2a                	mv	s4,a0
    8000135a:	89ae                	mv	s3,a1
    8000135c:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000135e:	fffff097          	auipc	ra,0xfffff
    80001362:	774080e7          	jalr	1908(ra) # 80000ad2 <kalloc>
    80001366:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001368:	6605                	lui	a2,0x1
    8000136a:	4581                	li	a1,0
    8000136c:	00000097          	auipc	ra,0x0
    80001370:	960080e7          	jalr	-1696(ra) # 80000ccc <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001374:	4779                	li	a4,30
    80001376:	86ca                	mv	a3,s2
    80001378:	6605                	lui	a2,0x1
    8000137a:	4581                	li	a1,0
    8000137c:	8552                	mv	a0,s4
    8000137e:	00000097          	auipc	ra,0x0
    80001382:	d1e080e7          	jalr	-738(ra) # 8000109c <mappages>
  memmove(mem, src, sz);
    80001386:	8626                	mv	a2,s1
    80001388:	85ce                	mv	a1,s3
    8000138a:	854a                	mv	a0,s2
    8000138c:	00000097          	auipc	ra,0x0
    80001390:	99c080e7          	jalr	-1636(ra) # 80000d28 <memmove>
}
    80001394:	70a2                	ld	ra,40(sp)
    80001396:	7402                	ld	s0,32(sp)
    80001398:	64e2                	ld	s1,24(sp)
    8000139a:	6942                	ld	s2,16(sp)
    8000139c:	69a2                	ld	s3,8(sp)
    8000139e:	6a02                	ld	s4,0(sp)
    800013a0:	6145                	addi	sp,sp,48
    800013a2:	8082                	ret
    panic("inituvm: more than a page");
    800013a4:	00008517          	auipc	a0,0x8
    800013a8:	d9c50513          	addi	a0,a0,-612 # 80009140 <digits+0x100>
    800013ac:	fffff097          	auipc	ra,0xfffff
    800013b0:	17e080e7          	jalr	382(ra) # 8000052a <panic>

00000000800013b4 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013b4:	1101                	addi	sp,sp,-32
    800013b6:	ec06                	sd	ra,24(sp)
    800013b8:	e822                	sd	s0,16(sp)
    800013ba:	e426                	sd	s1,8(sp)
    800013bc:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013be:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013c0:	00b67d63          	bgeu	a2,a1,800013da <uvmdealloc+0x26>
    800013c4:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013c6:	6785                	lui	a5,0x1
    800013c8:	17fd                	addi	a5,a5,-1
    800013ca:	00f60733          	add	a4,a2,a5
    800013ce:	767d                	lui	a2,0xfffff
    800013d0:	8f71                	and	a4,a4,a2
    800013d2:	97ae                	add	a5,a5,a1
    800013d4:	8ff1                	and	a5,a5,a2
    800013d6:	00f76863          	bltu	a4,a5,800013e6 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800013da:	8526                	mv	a0,s1
    800013dc:	60e2                	ld	ra,24(sp)
    800013de:	6442                	ld	s0,16(sp)
    800013e0:	64a2                	ld	s1,8(sp)
    800013e2:	6105                	addi	sp,sp,32
    800013e4:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800013e6:	8f99                	sub	a5,a5,a4
    800013e8:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800013ea:	4685                	li	a3,1
    800013ec:	0007861b          	sext.w	a2,a5
    800013f0:	85ba                	mv	a1,a4
    800013f2:	00000097          	auipc	ra,0x0
    800013f6:	e5e080e7          	jalr	-418(ra) # 80001250 <uvmunmap>
    800013fa:	b7c5                	j	800013da <uvmdealloc+0x26>

00000000800013fc <uvmalloc>:
  if(newsz < oldsz)
    800013fc:	0ab66163          	bltu	a2,a1,8000149e <uvmalloc+0xa2>
{
    80001400:	7139                	addi	sp,sp,-64
    80001402:	fc06                	sd	ra,56(sp)
    80001404:	f822                	sd	s0,48(sp)
    80001406:	f426                	sd	s1,40(sp)
    80001408:	f04a                	sd	s2,32(sp)
    8000140a:	ec4e                	sd	s3,24(sp)
    8000140c:	e852                	sd	s4,16(sp)
    8000140e:	e456                	sd	s5,8(sp)
    80001410:	0080                	addi	s0,sp,64
    80001412:	8aaa                	mv	s5,a0
    80001414:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001416:	6985                	lui	s3,0x1
    80001418:	19fd                	addi	s3,s3,-1
    8000141a:	95ce                	add	a1,a1,s3
    8000141c:	79fd                	lui	s3,0xfffff
    8000141e:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001422:	08c9f063          	bgeu	s3,a2,800014a2 <uvmalloc+0xa6>
    80001426:	894e                	mv	s2,s3
    mem = kalloc();
    80001428:	fffff097          	auipc	ra,0xfffff
    8000142c:	6aa080e7          	jalr	1706(ra) # 80000ad2 <kalloc>
    80001430:	84aa                	mv	s1,a0
    if(mem == 0){
    80001432:	c51d                	beqz	a0,80001460 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001434:	6605                	lui	a2,0x1
    80001436:	4581                	li	a1,0
    80001438:	00000097          	auipc	ra,0x0
    8000143c:	894080e7          	jalr	-1900(ra) # 80000ccc <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80001440:	4779                	li	a4,30
    80001442:	86a6                	mv	a3,s1
    80001444:	6605                	lui	a2,0x1
    80001446:	85ca                	mv	a1,s2
    80001448:	8556                	mv	a0,s5
    8000144a:	00000097          	auipc	ra,0x0
    8000144e:	c52080e7          	jalr	-942(ra) # 8000109c <mappages>
    80001452:	e905                	bnez	a0,80001482 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001454:	6785                	lui	a5,0x1
    80001456:	993e                	add	s2,s2,a5
    80001458:	fd4968e3          	bltu	s2,s4,80001428 <uvmalloc+0x2c>
  return newsz;
    8000145c:	8552                	mv	a0,s4
    8000145e:	a809                	j	80001470 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80001460:	864e                	mv	a2,s3
    80001462:	85ca                	mv	a1,s2
    80001464:	8556                	mv	a0,s5
    80001466:	00000097          	auipc	ra,0x0
    8000146a:	f4e080e7          	jalr	-178(ra) # 800013b4 <uvmdealloc>
      return 0;
    8000146e:	4501                	li	a0,0
}
    80001470:	70e2                	ld	ra,56(sp)
    80001472:	7442                	ld	s0,48(sp)
    80001474:	74a2                	ld	s1,40(sp)
    80001476:	7902                	ld	s2,32(sp)
    80001478:	69e2                	ld	s3,24(sp)
    8000147a:	6a42                	ld	s4,16(sp)
    8000147c:	6aa2                	ld	s5,8(sp)
    8000147e:	6121                	addi	sp,sp,64
    80001480:	8082                	ret
      kfree(mem);
    80001482:	8526                	mv	a0,s1
    80001484:	fffff097          	auipc	ra,0xfffff
    80001488:	552080e7          	jalr	1362(ra) # 800009d6 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000148c:	864e                	mv	a2,s3
    8000148e:	85ca                	mv	a1,s2
    80001490:	8556                	mv	a0,s5
    80001492:	00000097          	auipc	ra,0x0
    80001496:	f22080e7          	jalr	-222(ra) # 800013b4 <uvmdealloc>
      return 0;
    8000149a:	4501                	li	a0,0
    8000149c:	bfd1                	j	80001470 <uvmalloc+0x74>
    return oldsz;
    8000149e:	852e                	mv	a0,a1
}
    800014a0:	8082                	ret
  return newsz;
    800014a2:	8532                	mv	a0,a2
    800014a4:	b7f1                	j	80001470 <uvmalloc+0x74>

00000000800014a6 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800014a6:	7179                	addi	sp,sp,-48
    800014a8:	f406                	sd	ra,40(sp)
    800014aa:	f022                	sd	s0,32(sp)
    800014ac:	ec26                	sd	s1,24(sp)
    800014ae:	e84a                	sd	s2,16(sp)
    800014b0:	e44e                	sd	s3,8(sp)
    800014b2:	e052                	sd	s4,0(sp)
    800014b4:	1800                	addi	s0,sp,48
    800014b6:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014b8:	84aa                	mv	s1,a0
    800014ba:	6905                	lui	s2,0x1
    800014bc:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014be:	4985                	li	s3,1
    800014c0:	a821                	j	800014d8 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014c2:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800014c4:	0532                	slli	a0,a0,0xc
    800014c6:	00000097          	auipc	ra,0x0
    800014ca:	fe0080e7          	jalr	-32(ra) # 800014a6 <freewalk>
      pagetable[i] = 0;
    800014ce:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800014d2:	04a1                	addi	s1,s1,8
    800014d4:	03248163          	beq	s1,s2,800014f6 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800014d8:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014da:	00f57793          	andi	a5,a0,15
    800014de:	ff3782e3          	beq	a5,s3,800014c2 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800014e2:	8905                	andi	a0,a0,1
    800014e4:	d57d                	beqz	a0,800014d2 <freewalk+0x2c>
      panic("freewalk: leaf");
    800014e6:	00008517          	auipc	a0,0x8
    800014ea:	c7a50513          	addi	a0,a0,-902 # 80009160 <digits+0x120>
    800014ee:	fffff097          	auipc	ra,0xfffff
    800014f2:	03c080e7          	jalr	60(ra) # 8000052a <panic>
    }
  }
  kfree((void*)pagetable);
    800014f6:	8552                	mv	a0,s4
    800014f8:	fffff097          	auipc	ra,0xfffff
    800014fc:	4de080e7          	jalr	1246(ra) # 800009d6 <kfree>
}
    80001500:	70a2                	ld	ra,40(sp)
    80001502:	7402                	ld	s0,32(sp)
    80001504:	64e2                	ld	s1,24(sp)
    80001506:	6942                	ld	s2,16(sp)
    80001508:	69a2                	ld	s3,8(sp)
    8000150a:	6a02                	ld	s4,0(sp)
    8000150c:	6145                	addi	sp,sp,48
    8000150e:	8082                	ret

0000000080001510 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001510:	1101                	addi	sp,sp,-32
    80001512:	ec06                	sd	ra,24(sp)
    80001514:	e822                	sd	s0,16(sp)
    80001516:	e426                	sd	s1,8(sp)
    80001518:	1000                	addi	s0,sp,32
    8000151a:	84aa                	mv	s1,a0
  if(sz > 0)
    8000151c:	e999                	bnez	a1,80001532 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000151e:	8526                	mv	a0,s1
    80001520:	00000097          	auipc	ra,0x0
    80001524:	f86080e7          	jalr	-122(ra) # 800014a6 <freewalk>
}
    80001528:	60e2                	ld	ra,24(sp)
    8000152a:	6442                	ld	s0,16(sp)
    8000152c:	64a2                	ld	s1,8(sp)
    8000152e:	6105                	addi	sp,sp,32
    80001530:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001532:	6605                	lui	a2,0x1
    80001534:	167d                	addi	a2,a2,-1
    80001536:	962e                	add	a2,a2,a1
    80001538:	4685                	li	a3,1
    8000153a:	8231                	srli	a2,a2,0xc
    8000153c:	4581                	li	a1,0
    8000153e:	00000097          	auipc	ra,0x0
    80001542:	d12080e7          	jalr	-750(ra) # 80001250 <uvmunmap>
    80001546:	bfe1                	j	8000151e <uvmfree+0xe>

0000000080001548 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001548:	c679                	beqz	a2,80001616 <uvmcopy+0xce>
{
    8000154a:	715d                	addi	sp,sp,-80
    8000154c:	e486                	sd	ra,72(sp)
    8000154e:	e0a2                	sd	s0,64(sp)
    80001550:	fc26                	sd	s1,56(sp)
    80001552:	f84a                	sd	s2,48(sp)
    80001554:	f44e                	sd	s3,40(sp)
    80001556:	f052                	sd	s4,32(sp)
    80001558:	ec56                	sd	s5,24(sp)
    8000155a:	e85a                	sd	s6,16(sp)
    8000155c:	e45e                	sd	s7,8(sp)
    8000155e:	0880                	addi	s0,sp,80
    80001560:	8b2a                	mv	s6,a0
    80001562:	8aae                	mv	s5,a1
    80001564:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001566:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001568:	4601                	li	a2,0
    8000156a:	85ce                	mv	a1,s3
    8000156c:	855a                	mv	a0,s6
    8000156e:	00000097          	auipc	ra,0x0
    80001572:	a46080e7          	jalr	-1466(ra) # 80000fb4 <walk>
    80001576:	c531                	beqz	a0,800015c2 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001578:	6118                	ld	a4,0(a0)
    8000157a:	00177793          	andi	a5,a4,1
    8000157e:	cbb1                	beqz	a5,800015d2 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001580:	00a75593          	srli	a1,a4,0xa
    80001584:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001588:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000158c:	fffff097          	auipc	ra,0xfffff
    80001590:	546080e7          	jalr	1350(ra) # 80000ad2 <kalloc>
    80001594:	892a                	mv	s2,a0
    80001596:	c939                	beqz	a0,800015ec <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001598:	6605                	lui	a2,0x1
    8000159a:	85de                	mv	a1,s7
    8000159c:	fffff097          	auipc	ra,0xfffff
    800015a0:	78c080e7          	jalr	1932(ra) # 80000d28 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800015a4:	8726                	mv	a4,s1
    800015a6:	86ca                	mv	a3,s2
    800015a8:	6605                	lui	a2,0x1
    800015aa:	85ce                	mv	a1,s3
    800015ac:	8556                	mv	a0,s5
    800015ae:	00000097          	auipc	ra,0x0
    800015b2:	aee080e7          	jalr	-1298(ra) # 8000109c <mappages>
    800015b6:	e515                	bnez	a0,800015e2 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800015b8:	6785                	lui	a5,0x1
    800015ba:	99be                	add	s3,s3,a5
    800015bc:	fb49e6e3          	bltu	s3,s4,80001568 <uvmcopy+0x20>
    800015c0:	a081                	j	80001600 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800015c2:	00008517          	auipc	a0,0x8
    800015c6:	bae50513          	addi	a0,a0,-1106 # 80009170 <digits+0x130>
    800015ca:	fffff097          	auipc	ra,0xfffff
    800015ce:	f60080e7          	jalr	-160(ra) # 8000052a <panic>
      panic("uvmcopy: page not present");
    800015d2:	00008517          	auipc	a0,0x8
    800015d6:	bbe50513          	addi	a0,a0,-1090 # 80009190 <digits+0x150>
    800015da:	fffff097          	auipc	ra,0xfffff
    800015de:	f50080e7          	jalr	-176(ra) # 8000052a <panic>
      kfree(mem);
    800015e2:	854a                	mv	a0,s2
    800015e4:	fffff097          	auipc	ra,0xfffff
    800015e8:	3f2080e7          	jalr	1010(ra) # 800009d6 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800015ec:	4685                	li	a3,1
    800015ee:	00c9d613          	srli	a2,s3,0xc
    800015f2:	4581                	li	a1,0
    800015f4:	8556                	mv	a0,s5
    800015f6:	00000097          	auipc	ra,0x0
    800015fa:	c5a080e7          	jalr	-934(ra) # 80001250 <uvmunmap>
  return -1;
    800015fe:	557d                	li	a0,-1
}
    80001600:	60a6                	ld	ra,72(sp)
    80001602:	6406                	ld	s0,64(sp)
    80001604:	74e2                	ld	s1,56(sp)
    80001606:	7942                	ld	s2,48(sp)
    80001608:	79a2                	ld	s3,40(sp)
    8000160a:	7a02                	ld	s4,32(sp)
    8000160c:	6ae2                	ld	s5,24(sp)
    8000160e:	6b42                	ld	s6,16(sp)
    80001610:	6ba2                	ld	s7,8(sp)
    80001612:	6161                	addi	sp,sp,80
    80001614:	8082                	ret
  return 0;
    80001616:	4501                	li	a0,0
}
    80001618:	8082                	ret

000000008000161a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000161a:	1141                	addi	sp,sp,-16
    8000161c:	e406                	sd	ra,8(sp)
    8000161e:	e022                	sd	s0,0(sp)
    80001620:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001622:	4601                	li	a2,0
    80001624:	00000097          	auipc	ra,0x0
    80001628:	990080e7          	jalr	-1648(ra) # 80000fb4 <walk>
  if(pte == 0)
    8000162c:	c901                	beqz	a0,8000163c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000162e:	611c                	ld	a5,0(a0)
    80001630:	9bbd                	andi	a5,a5,-17
    80001632:	e11c                	sd	a5,0(a0)
}
    80001634:	60a2                	ld	ra,8(sp)
    80001636:	6402                	ld	s0,0(sp)
    80001638:	0141                	addi	sp,sp,16
    8000163a:	8082                	ret
    panic("uvmclear");
    8000163c:	00008517          	auipc	a0,0x8
    80001640:	b7450513          	addi	a0,a0,-1164 # 800091b0 <digits+0x170>
    80001644:	fffff097          	auipc	ra,0xfffff
    80001648:	ee6080e7          	jalr	-282(ra) # 8000052a <panic>

000000008000164c <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000164c:	c6bd                	beqz	a3,800016ba <copyout+0x6e>
{
    8000164e:	715d                	addi	sp,sp,-80
    80001650:	e486                	sd	ra,72(sp)
    80001652:	e0a2                	sd	s0,64(sp)
    80001654:	fc26                	sd	s1,56(sp)
    80001656:	f84a                	sd	s2,48(sp)
    80001658:	f44e                	sd	s3,40(sp)
    8000165a:	f052                	sd	s4,32(sp)
    8000165c:	ec56                	sd	s5,24(sp)
    8000165e:	e85a                	sd	s6,16(sp)
    80001660:	e45e                	sd	s7,8(sp)
    80001662:	e062                	sd	s8,0(sp)
    80001664:	0880                	addi	s0,sp,80
    80001666:	8b2a                	mv	s6,a0
    80001668:	8c2e                	mv	s8,a1
    8000166a:	8a32                	mv	s4,a2
    8000166c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000166e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001670:	6a85                	lui	s5,0x1
    80001672:	a015                	j	80001696 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001674:	9562                	add	a0,a0,s8
    80001676:	0004861b          	sext.w	a2,s1
    8000167a:	85d2                	mv	a1,s4
    8000167c:	41250533          	sub	a0,a0,s2
    80001680:	fffff097          	auipc	ra,0xfffff
    80001684:	6a8080e7          	jalr	1704(ra) # 80000d28 <memmove>

    len -= n;
    80001688:	409989b3          	sub	s3,s3,s1
    src += n;
    8000168c:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    8000168e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001692:	02098263          	beqz	s3,800016b6 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001696:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000169a:	85ca                	mv	a1,s2
    8000169c:	855a                	mv	a0,s6
    8000169e:	00000097          	auipc	ra,0x0
    800016a2:	9bc080e7          	jalr	-1604(ra) # 8000105a <walkaddr>
    if(pa0 == 0)
    800016a6:	cd01                	beqz	a0,800016be <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800016a8:	418904b3          	sub	s1,s2,s8
    800016ac:	94d6                	add	s1,s1,s5
    if(n > len)
    800016ae:	fc99f3e3          	bgeu	s3,s1,80001674 <copyout+0x28>
    800016b2:	84ce                	mv	s1,s3
    800016b4:	b7c1                	j	80001674 <copyout+0x28>
  }
  return 0;
    800016b6:	4501                	li	a0,0
    800016b8:	a021                	j	800016c0 <copyout+0x74>
    800016ba:	4501                	li	a0,0
}
    800016bc:	8082                	ret
      return -1;
    800016be:	557d                	li	a0,-1
}
    800016c0:	60a6                	ld	ra,72(sp)
    800016c2:	6406                	ld	s0,64(sp)
    800016c4:	74e2                	ld	s1,56(sp)
    800016c6:	7942                	ld	s2,48(sp)
    800016c8:	79a2                	ld	s3,40(sp)
    800016ca:	7a02                	ld	s4,32(sp)
    800016cc:	6ae2                	ld	s5,24(sp)
    800016ce:	6b42                	ld	s6,16(sp)
    800016d0:	6ba2                	ld	s7,8(sp)
    800016d2:	6c02                	ld	s8,0(sp)
    800016d4:	6161                	addi	sp,sp,80
    800016d6:	8082                	ret

00000000800016d8 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016d8:	caa5                	beqz	a3,80001748 <copyin+0x70>
{
    800016da:	715d                	addi	sp,sp,-80
    800016dc:	e486                	sd	ra,72(sp)
    800016de:	e0a2                	sd	s0,64(sp)
    800016e0:	fc26                	sd	s1,56(sp)
    800016e2:	f84a                	sd	s2,48(sp)
    800016e4:	f44e                	sd	s3,40(sp)
    800016e6:	f052                	sd	s4,32(sp)
    800016e8:	ec56                	sd	s5,24(sp)
    800016ea:	e85a                	sd	s6,16(sp)
    800016ec:	e45e                	sd	s7,8(sp)
    800016ee:	e062                	sd	s8,0(sp)
    800016f0:	0880                	addi	s0,sp,80
    800016f2:	8b2a                	mv	s6,a0
    800016f4:	8a2e                	mv	s4,a1
    800016f6:	8c32                	mv	s8,a2
    800016f8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800016fa:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016fc:	6a85                	lui	s5,0x1
    800016fe:	a01d                	j	80001724 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001700:	018505b3          	add	a1,a0,s8
    80001704:	0004861b          	sext.w	a2,s1
    80001708:	412585b3          	sub	a1,a1,s2
    8000170c:	8552                	mv	a0,s4
    8000170e:	fffff097          	auipc	ra,0xfffff
    80001712:	61a080e7          	jalr	1562(ra) # 80000d28 <memmove>

    len -= n;
    80001716:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000171a:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000171c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001720:	02098263          	beqz	s3,80001744 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001724:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001728:	85ca                	mv	a1,s2
    8000172a:	855a                	mv	a0,s6
    8000172c:	00000097          	auipc	ra,0x0
    80001730:	92e080e7          	jalr	-1746(ra) # 8000105a <walkaddr>
    if(pa0 == 0)
    80001734:	cd01                	beqz	a0,8000174c <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001736:	418904b3          	sub	s1,s2,s8
    8000173a:	94d6                	add	s1,s1,s5
    if(n > len)
    8000173c:	fc99f2e3          	bgeu	s3,s1,80001700 <copyin+0x28>
    80001740:	84ce                	mv	s1,s3
    80001742:	bf7d                	j	80001700 <copyin+0x28>
  }
  return 0;
    80001744:	4501                	li	a0,0
    80001746:	a021                	j	8000174e <copyin+0x76>
    80001748:	4501                	li	a0,0
}
    8000174a:	8082                	ret
      return -1;
    8000174c:	557d                	li	a0,-1
}
    8000174e:	60a6                	ld	ra,72(sp)
    80001750:	6406                	ld	s0,64(sp)
    80001752:	74e2                	ld	s1,56(sp)
    80001754:	7942                	ld	s2,48(sp)
    80001756:	79a2                	ld	s3,40(sp)
    80001758:	7a02                	ld	s4,32(sp)
    8000175a:	6ae2                	ld	s5,24(sp)
    8000175c:	6b42                	ld	s6,16(sp)
    8000175e:	6ba2                	ld	s7,8(sp)
    80001760:	6c02                	ld	s8,0(sp)
    80001762:	6161                	addi	sp,sp,80
    80001764:	8082                	ret

0000000080001766 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001766:	c6c5                	beqz	a3,8000180e <copyinstr+0xa8>
{
    80001768:	715d                	addi	sp,sp,-80
    8000176a:	e486                	sd	ra,72(sp)
    8000176c:	e0a2                	sd	s0,64(sp)
    8000176e:	fc26                	sd	s1,56(sp)
    80001770:	f84a                	sd	s2,48(sp)
    80001772:	f44e                	sd	s3,40(sp)
    80001774:	f052                	sd	s4,32(sp)
    80001776:	ec56                	sd	s5,24(sp)
    80001778:	e85a                	sd	s6,16(sp)
    8000177a:	e45e                	sd	s7,8(sp)
    8000177c:	0880                	addi	s0,sp,80
    8000177e:	8a2a                	mv	s4,a0
    80001780:	8b2e                	mv	s6,a1
    80001782:	8bb2                	mv	s7,a2
    80001784:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001786:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001788:	6985                	lui	s3,0x1
    8000178a:	a035                	j	800017b6 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000178c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001790:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001792:	0017b793          	seqz	a5,a5
    80001796:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000179a:	60a6                	ld	ra,72(sp)
    8000179c:	6406                	ld	s0,64(sp)
    8000179e:	74e2                	ld	s1,56(sp)
    800017a0:	7942                	ld	s2,48(sp)
    800017a2:	79a2                	ld	s3,40(sp)
    800017a4:	7a02                	ld	s4,32(sp)
    800017a6:	6ae2                	ld	s5,24(sp)
    800017a8:	6b42                	ld	s6,16(sp)
    800017aa:	6ba2                	ld	s7,8(sp)
    800017ac:	6161                	addi	sp,sp,80
    800017ae:	8082                	ret
    srcva = va0 + PGSIZE;
    800017b0:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800017b4:	c8a9                	beqz	s1,80001806 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    800017b6:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800017ba:	85ca                	mv	a1,s2
    800017bc:	8552                	mv	a0,s4
    800017be:	00000097          	auipc	ra,0x0
    800017c2:	89c080e7          	jalr	-1892(ra) # 8000105a <walkaddr>
    if(pa0 == 0)
    800017c6:	c131                	beqz	a0,8000180a <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800017c8:	41790833          	sub	a6,s2,s7
    800017cc:	984e                	add	a6,a6,s3
    if(n > max)
    800017ce:	0104f363          	bgeu	s1,a6,800017d4 <copyinstr+0x6e>
    800017d2:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800017d4:	955e                	add	a0,a0,s7
    800017d6:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800017da:	fc080be3          	beqz	a6,800017b0 <copyinstr+0x4a>
    800017de:	985a                	add	a6,a6,s6
    800017e0:	87da                	mv	a5,s6
      if(*p == '\0'){
    800017e2:	41650633          	sub	a2,a0,s6
    800017e6:	14fd                	addi	s1,s1,-1
    800017e8:	9b26                	add	s6,s6,s1
    800017ea:	00f60733          	add	a4,a2,a5
    800017ee:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffba000>
    800017f2:	df49                	beqz	a4,8000178c <copyinstr+0x26>
        *dst = *p;
    800017f4:	00e78023          	sb	a4,0(a5)
      --max;
    800017f8:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800017fc:	0785                	addi	a5,a5,1
    while(n > 0){
    800017fe:	ff0796e3          	bne	a5,a6,800017ea <copyinstr+0x84>
      dst++;
    80001802:	8b42                	mv	s6,a6
    80001804:	b775                	j	800017b0 <copyinstr+0x4a>
    80001806:	4781                	li	a5,0
    80001808:	b769                	j	80001792 <copyinstr+0x2c>
      return -1;
    8000180a:	557d                	li	a0,-1
    8000180c:	b779                	j	8000179a <copyinstr+0x34>
  int got_null = 0;
    8000180e:	4781                	li	a5,0
  if(got_null){
    80001810:	0017b793          	seqz	a5,a5
    80001814:	40f00533          	neg	a0,a5
}
    80001818:	8082                	ret

000000008000181a <proc_mapstacks>:
//struct spinlock join_lock;
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    8000181a:	711d                	addi	sp,sp,-96
    8000181c:	ec86                	sd	ra,88(sp)
    8000181e:	e8a2                	sd	s0,80(sp)
    80001820:	e4a6                	sd	s1,72(sp)
    80001822:	e0ca                	sd	s2,64(sp)
    80001824:	fc4e                	sd	s3,56(sp)
    80001826:	f852                	sd	s4,48(sp)
    80001828:	f456                	sd	s5,40(sp)
    8000182a:	f05a                	sd	s6,32(sp)
    8000182c:	ec5e                	sd	s7,24(sp)
    8000182e:	e862                	sd	s8,16(sp)
    80001830:	e466                	sd	s9,8(sp)
    80001832:	e06a                	sd	s10,0(sp)
    80001834:	1080                	addi	s0,sp,96
    80001836:	8b2a                	mv	s6,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001838:	00012997          	auipc	s3,0x12
    8000183c:	6f898993          	addi	s3,s3,1784 # 80013f30 <proc+0x808>
    80001840:	00035d17          	auipc	s10,0x35
    80001844:	4f0d0d13          	addi	s10,s10,1264 # 80036d30 <bcache+0x7f0>
    for(tr = p->threads; tr < &p->threads[NTHREAD]; tr++){
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    int t_index = (int)(tr - p->threads);
    int p_index = (int)(p - proc); 
    80001848:	7c7d                	lui	s8,0xfffff
    8000184a:	7f8c0c13          	addi	s8,s8,2040 # fffffffffffff7f8 <end+0xffffffff7ffba7f8>
    8000184e:	00007c97          	auipc	s9,0x7
    80001852:	7b2cbc83          	ld	s9,1970(s9) # 80009000 <etext>
    int t_index = (int)(tr - p->threads);
    80001856:	00007b97          	auipc	s7,0x7
    8000185a:	7b2b8b93          	addi	s7,s7,1970 # 80009008 <etext+0x8>
    uint64 va = KSTACK(p_index*NTHREAD + t_index);
    8000185e:	04000ab7          	lui	s5,0x4000
    80001862:	1afd                	addi	s5,s5,-1
    80001864:	0ab2                	slli	s5,s5,0xc
    80001866:	a839                	j	80001884 <proc_mapstacks+0x6a>
      panic("kalloc");
    80001868:	00008517          	auipc	a0,0x8
    8000186c:	95850513          	addi	a0,a0,-1704 # 800091c0 <digits+0x180>
    80001870:	fffff097          	auipc	ra,0xfffff
    80001874:	cba080e7          	jalr	-838(ra) # 8000052a <panic>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001878:	6785                	lui	a5,0x1
    8000187a:	8b878793          	addi	a5,a5,-1864 # 8b8 <_entry-0x7ffff748>
    8000187e:	99be                	add	s3,s3,a5
    80001880:	07a98363          	beq	s3,s10,800018e6 <proc_mapstacks+0xcc>
    for(tr = p->threads; tr < &p->threads[NTHREAD]; tr++){
    80001884:	9c098a13          	addi	s4,s3,-1600
    int p_index = (int)(p - proc); 
    80001888:	01898933          	add	s2,s3,s8
    8000188c:	00012797          	auipc	a5,0x12
    80001890:	e9c78793          	addi	a5,a5,-356 # 80013728 <proc>
    80001894:	40f90933          	sub	s2,s2,a5
    80001898:	40395913          	srai	s2,s2,0x3
    8000189c:	03990933          	mul	s2,s2,s9
    800018a0:	0039191b          	slliw	s2,s2,0x3
    for(tr = p->threads; tr < &p->threads[NTHREAD]; tr++){
    800018a4:	84d2                	mv	s1,s4
    char *pa = kalloc();
    800018a6:	fffff097          	auipc	ra,0xfffff
    800018aa:	22c080e7          	jalr	556(ra) # 80000ad2 <kalloc>
    800018ae:	862a                	mv	a2,a0
    if(pa == 0)
    800018b0:	dd45                	beqz	a0,80001868 <proc_mapstacks+0x4e>
    int t_index = (int)(tr - p->threads);
    800018b2:	414485b3          	sub	a1,s1,s4
    800018b6:	858d                	srai	a1,a1,0x3
    800018b8:	000bb783          	ld	a5,0(s7)
    800018bc:	02f585b3          	mul	a1,a1,a5
    uint64 va = KSTACK(p_index*NTHREAD + t_index);
    800018c0:	012585bb          	addw	a1,a1,s2
    800018c4:	2585                	addiw	a1,a1,1
    800018c6:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800018ca:	4719                	li	a4,6
    800018cc:	6685                	lui	a3,0x1
    800018ce:	40ba85b3          	sub	a1,s5,a1
    800018d2:	855a                	mv	a0,s6
    800018d4:	00000097          	auipc	ra,0x0
    800018d8:	856080e7          	jalr	-1962(ra) # 8000112a <kvmmap>
    for(tr = p->threads; tr < &p->threads[NTHREAD]; tr++){
    800018dc:	0c848493          	addi	s1,s1,200
    800018e0:	fd3493e3          	bne	s1,s3,800018a6 <proc_mapstacks+0x8c>
    800018e4:	bf51                	j	80001878 <proc_mapstacks+0x5e>
    }
  }
}
    800018e6:	60e6                	ld	ra,88(sp)
    800018e8:	6446                	ld	s0,80(sp)
    800018ea:	64a6                	ld	s1,72(sp)
    800018ec:	6906                	ld	s2,64(sp)
    800018ee:	79e2                	ld	s3,56(sp)
    800018f0:	7a42                	ld	s4,48(sp)
    800018f2:	7aa2                	ld	s5,40(sp)
    800018f4:	7b02                	ld	s6,32(sp)
    800018f6:	6be2                	ld	s7,24(sp)
    800018f8:	6c42                	ld	s8,16(sp)
    800018fa:	6ca2                	ld	s9,8(sp)
    800018fc:	6d02                	ld	s10,0(sp)
    800018fe:	6125                	addi	sp,sp,96
    80001900:	8082                	ret

0000000080001902 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80001902:	7159                	addi	sp,sp,-112
    80001904:	f486                	sd	ra,104(sp)
    80001906:	f0a2                	sd	s0,96(sp)
    80001908:	eca6                	sd	s1,88(sp)
    8000190a:	e8ca                	sd	s2,80(sp)
    8000190c:	e4ce                	sd	s3,72(sp)
    8000190e:	e0d2                	sd	s4,64(sp)
    80001910:	fc56                	sd	s5,56(sp)
    80001912:	f85a                	sd	s6,48(sp)
    80001914:	f45e                	sd	s7,40(sp)
    80001916:	f062                	sd	s8,32(sp)
    80001918:	ec66                	sd	s9,24(sp)
    8000191a:	e86a                	sd	s10,16(sp)
    8000191c:	e46e                	sd	s11,8(sp)
    8000191e:	1880                	addi	s0,sp,112
  struct proc *p;
  initlock(&pid_lock, "nextpid");
    80001920:	00008597          	auipc	a1,0x8
    80001924:	8a858593          	addi	a1,a1,-1880 # 800091c8 <digits+0x188>
    80001928:	00011517          	auipc	a0,0x11
    8000192c:	97850513          	addi	a0,a0,-1672 # 800122a0 <pid_lock>
    80001930:	fffff097          	auipc	ra,0xfffff
    80001934:	202080e7          	jalr	514(ra) # 80000b32 <initlock>
  initlock(&tid_lock, "nexttid");
    80001938:	00008597          	auipc	a1,0x8
    8000193c:	89858593          	addi	a1,a1,-1896 # 800091d0 <digits+0x190>
    80001940:	00011517          	auipc	a0,0x11
    80001944:	97850513          	addi	a0,a0,-1672 # 800122b8 <tid_lock>
    80001948:	fffff097          	auipc	ra,0xfffff
    8000194c:	1ea080e7          	jalr	490(ra) # 80000b32 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001950:	00008597          	auipc	a1,0x8
    80001954:	88858593          	addi	a1,a1,-1912 # 800091d8 <digits+0x198>
    80001958:	00011517          	auipc	a0,0x11
    8000195c:	97850513          	addi	a0,a0,-1672 # 800122d0 <wait_lock>
    80001960:	fffff097          	auipc	ra,0xfffff
    80001964:	1d2080e7          	jalr	466(ra) # 80000b32 <initlock>
 // initlock(&bsemid_lock, "bsemid");
//  initlock(&join_lock, "join_lock");
  for(p = proc; p < &proc[NPROC]; p++) {
    80001968:	00012997          	auipc	s3,0x12
    8000196c:	5c898993          	addi	s3,s3,1480 # 80013f30 <proc+0x808>
    80001970:	00012c17          	auipc	s8,0x12
    80001974:	db8c0c13          	addi	s8,s8,-584 # 80013728 <proc>
      initlock(&p->lock, "proc");
      struct thread* tr;
      for(tr = p->threads; tr < &p->threads[NTHREAD]; tr++) {
        int t_index = (int)(tr - p->threads);
        int p_index = (int)(p - proc); 
    80001978:	8de2                	mv	s11,s8
    8000197a:	00007d17          	auipc	s10,0x7
    8000197e:	686d0d13          	addi	s10,s10,1670 # 80009000 <etext>
        tr->kstack = KSTACK(p_index*NTHREAD + t_index);
    80001982:	04000b37          	lui	s6,0x4000
    80001986:	1b7d                	addi	s6,s6,-1
    80001988:	0b32                	slli	s6,s6,0xc
        initlock(&tr->lock, "thread");
    8000198a:	00008b97          	auipc	s7,0x8
    8000198e:	866b8b93          	addi	s7,s7,-1946 # 800091f0 <digits+0x1b0>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001992:	6c85                	lui	s9,0x1
    80001994:	8b8c8c93          	addi	s9,s9,-1864 # 8b8 <_entry-0x7ffff748>
    80001998:	a809                	j	800019aa <procinit+0xa8>
    8000199a:	9c66                	add	s8,s8,s9
    8000199c:	99e6                	add	s3,s3,s9
    8000199e:	00035797          	auipc	a5,0x35
    800019a2:	b8a78793          	addi	a5,a5,-1142 # 80036528 <tickslock>
    800019a6:	06fc0763          	beq	s8,a5,80001a14 <procinit+0x112>
      initlock(&p->lock, "proc");
    800019aa:	00008597          	auipc	a1,0x8
    800019ae:	83e58593          	addi	a1,a1,-1986 # 800091e8 <digits+0x1a8>
    800019b2:	8562                	mv	a0,s8
    800019b4:	fffff097          	auipc	ra,0xfffff
    800019b8:	17e080e7          	jalr	382(ra) # 80000b32 <initlock>
      for(tr = p->threads; tr < &p->threads[NTHREAD]; tr++) {
    800019bc:	1c8c0a13          	addi	s4,s8,456
        int p_index = (int)(p - proc); 
    800019c0:	41bc0933          	sub	s2,s8,s11
    800019c4:	40395913          	srai	s2,s2,0x3
    800019c8:	000d3783          	ld	a5,0(s10)
    800019cc:	02f90933          	mul	s2,s2,a5
        tr->kstack = KSTACK(p_index*NTHREAD + t_index);
    800019d0:	0039191b          	slliw	s2,s2,0x3
      for(tr = p->threads; tr < &p->threads[NTHREAD]; tr++) {
    800019d4:	84d2                	mv	s1,s4
        int t_index = (int)(tr - p->threads);
    800019d6:	00007797          	auipc	a5,0x7
    800019da:	63278793          	addi	a5,a5,1586 # 80009008 <etext+0x8>
    800019de:	0007ba83          	ld	s5,0(a5)
    800019e2:	414487b3          	sub	a5,s1,s4
    800019e6:	878d                	srai	a5,a5,0x3
    800019e8:	035787b3          	mul	a5,a5,s5
        tr->kstack = KSTACK(p_index*NTHREAD + t_index);
    800019ec:	012787bb          	addw	a5,a5,s2
    800019f0:	2785                	addiw	a5,a5,1
    800019f2:	00d7979b          	slliw	a5,a5,0xd
    800019f6:	40fb07b3          	sub	a5,s6,a5
    800019fa:	fcdc                	sd	a5,184(s1)
        initlock(&tr->lock, "thread");
    800019fc:	85de                	mv	a1,s7
    800019fe:	09048513          	addi	a0,s1,144
    80001a02:	fffff097          	auipc	ra,0xfffff
    80001a06:	130080e7          	jalr	304(ra) # 80000b32 <initlock>
      for(tr = p->threads; tr < &p->threads[NTHREAD]; tr++) {
    80001a0a:	0c848493          	addi	s1,s1,200
    80001a0e:	fd349ae3          	bne	s1,s3,800019e2 <procinit+0xe0>
    80001a12:	b761                	j	8000199a <procinit+0x98>
      }
  }
}
    80001a14:	70a6                	ld	ra,104(sp)
    80001a16:	7406                	ld	s0,96(sp)
    80001a18:	64e6                	ld	s1,88(sp)
    80001a1a:	6946                	ld	s2,80(sp)
    80001a1c:	69a6                	ld	s3,72(sp)
    80001a1e:	6a06                	ld	s4,64(sp)
    80001a20:	7ae2                	ld	s5,56(sp)
    80001a22:	7b42                	ld	s6,48(sp)
    80001a24:	7ba2                	ld	s7,40(sp)
    80001a26:	7c02                	ld	s8,32(sp)
    80001a28:	6ce2                	ld	s9,24(sp)
    80001a2a:	6d42                	ld	s10,16(sp)
    80001a2c:	6da2                	ld	s11,8(sp)
    80001a2e:	6165                	addi	sp,sp,112
    80001a30:	8082                	ret

0000000080001a32 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001a32:	1141                	addi	sp,sp,-16
    80001a34:	e422                	sd	s0,8(sp)
    80001a36:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a38:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001a3a:	2501                	sext.w	a0,a0
    80001a3c:	6422                	ld	s0,8(sp)
    80001a3e:	0141                	addi	sp,sp,16
    80001a40:	8082                	ret

0000000080001a42 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80001a42:	1141                	addi	sp,sp,-16
    80001a44:	e422                	sd	s0,8(sp)
    80001a46:	0800                	addi	s0,sp,16
    80001a48:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001a4a:	0007851b          	sext.w	a0,a5
    80001a4e:	00451793          	slli	a5,a0,0x4
    80001a52:	97aa                	add	a5,a5,a0
    80001a54:	078e                	slli	a5,a5,0x3
  return c;
}
    80001a56:	00011517          	auipc	a0,0x11
    80001a5a:	89250513          	addi	a0,a0,-1902 # 800122e8 <cpus>
    80001a5e:	953e                	add	a0,a0,a5
    80001a60:	6422                	ld	s0,8(sp)
    80001a62:	0141                	addi	sp,sp,16
    80001a64:	8082                	ret

0000000080001a66 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80001a66:	1101                	addi	sp,sp,-32
    80001a68:	ec06                	sd	ra,24(sp)
    80001a6a:	e822                	sd	s0,16(sp)
    80001a6c:	e426                	sd	s1,8(sp)
    80001a6e:	1000                	addi	s0,sp,32
  push_off();
    80001a70:	fffff097          	auipc	ra,0xfffff
    80001a74:	106080e7          	jalr	262(ra) # 80000b76 <push_off>
    80001a78:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001a7a:	0007871b          	sext.w	a4,a5
    80001a7e:	00471793          	slli	a5,a4,0x4
    80001a82:	97ba                	add	a5,a5,a4
    80001a84:	078e                	slli	a5,a5,0x3
    80001a86:	00011717          	auipc	a4,0x11
    80001a8a:	81a70713          	addi	a4,a4,-2022 # 800122a0 <pid_lock>
    80001a8e:	97ba                	add	a5,a5,a4
    80001a90:	67a4                	ld	s1,72(a5)
  pop_off();
    80001a92:	fffff097          	auipc	ra,0xfffff
    80001a96:	18c080e7          	jalr	396(ra) # 80000c1e <pop_off>
  return p;
}
    80001a9a:	8526                	mv	a0,s1
    80001a9c:	60e2                	ld	ra,24(sp)
    80001a9e:	6442                	ld	s0,16(sp)
    80001aa0:	64a2                	ld	s1,8(sp)
    80001aa2:	6105                	addi	sp,sp,32
    80001aa4:	8082                	ret

0000000080001aa6 <mythread>:

//Return the current struct thread*, or zero if none
struct thread*
mythread(void){
    80001aa6:	1101                	addi	sp,sp,-32
    80001aa8:	ec06                	sd	ra,24(sp)
    80001aaa:	e822                	sd	s0,16(sp)
    80001aac:	e426                	sd	s1,8(sp)
    80001aae:	1000                	addi	s0,sp,32
  push_off();
    80001ab0:	fffff097          	auipc	ra,0xfffff
    80001ab4:	0c6080e7          	jalr	198(ra) # 80000b76 <push_off>
    80001ab8:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct thread *tr = c->thread;
    80001aba:	0007871b          	sext.w	a4,a5
    80001abe:	00471793          	slli	a5,a4,0x4
    80001ac2:	97ba                	add	a5,a5,a4
    80001ac4:	078e                	slli	a5,a5,0x3
    80001ac6:	00010717          	auipc	a4,0x10
    80001aca:	7da70713          	addi	a4,a4,2010 # 800122a0 <pid_lock>
    80001ace:	97ba                	add	a5,a5,a4
    80001ad0:	6ba4                	ld	s1,80(a5)
  pop_off();
    80001ad2:	fffff097          	auipc	ra,0xfffff
    80001ad6:	14c080e7          	jalr	332(ra) # 80000c1e <pop_off>
  return tr;
}
    80001ada:	8526                	mv	a0,s1
    80001adc:	60e2                	ld	ra,24(sp)
    80001ade:	6442                	ld	s0,16(sp)
    80001ae0:	64a2                	ld	s1,8(sp)
    80001ae2:	6105                	addi	sp,sp,32
    80001ae4:	8082                	ret

0000000080001ae6 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001ae6:	1141                	addi	sp,sp,-16
    80001ae8:	e406                	sd	ra,8(sp)
    80001aea:	e022                	sd	s0,0(sp)
    80001aec:	0800                	addi	s0,sp,16
  static int first = 1;
  // Still holding p->lock from scheduler.
  release(&mythread()->lock);
    80001aee:	00000097          	auipc	ra,0x0
    80001af2:	fb8080e7          	jalr	-72(ra) # 80001aa6 <mythread>
    80001af6:	09050513          	addi	a0,a0,144
    80001afa:	fffff097          	auipc	ra,0xfffff
    80001afe:	18a080e7          	jalr	394(ra) # 80000c84 <release>
  if (first) {
    80001b02:	00008797          	auipc	a5,0x8
    80001b06:	d4e7a783          	lw	a5,-690(a5) # 80009850 <first.1>
    80001b0a:	eb89                	bnez	a5,80001b1c <forkret+0x36>
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }
  usertrapret();
    80001b0c:	00002097          	auipc	ra,0x2
    80001b10:	9f0080e7          	jalr	-1552(ra) # 800034fc <usertrapret>
}
    80001b14:	60a2                	ld	ra,8(sp)
    80001b16:	6402                	ld	s0,0(sp)
    80001b18:	0141                	addi	sp,sp,16
    80001b1a:	8082                	ret
    first = 0;
    80001b1c:	00008797          	auipc	a5,0x8
    80001b20:	d207aa23          	sw	zero,-716(a5) # 80009850 <first.1>
    fsinit(ROOTDEV);
    80001b24:	4505                	li	a0,1
    80001b26:	00003097          	auipc	ra,0x3
    80001b2a:	a1c080e7          	jalr	-1508(ra) # 80004542 <fsinit>
    80001b2e:	bff9                	j	80001b0c <forkret+0x26>

0000000080001b30 <allocpid>:
allocpid() {
    80001b30:	1101                	addi	sp,sp,-32
    80001b32:	ec06                	sd	ra,24(sp)
    80001b34:	e822                	sd	s0,16(sp)
    80001b36:	e426                	sd	s1,8(sp)
    80001b38:	e04a                	sd	s2,0(sp)
    80001b3a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001b3c:	00010917          	auipc	s2,0x10
    80001b40:	76490913          	addi	s2,s2,1892 # 800122a0 <pid_lock>
    80001b44:	854a                	mv	a0,s2
    80001b46:	fffff097          	auipc	ra,0xfffff
    80001b4a:	084080e7          	jalr	132(ra) # 80000bca <acquire>
  pid = nextpid;
    80001b4e:	00008797          	auipc	a5,0x8
    80001b52:	d0a78793          	addi	a5,a5,-758 # 80009858 <nextpid>
    80001b56:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001b58:	0014871b          	addiw	a4,s1,1
    80001b5c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001b5e:	854a                	mv	a0,s2
    80001b60:	fffff097          	auipc	ra,0xfffff
    80001b64:	124080e7          	jalr	292(ra) # 80000c84 <release>
}
    80001b68:	8526                	mv	a0,s1
    80001b6a:	60e2                	ld	ra,24(sp)
    80001b6c:	6442                	ld	s0,16(sp)
    80001b6e:	64a2                	ld	s1,8(sp)
    80001b70:	6902                	ld	s2,0(sp)
    80001b72:	6105                	addi	sp,sp,32
    80001b74:	8082                	ret

0000000080001b76 <alloctid>:
alloctid(){
    80001b76:	1101                	addi	sp,sp,-32
    80001b78:	ec06                	sd	ra,24(sp)
    80001b7a:	e822                	sd	s0,16(sp)
    80001b7c:	e426                	sd	s1,8(sp)
    80001b7e:	e04a                	sd	s2,0(sp)
    80001b80:	1000                	addi	s0,sp,32
  acquire(&tid_lock);
    80001b82:	00010917          	auipc	s2,0x10
    80001b86:	73690913          	addi	s2,s2,1846 # 800122b8 <tid_lock>
    80001b8a:	854a                	mv	a0,s2
    80001b8c:	fffff097          	auipc	ra,0xfffff
    80001b90:	03e080e7          	jalr	62(ra) # 80000bca <acquire>
  tid = nexttid;
    80001b94:	00008797          	auipc	a5,0x8
    80001b98:	cc078793          	addi	a5,a5,-832 # 80009854 <nexttid>
    80001b9c:	4384                	lw	s1,0(a5)
  nexttid = nexttid + 1;
    80001b9e:	0014871b          	addiw	a4,s1,1
    80001ba2:	c398                	sw	a4,0(a5)
  release(&tid_lock);
    80001ba4:	854a                	mv	a0,s2
    80001ba6:	fffff097          	auipc	ra,0xfffff
    80001baa:	0de080e7          	jalr	222(ra) # 80000c84 <release>
}
    80001bae:	8526                	mv	a0,s1
    80001bb0:	60e2                	ld	ra,24(sp)
    80001bb2:	6442                	ld	s0,16(sp)
    80001bb4:	64a2                	ld	s1,8(sp)
    80001bb6:	6902                	ld	s2,0(sp)
    80001bb8:	6105                	addi	sp,sp,32
    80001bba:	8082                	ret

0000000080001bbc <allocthread>:
{
    80001bbc:	7139                	addi	sp,sp,-64
    80001bbe:	fc06                	sd	ra,56(sp)
    80001bc0:	f822                	sd	s0,48(sp)
    80001bc2:	f426                	sd	s1,40(sp)
    80001bc4:	f04a                	sd	s2,32(sp)
    80001bc6:	ec4e                	sd	s3,24(sp)
    80001bc8:	e852                	sd	s4,16(sp)
    80001bca:	e456                	sd	s5,8(sp)
    80001bcc:	e05a                	sd	s6,0(sp)
    80001bce:	0080                	addi	s0,sp,64
    80001bd0:	8aaa                	mv	s5,a0
  for(tr = p->threads; !found && tr < &p->threads[NTHREAD]; tr++) {
    80001bd2:	1c850a13          	addi	s4,a0,456
    80001bd6:	6985                	lui	s3,0x1
    80001bd8:	80898993          	addi	s3,s3,-2040 # 808 <_entry-0x7ffff7f8>
    80001bdc:	99aa                	add	s3,s3,a0
    80001bde:	84d2                	mv	s1,s4
    else if (tr->state == TZOMBIE)
    80001be0:	4b15                	li	s6,5
    acquire(&tr->lock);
    80001be2:	09048913          	addi	s2,s1,144
    80001be6:	854a                	mv	a0,s2
    80001be8:	fffff097          	auipc	ra,0xfffff
    80001bec:	fe2080e7          	jalr	-30(ra) # 80000bca <acquire>
    if(tr->state == TUNUSED) {
    80001bf0:	40dc                	lw	a5,4(s1)
    80001bf2:	cf85                	beqz	a5,80001c2a <allocthread+0x6e>
    else if (tr->state == TZOMBIE)
    80001bf4:	01678d63          	beq	a5,s6,80001c0e <allocthread+0x52>
      release(&tr->lock);
    80001bf8:	854a                	mv	a0,s2
    80001bfa:	fffff097          	auipc	ra,0xfffff
    80001bfe:	08a080e7          	jalr	138(ra) # 80000c84 <release>
  for(tr = p->threads; !found && tr < &p->threads[NTHREAD]; tr++) {
    80001c02:	0c848493          	addi	s1,s1,200
    80001c06:	fd349ee3          	bne	s1,s3,80001be2 <allocthread+0x26>
    return 0;
    80001c0a:	4481                	li	s1,0
    80001c0c:	a069                	j	80001c96 <allocthread+0xda>
  tr->trapframe = 0;
    80001c0e:	0804b023          	sd	zero,128(s1)
  tr->userTrapFrameBackup = 0;
    80001c12:	0804b423          	sd	zero,136(s1)
  tr->xstate = 0;
    80001c16:	0a04a823          	sw	zero,176(s1)
  tr->tid = 0;
    80001c1a:	0004a023          	sw	zero,0(s1)
  tr->chan = 0;
    80001c1e:	0a04b423          	sd	zero,168(s1)
  tr->killed = 0;
    80001c22:	0c04a023          	sw	zero,192(s1)
  tr->state = TUNUSED;
    80001c26:	0004a223          	sw	zero,4(s1)
    tr->parent = p;
    80001c2a:	0754bc23          	sd	s5,120(s1)
    tr->tid = alloctid();
    80001c2e:	00000097          	auipc	ra,0x0
    80001c32:	f48080e7          	jalr	-184(ra) # 80001b76 <alloctid>
    80001c36:	c088                	sw	a0,0(s1)
    tr->state = TUSED;
    80001c38:	4785                	li	a5,1
    80001c3a:	c0dc                	sw	a5,4(s1)
    tr->killed = 0;
    80001c3c:	0c04a023          	sw	zero,192(s1)
    tr->trapframe = p->trapframes + ((tr - p->threads) * sizeof(struct trapframe));
    80001c40:	41448a33          	sub	s4,s1,s4
    80001c44:	403a5a13          	srai	s4,s4,0x3
    80001c48:	00007797          	auipc	a5,0x7
    80001c4c:	3c07b783          	ld	a5,960(a5) # 80009008 <etext+0x8>
    80001c50:	02fa0a33          	mul	s4,s4,a5
    80001c54:	003a1793          	slli	a5,s4,0x3
    80001c58:	9a3e                	add	s4,s4,a5
    80001c5a:	0a16                	slli	s4,s4,0x5
    80001c5c:	1c0ab783          	ld	a5,448(s5) # 40001c0 <_entry-0x7bfffe40>
    80001c60:	9a3e                	add	s4,s4,a5
    80001c62:	0944b023          	sd	s4,128(s1)
    memset(&(tr->context), 0, sizeof(tr->context));
    80001c66:	07000613          	li	a2,112
    80001c6a:	4581                	li	a1,0
    80001c6c:	00848513          	addi	a0,s1,8
    80001c70:	fffff097          	auipc	ra,0xfffff
    80001c74:	05c080e7          	jalr	92(ra) # 80000ccc <memset>
    tr->context.ra = (uint64)forkret;
    80001c78:	00000797          	auipc	a5,0x0
    80001c7c:	e6e78793          	addi	a5,a5,-402 # 80001ae6 <forkret>
    80001c80:	e49c                	sd	a5,8(s1)
    tr->context.sp = tr->kstack + PGSIZE;
    80001c82:	7cdc                	ld	a5,184(s1)
    80001c84:	6705                	lui	a4,0x1
    80001c86:	97ba                	add	a5,a5,a4
    80001c88:	e89c                	sd	a5,16(s1)
    release(&tr->lock);
    80001c8a:	09048513          	addi	a0,s1,144
    80001c8e:	fffff097          	auipc	ra,0xfffff
    80001c92:	ff6080e7          	jalr	-10(ra) # 80000c84 <release>
}
    80001c96:	8526                	mv	a0,s1
    80001c98:	70e2                	ld	ra,56(sp)
    80001c9a:	7442                	ld	s0,48(sp)
    80001c9c:	74a2                	ld	s1,40(sp)
    80001c9e:	7902                	ld	s2,32(sp)
    80001ca0:	69e2                	ld	s3,24(sp)
    80001ca2:	6a42                	ld	s4,16(sp)
    80001ca4:	6aa2                	ld	s5,8(sp)
    80001ca6:	6b02                	ld	s6,0(sp)
    80001ca8:	6121                	addi	sp,sp,64
    80001caa:	8082                	ret

0000000080001cac <proc_pagetable>:
{
    80001cac:	1101                	addi	sp,sp,-32
    80001cae:	ec06                	sd	ra,24(sp)
    80001cb0:	e822                	sd	s0,16(sp)
    80001cb2:	e426                	sd	s1,8(sp)
    80001cb4:	e04a                	sd	s2,0(sp)
    80001cb6:	1000                	addi	s0,sp,32
    80001cb8:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001cba:	fffff097          	auipc	ra,0xfffff
    80001cbe:	65a080e7          	jalr	1626(ra) # 80001314 <uvmcreate>
    80001cc2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001cc4:	c121                	beqz	a0,80001d04 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001cc6:	4729                	li	a4,10
    80001cc8:	00006697          	auipc	a3,0x6
    80001ccc:	33868693          	addi	a3,a3,824 # 80008000 <_trampoline>
    80001cd0:	6605                	lui	a2,0x1
    80001cd2:	040005b7          	lui	a1,0x4000
    80001cd6:	15fd                	addi	a1,a1,-1
    80001cd8:	05b2                	slli	a1,a1,0xc
    80001cda:	fffff097          	auipc	ra,0xfffff
    80001cde:	3c2080e7          	jalr	962(ra) # 8000109c <mappages>
    80001ce2:	02054863          	bltz	a0,80001d12 <proc_pagetable+0x66>
    if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001ce6:	4719                	li	a4,6
    80001ce8:	1c093683          	ld	a3,448(s2)
    80001cec:	6605                	lui	a2,0x1
    80001cee:	020005b7          	lui	a1,0x2000
    80001cf2:	15fd                	addi	a1,a1,-1
    80001cf4:	05b6                	slli	a1,a1,0xd
    80001cf6:	8526                	mv	a0,s1
    80001cf8:	fffff097          	auipc	ra,0xfffff
    80001cfc:	3a4080e7          	jalr	932(ra) # 8000109c <mappages>
    80001d00:	02054163          	bltz	a0,80001d22 <proc_pagetable+0x76>
}
    80001d04:	8526                	mv	a0,s1
    80001d06:	60e2                	ld	ra,24(sp)
    80001d08:	6442                	ld	s0,16(sp)
    80001d0a:	64a2                	ld	s1,8(sp)
    80001d0c:	6902                	ld	s2,0(sp)
    80001d0e:	6105                	addi	sp,sp,32
    80001d10:	8082                	ret
    uvmfree(pagetable, 0);
    80001d12:	4581                	li	a1,0
    80001d14:	8526                	mv	a0,s1
    80001d16:	fffff097          	auipc	ra,0xfffff
    80001d1a:	7fa080e7          	jalr	2042(ra) # 80001510 <uvmfree>
    return 0;
    80001d1e:	4481                	li	s1,0
    80001d20:	b7d5                	j	80001d04 <proc_pagetable+0x58>
      uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001d22:	4681                	li	a3,0
    80001d24:	4605                	li	a2,1
    80001d26:	040005b7          	lui	a1,0x4000
    80001d2a:	15fd                	addi	a1,a1,-1
    80001d2c:	05b2                	slli	a1,a1,0xc
    80001d2e:	8526                	mv	a0,s1
    80001d30:	fffff097          	auipc	ra,0xfffff
    80001d34:	520080e7          	jalr	1312(ra) # 80001250 <uvmunmap>
      uvmfree(pagetable, 0);
    80001d38:	4581                	li	a1,0
    80001d3a:	8526                	mv	a0,s1
    80001d3c:	fffff097          	auipc	ra,0xfffff
    80001d40:	7d4080e7          	jalr	2004(ra) # 80001510 <uvmfree>
      return 0;
    80001d44:	4481                	li	s1,0
    80001d46:	bf7d                	j	80001d04 <proc_pagetable+0x58>

0000000080001d48 <proc_freepagetable>:
{
    80001d48:	1101                	addi	sp,sp,-32
    80001d4a:	ec06                	sd	ra,24(sp)
    80001d4c:	e822                	sd	s0,16(sp)
    80001d4e:	e426                	sd	s1,8(sp)
    80001d50:	e04a                	sd	s2,0(sp)
    80001d52:	1000                	addi	s0,sp,32
    80001d54:	84aa                	mv	s1,a0
    80001d56:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001d58:	4681                	li	a3,0
    80001d5a:	4605                	li	a2,1
    80001d5c:	040005b7          	lui	a1,0x4000
    80001d60:	15fd                	addi	a1,a1,-1
    80001d62:	05b2                	slli	a1,a1,0xc
    80001d64:	fffff097          	auipc	ra,0xfffff
    80001d68:	4ec080e7          	jalr	1260(ra) # 80001250 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001d6c:	4681                	li	a3,0
    80001d6e:	4605                	li	a2,1
    80001d70:	020005b7          	lui	a1,0x2000
    80001d74:	15fd                	addi	a1,a1,-1
    80001d76:	05b6                	slli	a1,a1,0xd
    80001d78:	8526                	mv	a0,s1
    80001d7a:	fffff097          	auipc	ra,0xfffff
    80001d7e:	4d6080e7          	jalr	1238(ra) # 80001250 <uvmunmap>
  uvmfree(pagetable, sz);
    80001d82:	85ca                	mv	a1,s2
    80001d84:	8526                	mv	a0,s1
    80001d86:	fffff097          	auipc	ra,0xfffff
    80001d8a:	78a080e7          	jalr	1930(ra) # 80001510 <uvmfree>
}
    80001d8e:	60e2                	ld	ra,24(sp)
    80001d90:	6442                	ld	s0,16(sp)
    80001d92:	64a2                	ld	s1,8(sp)
    80001d94:	6902                	ld	s2,0(sp)
    80001d96:	6105                	addi	sp,sp,32
    80001d98:	8082                	ret

0000000080001d9a <freeproc>:
{
    80001d9a:	1101                	addi	sp,sp,-32
    80001d9c:	ec06                	sd	ra,24(sp)
    80001d9e:	e822                	sd	s0,16(sp)
    80001da0:	e426                	sd	s1,8(sp)
    80001da2:	1000                	addi	s0,sp,32
    80001da4:	84aa                	mv	s1,a0
  if(p->trapframes)
    80001da6:	1c053503          	ld	a0,448(a0)
    80001daa:	c509                	beqz	a0,80001db4 <freeproc+0x1a>
    kfree((struct trapframe*)p->trapframes);
    80001dac:	fffff097          	auipc	ra,0xfffff
    80001db0:	c2a080e7          	jalr	-982(ra) # 800009d6 <kfree>
  p->trapframes = 0;
    80001db4:	1c04b023          	sd	zero,448(s1)
  if(p->pagetable)
    80001db8:	6785                	lui	a5,0x1
    80001dba:	97a6                	add	a5,a5,s1
    80001dbc:	8187b503          	ld	a0,-2024(a5) # 818 <_entry-0x7ffff7e8>
    80001dc0:	c909                	beqz	a0,80001dd2 <freeproc+0x38>
    proc_freepagetable(p->pagetable, p->sz);
    80001dc2:	6785                	lui	a5,0x1
    80001dc4:	97a6                	add	a5,a5,s1
    80001dc6:	8107b583          	ld	a1,-2032(a5) # 810 <_entry-0x7ffff7f0>
    80001dca:	00000097          	auipc	ra,0x0
    80001dce:	f7e080e7          	jalr	-130(ra) # 80001d48 <proc_freepagetable>
  p->pagetable = 0;
    80001dd2:	6785                	lui	a5,0x1
    80001dd4:	97a6                	add	a5,a5,s1
    80001dd6:	8007bc23          	sd	zero,-2024(a5) # 818 <_entry-0x7ffff7e8>
  p->sz = 0;
    80001dda:	8007b823          	sd	zero,-2032(a5)
  p->pid = 0;
    80001dde:	0204a223          	sw	zero,36(s1)
  p->parent = 0;
    80001de2:	8007b423          	sd	zero,-2040(a5)
  p->name[0] = 0;
    80001de6:	8a078423          	sb	zero,-1880(a5)
  p->killed = 0;
    80001dea:	0004ae23          	sw	zero,28(s1)
  p->xstate = 0;
    80001dee:	0204a023          	sw	zero,32(s1)
  p->state = UNUSED;
    80001df2:	0004ac23          	sw	zero,24(s1)
}
    80001df6:	60e2                	ld	ra,24(sp)
    80001df8:	6442                	ld	s0,16(sp)
    80001dfa:	64a2                	ld	s1,8(sp)
    80001dfc:	6105                	addi	sp,sp,32
    80001dfe:	8082                	ret

0000000080001e00 <allocproc>:
{
    80001e00:	7179                	addi	sp,sp,-48
    80001e02:	f406                	sd	ra,40(sp)
    80001e04:	f022                	sd	s0,32(sp)
    80001e06:	ec26                	sd	s1,24(sp)
    80001e08:	e84a                	sd	s2,16(sp)
    80001e0a:	e44e                	sd	s3,8(sp)
    80001e0c:	e052                	sd	s4,0(sp)
    80001e0e:	1800                	addi	s0,sp,48
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e10:	00012497          	auipc	s1,0x12
    80001e14:	91848493          	addi	s1,s1,-1768 # 80013728 <proc>
    80001e18:	6985                	lui	s3,0x1
    80001e1a:	8b898993          	addi	s3,s3,-1864 # 8b8 <_entry-0x7ffff748>
    80001e1e:	00034a17          	auipc	s4,0x34
    80001e22:	70aa0a13          	addi	s4,s4,1802 # 80036528 <tickslock>
    acquire(&p->lock);
    80001e26:	8526                	mv	a0,s1
    80001e28:	fffff097          	auipc	ra,0xfffff
    80001e2c:	da2080e7          	jalr	-606(ra) # 80000bca <acquire>
    if(p->state == UNUSED) {
    80001e30:	4c9c                	lw	a5,24(s1)
    80001e32:	cb99                	beqz	a5,80001e48 <allocproc+0x48>
      release(&p->lock);
    80001e34:	8526                	mv	a0,s1
    80001e36:	fffff097          	auipc	ra,0xfffff
    80001e3a:	e4e080e7          	jalr	-434(ra) # 80000c84 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e3e:	94ce                	add	s1,s1,s3
    80001e40:	ff4493e3          	bne	s1,s4,80001e26 <allocproc+0x26>
  return 0;
    80001e44:	4481                	li	s1,0
    80001e46:	a8ad                	j	80001ec0 <allocproc+0xc0>
  p->pid = allocpid();
    80001e48:	00000097          	auipc	ra,0x0
    80001e4c:	ce8080e7          	jalr	-792(ra) # 80001b30 <allocpid>
    80001e50:	d0c8                	sw	a0,36(s1)
  p->state = USED;
    80001e52:	4785                	li	a5,1
    80001e54:	cc9c                	sw	a5,24(s1)
  p->stopped = 0;
    80001e56:	1a04ac23          	sw	zero,440(s1)
  if((p->trapframes = kalloc()) == 0){
    80001e5a:	fffff097          	auipc	ra,0xfffff
    80001e5e:	c78080e7          	jalr	-904(ra) # 80000ad2 <kalloc>
    80001e62:	89aa                	mv	s3,a0
    80001e64:	1ca4b023          	sd	a0,448(s1)
    80001e68:	c52d                	beqz	a0,80001ed2 <allocproc+0xd2>
    p->threads[i].state = TUNUSED;
    80001e6a:	1c04a623          	sw	zero,460(s1)
    80001e6e:	2804aa23          	sw	zero,660(s1)
    80001e72:	3404ae23          	sw	zero,860(s1)
    80001e76:	4204a223          	sw	zero,1060(s1)
    80001e7a:	4e04a623          	sw	zero,1260(s1)
    80001e7e:	5a04aa23          	sw	zero,1460(s1)
    80001e82:	6604ae23          	sw	zero,1660(s1)
    80001e86:	7404a223          	sw	zero,1860(s1)
  for(int i = 0; i < NTHREAD;i++){
    80001e8a:	03048713          	addi	a4,s1,48
    80001e8e:	13048793          	addi	a5,s1,304
    80001e92:	1b048693          	addi	a3,s1,432
    p->signalHandlers[i] = (void *)SIG_DFL;
    80001e96:	460d                	li	a2,3
    80001e98:	e310                	sd	a2,0(a4)
    p->signalHandlersMasks[i] = 0;
    80001e9a:	0007a023          	sw	zero,0(a5)
   for(int i = 0; i < 32;i++){
    80001e9e:	0721                	addi	a4,a4,8
    80001ea0:	0791                	addi	a5,a5,4
    80001ea2:	fef69be3          	bne	a3,a5,80001e98 <allocproc+0x98>
  p->pendingSignals= 0;
    80001ea6:	0204a423          	sw	zero,40(s1)
  p->pagetable = proc_pagetable(p);
    80001eaa:	8526                	mv	a0,s1
    80001eac:	00000097          	auipc	ra,0x0
    80001eb0:	e00080e7          	jalr	-512(ra) # 80001cac <proc_pagetable>
    80001eb4:	892a                	mv	s2,a0
    80001eb6:	6785                	lui	a5,0x1
    80001eb8:	97a6                	add	a5,a5,s1
    80001eba:	80a7bc23          	sd	a0,-2024(a5) # 818 <_entry-0x7ffff7e8>
  if(p->pagetable == 0){
    80001ebe:	c515                	beqz	a0,80001eea <allocproc+0xea>
}
    80001ec0:	8526                	mv	a0,s1
    80001ec2:	70a2                	ld	ra,40(sp)
    80001ec4:	7402                	ld	s0,32(sp)
    80001ec6:	64e2                	ld	s1,24(sp)
    80001ec8:	6942                	ld	s2,16(sp)
    80001eca:	69a2                	ld	s3,8(sp)
    80001ecc:	6a02                	ld	s4,0(sp)
    80001ece:	6145                	addi	sp,sp,48
    80001ed0:	8082                	ret
      freeproc(p);
    80001ed2:	8526                	mv	a0,s1
    80001ed4:	00000097          	auipc	ra,0x0
    80001ed8:	ec6080e7          	jalr	-314(ra) # 80001d9a <freeproc>
      release(&p->lock);
    80001edc:	8526                	mv	a0,s1
    80001ede:	fffff097          	auipc	ra,0xfffff
    80001ee2:	da6080e7          	jalr	-602(ra) # 80000c84 <release>
      return 0;
    80001ee6:	84ce                	mv	s1,s3
    80001ee8:	bfe1                	j	80001ec0 <allocproc+0xc0>
    freeproc(p);
    80001eea:	8526                	mv	a0,s1
    80001eec:	00000097          	auipc	ra,0x0
    80001ef0:	eae080e7          	jalr	-338(ra) # 80001d9a <freeproc>
    release(&p->lock);
    80001ef4:	8526                	mv	a0,s1
    80001ef6:	fffff097          	auipc	ra,0xfffff
    80001efa:	d8e080e7          	jalr	-626(ra) # 80000c84 <release>
    return 0;
    80001efe:	84ca                	mv	s1,s2
    80001f00:	b7c1                	j	80001ec0 <allocproc+0xc0>

0000000080001f02 <userinit>:
{
    80001f02:	7139                	addi	sp,sp,-64
    80001f04:	fc06                	sd	ra,56(sp)
    80001f06:	f822                	sd	s0,48(sp)
    80001f08:	f426                	sd	s1,40(sp)
    80001f0a:	f04a                	sd	s2,32(sp)
    80001f0c:	ec4e                	sd	s3,24(sp)
    80001f0e:	e852                	sd	s4,16(sp)
    80001f10:	e456                	sd	s5,8(sp)
    80001f12:	0080                	addi	s0,sp,64
  p = allocproc();
    80001f14:	00000097          	auipc	ra,0x0
    80001f18:	eec080e7          	jalr	-276(ra) # 80001e00 <allocproc>
    80001f1c:	84aa                	mv	s1,a0
  t = allocthread(p);
    80001f1e:	00000097          	auipc	ra,0x0
    80001f22:	c9e080e7          	jalr	-866(ra) # 80001bbc <allocthread>
    80001f26:	892a                	mv	s2,a0
  initproc = p;
    80001f28:	00008797          	auipc	a5,0x8
    80001f2c:	1097b423          	sd	s1,264(a5) # 8000a030 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001f30:	6985                	lui	s3,0x1
    80001f32:	01348a33          	add	s4,s1,s3
    80001f36:	03400613          	li	a2,52
    80001f3a:	00008597          	auipc	a1,0x8
    80001f3e:	92658593          	addi	a1,a1,-1754 # 80009860 <initcode>
    80001f42:	818a3503          	ld	a0,-2024(s4)
    80001f46:	fffff097          	auipc	ra,0xfffff
    80001f4a:	3fc080e7          	jalr	1020(ra) # 80001342 <uvminit>
  p->sz = PGSIZE;
    80001f4e:	813a3823          	sd	s3,-2032(s4)
  acquire(&t->lock);
    80001f52:	09090a93          	addi	s5,s2,144
    80001f56:	8556                	mv	a0,s5
    80001f58:	fffff097          	auipc	ra,0xfffff
    80001f5c:	c72080e7          	jalr	-910(ra) # 80000bca <acquire>
  t->trapframe->epc = 0;      // user program counter
    80001f60:	08093783          	ld	a5,128(s2)
    80001f64:	0007bc23          	sd	zero,24(a5)
  t->trapframe->sp = PGSIZE;  // user stack pointer
    80001f68:	08093783          	ld	a5,128(s2)
    80001f6c:	0337b823          	sd	s3,48(a5)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001f70:	8a898513          	addi	a0,s3,-1880 # 8a8 <_entry-0x7ffff758>
    80001f74:	4641                	li	a2,16
    80001f76:	00007597          	auipc	a1,0x7
    80001f7a:	28258593          	addi	a1,a1,642 # 800091f8 <digits+0x1b8>
    80001f7e:	9526                	add	a0,a0,s1
    80001f80:	fffff097          	auipc	ra,0xfffff
    80001f84:	e9e080e7          	jalr	-354(ra) # 80000e1e <safestrcpy>
  p->cwd = namei("/");
    80001f88:	00007517          	auipc	a0,0x7
    80001f8c:	28050513          	addi	a0,a0,640 # 80009208 <digits+0x1c8>
    80001f90:	00003097          	auipc	ra,0x3
    80001f94:	fe4080e7          	jalr	-28(ra) # 80004f74 <namei>
    80001f98:	8aaa3023          	sd	a0,-1888(s4)
  t->state = TRUNNABLE;
    80001f9c:	478d                	li	a5,3
    80001f9e:	00f92223          	sw	a5,4(s2)
  release(&t->lock);
    80001fa2:	8556                	mv	a0,s5
    80001fa4:	fffff097          	auipc	ra,0xfffff
    80001fa8:	ce0080e7          	jalr	-800(ra) # 80000c84 <release>
  release(&p->lock);
    80001fac:	8526                	mv	a0,s1
    80001fae:	fffff097          	auipc	ra,0xfffff
    80001fb2:	cd6080e7          	jalr	-810(ra) # 80000c84 <release>
}
    80001fb6:	70e2                	ld	ra,56(sp)
    80001fb8:	7442                	ld	s0,48(sp)
    80001fba:	74a2                	ld	s1,40(sp)
    80001fbc:	7902                	ld	s2,32(sp)
    80001fbe:	69e2                	ld	s3,24(sp)
    80001fc0:	6a42                	ld	s4,16(sp)
    80001fc2:	6aa2                	ld	s5,8(sp)
    80001fc4:	6121                	addi	sp,sp,64
    80001fc6:	8082                	ret

0000000080001fc8 <growproc>:
{
    80001fc8:	1101                	addi	sp,sp,-32
    80001fca:	ec06                	sd	ra,24(sp)
    80001fcc:	e822                	sd	s0,16(sp)
    80001fce:	e426                	sd	s1,8(sp)
    80001fd0:	e04a                	sd	s2,0(sp)
    80001fd2:	1000                	addi	s0,sp,32
    80001fd4:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001fd6:	00000097          	auipc	ra,0x0
    80001fda:	a90080e7          	jalr	-1392(ra) # 80001a66 <myproc>
    80001fde:	84aa                	mv	s1,a0
  sz = p->sz;
    80001fe0:	6785                	lui	a5,0x1
    80001fe2:	97aa                	add	a5,a5,a0
    80001fe4:	8107b583          	ld	a1,-2032(a5) # 810 <_entry-0x7ffff7f0>
    80001fe8:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001fec:	03204163          	bgtz	s2,8000200e <growproc+0x46>
  } else if(n < 0){
    80001ff0:	04094263          	bltz	s2,80002034 <growproc+0x6c>
  p->sz = sz;
    80001ff4:	6505                	lui	a0,0x1
    80001ff6:	94aa                	add	s1,s1,a0
    80001ff8:	1602                	slli	a2,a2,0x20
    80001ffa:	9201                	srli	a2,a2,0x20
    80001ffc:	80c4b823          	sd	a2,-2032(s1)
  return 0;
    80002000:	4501                	li	a0,0
}
    80002002:	60e2                	ld	ra,24(sp)
    80002004:	6442                	ld	s0,16(sp)
    80002006:	64a2                	ld	s1,8(sp)
    80002008:	6902                	ld	s2,0(sp)
    8000200a:	6105                	addi	sp,sp,32
    8000200c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000200e:	00c9063b          	addw	a2,s2,a2
    80002012:	6785                	lui	a5,0x1
    80002014:	97aa                	add	a5,a5,a0
    80002016:	1602                	slli	a2,a2,0x20
    80002018:	9201                	srli	a2,a2,0x20
    8000201a:	1582                	slli	a1,a1,0x20
    8000201c:	9181                	srli	a1,a1,0x20
    8000201e:	8187b503          	ld	a0,-2024(a5) # 818 <_entry-0x7ffff7e8>
    80002022:	fffff097          	auipc	ra,0xfffff
    80002026:	3da080e7          	jalr	986(ra) # 800013fc <uvmalloc>
    8000202a:	0005061b          	sext.w	a2,a0
    8000202e:	f279                	bnez	a2,80001ff4 <growproc+0x2c>
      return -1;
    80002030:	557d                	li	a0,-1
    80002032:	bfc1                	j	80002002 <growproc+0x3a>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80002034:	00c9063b          	addw	a2,s2,a2
    80002038:	6785                	lui	a5,0x1
    8000203a:	97aa                	add	a5,a5,a0
    8000203c:	1602                	slli	a2,a2,0x20
    8000203e:	9201                	srli	a2,a2,0x20
    80002040:	1582                	slli	a1,a1,0x20
    80002042:	9181                	srli	a1,a1,0x20
    80002044:	8187b503          	ld	a0,-2024(a5) # 818 <_entry-0x7ffff7e8>
    80002048:	fffff097          	auipc	ra,0xfffff
    8000204c:	36c080e7          	jalr	876(ra) # 800013b4 <uvmdealloc>
    80002050:	0005061b          	sext.w	a2,a0
    80002054:	b745                	j	80001ff4 <growproc+0x2c>

0000000080002056 <fork>:
{
    80002056:	7139                	addi	sp,sp,-64
    80002058:	fc06                	sd	ra,56(sp)
    8000205a:	f822                	sd	s0,48(sp)
    8000205c:	f426                	sd	s1,40(sp)
    8000205e:	f04a                	sd	s2,32(sp)
    80002060:	ec4e                	sd	s3,24(sp)
    80002062:	e852                	sd	s4,16(sp)
    80002064:	e456                	sd	s5,8(sp)
    80002066:	e05a                	sd	s6,0(sp)
    80002068:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000206a:	00000097          	auipc	ra,0x0
    8000206e:	9fc080e7          	jalr	-1540(ra) # 80001a66 <myproc>
    80002072:	8a2a                	mv	s4,a0
  struct thread *t = mythread();
    80002074:	00000097          	auipc	ra,0x0
    80002078:	a32080e7          	jalr	-1486(ra) # 80001aa6 <mythread>
    8000207c:	84aa                	mv	s1,a0
  if((np = allocproc()) == 0){
    8000207e:	00000097          	auipc	ra,0x0
    80002082:	d82080e7          	jalr	-638(ra) # 80001e00 <allocproc>
    80002086:	1a050363          	beqz	a0,8000222c <fork+0x1d6>
    8000208a:	89aa                	mv	s3,a0
  if((nt = allocthread(np)) == 0){
    8000208c:	00000097          	auipc	ra,0x0
    80002090:	b30080e7          	jalr	-1232(ra) # 80001bbc <allocthread>
    80002094:	8aaa                	mv	s5,a0
    80002096:	18050d63          	beqz	a0,80002230 <fork+0x1da>
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000209a:	6785                	lui	a5,0x1
    8000209c:	00fa0733          	add	a4,s4,a5
    800020a0:	97ce                	add	a5,a5,s3
    800020a2:	81073603          	ld	a2,-2032(a4) # 810 <_entry-0x7ffff7f0>
    800020a6:	8187b583          	ld	a1,-2024(a5) # 818 <_entry-0x7ffff7e8>
    800020aa:	81873503          	ld	a0,-2024(a4)
    800020ae:	fffff097          	auipc	ra,0xfffff
    800020b2:	49a080e7          	jalr	1178(ra) # 80001548 <uvmcopy>
    800020b6:	06054e63          	bltz	a0,80002132 <fork+0xdc>
  np->sz = p->sz;
    800020ba:	6785                	lui	a5,0x1
    800020bc:	00fa0733          	add	a4,s4,a5
    800020c0:	81073703          	ld	a4,-2032(a4)
    800020c4:	97ce                	add	a5,a5,s3
    800020c6:	80e7b823          	sd	a4,-2032(a5) # 810 <_entry-0x7ffff7f0>
  np->signalMask = p->signalMask;
    800020ca:	02ca2783          	lw	a5,44(s4)
    800020ce:	02f9a623          	sw	a5,44(s3)
  for (int i = 0; i < 32; i++)
    800020d2:	030a0793          	addi	a5,s4,48
    800020d6:	03098713          	addi	a4,s3,48
    800020da:	130a0613          	addi	a2,s4,304
    np->signalHandlers[i] = p->signalHandlers[i];
    800020de:	6394                	ld	a3,0(a5)
    800020e0:	e314                	sd	a3,0(a4)
  for (int i = 0; i < 32; i++)
    800020e2:	07a1                	addi	a5,a5,8
    800020e4:	0721                	addi	a4,a4,8
    800020e6:	fec79ce3          	bne	a5,a2,800020de <fork+0x88>
  *(nt->trapframe) = *(t->trapframe);
    800020ea:	60d4                	ld	a3,128(s1)
    800020ec:	87b6                	mv	a5,a3
    800020ee:	080ab703          	ld	a4,128(s5)
    800020f2:	12068693          	addi	a3,a3,288
    800020f6:	0007b803          	ld	a6,0(a5)
    800020fa:	6788                	ld	a0,8(a5)
    800020fc:	6b8c                	ld	a1,16(a5)
    800020fe:	6f90                	ld	a2,24(a5)
    80002100:	01073023          	sd	a6,0(a4)
    80002104:	e708                	sd	a0,8(a4)
    80002106:	eb0c                	sd	a1,16(a4)
    80002108:	ef10                	sd	a2,24(a4)
    8000210a:	02078793          	addi	a5,a5,32
    8000210e:	02070713          	addi	a4,a4,32
    80002112:	fed792e3          	bne	a5,a3,800020f6 <fork+0xa0>
  nt->trapframe->a0 = 0;
    80002116:	080ab783          	ld	a5,128(s5)
    8000211a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000211e:	6b05                	lui	s6,0x1
    80002120:	820b0913          	addi	s2,s6,-2016 # 820 <_entry-0x7ffff7e0>
    80002124:	012a04b3          	add	s1,s4,s2
    80002128:	994e                	add	s2,s2,s3
    8000212a:	8a0b0b13          	addi	s6,s6,-1888
    8000212e:	9b52                	add	s6,s6,s4
    80002130:	a0b9                	j	8000217e <fork+0x128>
    freeproc(np);
    80002132:	854e                	mv	a0,s3
    80002134:	00000097          	auipc	ra,0x0
    80002138:	c66080e7          	jalr	-922(ra) # 80001d9a <freeproc>
  tr->trapframe = 0;
    8000213c:	080ab023          	sd	zero,128(s5)
  tr->userTrapFrameBackup = 0;
    80002140:	080ab423          	sd	zero,136(s5)
  tr->xstate = 0;
    80002144:	0a0aa823          	sw	zero,176(s5)
  tr->tid = 0;
    80002148:	000aa023          	sw	zero,0(s5)
  tr->parent = 0;
    8000214c:	060abc23          	sd	zero,120(s5)
  tr->chan = 0;
    80002150:	0a0ab423          	sd	zero,168(s5)
  tr->killed = 0;
    80002154:	0c0aa023          	sw	zero,192(s5)
  tr->state = TUNUSED;
    80002158:	000aa223          	sw	zero,4(s5)
    release(&np->lock);
    8000215c:	854e                	mv	a0,s3
    8000215e:	fffff097          	auipc	ra,0xfffff
    80002162:	b26080e7          	jalr	-1242(ra) # 80000c84 <release>
    return -1;
    80002166:	5b7d                	li	s6,-1
    80002168:	a07d                	j	80002216 <fork+0x1c0>
      np->ofile[i] = filedup(p->ofile[i]);
    8000216a:	00003097          	auipc	ra,0x3
    8000216e:	4a4080e7          	jalr	1188(ra) # 8000560e <filedup>
    80002172:	00a93023          	sd	a0,0(s2)
  for(i = 0; i < NOFILE; i++)
    80002176:	04a1                	addi	s1,s1,8
    80002178:	0921                	addi	s2,s2,8
    8000217a:	01648563          	beq	s1,s6,80002184 <fork+0x12e>
    if(p->ofile[i])
    8000217e:	6088                	ld	a0,0(s1)
    80002180:	f56d                	bnez	a0,8000216a <fork+0x114>
    80002182:	bfd5                	j	80002176 <fork+0x120>
  np->cwd = idup(p->cwd);
    80002184:	6485                	lui	s1,0x1
    80002186:	009a07b3          	add	a5,s4,s1
    8000218a:	8a07b503          	ld	a0,-1888(a5)
    8000218e:	00002097          	auipc	ra,0x2
    80002192:	5ee080e7          	jalr	1518(ra) # 8000477c <idup>
    80002196:	00998933          	add	s2,s3,s1
    8000219a:	8aa93023          	sd	a0,-1888(s2)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000219e:	8a848513          	addi	a0,s1,-1880 # 8a8 <_entry-0x7ffff758>
    800021a2:	4641                	li	a2,16
    800021a4:	00aa05b3          	add	a1,s4,a0
    800021a8:	954e                	add	a0,a0,s3
    800021aa:	fffff097          	auipc	ra,0xfffff
    800021ae:	c74080e7          	jalr	-908(ra) # 80000e1e <safestrcpy>
  pid = np->pid;
    800021b2:	0249ab03          	lw	s6,36(s3)
  release(&np->lock); 
    800021b6:	854e                	mv	a0,s3
    800021b8:	fffff097          	auipc	ra,0xfffff
    800021bc:	acc080e7          	jalr	-1332(ra) # 80000c84 <release>
  acquire(&wait_lock);
    800021c0:	00010497          	auipc	s1,0x10
    800021c4:	11048493          	addi	s1,s1,272 # 800122d0 <wait_lock>
    800021c8:	8526                	mv	a0,s1
    800021ca:	fffff097          	auipc	ra,0xfffff
    800021ce:	a00080e7          	jalr	-1536(ra) # 80000bca <acquire>
  np->parent = p;
    800021d2:	81493423          	sd	s4,-2040(s2)
  release(&wait_lock);
    800021d6:	8526                	mv	a0,s1
    800021d8:	fffff097          	auipc	ra,0xfffff
    800021dc:	aac080e7          	jalr	-1364(ra) # 80000c84 <release>
  acquire(&np->lock);
    800021e0:	854e                	mv	a0,s3
    800021e2:	fffff097          	auipc	ra,0xfffff
    800021e6:	9e8080e7          	jalr	-1560(ra) # 80000bca <acquire>
  acquire(&nt->lock);
    800021ea:	090a8493          	addi	s1,s5,144
    800021ee:	8526                	mv	a0,s1
    800021f0:	fffff097          	auipc	ra,0xfffff
    800021f4:	9da080e7          	jalr	-1574(ra) # 80000bca <acquire>
  nt->state = TRUNNABLE;
    800021f8:	478d                	li	a5,3
    800021fa:	00faa223          	sw	a5,4(s5)
  nt->parent = np;
    800021fe:	073abc23          	sd	s3,120(s5)
  release(&nt->lock);
    80002202:	8526                	mv	a0,s1
    80002204:	fffff097          	auipc	ra,0xfffff
    80002208:	a80080e7          	jalr	-1408(ra) # 80000c84 <release>
  release(&np->lock);
    8000220c:	854e                	mv	a0,s3
    8000220e:	fffff097          	auipc	ra,0xfffff
    80002212:	a76080e7          	jalr	-1418(ra) # 80000c84 <release>
}
    80002216:	855a                	mv	a0,s6
    80002218:	70e2                	ld	ra,56(sp)
    8000221a:	7442                	ld	s0,48(sp)
    8000221c:	74a2                	ld	s1,40(sp)
    8000221e:	7902                	ld	s2,32(sp)
    80002220:	69e2                	ld	s3,24(sp)
    80002222:	6a42                	ld	s4,16(sp)
    80002224:	6aa2                	ld	s5,8(sp)
    80002226:	6b02                	ld	s6,0(sp)
    80002228:	6121                	addi	sp,sp,64
    8000222a:	8082                	ret
    return -1;
    8000222c:	5b7d                	li	s6,-1
    8000222e:	b7e5                	j	80002216 <fork+0x1c0>
    return -1;
    80002230:	5b7d                	li	s6,-1
    80002232:	b7d5                	j	80002216 <fork+0x1c0>

0000000080002234 <sigprocmask>:
{
    80002234:	7179                	addi	sp,sp,-48
    80002236:	f406                	sd	ra,40(sp)
    80002238:	f022                	sd	s0,32(sp)
    8000223a:	ec26                	sd	s1,24(sp)
    8000223c:	e84a                	sd	s2,16(sp)
    8000223e:	e44e                	sd	s3,8(sp)
    80002240:	1800                	addi	s0,sp,48
    80002242:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80002244:	00000097          	auipc	ra,0x0
    80002248:	822080e7          	jalr	-2014(ra) # 80001a66 <myproc>
    8000224c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000224e:	fffff097          	auipc	ra,0xfffff
    80002252:	97c080e7          	jalr	-1668(ra) # 80000bca <acquire>
  uint old_mask = p->signalMask;
    80002256:	02c4a983          	lw	s3,44(s1)
  p->signalMask = mask;
    8000225a:	0324a623          	sw	s2,44(s1)
  release(&p->lock);
    8000225e:	8526                	mv	a0,s1
    80002260:	fffff097          	auipc	ra,0xfffff
    80002264:	a24080e7          	jalr	-1500(ra) # 80000c84 <release>
}
    80002268:	854e                	mv	a0,s3
    8000226a:	70a2                	ld	ra,40(sp)
    8000226c:	7402                	ld	s0,32(sp)
    8000226e:	64e2                	ld	s1,24(sp)
    80002270:	6942                	ld	s2,16(sp)
    80002272:	69a2                	ld	s3,8(sp)
    80002274:	6145                	addi	sp,sp,48
    80002276:	8082                	ret

0000000080002278 <sigaction>:
{
    80002278:	7139                	addi	sp,sp,-64
    8000227a:	fc06                	sd	ra,56(sp)
    8000227c:	f822                	sd	s0,48(sp)
    8000227e:	f426                	sd	s1,40(sp)
    80002280:	f04a                	sd	s2,32(sp)
    80002282:	ec4e                	sd	s3,24(sp)
    80002284:	e852                	sd	s4,16(sp)
    80002286:	0080                	addi	s0,sp,64
    80002288:	84aa                	mv	s1,a0
    8000228a:	89ae                	mv	s3,a1
    8000228c:	8a32                	mv	s4,a2
  struct proc* p = myproc();
    8000228e:	fffff097          	auipc	ra,0xfffff
    80002292:	7d8080e7          	jalr	2008(ra) # 80001a66 <myproc>
    80002296:	892a                	mv	s2,a0
  if(copyin(p->pagetable, (char*)&handler, act, sizeof(void*)) < 0) {
    80002298:	6785                	lui	a5,0x1
    8000229a:	97aa                	add	a5,a5,a0
    8000229c:	46a1                	li	a3,8
    8000229e:	864e                	mv	a2,s3
    800022a0:	fc040593          	addi	a1,s0,-64
    800022a4:	8187b503          	ld	a0,-2024(a5) # 818 <_entry-0x7ffff7e8>
    800022a8:	fffff097          	auipc	ra,0xfffff
    800022ac:	430080e7          	jalr	1072(ra) # 800016d8 <copyin>
    800022b0:	0c054663          	bltz	a0,8000237c <sigaction+0x104>
  if(copyin(p->pagetable, (char*)&sigmask, act + sizeof(void*), sizeof(int)) < 0) {
    800022b4:	6785                	lui	a5,0x1
    800022b6:	97ca                	add	a5,a5,s2
    800022b8:	4691                	li	a3,4
    800022ba:	00898613          	addi	a2,s3,8
    800022be:	fcc40593          	addi	a1,s0,-52
    800022c2:	8187b503          	ld	a0,-2024(a5) # 818 <_entry-0x7ffff7e8>
    800022c6:	fffff097          	auipc	ra,0xfffff
    800022ca:	412080e7          	jalr	1042(ra) # 800016d8 <copyin>
    800022ce:	0a054963          	bltz	a0,80002380 <sigaction+0x108>
  if(act == 0 || sigmask < 0 || signum == SIGKILL || signum == SIGSTOP || (sigmask & (1 << SIGKILL)) || (sigmask & (1 << SIGSTOP)))
    800022d2:	0a098963          	beqz	s3,80002384 <sigaction+0x10c>
    800022d6:	fcc42703          	lw	a4,-52(s0)
    800022da:	0a074763          	bltz	a4,80002388 <sigaction+0x110>
    800022de:	ff74879b          	addiw	a5,s1,-9
    800022e2:	9bdd                	andi	a5,a5,-9
    800022e4:	2781                	sext.w	a5,a5
    800022e6:	c3dd                	beqz	a5,8000238c <sigaction+0x114>
    800022e8:	000207b7          	lui	a5,0x20
    800022ec:	20078793          	addi	a5,a5,512 # 20200 <_entry-0x7ffdfe00>
    800022f0:	8f7d                	and	a4,a4,a5
    800022f2:	ef59                	bnez	a4,80002390 <sigaction+0x118>
  if(oldact != 0)
    800022f4:	040a0363          	beqz	s4,8000233a <sigaction+0xc2>
    if(copyout(p->pagetable, oldact, (char*)&p->signalHandlers[signum], sizeof(void*)) < 0){
    800022f8:	00648613          	addi	a2,s1,6
    800022fc:	060e                	slli	a2,a2,0x3
    800022fe:	6785                	lui	a5,0x1
    80002300:	97ca                	add	a5,a5,s2
    80002302:	46a1                	li	a3,8
    80002304:	964a                	add	a2,a2,s2
    80002306:	85d2                	mv	a1,s4
    80002308:	8187b503          	ld	a0,-2024(a5) # 818 <_entry-0x7ffff7e8>
    8000230c:	fffff097          	auipc	ra,0xfffff
    80002310:	340080e7          	jalr	832(ra) # 8000164c <copyout>
    80002314:	08054063          	bltz	a0,80002394 <sigaction+0x11c>
    if(copyout(p->pagetable, oldact + sizeof(void*), (char*)&p->signalHandlersMasks[signum], sizeof(uint)) < 0){
    80002318:	04c48613          	addi	a2,s1,76
    8000231c:	060a                	slli	a2,a2,0x2
    8000231e:	6785                	lui	a5,0x1
    80002320:	97ca                	add	a5,a5,s2
    80002322:	4691                	li	a3,4
    80002324:	964a                	add	a2,a2,s2
    80002326:	008a0593          	addi	a1,s4,8
    8000232a:	8187b503          	ld	a0,-2024(a5) # 818 <_entry-0x7ffff7e8>
    8000232e:	fffff097          	auipc	ra,0xfffff
    80002332:	31e080e7          	jalr	798(ra) # 8000164c <copyout>
    80002336:	06054163          	bltz	a0,80002398 <sigaction+0x120>
  acquire(&p->lock);
    8000233a:	854a                	mv	a0,s2
    8000233c:	fffff097          	auipc	ra,0xfffff
    80002340:	88e080e7          	jalr	-1906(ra) # 80000bca <acquire>
  p->signalHandlers[signum] = (void*)handler;
    80002344:	00648793          	addi	a5,s1,6
    80002348:	078e                	slli	a5,a5,0x3
    8000234a:	97ca                	add	a5,a5,s2
    8000234c:	fc043703          	ld	a4,-64(s0)
    80002350:	e398                	sd	a4,0(a5)
  p->signalHandlersMasks[signum] = sigmask;
    80002352:	04c48493          	addi	s1,s1,76
    80002356:	048a                	slli	s1,s1,0x2
    80002358:	94ca                	add	s1,s1,s2
    8000235a:	fcc42783          	lw	a5,-52(s0)
    8000235e:	c09c                	sw	a5,0(s1)
  release(&p->lock);
    80002360:	854a                	mv	a0,s2
    80002362:	fffff097          	auipc	ra,0xfffff
    80002366:	922080e7          	jalr	-1758(ra) # 80000c84 <release>
  return 0;
    8000236a:	4501                	li	a0,0
}
    8000236c:	70e2                	ld	ra,56(sp)
    8000236e:	7442                	ld	s0,48(sp)
    80002370:	74a2                	ld	s1,40(sp)
    80002372:	7902                	ld	s2,32(sp)
    80002374:	69e2                	ld	s3,24(sp)
    80002376:	6a42                	ld	s4,16(sp)
    80002378:	6121                	addi	sp,sp,64
    8000237a:	8082                	ret
    return -1;
    8000237c:	557d                	li	a0,-1
    8000237e:	b7fd                	j	8000236c <sigaction+0xf4>
    return -1;
    80002380:	557d                	li	a0,-1
    80002382:	b7ed                	j	8000236c <sigaction+0xf4>
    return -1;
    80002384:	557d                	li	a0,-1
    80002386:	b7dd                	j	8000236c <sigaction+0xf4>
    80002388:	557d                	li	a0,-1
    8000238a:	b7cd                	j	8000236c <sigaction+0xf4>
    8000238c:	557d                	li	a0,-1
    8000238e:	bff9                	j	8000236c <sigaction+0xf4>
    80002390:	557d                	li	a0,-1
    80002392:	bfe9                	j	8000236c <sigaction+0xf4>
      return -1;
    80002394:	557d                	li	a0,-1
    80002396:	bfd9                	j	8000236c <sigaction+0xf4>
      return -1;
    80002398:	557d                	li	a0,-1
    8000239a:	bfc9                	j	8000236c <sigaction+0xf4>

000000008000239c <sigret>:
sigret(void){
    8000239c:	1101                	addi	sp,sp,-32
    8000239e:	ec06                	sd	ra,24(sp)
    800023a0:	e822                	sd	s0,16(sp)
    800023a2:	e426                	sd	s1,8(sp)
    800023a4:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    800023a6:	fffff097          	auipc	ra,0xfffff
    800023aa:	6c0080e7          	jalr	1728(ra) # 80001a66 <myproc>
    800023ae:	84aa                	mv	s1,a0
    struct thread *t = mythread();
    800023b0:	fffff097          	auipc	ra,0xfffff
    800023b4:	6f6080e7          	jalr	1782(ra) # 80001aa6 <mythread>
    copyin(p->pagetable, (char*)t->trapframe, (uint64)t->userTrapFrameBackup, sizeof(struct trapframe));
    800023b8:	6785                	lui	a5,0x1
    800023ba:	97a6                	add	a5,a5,s1
    800023bc:	12000693          	li	a3,288
    800023c0:	6550                	ld	a2,136(a0)
    800023c2:	614c                	ld	a1,128(a0)
    800023c4:	8187b503          	ld	a0,-2024(a5) # 818 <_entry-0x7ffff7e8>
    800023c8:	fffff097          	auipc	ra,0xfffff
    800023cc:	310080e7          	jalr	784(ra) # 800016d8 <copyin>
    p->signalMask = p->oldSignalMask;
    800023d0:	1b44a783          	lw	a5,436(s1)
    800023d4:	d4dc                	sw	a5,44(s1)
    p->handlesUserSignalHandler = 0;
    800023d6:	1a04a823          	sw	zero,432(s1)
}
    800023da:	60e2                	ld	ra,24(sp)
    800023dc:	6442                	ld	s0,16(sp)
    800023de:	64a2                	ld	s1,8(sp)
    800023e0:	6105                	addi	sp,sp,32
    800023e2:	8082                	ret

00000000800023e4 <SIGKILL_handler>:
{
    800023e4:	1141                	addi	sp,sp,-16
    800023e6:	e422                	sd	s0,8(sp)
    800023e8:	0800                	addi	s0,sp,16
  p->killed = 1;
    800023ea:	4785                	li	a5,1
    800023ec:	cd5c                	sw	a5,28(a0)
}
    800023ee:	6422                	ld	s0,8(sp)
    800023f0:	0141                	addi	sp,sp,16
    800023f2:	8082                	ret

00000000800023f4 <SIGCONT_handler>:
{
    800023f4:	1141                	addi	sp,sp,-16
    800023f6:	e422                	sd	s0,8(sp)
    800023f8:	0800                	addi	s0,sp,16
  if(p->stopped){
    800023fa:	1b852783          	lw	a5,440(a0) # 11b8 <_entry-0x7fffee48>
    800023fe:	cb89                	beqz	a5,80002410 <SIGCONT_handler+0x1c>
    p->stopped = 0;
    80002400:	1a052c23          	sw	zero,440(a0)
    p->pendingSignals &= ~(1 << SIGCONT);
    80002404:	551c                	lw	a5,40(a0)
    80002406:	fff80737          	lui	a4,0xfff80
    8000240a:	177d                	addi	a4,a4,-1
    8000240c:	8ff9                	and	a5,a5,a4
    8000240e:	d51c                	sw	a5,40(a0)
}
    80002410:	6422                	ld	s0,8(sp)
    80002412:	0141                	addi	sp,sp,16
    80002414:	8082                	ret

0000000080002416 <kthread_create>:
kthread_create(void (* start_func)(), void *stack){
    80002416:	7179                	addi	sp,sp,-48
    80002418:	f406                	sd	ra,40(sp)
    8000241a:	f022                	sd	s0,32(sp)
    8000241c:	ec26                	sd	s1,24(sp)
    8000241e:	e84a                	sd	s2,16(sp)
    80002420:	e44e                	sd	s3,8(sp)
    80002422:	e052                	sd	s4,0(sp)
    80002424:	1800                	addi	s0,sp,48
  if(stack == 0)
    80002426:	c9d5                	beqz	a1,800024da <kthread_create+0xc4>
    80002428:	8a2a                	mv	s4,a0
    8000242a:	892e                	mv	s2,a1
  struct proc* p = myproc();
    8000242c:	fffff097          	auipc	ra,0xfffff
    80002430:	63a080e7          	jalr	1594(ra) # 80001a66 <myproc>
    80002434:	89aa                	mv	s3,a0
  acquire(&p->lock);
    80002436:	ffffe097          	auipc	ra,0xffffe
    8000243a:	794080e7          	jalr	1940(ra) # 80000bca <acquire>
  if((t = allocthread(p)) == 0){
    8000243e:	854e                	mv	a0,s3
    80002440:	fffff097          	auipc	ra,0xfffff
    80002444:	77c080e7          	jalr	1916(ra) # 80001bbc <allocthread>
    80002448:	84aa                	mv	s1,a0
    8000244a:	c149                	beqz	a0,800024cc <kthread_create+0xb6>
  release(&p->lock);
    8000244c:	854e                	mv	a0,s3
    8000244e:	fffff097          	auipc	ra,0xfffff
    80002452:	836080e7          	jalr	-1994(ra) # 80000c84 <release>
  acquire(&t->lock);  
    80002456:	09048993          	addi	s3,s1,144
    8000245a:	854e                	mv	a0,s3
    8000245c:	ffffe097          	auipc	ra,0xffffe
    80002460:	76e080e7          	jalr	1902(ra) # 80000bca <acquire>
  *(t->trapframe) = *(mythread()->trapframe);
    80002464:	fffff097          	auipc	ra,0xfffff
    80002468:	642080e7          	jalr	1602(ra) # 80001aa6 <mythread>
    8000246c:	6154                	ld	a3,128(a0)
    8000246e:	87b6                	mv	a5,a3
    80002470:	60d8                	ld	a4,128(s1)
    80002472:	12068693          	addi	a3,a3,288
    80002476:	0007b803          	ld	a6,0(a5)
    8000247a:	6788                	ld	a0,8(a5)
    8000247c:	6b8c                	ld	a1,16(a5)
    8000247e:	6f90                	ld	a2,24(a5)
    80002480:	01073023          	sd	a6,0(a4) # fffffffffff80000 <end+0xffffffff7ff3b000>
    80002484:	e708                	sd	a0,8(a4)
    80002486:	eb0c                	sd	a1,16(a4)
    80002488:	ef10                	sd	a2,24(a4)
    8000248a:	02078793          	addi	a5,a5,32
    8000248e:	02070713          	addi	a4,a4,32
    80002492:	fed792e3          	bne	a5,a3,80002476 <kthread_create+0x60>
  t->trapframe->epc = (uint64)(start_func);
    80002496:	60dc                	ld	a5,128(s1)
    80002498:	0147bc23          	sd	s4,24(a5)
  t->trapframe->sp = (uint64)stack + MAX_STACK_SIZE - 16;
    8000249c:	60dc                	ld	a5,128(s1)
    8000249e:	6585                	lui	a1,0x1
    800024a0:	f9058593          	addi	a1,a1,-112 # f90 <_entry-0x7ffff070>
    800024a4:	992e                	add	s2,s2,a1
    800024a6:	0327b823          	sd	s2,48(a5)
  t->state = TRUNNABLE;
    800024aa:	478d                	li	a5,3
    800024ac:	c0dc                	sw	a5,4(s1)
  tid = t->tid;
    800024ae:	4084                	lw	s1,0(s1)
  release(&t->lock);
    800024b0:	854e                	mv	a0,s3
    800024b2:	ffffe097          	auipc	ra,0xffffe
    800024b6:	7d2080e7          	jalr	2002(ra) # 80000c84 <release>
}
    800024ba:	8526                	mv	a0,s1
    800024bc:	70a2                	ld	ra,40(sp)
    800024be:	7402                	ld	s0,32(sp)
    800024c0:	64e2                	ld	s1,24(sp)
    800024c2:	6942                	ld	s2,16(sp)
    800024c4:	69a2                	ld	s3,8(sp)
    800024c6:	6a02                	ld	s4,0(sp)
    800024c8:	6145                	addi	sp,sp,48
    800024ca:	8082                	ret
    release(&p->lock);
    800024cc:	854e                	mv	a0,s3
    800024ce:	ffffe097          	auipc	ra,0xffffe
    800024d2:	7b6080e7          	jalr	1974(ra) # 80000c84 <release>
    return -1;
    800024d6:	54fd                	li	s1,-1
    800024d8:	b7cd                	j	800024ba <kthread_create+0xa4>
    return -1;
    800024da:	54fd                	li	s1,-1
    800024dc:	bff9                	j	800024ba <kthread_create+0xa4>

00000000800024de <kthread_id>:
kthread_id(){
    800024de:	1141                	addi	sp,sp,-16
    800024e0:	e406                	sd	ra,8(sp)
    800024e2:	e022                	sd	s0,0(sp)
    800024e4:	0800                	addi	s0,sp,16
  struct thread* t = mythread();
    800024e6:	fffff097          	auipc	ra,0xfffff
    800024ea:	5c0080e7          	jalr	1472(ra) # 80001aa6 <mythread>
  if(!t->tid)
    800024ee:	4108                	lw	a0,0(a0)
    800024f0:	c509                	beqz	a0,800024fa <kthread_id+0x1c>
}
    800024f2:	60a2                	ld	ra,8(sp)
    800024f4:	6402                	ld	s0,0(sp)
    800024f6:	0141                	addi	sp,sp,16
    800024f8:	8082                	ret
    return -1;
    800024fa:	557d                	li	a0,-1
    800024fc:	bfdd                	j	800024f2 <kthread_id+0x14>

00000000800024fe <bsem_alloc>:
bsem_alloc() {
    800024fe:	7179                	addi	sp,sp,-48
    80002500:	f406                	sd	ra,40(sp)
    80002502:	f022                	sd	s0,32(sp)
    80002504:	ec26                	sd	s1,24(sp)
    80002506:	e84a                	sd	s2,16(sp)
    80002508:	e44e                	sd	s3,8(sp)
    8000250a:	e052                	sd	s4,0(sp)
    8000250c:	1800                	addi	s0,sp,48
  for(int i = 0; i < MAX_BSEM; i++){
    8000250e:	00010717          	auipc	a4,0x10
    80002512:	21e70713          	addi	a4,a4,542 # 8001272c <bsemaphores+0x4>
    80002516:	4781                	li	a5,0
  int free_id = -1;
    80002518:	54fd                	li	s1,-1
  for(int i = 0; i < MAX_BSEM; i++){
    8000251a:	08000613          	li	a2,128
    8000251e:	a031                	j	8000252a <bsem_alloc+0x2c>
    80002520:	2785                	addiw	a5,a5,1
    80002522:	02070713          	addi	a4,a4,32
    80002526:	00c78663          	beq	a5,a2,80002532 <bsem_alloc+0x34>
    if(!bsemaphores[i].active)
    8000252a:	4314                	lw	a3,0(a4)
    8000252c:	faf5                	bnez	a3,80002520 <bsem_alloc+0x22>
    8000252e:	84be                	mv	s1,a5
    80002530:	bfc5                	j	80002520 <bsem_alloc+0x22>
  if(free_id == -1)
    80002532:	57fd                	li	a5,-1
    80002534:	04f48463          	beq	s1,a5,8000257c <bsem_alloc+0x7e>
  initlock(&bsemaphores[free_id].lock, "bsem_lock");
    80002538:	00549a13          	slli	s4,s1,0x5
    8000253c:	008a0913          	addi	s2,s4,8
    80002540:	00010997          	auipc	s3,0x10
    80002544:	1e898993          	addi	s3,s3,488 # 80012728 <bsemaphores>
    80002548:	994e                	add	s2,s2,s3
    8000254a:	00007597          	auipc	a1,0x7
    8000254e:	cc658593          	addi	a1,a1,-826 # 80009210 <digits+0x1d0>
    80002552:	854a                	mv	a0,s2
    80002554:	ffffe097          	auipc	ra,0xffffe
    80002558:	5de080e7          	jalr	1502(ra) # 80000b32 <initlock>
  acquire(&bsemaphores[free_id].lock);
    8000255c:	854a                	mv	a0,s2
    8000255e:	ffffe097          	auipc	ra,0xffffe
    80002562:	66c080e7          	jalr	1644(ra) # 80000bca <acquire>
  bsemaphores[free_id].active = 1;
    80002566:	99d2                	add	s3,s3,s4
    80002568:	4785                	li	a5,1
    8000256a:	00f9a223          	sw	a5,4(s3)
  bsemaphores[free_id].value = 1;
    8000256e:	00f9a023          	sw	a5,0(s3)
  release(&bsemaphores[free_id].lock);
    80002572:	854a                	mv	a0,s2
    80002574:	ffffe097          	auipc	ra,0xffffe
    80002578:	710080e7          	jalr	1808(ra) # 80000c84 <release>
}
    8000257c:	8526                	mv	a0,s1
    8000257e:	70a2                	ld	ra,40(sp)
    80002580:	7402                	ld	s0,32(sp)
    80002582:	64e2                	ld	s1,24(sp)
    80002584:	6942                	ld	s2,16(sp)
    80002586:	69a2                	ld	s3,8(sp)
    80002588:	6a02                	ld	s4,0(sp)
    8000258a:	6145                	addi	sp,sp,48
    8000258c:	8082                	ret

000000008000258e <bsem_free>:
bsem_free(int descriptor) {
    8000258e:	7179                	addi	sp,sp,-48
    80002590:	f406                	sd	ra,40(sp)
    80002592:	f022                	sd	s0,32(sp)
    80002594:	ec26                	sd	s1,24(sp)
    80002596:	e84a                	sd	s2,16(sp)
    80002598:	e44e                	sd	s3,8(sp)
    8000259a:	1800                	addi	s0,sp,48
  acquire(&bsemaphores[descriptor].lock);
    8000259c:	00551993          	slli	s3,a0,0x5
    800025a0:	00898913          	addi	s2,s3,8
    800025a4:	00010497          	auipc	s1,0x10
    800025a8:	18448493          	addi	s1,s1,388 # 80012728 <bsemaphores>
    800025ac:	9926                	add	s2,s2,s1
    800025ae:	854a                	mv	a0,s2
    800025b0:	ffffe097          	auipc	ra,0xffffe
    800025b4:	61a080e7          	jalr	1562(ra) # 80000bca <acquire>
  bsemaphores[descriptor].active = 0;
    800025b8:	94ce                	add	s1,s1,s3
    800025ba:	0004a223          	sw	zero,4(s1)
  bsemaphores[descriptor].value = 1;
    800025be:	4785                	li	a5,1
    800025c0:	c09c                	sw	a5,0(s1)
  release(&bsemaphores[descriptor].lock);
    800025c2:	854a                	mv	a0,s2
    800025c4:	ffffe097          	auipc	ra,0xffffe
    800025c8:	6c0080e7          	jalr	1728(ra) # 80000c84 <release>
}
    800025cc:	70a2                	ld	ra,40(sp)
    800025ce:	7402                	ld	s0,32(sp)
    800025d0:	64e2                	ld	s1,24(sp)
    800025d2:	6942                	ld	s2,16(sp)
    800025d4:	69a2                	ld	s3,8(sp)
    800025d6:	6145                	addi	sp,sp,48
    800025d8:	8082                	ret

00000000800025da <scheduler>:
{
    800025da:	711d                	addi	sp,sp,-96
    800025dc:	ec86                	sd	ra,88(sp)
    800025de:	e8a2                	sd	s0,80(sp)
    800025e0:	e4a6                	sd	s1,72(sp)
    800025e2:	e0ca                	sd	s2,64(sp)
    800025e4:	fc4e                	sd	s3,56(sp)
    800025e6:	f852                	sd	s4,48(sp)
    800025e8:	f456                	sd	s5,40(sp)
    800025ea:	f05a                	sd	s6,32(sp)
    800025ec:	ec5e                	sd	s7,24(sp)
    800025ee:	e862                	sd	s8,16(sp)
    800025f0:	e466                	sd	s9,8(sp)
    800025f2:	e06a                	sd	s10,0(sp)
    800025f4:	1080                	addi	s0,sp,96
    800025f6:	8792                	mv	a5,tp
  int id = r_tp();
    800025f8:	2781                	sext.w	a5,a5
  c->proc = 0;
    800025fa:	00479713          	slli	a4,a5,0x4
    800025fe:	00f706b3          	add	a3,a4,a5
    80002602:	00369613          	slli	a2,a3,0x3
    80002606:	00010697          	auipc	a3,0x10
    8000260a:	c9a68693          	addi	a3,a3,-870 # 800122a0 <pid_lock>
    8000260e:	96b2                	add	a3,a3,a2
    80002610:	0406b423          	sd	zero,72(a3)
  c->thread = 0;
    80002614:	0406b823          	sd	zero,80(a3)
            swtch(&c->context, &tr->context);
    80002618:	00010717          	auipc	a4,0x10
    8000261c:	ce070713          	addi	a4,a4,-800 # 800122f8 <cpus+0x10>
    80002620:	00e60b33          	add	s6,a2,a4
            c->thread = tr;
    80002624:	8a36                	mv	s4,a3
        for(tr = p->threads;tr < &p->threads[NTHREAD]; tr++) {
    80002626:	6a85                	lui	s5,0x1
    80002628:	808a8b93          	addi	s7,s5,-2040 # 808 <_entry-0x7ffff7f8>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000262c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002630:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002634:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80002638:	00011917          	auipc	s2,0x11
    8000263c:	0f090913          	addi	s2,s2,240 # 80013728 <proc>
    80002640:	a0a5                	j	800026a8 <scheduler+0xce>
            tr->state = TRUNNING;
    80002642:	01a4a223          	sw	s10,4(s1)
            c->thread = tr;
    80002646:	049a3823          	sd	s1,80(s4)
            c->proc = p;
    8000264a:	052a3423          	sd	s2,72(s4)
            swtch(&c->context, &tr->context);
    8000264e:	00848593          	addi	a1,s1,8
    80002652:	855a                	mv	a0,s6
    80002654:	00001097          	auipc	ra,0x1
    80002658:	c1c080e7          	jalr	-996(ra) # 80003270 <swtch>
            c->thread = 0;
    8000265c:	040a3823          	sd	zero,80(s4)
            c->proc = 0;
    80002660:	040a3423          	sd	zero,72(s4)
            release(&tr->lock);
    80002664:	854e                	mv	a0,s3
    80002666:	ffffe097          	auipc	ra,0xffffe
    8000266a:	61e080e7          	jalr	1566(ra) # 80000c84 <release>
        for(tr = p->threads;tr < &p->threads[NTHREAD]; tr++) {
    8000266e:	0c848493          	addi	s1,s1,200
    80002672:	03848263          	beq	s1,s8,80002696 <scheduler+0xbc>
          acquire(&tr->lock);
    80002676:	09048993          	addi	s3,s1,144
    8000267a:	854e                	mv	a0,s3
    8000267c:	ffffe097          	auipc	ra,0xffffe
    80002680:	54e080e7          	jalr	1358(ra) # 80000bca <acquire>
          if(tr->state == TRUNNABLE){
    80002684:	40dc                	lw	a5,4(s1)
    80002686:	fb978ee3          	beq	a5,s9,80002642 <scheduler+0x68>
            release(&tr->lock);
    8000268a:	854e                	mv	a0,s3
    8000268c:	ffffe097          	auipc	ra,0xffffe
    80002690:	5f8080e7          	jalr	1528(ra) # 80000c84 <release>
    80002694:	bfe9                	j	8000266e <scheduler+0x94>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002696:	8b8a8793          	addi	a5,s5,-1864
    8000269a:	993e                	add	s2,s2,a5
    8000269c:	00034797          	auipc	a5,0x34
    800026a0:	e8c78793          	addi	a5,a5,-372 # 80036528 <tickslock>
    800026a4:	f8f904e3          	beq	s2,a5,8000262c <scheduler+0x52>
      if(p->state == USED) {
    800026a8:	01892703          	lw	a4,24(s2)
    800026ac:	4785                	li	a5,1
    800026ae:	fef714e3          	bne	a4,a5,80002696 <scheduler+0xbc>
        for(tr = p->threads;tr < &p->threads[NTHREAD]; tr++) {
    800026b2:	1c890493          	addi	s1,s2,456
          if(tr->state == TRUNNABLE){
    800026b6:	4c8d                	li	s9,3
            tr->state = TRUNNING;
    800026b8:	4d11                	li	s10,4
        for(tr = p->threads;tr < &p->threads[NTHREAD]; tr++) {
    800026ba:	01790c33          	add	s8,s2,s7
    800026be:	bf65                	j	80002676 <scheduler+0x9c>

00000000800026c0 <sched>:
{
    800026c0:	7179                	addi	sp,sp,-48
    800026c2:	f406                	sd	ra,40(sp)
    800026c4:	f022                	sd	s0,32(sp)
    800026c6:	ec26                	sd	s1,24(sp)
    800026c8:	e84a                	sd	s2,16(sp)
    800026ca:	e44e                	sd	s3,8(sp)
    800026cc:	1800                	addi	s0,sp,48
  struct thread *t = mythread();
    800026ce:	fffff097          	auipc	ra,0xfffff
    800026d2:	3d8080e7          	jalr	984(ra) # 80001aa6 <mythread>
    800026d6:	84aa                	mv	s1,a0
  if(!holding(&t->lock))
    800026d8:	09050513          	addi	a0,a0,144
    800026dc:	ffffe097          	auipc	ra,0xffffe
    800026e0:	46c080e7          	jalr	1132(ra) # 80000b48 <holding>
    800026e4:	c959                	beqz	a0,8000277a <sched+0xba>
  asm volatile("mv %0, tp" : "=r" (x) );
    800026e6:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800026e8:	0007871b          	sext.w	a4,a5
    800026ec:	00471793          	slli	a5,a4,0x4
    800026f0:	97ba                	add	a5,a5,a4
    800026f2:	078e                	slli	a5,a5,0x3
    800026f4:	00010717          	auipc	a4,0x10
    800026f8:	bac70713          	addi	a4,a4,-1108 # 800122a0 <pid_lock>
    800026fc:	97ba                	add	a5,a5,a4
    800026fe:	0c87a703          	lw	a4,200(a5)
    80002702:	4785                	li	a5,1
    80002704:	08f71363          	bne	a4,a5,8000278a <sched+0xca>
  if(t->state == TRUNNING)
    80002708:	40d8                	lw	a4,4(s1)
    8000270a:	4791                	li	a5,4
    8000270c:	08f70763          	beq	a4,a5,8000279a <sched+0xda>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002710:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002714:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002716:	ebd1                	bnez	a5,800027aa <sched+0xea>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002718:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000271a:	00010917          	auipc	s2,0x10
    8000271e:	b8690913          	addi	s2,s2,-1146 # 800122a0 <pid_lock>
    80002722:	0007871b          	sext.w	a4,a5
    80002726:	00471793          	slli	a5,a4,0x4
    8000272a:	97ba                	add	a5,a5,a4
    8000272c:	078e                	slli	a5,a5,0x3
    8000272e:	97ca                	add	a5,a5,s2
    80002730:	0cc7a983          	lw	s3,204(a5)
    80002734:	8792                	mv	a5,tp
  swtch(&t->context, &mycpu()->context);
    80002736:	0007859b          	sext.w	a1,a5
    8000273a:	00459793          	slli	a5,a1,0x4
    8000273e:	97ae                	add	a5,a5,a1
    80002740:	078e                	slli	a5,a5,0x3
    80002742:	00010597          	auipc	a1,0x10
    80002746:	bb658593          	addi	a1,a1,-1098 # 800122f8 <cpus+0x10>
    8000274a:	95be                	add	a1,a1,a5
    8000274c:	00848513          	addi	a0,s1,8
    80002750:	00001097          	auipc	ra,0x1
    80002754:	b20080e7          	jalr	-1248(ra) # 80003270 <swtch>
    80002758:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000275a:	0007871b          	sext.w	a4,a5
    8000275e:	00471793          	slli	a5,a4,0x4
    80002762:	97ba                	add	a5,a5,a4
    80002764:	078e                	slli	a5,a5,0x3
    80002766:	97ca                	add	a5,a5,s2
    80002768:	0d37a623          	sw	s3,204(a5)
}
    8000276c:	70a2                	ld	ra,40(sp)
    8000276e:	7402                	ld	s0,32(sp)
    80002770:	64e2                	ld	s1,24(sp)
    80002772:	6942                	ld	s2,16(sp)
    80002774:	69a2                	ld	s3,8(sp)
    80002776:	6145                	addi	sp,sp,48
    80002778:	8082                	ret
    panic("sched p->lock");
    8000277a:	00007517          	auipc	a0,0x7
    8000277e:	aa650513          	addi	a0,a0,-1370 # 80009220 <digits+0x1e0>
    80002782:	ffffe097          	auipc	ra,0xffffe
    80002786:	da8080e7          	jalr	-600(ra) # 8000052a <panic>
    panic("sched locks");
    8000278a:	00007517          	auipc	a0,0x7
    8000278e:	aa650513          	addi	a0,a0,-1370 # 80009230 <digits+0x1f0>
    80002792:	ffffe097          	auipc	ra,0xffffe
    80002796:	d98080e7          	jalr	-616(ra) # 8000052a <panic>
    panic("sched running");
    8000279a:	00007517          	auipc	a0,0x7
    8000279e:	aa650513          	addi	a0,a0,-1370 # 80009240 <digits+0x200>
    800027a2:	ffffe097          	auipc	ra,0xffffe
    800027a6:	d88080e7          	jalr	-632(ra) # 8000052a <panic>
    panic("sched interruptible");
    800027aa:	00007517          	auipc	a0,0x7
    800027ae:	aa650513          	addi	a0,a0,-1370 # 80009250 <digits+0x210>
    800027b2:	ffffe097          	auipc	ra,0xffffe
    800027b6:	d78080e7          	jalr	-648(ra) # 8000052a <panic>

00000000800027ba <yield>:
{
    800027ba:	1101                	addi	sp,sp,-32
    800027bc:	ec06                	sd	ra,24(sp)
    800027be:	e822                	sd	s0,16(sp)
    800027c0:	e426                	sd	s1,8(sp)
    800027c2:	e04a                	sd	s2,0(sp)
    800027c4:	1000                	addi	s0,sp,32
  struct thread *tr = mythread();
    800027c6:	fffff097          	auipc	ra,0xfffff
    800027ca:	2e0080e7          	jalr	736(ra) # 80001aa6 <mythread>
    800027ce:	84aa                	mv	s1,a0
  acquire(&tr->lock);
    800027d0:	09050913          	addi	s2,a0,144
    800027d4:	854a                	mv	a0,s2
    800027d6:	ffffe097          	auipc	ra,0xffffe
    800027da:	3f4080e7          	jalr	1012(ra) # 80000bca <acquire>
  tr->state = TRUNNABLE;
    800027de:	478d                	li	a5,3
    800027e0:	c0dc                	sw	a5,4(s1)
  sched();
    800027e2:	00000097          	auipc	ra,0x0
    800027e6:	ede080e7          	jalr	-290(ra) # 800026c0 <sched>
  release(&tr->lock);
    800027ea:	854a                	mv	a0,s2
    800027ec:	ffffe097          	auipc	ra,0xffffe
    800027f0:	498080e7          	jalr	1176(ra) # 80000c84 <release>
}
    800027f4:	60e2                	ld	ra,24(sp)
    800027f6:	6442                	ld	s0,16(sp)
    800027f8:	64a2                	ld	s1,8(sp)
    800027fa:	6902                	ld	s2,0(sp)
    800027fc:	6105                	addi	sp,sp,32
    800027fe:	8082                	ret

0000000080002800 <SIGSTOP_handler>:
{  
    80002800:	1101                	addi	sp,sp,-32
    80002802:	ec06                	sd	ra,24(sp)
    80002804:	e822                	sd	s0,16(sp)
    80002806:	e426                	sd	s1,8(sp)
    80002808:	e04a                	sd	s2,0(sp)
    8000280a:	1000                	addi	s0,sp,32
    8000280c:	84aa                	mv	s1,a0
    p->stopped=1;
    8000280e:	4785                	li	a5,1
    80002810:	1af52c23          	sw	a5,440(a0)
    while(((p->pendingSignals&(1<<SIGCONT))==0) && p->stopped){
    80002814:	5518                	lw	a4,40(a0)
    80002816:	01375793          	srli	a5,a4,0x13
    8000281a:	8b85                	andi	a5,a5,1
    8000281c:	ef99                	bnez	a5,8000283a <SIGSTOP_handler+0x3a>
    8000281e:	00080937          	lui	s2,0x80
        yield();
    80002822:	00000097          	auipc	ra,0x0
    80002826:	f98080e7          	jalr	-104(ra) # 800027ba <yield>
    while(((p->pendingSignals&(1<<SIGCONT))==0) && p->stopped){
    8000282a:	5498                	lw	a4,40(s1)
    8000282c:	012777b3          	and	a5,a4,s2
    80002830:	2781                	sext.w	a5,a5
    80002832:	e781                	bnez	a5,8000283a <SIGSTOP_handler+0x3a>
    80002834:	1b84a783          	lw	a5,440(s1)
    80002838:	f7ed                	bnez	a5,80002822 <SIGSTOP_handler+0x22>
    p->stopped=0;
    8000283a:	1a04ac23          	sw	zero,440(s1)
    p->pendingSignals &= ~(1 << SIGCONT);
    8000283e:	fff607b7          	lui	a5,0xfff60
    80002842:	17fd                	addi	a5,a5,-1
    80002844:	8f7d                	and	a4,a4,a5
    80002846:	d498                	sw	a4,40(s1)
}
    80002848:	60e2                	ld	ra,24(sp)
    8000284a:	6442                	ld	s0,16(sp)
    8000284c:	64a2                	ld	s1,8(sp)
    8000284e:	6902                	ld	s2,0(sp)
    80002850:	6105                	addi	sp,sp,32
    80002852:	8082                	ret

0000000080002854 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002854:	7179                	addi	sp,sp,-48
    80002856:	f406                	sd	ra,40(sp)
    80002858:	f022                	sd	s0,32(sp)
    8000285a:	ec26                	sd	s1,24(sp)
    8000285c:	e84a                	sd	s2,16(sp)
    8000285e:	e44e                	sd	s3,8(sp)
    80002860:	e052                	sd	s4,0(sp)
    80002862:	1800                	addi	s0,sp,48
    80002864:	89aa                	mv	s3,a0
    80002866:	892e                	mv	s2,a1
  //printf("hi chan:%d    proc:%d    tr:%d\n",chan,myproc(),mythread());
  //struct proc *p = myproc();
  struct thread *t = mythread();
    80002868:	fffff097          	auipc	ra,0xfffff
    8000286c:	23e080e7          	jalr	574(ra) # 80001aa6 <mythread>
    80002870:	84aa                	mv	s1,a0
  // change p->state and then call sched.
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.
  acquire(&t->lock);  //DOC: sleeplock1
    80002872:	09050a13          	addi	s4,a0,144
    80002876:	8552                	mv	a0,s4
    80002878:	ffffe097          	auipc	ra,0xffffe
    8000287c:	352080e7          	jalr	850(ra) # 80000bca <acquire>
  release(lk);
    80002880:	854a                	mv	a0,s2
    80002882:	ffffe097          	auipc	ra,0xffffe
    80002886:	402080e7          	jalr	1026(ra) # 80000c84 <release>
  // Go to sleep.
  t->chan = chan;
    8000288a:	0b34b423          	sd	s3,168(s1)
  t->state = TSLEEPING;
    8000288e:	4789                	li	a5,2
    80002890:	c0dc                	sw	a5,4(s1)
  sched();
    80002892:	00000097          	auipc	ra,0x0
    80002896:	e2e080e7          	jalr	-466(ra) # 800026c0 <sched>
  // Tidy up.
  t->chan = 0;
    8000289a:	0a04b423          	sd	zero,168(s1)
  // Reacquire original lock.
  release(&t->lock);
    8000289e:	8552                	mv	a0,s4
    800028a0:	ffffe097          	auipc	ra,0xffffe
    800028a4:	3e4080e7          	jalr	996(ra) # 80000c84 <release>
  acquire(lk);
    800028a8:	854a                	mv	a0,s2
    800028aa:	ffffe097          	auipc	ra,0xffffe
    800028ae:	320080e7          	jalr	800(ra) # 80000bca <acquire>
}
    800028b2:	70a2                	ld	ra,40(sp)
    800028b4:	7402                	ld	s0,32(sp)
    800028b6:	64e2                	ld	s1,24(sp)
    800028b8:	6942                	ld	s2,16(sp)
    800028ba:	69a2                	ld	s3,8(sp)
    800028bc:	6a02                	ld	s4,0(sp)
    800028be:	6145                	addi	sp,sp,48
    800028c0:	8082                	ret

00000000800028c2 <kthread_join>:
kthread_join(int thread_id, int* status) {
    800028c2:	715d                	addi	sp,sp,-80
    800028c4:	e486                	sd	ra,72(sp)
    800028c6:	e0a2                	sd	s0,64(sp)
    800028c8:	fc26                	sd	s1,56(sp)
    800028ca:	f84a                	sd	s2,48(sp)
    800028cc:	f44e                	sd	s3,40(sp)
    800028ce:	f052                	sd	s4,32(sp)
    800028d0:	ec56                	sd	s5,24(sp)
    800028d2:	e85a                	sd	s6,16(sp)
    800028d4:	e45e                	sd	s7,8(sp)
    800028d6:	0880                	addi	s0,sp,80
    800028d8:	89aa                	mv	s3,a0
    800028da:	8b2e                	mv	s6,a1
  struct proc* p = myproc();
    800028dc:	fffff097          	auipc	ra,0xfffff
    800028e0:	18a080e7          	jalr	394(ra) # 80001a66 <myproc>
    800028e4:	8aaa                	mv	s5,a0
  struct thread* cr = mythread();
    800028e6:	fffff097          	auipc	ra,0xfffff
    800028ea:	1c0080e7          	jalr	448(ra) # 80001aa6 <mythread>
  if(thread_id == cr->tid)
    800028ee:	411c                	lw	a5,0(a0)
    800028f0:	0d378463          	beq	a5,s3,800029b8 <kthread_join+0xf6>
  for(t = p->threads; t < &p->threads[NTHREAD]; t++){
    800028f4:	1c8a8493          	addi	s1,s5,456
    800028f8:	6a05                	lui	s4,0x1
    800028fa:	808a0a13          	addi	s4,s4,-2040 # 808 <_entry-0x7ffff7f8>
    800028fe:	9a56                	add	s4,s4,s5
    if(t->tid == thread_id && t->state != DYING && t->state != TUNUSED){
    80002900:	4b99                	li	s7,6
    80002902:	a811                	j	80002916 <kthread_join+0x54>
    release(&t->lock);
    80002904:	854a                	mv	a0,s2
    80002906:	ffffe097          	auipc	ra,0xffffe
    8000290a:	37e080e7          	jalr	894(ra) # 80000c84 <release>
  for(t = p->threads; t < &p->threads[NTHREAD]; t++){
    8000290e:	0c848493          	addi	s1,s1,200
    80002912:	089a0963          	beq	s4,s1,800029a4 <kthread_join+0xe2>
    acquire(&t->lock);
    80002916:	09048913          	addi	s2,s1,144
    8000291a:	854a                	mv	a0,s2
    8000291c:	ffffe097          	auipc	ra,0xffffe
    80002920:	2ae080e7          	jalr	686(ra) # 80000bca <acquire>
    if(t->tid == thread_id && t->state != DYING && t->state != TUNUSED){
    80002924:	409c                	lw	a5,0(s1)
    80002926:	fd379fe3          	bne	a5,s3,80002904 <kthread_join+0x42>
    8000292a:	40dc                	lw	a5,4(s1)
    8000292c:	fd778ce3          	beq	a5,s7,80002904 <kthread_join+0x42>
    80002930:	dbf1                	beqz	a5,80002904 <kthread_join+0x42>
  while(t->tid == thread_id && t->state != TUNUSED && t->state != TZOMBIE){
    80002932:	409c                	lw	a5,0(s1)
    80002934:	4915                	li	s2,5
    sleep(t, &t->lock);
    80002936:	09048a13          	addi	s4,s1,144
  while(t->tid == thread_id && t->state != TUNUSED && t->state != TZOMBIE){
    8000293a:	01379f63          	bne	a5,s3,80002958 <kthread_join+0x96>
    8000293e:	40dc                	lw	a5,4(s1)
    80002940:	c3cd                	beqz	a5,800029e2 <kthread_join+0x120>
    80002942:	07278d63          	beq	a5,s2,800029bc <kthread_join+0xfa>
    sleep(t, &t->lock);
    80002946:	85d2                	mv	a1,s4
    80002948:	8526                	mv	a0,s1
    8000294a:	00000097          	auipc	ra,0x0
    8000294e:	f0a080e7          	jalr	-246(ra) # 80002854 <sleep>
  while(t->tid == thread_id && t->state != TUNUSED && t->state != TZOMBIE){
    80002952:	409c                	lw	a5,0(s1)
    80002954:	ff3785e3          	beq	a5,s3,8000293e <kthread_join+0x7c>
  if(status != 0 && copyout(p->pagetable, (uint64)status, (char *)&t->xstate, sizeof(int)) < 0){
    80002958:	020b0063          	beqz	s6,80002978 <kthread_join+0xb6>
    8000295c:	6785                	lui	a5,0x1
    8000295e:	9abe                	add	s5,s5,a5
    80002960:	4691                	li	a3,4
    80002962:	0b048613          	addi	a2,s1,176
    80002966:	85da                	mv	a1,s6
    80002968:	818ab503          	ld	a0,-2024(s5)
    8000296c:	fffff097          	auipc	ra,0xfffff
    80002970:	ce0080e7          	jalr	-800(ra) # 8000164c <copyout>
    80002974:	02054a63          	bltz	a0,800029a8 <kthread_join+0xe6>
  if(t->state == TZOMBIE)
    80002978:	40d8                	lw	a4,4(s1)
    8000297a:	4795                	li	a5,5
    8000297c:	04f70263          	beq	a4,a5,800029c0 <kthread_join+0xfe>
  release(&t->lock);
    80002980:	09048513          	addi	a0,s1,144
    80002984:	ffffe097          	auipc	ra,0xffffe
    80002988:	300080e7          	jalr	768(ra) # 80000c84 <release>
  return 0;
    8000298c:	4501                	li	a0,0
}
    8000298e:	60a6                	ld	ra,72(sp)
    80002990:	6406                	ld	s0,64(sp)
    80002992:	74e2                	ld	s1,56(sp)
    80002994:	7942                	ld	s2,48(sp)
    80002996:	79a2                	ld	s3,40(sp)
    80002998:	7a02                	ld	s4,32(sp)
    8000299a:	6ae2                	ld	s5,24(sp)
    8000299c:	6b42                	ld	s6,16(sp)
    8000299e:	6ba2                	ld	s7,8(sp)
    800029a0:	6161                	addi	sp,sp,80
    800029a2:	8082                	ret
    return -1;
    800029a4:	557d                	li	a0,-1
    800029a6:	b7e5                	j	8000298e <kthread_join+0xcc>
    release(&t->lock);
    800029a8:	09048513          	addi	a0,s1,144
    800029ac:	ffffe097          	auipc	ra,0xffffe
    800029b0:	2d8080e7          	jalr	728(ra) # 80000c84 <release>
    return -1;
    800029b4:	557d                	li	a0,-1
    800029b6:	bfe1                	j	8000298e <kthread_join+0xcc>
    return -1;
    800029b8:	557d                	li	a0,-1
    800029ba:	bfd1                	j	8000298e <kthread_join+0xcc>
  if(status != 0 && copyout(p->pagetable, (uint64)status, (char *)&t->xstate, sizeof(int)) < 0){
    800029bc:	fa0b10e3          	bnez	s6,8000295c <kthread_join+0x9a>
  tr->trapframe = 0;
    800029c0:	0804b023          	sd	zero,128(s1)
  tr->userTrapFrameBackup = 0;
    800029c4:	0804b423          	sd	zero,136(s1)
  tr->xstate = 0;
    800029c8:	0a04a823          	sw	zero,176(s1)
  tr->tid = 0;
    800029cc:	0004a023          	sw	zero,0(s1)
  tr->parent = 0;
    800029d0:	0604bc23          	sd	zero,120(s1)
  tr->chan = 0;
    800029d4:	0a04b423          	sd	zero,168(s1)
  tr->killed = 0;
    800029d8:	0c04a023          	sw	zero,192(s1)
  tr->state = TUNUSED;
    800029dc:	0004a223          	sw	zero,4(s1)
}
    800029e0:	b745                	j	80002980 <kthread_join+0xbe>
  if(status != 0 && copyout(p->pagetable, (uint64)status, (char *)&t->xstate, sizeof(int)) < 0){
    800029e2:	f60b1de3          	bnez	s6,8000295c <kthread_join+0x9a>
    800029e6:	bf69                	j	80002980 <kthread_join+0xbe>

00000000800029e8 <bsem_down>:
bsem_down(int descriptor) {
    800029e8:	7179                	addi	sp,sp,-48
    800029ea:	f406                	sd	ra,40(sp)
    800029ec:	f022                	sd	s0,32(sp)
    800029ee:	ec26                	sd	s1,24(sp)
    800029f0:	e84a                	sd	s2,16(sp)
    800029f2:	e44e                	sd	s3,8(sp)
    800029f4:	e052                	sd	s4,0(sp)
    800029f6:	1800                	addi	s0,sp,48
    800029f8:	8a2a                	mv	s4,a0
  acquire(&bsemaphores[descriptor].lock);
    800029fa:	00551913          	slli	s2,a0,0x5
    800029fe:	00890493          	addi	s1,s2,8 # 80008 <_entry-0x7ff7fff8>
    80002a02:	00010997          	auipc	s3,0x10
    80002a06:	d2698993          	addi	s3,s3,-730 # 80012728 <bsemaphores>
    80002a0a:	94ce                	add	s1,s1,s3
    80002a0c:	8526                	mv	a0,s1
    80002a0e:	ffffe097          	auipc	ra,0xffffe
    80002a12:	1bc080e7          	jalr	444(ra) # 80000bca <acquire>
  while(bsemaphores[descriptor].value == 0){
    80002a16:	99ca                	add	s3,s3,s2
    80002a18:	0009a783          	lw	a5,0(s3)
    80002a1c:	eb99                	bnez	a5,80002a32 <bsem_down+0x4a>
    sleep(&bsemaphores[descriptor], &bsemaphores[descriptor].lock);
    80002a1e:	894e                	mv	s2,s3
    80002a20:	85a6                	mv	a1,s1
    80002a22:	854a                	mv	a0,s2
    80002a24:	00000097          	auipc	ra,0x0
    80002a28:	e30080e7          	jalr	-464(ra) # 80002854 <sleep>
  while(bsemaphores[descriptor].value == 0){
    80002a2c:	0009a783          	lw	a5,0(s3)
    80002a30:	dbe5                	beqz	a5,80002a20 <bsem_down+0x38>
  bsemaphores[descriptor].value = 0;
    80002a32:	0a16                	slli	s4,s4,0x5
    80002a34:	00010797          	auipc	a5,0x10
    80002a38:	cf478793          	addi	a5,a5,-780 # 80012728 <bsemaphores>
    80002a3c:	9a3e                	add	s4,s4,a5
    80002a3e:	000a2023          	sw	zero,0(s4)
  release(&bsemaphores[descriptor].lock);
    80002a42:	8526                	mv	a0,s1
    80002a44:	ffffe097          	auipc	ra,0xffffe
    80002a48:	240080e7          	jalr	576(ra) # 80000c84 <release>
}
    80002a4c:	70a2                	ld	ra,40(sp)
    80002a4e:	7402                	ld	s0,32(sp)
    80002a50:	64e2                	ld	s1,24(sp)
    80002a52:	6942                	ld	s2,16(sp)
    80002a54:	69a2                	ld	s3,8(sp)
    80002a56:	6a02                	ld	s4,0(sp)
    80002a58:	6145                	addi	sp,sp,48
    80002a5a:	8082                	ret

0000000080002a5c <wait>:
{
    80002a5c:	711d                	addi	sp,sp,-96
    80002a5e:	ec86                	sd	ra,88(sp)
    80002a60:	e8a2                	sd	s0,80(sp)
    80002a62:	e4a6                	sd	s1,72(sp)
    80002a64:	e0ca                	sd	s2,64(sp)
    80002a66:	fc4e                	sd	s3,56(sp)
    80002a68:	f852                	sd	s4,48(sp)
    80002a6a:	f456                	sd	s5,40(sp)
    80002a6c:	f05a                	sd	s6,32(sp)
    80002a6e:	ec5e                	sd	s7,24(sp)
    80002a70:	e862                	sd	s8,16(sp)
    80002a72:	e466                	sd	s9,8(sp)
    80002a74:	1080                	addi	s0,sp,96
    80002a76:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80002a78:	fffff097          	auipc	ra,0xfffff
    80002a7c:	fee080e7          	jalr	-18(ra) # 80001a66 <myproc>
    80002a80:	89aa                	mv	s3,a0
  acquire(&wait_lock);
    80002a82:	00010517          	auipc	a0,0x10
    80002a86:	84e50513          	addi	a0,a0,-1970 # 800122d0 <wait_lock>
    80002a8a:	ffffe097          	auipc	ra,0xffffe
    80002a8e:	140080e7          	jalr	320(ra) # 80000bca <acquire>
    80002a92:	6a05                	lui	s4,0x1
    80002a94:	808a0a93          	addi	s5,s4,-2040 # 808 <_entry-0x7ffff7f8>
        if(np->state == ZOMBIE){
    80002a98:	4c09                	li	s8,2
    for(np = proc; np < &proc[NPROC]; np++){
    80002a9a:	8b8a0a13          	addi	s4,s4,-1864
    80002a9e:	00034b17          	auipc	s6,0x34
    80002aa2:	a8ab0b13          	addi	s6,s6,-1398 # 80036528 <tickslock>
    havekids = 0;
    80002aa6:	4701                	li	a4,0
    for(np = proc; np < &proc[NPROC]; np++){
    80002aa8:	00011497          	auipc	s1,0x11
    80002aac:	c8048493          	addi	s1,s1,-896 # 80013728 <proc>
        havekids = 1;
    80002ab0:	4c85                	li	s9,1
    80002ab2:	a871                	j	80002b4e <wait+0xf2>
          pid = np->pid;
    80002ab4:	0244aa03          	lw	s4,36(s1)
          for(t = np->threads; t < &np->threads[NTHREAD]; t++)
    80002ab8:	1c848793          	addi	a5,s1,456
  tr->trapframe = 0;
    80002abc:	0807b023          	sd	zero,128(a5)
  tr->userTrapFrameBackup = 0;
    80002ac0:	0807b423          	sd	zero,136(a5)
  tr->xstate = 0;
    80002ac4:	0a07a823          	sw	zero,176(a5)
  tr->tid = 0;
    80002ac8:	0007a023          	sw	zero,0(a5)
  tr->parent = 0;
    80002acc:	0607bc23          	sd	zero,120(a5)
  tr->chan = 0;
    80002ad0:	0a07b423          	sd	zero,168(a5)
  tr->killed = 0;
    80002ad4:	0c07a023          	sw	zero,192(a5)
  tr->state = TUNUSED;
    80002ad8:	0007a223          	sw	zero,4(a5)
          for(t = np->threads; t < &np->threads[NTHREAD]; t++)
    80002adc:	0c878793          	addi	a5,a5,200
    80002ae0:	fcf91ee3          	bne	s2,a5,80002abc <wait+0x60>
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002ae4:	020b8063          	beqz	s7,80002b04 <wait+0xa8>
    80002ae8:	6785                	lui	a5,0x1
    80002aea:	99be                	add	s3,s3,a5
    80002aec:	4691                	li	a3,4
    80002aee:	02048613          	addi	a2,s1,32
    80002af2:	85de                	mv	a1,s7
    80002af4:	8189b503          	ld	a0,-2024(s3)
    80002af8:	fffff097          	auipc	ra,0xfffff
    80002afc:	b54080e7          	jalr	-1196(ra) # 8000164c <copyout>
    80002b00:	02054563          	bltz	a0,80002b2a <wait+0xce>
          freeproc(np);
    80002b04:	8526                	mv	a0,s1
    80002b06:	fffff097          	auipc	ra,0xfffff
    80002b0a:	294080e7          	jalr	660(ra) # 80001d9a <freeproc>
          release(&np->lock);
    80002b0e:	8526                	mv	a0,s1
    80002b10:	ffffe097          	auipc	ra,0xffffe
    80002b14:	174080e7          	jalr	372(ra) # 80000c84 <release>
          release(&wait_lock);
    80002b18:	0000f517          	auipc	a0,0xf
    80002b1c:	7b850513          	addi	a0,a0,1976 # 800122d0 <wait_lock>
    80002b20:	ffffe097          	auipc	ra,0xffffe
    80002b24:	164080e7          	jalr	356(ra) # 80000c84 <release>
          return pid;
    80002b28:	a0ad                	j	80002b92 <wait+0x136>
            release(&np->lock);
    80002b2a:	8526                	mv	a0,s1
    80002b2c:	ffffe097          	auipc	ra,0xffffe
    80002b30:	158080e7          	jalr	344(ra) # 80000c84 <release>
            release(&wait_lock);
    80002b34:	0000f517          	auipc	a0,0xf
    80002b38:	79c50513          	addi	a0,a0,1948 # 800122d0 <wait_lock>
    80002b3c:	ffffe097          	auipc	ra,0xffffe
    80002b40:	148080e7          	jalr	328(ra) # 80000c84 <release>
            return -1;
    80002b44:	5a7d                	li	s4,-1
    80002b46:	a0b1                	j	80002b92 <wait+0x136>
    for(np = proc; np < &proc[NPROC]; np++){
    80002b48:	94d2                	add	s1,s1,s4
    80002b4a:	03648763          	beq	s1,s6,80002b78 <wait+0x11c>
      if(np->parent == p){
    80002b4e:	01548933          	add	s2,s1,s5
    80002b52:	00093783          	ld	a5,0(s2)
    80002b56:	ff3799e3          	bne	a5,s3,80002b48 <wait+0xec>
        acquire(&np->lock);
    80002b5a:	8526                	mv	a0,s1
    80002b5c:	ffffe097          	auipc	ra,0xffffe
    80002b60:	06e080e7          	jalr	110(ra) # 80000bca <acquire>
        if(np->state == ZOMBIE){
    80002b64:	4c9c                	lw	a5,24(s1)
    80002b66:	f58787e3          	beq	a5,s8,80002ab4 <wait+0x58>
        release(&np->lock);
    80002b6a:	8526                	mv	a0,s1
    80002b6c:	ffffe097          	auipc	ra,0xffffe
    80002b70:	118080e7          	jalr	280(ra) # 80000c84 <release>
        havekids = 1;
    80002b74:	8766                	mv	a4,s9
    80002b76:	bfc9                	j	80002b48 <wait+0xec>
    if(!havekids || p->killed){
    80002b78:	c701                	beqz	a4,80002b80 <wait+0x124>
    80002b7a:	01c9a783          	lw	a5,28(s3)
    80002b7e:	cb85                	beqz	a5,80002bae <wait+0x152>
      release(&wait_lock);
    80002b80:	0000f517          	auipc	a0,0xf
    80002b84:	75050513          	addi	a0,a0,1872 # 800122d0 <wait_lock>
    80002b88:	ffffe097          	auipc	ra,0xffffe
    80002b8c:	0fc080e7          	jalr	252(ra) # 80000c84 <release>
      return -1;
    80002b90:	5a7d                	li	s4,-1
}
    80002b92:	8552                	mv	a0,s4
    80002b94:	60e6                	ld	ra,88(sp)
    80002b96:	6446                	ld	s0,80(sp)
    80002b98:	64a6                	ld	s1,72(sp)
    80002b9a:	6906                	ld	s2,64(sp)
    80002b9c:	79e2                	ld	s3,56(sp)
    80002b9e:	7a42                	ld	s4,48(sp)
    80002ba0:	7aa2                	ld	s5,40(sp)
    80002ba2:	7b02                	ld	s6,32(sp)
    80002ba4:	6be2                	ld	s7,24(sp)
    80002ba6:	6c42                	ld	s8,16(sp)
    80002ba8:	6ca2                	ld	s9,8(sp)
    80002baa:	6125                	addi	sp,sp,96
    80002bac:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002bae:	0000f597          	auipc	a1,0xf
    80002bb2:	72258593          	addi	a1,a1,1826 # 800122d0 <wait_lock>
    80002bb6:	854e                	mv	a0,s3
    80002bb8:	00000097          	auipc	ra,0x0
    80002bbc:	c9c080e7          	jalr	-868(ra) # 80002854 <sleep>
    havekids = 0;
    80002bc0:	b5dd                	j	80002aa6 <wait+0x4a>

0000000080002bc2 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002bc2:	711d                	addi	sp,sp,-96
    80002bc4:	ec86                	sd	ra,88(sp)
    80002bc6:	e8a2                	sd	s0,80(sp)
    80002bc8:	e4a6                	sd	s1,72(sp)
    80002bca:	e0ca                	sd	s2,64(sp)
    80002bcc:	fc4e                	sd	s3,56(sp)
    80002bce:	f852                	sd	s4,48(sp)
    80002bd0:	f456                	sd	s5,40(sp)
    80002bd2:	f05a                	sd	s6,32(sp)
    80002bd4:	ec5e                	sd	s7,24(sp)
    80002bd6:	e862                	sd	s8,16(sp)
    80002bd8:	e466                	sd	s9,8(sp)
    80002bda:	e06a                	sd	s10,0(sp)
    80002bdc:	1080                	addi	s0,sp,96
    80002bde:	8b2a                	mv	s6,a0
  struct proc *p;
  struct thread *tr;
  for(p = proc; p < &proc[NPROC]; p++) {
    80002be0:	00011997          	auipc	s3,0x11
    80002be4:	3e098993          	addi	s3,s3,992 # 80013fc0 <proc+0x898>
    80002be8:	00034c97          	auipc	s9,0x34
    80002bec:	1d8c8c93          	addi	s9,s9,472 # 80036dc0 <bcache+0x880>
    80002bf0:	7c7d                	lui	s8,0xfffff
    80002bf2:	768c0c13          	addi	s8,s8,1896 # fffffffffffff768 <end+0xffffffff7ffba768>
      acquire(&p->lock);
      for(tr = p->threads;tr < &p->threads[NTHREAD]; tr++) {
        acquire(&tr->lock);
        
        if(tr->state == TSLEEPING && tr->chan == chan) {
    80002bf6:	4a09                	li	s4,2
          tr->state = TRUNNABLE;
    80002bf8:	4d0d                	li	s10,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002bfa:	6b85                	lui	s7,0x1
    80002bfc:	8b8b8b93          	addi	s7,s7,-1864 # 8b8 <_entry-0x7ffff748>
    80002c00:	a091                	j	80002c44 <wakeup+0x82>
        }
        release(&tr->lock);
    80002c02:	854a                	mv	a0,s2
    80002c04:	ffffe097          	auipc	ra,0xffffe
    80002c08:	080080e7          	jalr	128(ra) # 80000c84 <release>
      for(tr = p->threads;tr < &p->threads[NTHREAD]; tr++) {
    80002c0c:	0c848493          	addi	s1,s1,200
    80002c10:	03348263          	beq	s1,s3,80002c34 <wakeup+0x72>
        acquire(&tr->lock);
    80002c14:	8926                	mv	s2,s1
    80002c16:	8526                	mv	a0,s1
    80002c18:	ffffe097          	auipc	ra,0xffffe
    80002c1c:	fb2080e7          	jalr	-78(ra) # 80000bca <acquire>
        if(tr->state == TSLEEPING && tr->chan == chan) {
    80002c20:	f744a783          	lw	a5,-140(s1)
    80002c24:	fd479fe3          	bne	a5,s4,80002c02 <wakeup+0x40>
    80002c28:	6c9c                	ld	a5,24(s1)
    80002c2a:	fd679ce3          	bne	a5,s6,80002c02 <wakeup+0x40>
          tr->state = TRUNNABLE;
    80002c2e:	f7a4aa23          	sw	s10,-140(s1)
    80002c32:	bfc1                	j	80002c02 <wakeup+0x40>
      }
      release(&p->lock);
    80002c34:	8556                	mv	a0,s5
    80002c36:	ffffe097          	auipc	ra,0xffffe
    80002c3a:	04e080e7          	jalr	78(ra) # 80000c84 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002c3e:	99de                	add	s3,s3,s7
    80002c40:	01998c63          	beq	s3,s9,80002c58 <wakeup+0x96>
      acquire(&p->lock);
    80002c44:	01898ab3          	add	s5,s3,s8
    80002c48:	8556                	mv	a0,s5
    80002c4a:	ffffe097          	auipc	ra,0xffffe
    80002c4e:	f80080e7          	jalr	-128(ra) # 80000bca <acquire>
      for(tr = p->threads;tr < &p->threads[NTHREAD]; tr++) {
    80002c52:	9c098493          	addi	s1,s3,-1600
    80002c56:	bf7d                	j	80002c14 <wakeup+0x52>
    }
}
    80002c58:	60e6                	ld	ra,88(sp)
    80002c5a:	6446                	ld	s0,80(sp)
    80002c5c:	64a6                	ld	s1,72(sp)
    80002c5e:	6906                	ld	s2,64(sp)
    80002c60:	79e2                	ld	s3,56(sp)
    80002c62:	7a42                	ld	s4,48(sp)
    80002c64:	7aa2                	ld	s5,40(sp)
    80002c66:	7b02                	ld	s6,32(sp)
    80002c68:	6be2                	ld	s7,24(sp)
    80002c6a:	6c42                	ld	s8,16(sp)
    80002c6c:	6ca2                	ld	s9,8(sp)
    80002c6e:	6d02                	ld	s10,0(sp)
    80002c70:	6125                	addi	sp,sp,96
    80002c72:	8082                	ret

0000000080002c74 <reparent>:
{
    80002c74:	7139                	addi	sp,sp,-64
    80002c76:	fc06                	sd	ra,56(sp)
    80002c78:	f822                	sd	s0,48(sp)
    80002c7a:	f426                	sd	s1,40(sp)
    80002c7c:	f04a                	sd	s2,32(sp)
    80002c7e:	ec4e                	sd	s3,24(sp)
    80002c80:	e852                	sd	s4,16(sp)
    80002c82:	e456                	sd	s5,8(sp)
    80002c84:	0080                	addi	s0,sp,64
    80002c86:	89aa                	mv	s3,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002c88:	00011497          	auipc	s1,0x11
    80002c8c:	2a848493          	addi	s1,s1,680 # 80013f30 <proc+0x808>
    80002c90:	00034a17          	auipc	s4,0x34
    80002c94:	0a0a0a13          	addi	s4,s4,160 # 80036d30 <bcache+0x7f0>
      pp->parent = initproc;
    80002c98:	00007a97          	auipc	s5,0x7
    80002c9c:	398a8a93          	addi	s5,s5,920 # 8000a030 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002ca0:	6905                	lui	s2,0x1
    80002ca2:	8b890913          	addi	s2,s2,-1864 # 8b8 <_entry-0x7ffff748>
    80002ca6:	a021                	j	80002cae <reparent+0x3a>
    80002ca8:	94ca                	add	s1,s1,s2
    80002caa:	01448d63          	beq	s1,s4,80002cc4 <reparent+0x50>
    if(pp->parent == p){
    80002cae:	609c                	ld	a5,0(s1)
    80002cb0:	ff379ce3          	bne	a5,s3,80002ca8 <reparent+0x34>
      pp->parent = initproc;
    80002cb4:	000ab503          	ld	a0,0(s5)
    80002cb8:	e088                	sd	a0,0(s1)
      wakeup(initproc);
    80002cba:	00000097          	auipc	ra,0x0
    80002cbe:	f08080e7          	jalr	-248(ra) # 80002bc2 <wakeup>
    80002cc2:	b7dd                	j	80002ca8 <reparent+0x34>
}
    80002cc4:	70e2                	ld	ra,56(sp)
    80002cc6:	7442                	ld	s0,48(sp)
    80002cc8:	74a2                	ld	s1,40(sp)
    80002cca:	7902                	ld	s2,32(sp)
    80002ccc:	69e2                	ld	s3,24(sp)
    80002cce:	6a42                	ld	s4,16(sp)
    80002cd0:	6aa2                	ld	s5,8(sp)
    80002cd2:	6121                	addi	sp,sp,64
    80002cd4:	8082                	ret

0000000080002cd6 <killOtherThreads>:
killOtherThreads(){
    80002cd6:	7139                	addi	sp,sp,-64
    80002cd8:	fc06                	sd	ra,56(sp)
    80002cda:	f822                	sd	s0,48(sp)
    80002cdc:	f426                	sd	s1,40(sp)
    80002cde:	f04a                	sd	s2,32(sp)
    80002ce0:	ec4e                	sd	s3,24(sp)
    80002ce2:	e852                	sd	s4,16(sp)
    80002ce4:	e456                	sd	s5,8(sp)
    80002ce6:	e05a                	sd	s6,0(sp)
    80002ce8:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80002cea:	fffff097          	auipc	ra,0xfffff
    80002cee:	d7c080e7          	jalr	-644(ra) # 80001a66 <myproc>
    80002cf2:	89aa                	mv	s3,a0
  struct thread* t = mythread();
    80002cf4:	fffff097          	auipc	ra,0xfffff
    80002cf8:	db2080e7          	jalr	-590(ra) # 80001aa6 <mythread>
    80002cfc:	892a                	mv	s2,a0
  if(t->killed) {
    80002cfe:	0c052783          	lw	a5,192(a0)
    80002d02:	eb89                	bnez	a5,80002d14 <killOtherThreads+0x3e>
    for(struct thread* tr = p->threads;tr < &p->threads[NTHREAD]; tr++) {
    80002d04:	25898493          	addi	s1,s3,600
    80002d08:	6a85                	lui	s5,0x1
    80002d0a:	898a8a93          	addi	s5,s5,-1896 # 898 <_entry-0x7ffff768>
    80002d0e:	9ace                	add	s5,s5,s3
        tr->killed = 1;
    80002d10:	4b05                	li	s6,1
    80002d12:	a0b9                	j	80002d60 <killOtherThreads+0x8a>
    wakeup(t);
    80002d14:	00000097          	auipc	ra,0x0
    80002d18:	eae080e7          	jalr	-338(ra) # 80002bc2 <wakeup>
    t->state = DYING;
    80002d1c:	4799                	li	a5,6
    80002d1e:	00f92223          	sw	a5,4(s2)
    acquire(&t->lock);
    80002d22:	09090513          	addi	a0,s2,144
    80002d26:	ffffe097          	auipc	ra,0xffffe
    80002d2a:	ea4080e7          	jalr	-348(ra) # 80000bca <acquire>
    sched();
    80002d2e:	00000097          	auipc	ra,0x0
    80002d32:	992080e7          	jalr	-1646(ra) # 800026c0 <sched>
    80002d36:	6485                	lui	s1,0x1
    80002d38:	80848493          	addi	s1,s1,-2040 # 808 <_entry-0x7ffff7f8>
    80002d3c:	94ce                	add	s1,s1,s3
    threadStillAlive = 0;
    80002d3e:	4a81                	li	s5,0
      if(tr->tid != t->tid && tr->state != TUNUSED && tr->state != DYING && tr->state != TZOMBIE){
    80002d40:	4a05                	li	s4,1
    for(struct thread* tr = p->threads;tr < &p->threads[NTHREAD]; tr++) {
    80002d42:	1c898793          	addi	a5,s3,456
      if(tr->tid != t->tid && tr->state != TUNUSED && tr->state != DYING && tr->state != TZOMBIE){
    80002d46:	00092683          	lw	a3,0(s2)
    threadStillAlive = 0;
    80002d4a:	8656                	mv	a2,s5
    80002d4c:	a82d                	j	80002d86 <killOtherThreads+0xb0>
      release(&tr->lock);
    80002d4e:	8552                	mv	a0,s4
    80002d50:	ffffe097          	auipc	ra,0xffffe
    80002d54:	f34080e7          	jalr	-204(ra) # 80000c84 <release>
    for(struct thread* tr = p->threads;tr < &p->threads[NTHREAD]; tr++) {
    80002d58:	0c848493          	addi	s1,s1,200
    80002d5c:	fd548de3          	beq	s1,s5,80002d36 <killOtherThreads+0x60>
      acquire(&tr->lock);
    80002d60:	8a26                	mv	s4,s1
    80002d62:	8526                	mv	a0,s1
    80002d64:	ffffe097          	auipc	ra,0xffffe
    80002d68:	e66080e7          	jalr	-410(ra) # 80000bca <acquire>
      if(tr->tid != t->tid){
    80002d6c:	f704a703          	lw	a4,-144(s1)
    80002d70:	00092783          	lw	a5,0(s2)
    80002d74:	fcf70de3          	beq	a4,a5,80002d4e <killOtherThreads+0x78>
        tr->killed = 1;
    80002d78:	0364a823          	sw	s6,48(s1)
    80002d7c:	bfc9                	j	80002d4e <killOtherThreads+0x78>
    for(struct thread* tr = p->threads;tr < &p->threads[NTHREAD]; tr++) {
    80002d7e:	0c878793          	addi	a5,a5,200 # 10c8 <_entry-0x7fffef38>
    80002d82:	00f48c63          	beq	s1,a5,80002d9a <killOtherThreads+0xc4>
      if(tr->tid != t->tid && tr->state != TUNUSED && tr->state != DYING && tr->state != TZOMBIE){
    80002d86:	4398                	lw	a4,0(a5)
    80002d88:	fed70be3          	beq	a4,a3,80002d7e <killOtherThreads+0xa8>
    80002d8c:	43d8                	lw	a4,4(a5)
    80002d8e:	db65                	beqz	a4,80002d7e <killOtherThreads+0xa8>
    80002d90:	376d                	addiw	a4,a4,-5
    80002d92:	feea76e3          	bgeu	s4,a4,80002d7e <killOtherThreads+0xa8>
        threadStillAlive = 1;
    80002d96:	8652                	mv	a2,s4
    80002d98:	b7dd                	j	80002d7e <killOtherThreads+0xa8>
    if(threadStillAlive){
    80002d9a:	ea19                	bnez	a2,80002db0 <killOtherThreads+0xda>
}
    80002d9c:	70e2                	ld	ra,56(sp)
    80002d9e:	7442                	ld	s0,48(sp)
    80002da0:	74a2                	ld	s1,40(sp)
    80002da2:	7902                	ld	s2,32(sp)
    80002da4:	69e2                	ld	s3,24(sp)
    80002da6:	6a42                	ld	s4,16(sp)
    80002da8:	6aa2                	ld	s5,8(sp)
    80002daa:	6b02                	ld	s6,0(sp)
    80002dac:	6121                	addi	sp,sp,64
    80002dae:	8082                	ret
      yield();
    80002db0:	00000097          	auipc	ra,0x0
    80002db4:	a0a080e7          	jalr	-1526(ra) # 800027ba <yield>
    threadStillAlive = 0;
    80002db8:	b769                	j	80002d42 <killOtherThreads+0x6c>

0000000080002dba <killCurThread>:
{
    80002dba:	1101                	addi	sp,sp,-32
    80002dbc:	ec06                	sd	ra,24(sp)
    80002dbe:	e822                	sd	s0,16(sp)
    80002dc0:	e426                	sd	s1,8(sp)
    80002dc2:	1000                	addi	s0,sp,32
  struct thread* t = mythread();
    80002dc4:	fffff097          	auipc	ra,0xfffff
    80002dc8:	ce2080e7          	jalr	-798(ra) # 80001aa6 <mythread>
    80002dcc:	84aa                	mv	s1,a0
  wakeup(t);
    80002dce:	00000097          	auipc	ra,0x0
    80002dd2:	df4080e7          	jalr	-524(ra) # 80002bc2 <wakeup>
  acquire(&t->lock);
    80002dd6:	09048513          	addi	a0,s1,144
    80002dda:	ffffe097          	auipc	ra,0xffffe
    80002dde:	df0080e7          	jalr	-528(ra) # 80000bca <acquire>
  t->state = DYING;
    80002de2:	4799                	li	a5,6
    80002de4:	c0dc                	sw	a5,4(s1)
  sched();
    80002de6:	00000097          	auipc	ra,0x0
    80002dea:	8da080e7          	jalr	-1830(ra) # 800026c0 <sched>
}
    80002dee:	60e2                	ld	ra,24(sp)
    80002df0:	6442                	ld	s0,16(sp)
    80002df2:	64a2                	ld	s1,8(sp)
    80002df4:	6105                	addi	sp,sp,32
    80002df6:	8082                	ret

0000000080002df8 <bsem_up>:
bsem_up(int descriptor) {
    80002df8:	7179                	addi	sp,sp,-48
    80002dfa:	f406                	sd	ra,40(sp)
    80002dfc:	f022                	sd	s0,32(sp)
    80002dfe:	ec26                	sd	s1,24(sp)
    80002e00:	e84a                	sd	s2,16(sp)
    80002e02:	e44e                	sd	s3,8(sp)
    80002e04:	1800                	addi	s0,sp,48
  acquire(&bsemaphores[descriptor].lock);
    80002e06:	00551993          	slli	s3,a0,0x5
    80002e0a:	00898913          	addi	s2,s3,8
    80002e0e:	00010497          	auipc	s1,0x10
    80002e12:	91a48493          	addi	s1,s1,-1766 # 80012728 <bsemaphores>
    80002e16:	9926                	add	s2,s2,s1
    80002e18:	854a                	mv	a0,s2
    80002e1a:	ffffe097          	auipc	ra,0xffffe
    80002e1e:	db0080e7          	jalr	-592(ra) # 80000bca <acquire>
  bsemaphores[descriptor].value = 1;
    80002e22:	94ce                	add	s1,s1,s3
    80002e24:	4785                	li	a5,1
    80002e26:	c09c                	sw	a5,0(s1)
  release(&bsemaphores[descriptor].lock);  
    80002e28:	854a                	mv	a0,s2
    80002e2a:	ffffe097          	auipc	ra,0xffffe
    80002e2e:	e5a080e7          	jalr	-422(ra) # 80000c84 <release>
  wakeup(&bsemaphores[descriptor]);
    80002e32:	8526                	mv	a0,s1
    80002e34:	00000097          	auipc	ra,0x0
    80002e38:	d8e080e7          	jalr	-626(ra) # 80002bc2 <wakeup>
}
    80002e3c:	70a2                	ld	ra,40(sp)
    80002e3e:	7402                	ld	s0,32(sp)
    80002e40:	64e2                	ld	s1,24(sp)
    80002e42:	6942                	ld	s2,16(sp)
    80002e44:	69a2                	ld	s3,8(sp)
    80002e46:	6145                	addi	sp,sp,48
    80002e48:	8082                	ret

0000000080002e4a <exit>:
{
    80002e4a:	7179                	addi	sp,sp,-48
    80002e4c:	f406                	sd	ra,40(sp)
    80002e4e:	f022                	sd	s0,32(sp)
    80002e50:	ec26                	sd	s1,24(sp)
    80002e52:	e84a                	sd	s2,16(sp)
    80002e54:	e44e                	sd	s3,8(sp)
    80002e56:	e052                	sd	s4,0(sp)
    80002e58:	1800                	addi	s0,sp,48
    80002e5a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002e5c:	fffff097          	auipc	ra,0xfffff
    80002e60:	c0a080e7          	jalr	-1014(ra) # 80001a66 <myproc>
    80002e64:	89aa                	mv	s3,a0
  killOtherThreads();
    80002e66:	00000097          	auipc	ra,0x0
    80002e6a:	e70080e7          	jalr	-400(ra) # 80002cd6 <killOtherThreads>
  if(p == initproc)
    80002e6e:	00007797          	auipc	a5,0x7
    80002e72:	1c27b783          	ld	a5,450(a5) # 8000a030 <initproc>
    80002e76:	01378a63          	beq	a5,s3,80002e8a <exit+0x40>
    80002e7a:	6905                	lui	s2,0x1
    80002e7c:	82090493          	addi	s1,s2,-2016 # 820 <_entry-0x7ffff7e0>
    80002e80:	94ce                	add	s1,s1,s3
    80002e82:	8a090913          	addi	s2,s2,-1888
    80002e86:	994e                	add	s2,s2,s3
    80002e88:	a015                	j	80002eac <exit+0x62>
    panic("init exiting");
    80002e8a:	00006517          	auipc	a0,0x6
    80002e8e:	3de50513          	addi	a0,a0,990 # 80009268 <digits+0x228>
    80002e92:	ffffd097          	auipc	ra,0xffffd
    80002e96:	698080e7          	jalr	1688(ra) # 8000052a <panic>
      fileclose(f);
    80002e9a:	00002097          	auipc	ra,0x2
    80002e9e:	7c6080e7          	jalr	1990(ra) # 80005660 <fileclose>
      p->ofile[fd] = 0;
    80002ea2:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002ea6:	04a1                	addi	s1,s1,8
    80002ea8:	01248563          	beq	s1,s2,80002eb2 <exit+0x68>
    if(p->ofile[fd]){
    80002eac:	6088                	ld	a0,0(s1)
    80002eae:	f575                	bnez	a0,80002e9a <exit+0x50>
    80002eb0:	bfdd                	j	80002ea6 <exit+0x5c>
  begin_op();
    80002eb2:	00002097          	auipc	ra,0x2
    80002eb6:	2e2080e7          	jalr	738(ra) # 80005194 <begin_op>
  iput(p->cwd);
    80002eba:	6485                	lui	s1,0x1
    80002ebc:	94ce                	add	s1,s1,s3
    80002ebe:	8a04b503          	ld	a0,-1888(s1) # 8a0 <_entry-0x7ffff760>
    80002ec2:	00002097          	auipc	ra,0x2
    80002ec6:	ab2080e7          	jalr	-1358(ra) # 80004974 <iput>
  end_op();
    80002eca:	00002097          	auipc	ra,0x2
    80002ece:	34a080e7          	jalr	842(ra) # 80005214 <end_op>
  p->cwd = 0;
    80002ed2:	8a04b023          	sd	zero,-1888(s1)
  acquire(&wait_lock);
    80002ed6:	0000f917          	auipc	s2,0xf
    80002eda:	3fa90913          	addi	s2,s2,1018 # 800122d0 <wait_lock>
    80002ede:	854a                	mv	a0,s2
    80002ee0:	ffffe097          	auipc	ra,0xffffe
    80002ee4:	cea080e7          	jalr	-790(ra) # 80000bca <acquire>
  reparent(p);
    80002ee8:	854e                	mv	a0,s3
    80002eea:	00000097          	auipc	ra,0x0
    80002eee:	d8a080e7          	jalr	-630(ra) # 80002c74 <reparent>
  wakeup(p->parent);
    80002ef2:	8084b503          	ld	a0,-2040(s1)
    80002ef6:	00000097          	auipc	ra,0x0
    80002efa:	ccc080e7          	jalr	-820(ra) # 80002bc2 <wakeup>
  acquire(&p->lock);
    80002efe:	854e                	mv	a0,s3
    80002f00:	ffffe097          	auipc	ra,0xffffe
    80002f04:	cca080e7          	jalr	-822(ra) # 80000bca <acquire>
  p->xstate = status;
    80002f08:	0349a023          	sw	s4,32(s3)
  acquire(&mythread()->lock);
    80002f0c:	fffff097          	auipc	ra,0xfffff
    80002f10:	b9a080e7          	jalr	-1126(ra) # 80001aa6 <mythread>
    80002f14:	09050513          	addi	a0,a0,144
    80002f18:	ffffe097          	auipc	ra,0xffffe
    80002f1c:	cb2080e7          	jalr	-846(ra) # 80000bca <acquire>
  mythread()->state = DYING;
    80002f20:	fffff097          	auipc	ra,0xfffff
    80002f24:	b86080e7          	jalr	-1146(ra) # 80001aa6 <mythread>
    80002f28:	4799                	li	a5,6
    80002f2a:	c15c                	sw	a5,4(a0)
  p->state = ZOMBIE;
    80002f2c:	4789                	li	a5,2
    80002f2e:	00f9ac23          	sw	a5,24(s3)
  release(&p->lock);
    80002f32:	854e                	mv	a0,s3
    80002f34:	ffffe097          	auipc	ra,0xffffe
    80002f38:	d50080e7          	jalr	-688(ra) # 80000c84 <release>
  release(&wait_lock);
    80002f3c:	854a                	mv	a0,s2
    80002f3e:	ffffe097          	auipc	ra,0xffffe
    80002f42:	d46080e7          	jalr	-698(ra) # 80000c84 <release>
  sched();
    80002f46:	fffff097          	auipc	ra,0xfffff
    80002f4a:	77a080e7          	jalr	1914(ra) # 800026c0 <sched>
  panic("zombie exit");
    80002f4e:	00006517          	auipc	a0,0x6
    80002f52:	32a50513          	addi	a0,a0,810 # 80009278 <digits+0x238>
    80002f56:	ffffd097          	auipc	ra,0xffffd
    80002f5a:	5d4080e7          	jalr	1492(ra) # 8000052a <panic>

0000000080002f5e <kthread_exit>:
kthread_exit(int status){
    80002f5e:	7179                	addi	sp,sp,-48
    80002f60:	f406                	sd	ra,40(sp)
    80002f62:	f022                	sd	s0,32(sp)
    80002f64:	ec26                	sd	s1,24(sp)
    80002f66:	e84a                	sd	s2,16(sp)
    80002f68:	e44e                	sd	s3,8(sp)
    80002f6a:	e052                	sd	s4,0(sp)
    80002f6c:	1800                	addi	s0,sp,48
    80002f6e:	89aa                	mv	s3,a0
  struct thread* t = mythread();
    80002f70:	fffff097          	auipc	ra,0xfffff
    80002f74:	b36080e7          	jalr	-1226(ra) # 80001aa6 <mythread>
    80002f78:	892a                	mv	s2,a0
  struct proc* p = myproc();
    80002f7a:	fffff097          	auipc	ra,0xfffff
    80002f7e:	aec080e7          	jalr	-1300(ra) # 80001a66 <myproc>
    80002f82:	84aa                	mv	s1,a0
  acquire(&t->lock);
    80002f84:	09090a13          	addi	s4,s2,144
    80002f88:	8552                	mv	a0,s4
    80002f8a:	ffffe097          	auipc	ra,0xffffe
    80002f8e:	c40080e7          	jalr	-960(ra) # 80000bca <acquire>
    for(struct thread* tr = p->threads;tr < &p->threads[NTHREAD]; tr++) {
    80002f92:	1c848793          	addi	a5,s1,456
      if(tr->tid != t->tid && tr->state != TUNUSED && tr->state != DYING && tr->state != TZOMBIE){
    80002f96:	00092603          	lw	a2,0(s2)
    80002f9a:	6685                	lui	a3,0x1
    80002f9c:	80868693          	addi	a3,a3,-2040 # 808 <_entry-0x7ffff7f8>
    80002fa0:	96a6                	add	a3,a3,s1
    80002fa2:	4585                	li	a1,1
    80002fa4:	a029                	j	80002fae <kthread_exit+0x50>
    for(struct thread* tr = p->threads;tr < &p->threads[NTHREAD]; tr++) {
    80002fa6:	0c878793          	addi	a5,a5,200
    80002faa:	04d78a63          	beq	a5,a3,80002ffe <kthread_exit+0xa0>
      if(tr->tid != t->tid && tr->state != TUNUSED && tr->state != DYING && tr->state != TZOMBIE){
    80002fae:	4398                	lw	a4,0(a5)
    80002fb0:	fec70be3          	beq	a4,a2,80002fa6 <kthread_exit+0x48>
    80002fb4:	43d8                	lw	a4,4(a5)
    80002fb6:	db65                	beqz	a4,80002fa6 <kthread_exit+0x48>
    80002fb8:	376d                	addiw	a4,a4,-5
    80002fba:	fee5f6e3          	bgeu	a1,a4,80002fa6 <kthread_exit+0x48>
    t->xstate = status;
    80002fbe:	0b392823          	sw	s3,176(s2)
      t->state = TZOMBIE;
    80002fc2:	4795                	li	a5,5
    80002fc4:	00f92223          	sw	a5,4(s2)
      release(&t->lock);
    80002fc8:	8552                	mv	a0,s4
    80002fca:	ffffe097          	auipc	ra,0xffffe
    80002fce:	cba080e7          	jalr	-838(ra) # 80000c84 <release>
      wakeup(t);
    80002fd2:	854a                	mv	a0,s2
    80002fd4:	00000097          	auipc	ra,0x0
    80002fd8:	bee080e7          	jalr	-1042(ra) # 80002bc2 <wakeup>
      acquire(&t->lock);
    80002fdc:	8552                	mv	a0,s4
    80002fde:	ffffe097          	auipc	ra,0xffffe
    80002fe2:	bec080e7          	jalr	-1044(ra) # 80000bca <acquire>
      sched();
    80002fe6:	fffff097          	auipc	ra,0xfffff
    80002fea:	6da080e7          	jalr	1754(ra) # 800026c0 <sched>
}
    80002fee:	70a2                	ld	ra,40(sp)
    80002ff0:	7402                	ld	s0,32(sp)
    80002ff2:	64e2                	ld	s1,24(sp)
    80002ff4:	6942                	ld	s2,16(sp)
    80002ff6:	69a2                	ld	s3,8(sp)
    80002ff8:	6a02                	ld	s4,0(sp)
    80002ffa:	6145                	addi	sp,sp,48
    80002ffc:	8082                	ret
    t->xstate = status;
    80002ffe:	0b392823          	sw	s3,176(s2)
      release(&t->lock);
    80003002:	8552                	mv	a0,s4
    80003004:	ffffe097          	auipc	ra,0xffffe
    80003008:	c80080e7          	jalr	-896(ra) # 80000c84 <release>
      exit(status);
    8000300c:	854e                	mv	a0,s3
    8000300e:	00000097          	auipc	ra,0x0
    80003012:	e3c080e7          	jalr	-452(ra) # 80002e4a <exit>

0000000080003016 <kill>:

int
kill(int pid, int signum)
{
  if (signum < 0 || signum > 31)
    80003016:	47fd                	li	a5,31
    80003018:	0eb7e263          	bltu	a5,a1,800030fc <kill+0xe6>
{
    8000301c:	7139                	addi	sp,sp,-64
    8000301e:	fc06                	sd	ra,56(sp)
    80003020:	f822                	sd	s0,48(sp)
    80003022:	f426                	sd	s1,40(sp)
    80003024:	f04a                	sd	s2,32(sp)
    80003026:	ec4e                	sd	s3,24(sp)
    80003028:	e852                	sd	s4,16(sp)
    8000302a:	e456                	sd	s5,8(sp)
    8000302c:	e05a                	sd	s6,0(sp)
    8000302e:	0080                	addi	s0,sp,64
    80003030:	892a                	mv	s2,a0
    80003032:	8b2e                	mv	s6,a1
    return -1;
  }
  struct proc *p;
  struct thread *t;

  for(p = proc; p < &proc[NPROC]; p++){
    80003034:	00010497          	auipc	s1,0x10
    80003038:	6f448493          	addi	s1,s1,1780 # 80013728 <proc>
    8000303c:	6a05                	lui	s4,0x1
    8000303e:	8b8a0a13          	addi	s4,s4,-1864 # 8b8 <_entry-0x7ffff748>
    80003042:	00033a97          	auipc	s5,0x33
    80003046:	4e6a8a93          	addi	s5,s5,1254 # 80036528 <tickslock>
    acquire(&p->lock);
    8000304a:	89a6                	mv	s3,s1
    8000304c:	8526                	mv	a0,s1
    8000304e:	ffffe097          	auipc	ra,0xffffe
    80003052:	b7c080e7          	jalr	-1156(ra) # 80000bca <acquire>
    if(p->pid == pid){
    80003056:	50dc                	lw	a5,36(s1)
    80003058:	01278c63          	beq	a5,s2,80003070 <kill+0x5a>
        }
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000305c:	8526                	mv	a0,s1
    8000305e:	ffffe097          	auipc	ra,0xffffe
    80003062:	c26080e7          	jalr	-986(ra) # 80000c84 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80003066:	94d2                	add	s1,s1,s4
    80003068:	ff5491e3          	bne	s1,s5,8000304a <kill+0x34>
  }
  return -1;
    8000306c:	557d                	li	a0,-1
    8000306e:	a805                	j	8000309e <kill+0x88>
      p->pendingSignals = p->pendingSignals | (1 << signum);
    80003070:	4705                	li	a4,1
    80003072:	0167173b          	sllw	a4,a4,s6
    80003076:	549c                	lw	a5,40(s1)
    80003078:	8fd9                	or	a5,a5,a4
    8000307a:	d49c                	sw	a5,40(s1)
      if(signum == SIGKILL || (p->signalHandlers[signum] == (void*)SIGKILL && ((p->signalMask & (1 << signum)) == 0))) {
    8000307c:	47a5                	li	a5,9
    8000307e:	02fb0e63          	beq	s6,a5,800030ba <kill+0xa4>
    80003082:	006b0793          	addi	a5,s6,6
    80003086:	078e                	slli	a5,a5,0x3
    80003088:	97a6                	add	a5,a5,s1
    8000308a:	6394                	ld	a3,0(a5)
    8000308c:	47a5                	li	a5,9
    8000308e:	02f68263          	beq	a3,a5,800030b2 <kill+0x9c>
      release(&p->lock);
    80003092:	8526                	mv	a0,s1
    80003094:	ffffe097          	auipc	ra,0xffffe
    80003098:	bf0080e7          	jalr	-1040(ra) # 80000c84 <release>
      return 0;
    8000309c:	4501                	li	a0,0
}
    8000309e:	70e2                	ld	ra,56(sp)
    800030a0:	7442                	ld	s0,48(sp)
    800030a2:	74a2                	ld	s1,40(sp)
    800030a4:	7902                	ld	s2,32(sp)
    800030a6:	69e2                	ld	s3,24(sp)
    800030a8:	6a42                	ld	s4,16(sp)
    800030aa:	6aa2                	ld	s5,8(sp)
    800030ac:	6b02                	ld	s6,0(sp)
    800030ae:	6121                	addi	sp,sp,64
    800030b0:	8082                	ret
      if(signum == SIGKILL || (p->signalHandlers[signum] == (void*)SIGKILL && ((p->signalMask & (1 << signum)) == 0))) {
    800030b2:	54dc                	lw	a5,44(s1)
    800030b4:	8ff9                	and	a5,a5,a4
    800030b6:	2781                	sext.w	a5,a5
    800030b8:	ffe9                	bnez	a5,80003092 <kill+0x7c>
        p->killed = 1;
    800030ba:	4785                	li	a5,1
    800030bc:	ccdc                	sw	a5,28(s1)
      for(t = p->threads; t < &p->threads[NTHREAD]; t++){
    800030be:	25848913          	addi	s2,s1,600
    800030c2:	6785                	lui	a5,0x1
    800030c4:	89878793          	addi	a5,a5,-1896 # 898 <_entry-0x7ffff768>
    800030c8:	99be                	add	s3,s3,a5
        if(t->state == TSLEEPING){
    800030ca:	4a89                	li	s5,2
          t->state = TRUNNABLE;
    800030cc:	4b0d                	li	s6,3
    800030ce:	a811                	j	800030e2 <kill+0xcc>
        release(&t->lock);
    800030d0:	8552                	mv	a0,s4
    800030d2:	ffffe097          	auipc	ra,0xffffe
    800030d6:	bb2080e7          	jalr	-1102(ra) # 80000c84 <release>
      for(t = p->threads; t < &p->threads[NTHREAD]; t++){
    800030da:	0c890913          	addi	s2,s2,200
    800030de:	fb390ae3          	beq	s2,s3,80003092 <kill+0x7c>
        acquire(&t->lock);
    800030e2:	8a4a                	mv	s4,s2
    800030e4:	854a                	mv	a0,s2
    800030e6:	ffffe097          	auipc	ra,0xffffe
    800030ea:	ae4080e7          	jalr	-1308(ra) # 80000bca <acquire>
        if(t->state == TSLEEPING){
    800030ee:	f7492783          	lw	a5,-140(s2)
    800030f2:	fd579fe3          	bne	a5,s5,800030d0 <kill+0xba>
          t->state = TRUNNABLE;
    800030f6:	f7692a23          	sw	s6,-140(s2)
    800030fa:	bfd9                	j	800030d0 <kill+0xba>
    return -1;
    800030fc:	557d                	li	a0,-1
}
    800030fe:	8082                	ret

0000000080003100 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80003100:	7179                	addi	sp,sp,-48
    80003102:	f406                	sd	ra,40(sp)
    80003104:	f022                	sd	s0,32(sp)
    80003106:	ec26                	sd	s1,24(sp)
    80003108:	e84a                	sd	s2,16(sp)
    8000310a:	e44e                	sd	s3,8(sp)
    8000310c:	e052                	sd	s4,0(sp)
    8000310e:	1800                	addi	s0,sp,48
    80003110:	84aa                	mv	s1,a0
    80003112:	892e                	mv	s2,a1
    80003114:	89b2                	mv	s3,a2
    80003116:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80003118:	fffff097          	auipc	ra,0xfffff
    8000311c:	94e080e7          	jalr	-1714(ra) # 80001a66 <myproc>
  if(user_dst){
    80003120:	c485                	beqz	s1,80003148 <either_copyout+0x48>
    return copyout(p->pagetable, dst, src, len);
    80003122:	6785                	lui	a5,0x1
    80003124:	953e                	add	a0,a0,a5
    80003126:	86d2                	mv	a3,s4
    80003128:	864e                	mv	a2,s3
    8000312a:	85ca                	mv	a1,s2
    8000312c:	81853503          	ld	a0,-2024(a0)
    80003130:	ffffe097          	auipc	ra,0xffffe
    80003134:	51c080e7          	jalr	1308(ra) # 8000164c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80003138:	70a2                	ld	ra,40(sp)
    8000313a:	7402                	ld	s0,32(sp)
    8000313c:	64e2                	ld	s1,24(sp)
    8000313e:	6942                	ld	s2,16(sp)
    80003140:	69a2                	ld	s3,8(sp)
    80003142:	6a02                	ld	s4,0(sp)
    80003144:	6145                	addi	sp,sp,48
    80003146:	8082                	ret
    memmove((char *)dst, src, len);
    80003148:	000a061b          	sext.w	a2,s4
    8000314c:	85ce                	mv	a1,s3
    8000314e:	854a                	mv	a0,s2
    80003150:	ffffe097          	auipc	ra,0xffffe
    80003154:	bd8080e7          	jalr	-1064(ra) # 80000d28 <memmove>
    return 0;
    80003158:	8526                	mv	a0,s1
    8000315a:	bff9                	j	80003138 <either_copyout+0x38>

000000008000315c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000315c:	7179                	addi	sp,sp,-48
    8000315e:	f406                	sd	ra,40(sp)
    80003160:	f022                	sd	s0,32(sp)
    80003162:	ec26                	sd	s1,24(sp)
    80003164:	e84a                	sd	s2,16(sp)
    80003166:	e44e                	sd	s3,8(sp)
    80003168:	e052                	sd	s4,0(sp)
    8000316a:	1800                	addi	s0,sp,48
    8000316c:	892a                	mv	s2,a0
    8000316e:	84ae                	mv	s1,a1
    80003170:	89b2                	mv	s3,a2
    80003172:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80003174:	fffff097          	auipc	ra,0xfffff
    80003178:	8f2080e7          	jalr	-1806(ra) # 80001a66 <myproc>
  if(user_src){
    8000317c:	c485                	beqz	s1,800031a4 <either_copyin+0x48>
    return copyin(p->pagetable, dst, src, len);
    8000317e:	6785                	lui	a5,0x1
    80003180:	97aa                	add	a5,a5,a0
    80003182:	86d2                	mv	a3,s4
    80003184:	864e                	mv	a2,s3
    80003186:	85ca                	mv	a1,s2
    80003188:	8187b503          	ld	a0,-2024(a5) # 818 <_entry-0x7ffff7e8>
    8000318c:	ffffe097          	auipc	ra,0xffffe
    80003190:	54c080e7          	jalr	1356(ra) # 800016d8 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80003194:	70a2                	ld	ra,40(sp)
    80003196:	7402                	ld	s0,32(sp)
    80003198:	64e2                	ld	s1,24(sp)
    8000319a:	6942                	ld	s2,16(sp)
    8000319c:	69a2                	ld	s3,8(sp)
    8000319e:	6a02                	ld	s4,0(sp)
    800031a0:	6145                	addi	sp,sp,48
    800031a2:	8082                	ret
    memmove(dst, (char*)src, len);
    800031a4:	000a061b          	sext.w	a2,s4
    800031a8:	85ce                	mv	a1,s3
    800031aa:	854a                	mv	a0,s2
    800031ac:	ffffe097          	auipc	ra,0xffffe
    800031b0:	b7c080e7          	jalr	-1156(ra) # 80000d28 <memmove>
    return 0;
    800031b4:	8526                	mv	a0,s1
    800031b6:	bff9                	j	80003194 <either_copyin+0x38>

00000000800031b8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800031b8:	715d                	addi	sp,sp,-80
    800031ba:	e486                	sd	ra,72(sp)
    800031bc:	e0a2                	sd	s0,64(sp)
    800031be:	fc26                	sd	s1,56(sp)
    800031c0:	f84a                	sd	s2,48(sp)
    800031c2:	f44e                	sd	s3,40(sp)
    800031c4:	f052                	sd	s4,32(sp)
    800031c6:	ec56                	sd	s5,24(sp)
    800031c8:	e85a                	sd	s6,16(sp)
    800031ca:	e45e                	sd	s7,8(sp)
    800031cc:	e062                	sd	s8,0(sp)
    800031ce:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800031d0:	00006517          	auipc	a0,0x6
    800031d4:	23850513          	addi	a0,a0,568 # 80009408 <states.0+0x150>
    800031d8:	ffffd097          	auipc	ra,0xffffd
    800031dc:	39c080e7          	jalr	924(ra) # 80000574 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800031e0:	00010497          	auipc	s1,0x10
    800031e4:	54848493          	addi	s1,s1,1352 # 80013728 <proc>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800031e8:	4b89                	li	s7,2
      state = states[p->state];
    else
      state = "???";
    800031ea:	00006a17          	auipc	s4,0x6
    800031ee:	09ea0a13          	addi	s4,s4,158 # 80009288 <digits+0x248>
    printf("%d %s %s", p->pid, state, p->name);
    800031f2:	6905                	lui	s2,0x1
    800031f4:	8a890b13          	addi	s6,s2,-1880 # 8a8 <_entry-0x7ffff758>
    800031f8:	00006a97          	auipc	s5,0x6
    800031fc:	098a8a93          	addi	s5,s5,152 # 80009290 <digits+0x250>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80003200:	00006c17          	auipc	s8,0x6
    80003204:	0b8c0c13          	addi	s8,s8,184 # 800092b8 <states.0>
  for(p = proc; p < &proc[NPROC]; p++){
    80003208:	8b890913          	addi	s2,s2,-1864
    8000320c:	00033997          	auipc	s3,0x33
    80003210:	31c98993          	addi	s3,s3,796 # 80036528 <tickslock>
    80003214:	a025                	j	8000323c <procdump+0x84>
    printf("%d %s %s", p->pid, state, p->name);
    80003216:	016486b3          	add	a3,s1,s6
    8000321a:	50cc                	lw	a1,36(s1)
    8000321c:	8556                	mv	a0,s5
    8000321e:	ffffd097          	auipc	ra,0xffffd
    80003222:	356080e7          	jalr	854(ra) # 80000574 <printf>
    printf("\n");
    80003226:	00006517          	auipc	a0,0x6
    8000322a:	1e250513          	addi	a0,a0,482 # 80009408 <states.0+0x150>
    8000322e:	ffffd097          	auipc	ra,0xffffd
    80003232:	346080e7          	jalr	838(ra) # 80000574 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80003236:	94ca                	add	s1,s1,s2
    80003238:	03348063          	beq	s1,s3,80003258 <procdump+0xa0>
    if(p->state == UNUSED)
    8000323c:	4c9c                	lw	a5,24(s1)
    8000323e:	dfe5                	beqz	a5,80003236 <procdump+0x7e>
      state = "???";
    80003240:	8652                	mv	a2,s4
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80003242:	fcfbeae3          	bltu	s7,a5,80003216 <procdump+0x5e>
    80003246:	02079713          	slli	a4,a5,0x20
    8000324a:	01d75793          	srli	a5,a4,0x1d
    8000324e:	97e2                	add	a5,a5,s8
    80003250:	6390                	ld	a2,0(a5)
    80003252:	f271                	bnez	a2,80003216 <procdump+0x5e>
      state = "???";
    80003254:	8652                	mv	a2,s4
    80003256:	b7c1                	j	80003216 <procdump+0x5e>
  }
}
    80003258:	60a6                	ld	ra,72(sp)
    8000325a:	6406                	ld	s0,64(sp)
    8000325c:	74e2                	ld	s1,56(sp)
    8000325e:	7942                	ld	s2,48(sp)
    80003260:	79a2                	ld	s3,40(sp)
    80003262:	7a02                	ld	s4,32(sp)
    80003264:	6ae2                	ld	s5,24(sp)
    80003266:	6b42                	ld	s6,16(sp)
    80003268:	6ba2                	ld	s7,8(sp)
    8000326a:	6c02                	ld	s8,0(sp)
    8000326c:	6161                	addi	sp,sp,80
    8000326e:	8082                	ret

0000000080003270 <swtch>:
    80003270:	00153023          	sd	ra,0(a0)
    80003274:	00253423          	sd	sp,8(a0)
    80003278:	e900                	sd	s0,16(a0)
    8000327a:	ed04                	sd	s1,24(a0)
    8000327c:	03253023          	sd	s2,32(a0)
    80003280:	03353423          	sd	s3,40(a0)
    80003284:	03453823          	sd	s4,48(a0)
    80003288:	03553c23          	sd	s5,56(a0)
    8000328c:	05653023          	sd	s6,64(a0)
    80003290:	05753423          	sd	s7,72(a0)
    80003294:	05853823          	sd	s8,80(a0)
    80003298:	05953c23          	sd	s9,88(a0)
    8000329c:	07a53023          	sd	s10,96(a0)
    800032a0:	07b53423          	sd	s11,104(a0)
    800032a4:	0005b083          	ld	ra,0(a1)
    800032a8:	0085b103          	ld	sp,8(a1)
    800032ac:	6980                	ld	s0,16(a1)
    800032ae:	6d84                	ld	s1,24(a1)
    800032b0:	0205b903          	ld	s2,32(a1)
    800032b4:	0285b983          	ld	s3,40(a1)
    800032b8:	0305ba03          	ld	s4,48(a1)
    800032bc:	0385ba83          	ld	s5,56(a1)
    800032c0:	0405bb03          	ld	s6,64(a1)
    800032c4:	0485bb83          	ld	s7,72(a1)
    800032c8:	0505bc03          	ld	s8,80(a1)
    800032cc:	0585bc83          	ld	s9,88(a1)
    800032d0:	0605bd03          	ld	s10,96(a1)
    800032d4:	0685bd83          	ld	s11,104(a1)
    800032d8:	8082                	ret

00000000800032da <sigret_start>:
    800032da:	48e1                	li	a7,24
    800032dc:	00000073          	ecall
    800032e0:	8082                	ret

00000000800032e2 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800032e2:	1141                	addi	sp,sp,-16
    800032e4:	e406                	sd	ra,8(sp)
    800032e6:	e022                	sd	s0,0(sp)
    800032e8:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800032ea:	00006597          	auipc	a1,0x6
    800032ee:	fe658593          	addi	a1,a1,-26 # 800092d0 <states.0+0x18>
    800032f2:	00033517          	auipc	a0,0x33
    800032f6:	23650513          	addi	a0,a0,566 # 80036528 <tickslock>
    800032fa:	ffffe097          	auipc	ra,0xffffe
    800032fe:	838080e7          	jalr	-1992(ra) # 80000b32 <initlock>
}
    80003302:	60a2                	ld	ra,8(sp)
    80003304:	6402                	ld	s0,0(sp)
    80003306:	0141                	addi	sp,sp,16
    80003308:	8082                	ret

000000008000330a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000330a:	1141                	addi	sp,sp,-16
    8000330c:	e422                	sd	s0,8(sp)
    8000330e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003310:	00004797          	auipc	a5,0x4
    80003314:	a0078793          	addi	a5,a5,-1536 # 80006d10 <kernelvec>
    80003318:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000331c:	6422                	ld	s0,8(sp)
    8000331e:	0141                	addi	sp,sp,16
    80003320:	8082                	ret

0000000080003322 <handle_signals>:


  usertrapret();
}

void handle_signals(struct proc* p, struct thread* t){
    80003322:	7175                	addi	sp,sp,-144
    80003324:	e506                	sd	ra,136(sp)
    80003326:	e122                	sd	s0,128(sp)
    80003328:	fca6                	sd	s1,120(sp)
    8000332a:	f8ca                	sd	s2,112(sp)
    8000332c:	f4ce                	sd	s3,104(sp)
    8000332e:	f0d2                	sd	s4,96(sp)
    80003330:	ecd6                	sd	s5,88(sp)
    80003332:	e8da                	sd	s6,80(sp)
    80003334:	e4de                	sd	s7,72(sp)
    80003336:	e0e2                	sd	s8,64(sp)
    80003338:	fc66                	sd	s9,56(sp)
    8000333a:	f86a                	sd	s10,48(sp)
    8000333c:	f46e                	sd	s11,40(sp)
    8000333e:	0900                	addi	s0,sp,144
    80003340:	8a2a                	mv	s4,a0
    80003342:	8c2e                	mv	s8,a1
    acquire(&t->lock);
    80003344:	09058793          	addi	a5,a1,144
    80003348:	f6f43823          	sd	a5,-144(s0)
    8000334c:	853e                	mv	a0,a5
    8000334e:	ffffe097          	auipc	ra,0xffffe
    80003352:	87c080e7          	jalr	-1924(ra) # 80000bca <acquire>
    for(int i = 0; i < 32; i++){
    80003356:	130a0a93          	addi	s5,s4,304
    8000335a:	030a0993          	addi	s3,s4,48
    acquire(&t->lock);
    8000335e:	4905                	li	s2,1
    80003360:	4481                	li	s1,0
    for(int i = 0; i < 32; i++){
    80003362:	4bfd                	li	s7,31
    if((1 & (p->pendingSignals >> i)) && (!(1 & (p->signalMask >> i)))){
      if(p->signalHandlers[i] != (void*)SIG_IGN){
    80003364:	4c85                	li	s9,1
        p->oldSignalMask = p->signalMask;
        p->signalMask = p->signalHandlersMasks[i];
        p->handlesUserSignalHandler = 1;
        t->trapframe->sp -= sizeof(struct trapframe);
        t->userTrapFrameBackup = (struct trapframe*) t->trapframe->sp;
        copyout(p->pagetable, (uint64)t->userTrapFrameBackup, (char*)t->trapframe, sizeof(struct trapframe));
    80003366:	6d05                	lui	s10,0x1
    80003368:	9d52                	add	s10,s10,s4
        uint64 sigret_length = (uint64)&sigret_end - (uint64)&sigret_start;
    8000336a:	00000797          	auipc	a5,0x0
    8000336e:	f7878793          	addi	a5,a5,-136 # 800032e2 <trapinit>
    80003372:	00000d97          	auipc	s11,0x0
    80003376:	f68d8d93          	addi	s11,s11,-152 # 800032da <sigret_start>
        t->trapframe->sp -= sigret_length;
    8000337a:	40fd8733          	sub	a4,s11,a5
    8000337e:	f8e43023          	sd	a4,-128(s0)
        uint64 sigret_length = (uint64)&sigret_end - (uint64)&sigret_start;
    80003382:	41b787b3          	sub	a5,a5,s11
    80003386:	f6f43c23          	sd	a5,-136(s0)
    8000338a:	a03d                	j	800033b8 <handle_signals+0x96>
        if(i == SIGKILL)
    8000338c:	4725                	li	a4,9
    8000338e:	0eeb0e63          	beq	s6,a4,8000348a <handle_signals+0x168>
        else if(i == SIGSTOP)
    80003392:	4745                	li	a4,17
    80003394:	10eb0163          	beq	s6,a4,80003496 <handle_signals+0x174>
        else if(i == SIGCONT)
    80003398:	474d                	li	a4,19
    8000339a:	10eb0463          	beq	s6,a4,800034a2 <handle_signals+0x180>
          SIGKILL_handler(p);
    8000339e:	8552                	mv	a0,s4
    800033a0:	fffff097          	auipc	ra,0xfffff
    800033a4:	044080e7          	jalr	68(ra) # 800023e4 <SIGKILL_handler>
    for(int i = 0; i < 32; i++){
    800033a8:	0009079b          	sext.w	a5,s2
    800033ac:	12fbc363          	blt	s7,a5,800034d2 <handle_signals+0x1b0>
    800033b0:	0485                	addi	s1,s1,1
    800033b2:	2905                	addiw	s2,s2,1
    800033b4:	0a91                	addi	s5,s5,4
    800033b6:	09a1                	addi	s3,s3,8
    800033b8:	00048b1b          	sext.w	s6,s1
    if((1 & (p->pendingSignals >> i)) && (!(1 & (p->signalMask >> i)))){
    800033bc:	028a2783          	lw	a5,40(s4)
    800033c0:	0097d7bb          	srlw	a5,a5,s1
    800033c4:	8b85                	andi	a5,a5,1
    800033c6:	d3ed                	beqz	a5,800033a8 <handle_signals+0x86>
    800033c8:	02ca2703          	lw	a4,44(s4)
    800033cc:	016757bb          	srlw	a5,a4,s6
    800033d0:	8b85                	andi	a5,a5,1
    800033d2:	fbf9                	bnez	a5,800033a8 <handle_signals+0x86>
      if(p->signalHandlers[i] != (void*)SIG_IGN){
    800033d4:	f9343423          	sd	s3,-120(s0)
    800033d8:	0009b783          	ld	a5,0(s3)
    800033dc:	fd9786e3          	beq	a5,s9,800033a8 <handle_signals+0x86>
       if(p->signalHandlers[i] == (void*)SIG_DFL){
    800033e0:	468d                	li	a3,3
    800033e2:	fad785e3          	beq	a5,a3,8000338c <handle_signals+0x6a>
      else if(p->signalHandlers[i] == (void*) SIGKILL)
    800033e6:	46a5                	li	a3,9
    800033e8:	0cd78363          	beq	a5,a3,800034ae <handle_signals+0x18c>
      else if(p->signalHandlers[i] == (void*) SIGSTOP)
    800033ec:	46c5                	li	a3,17
    800033ee:	0cd78663          	beq	a5,a3,800034ba <handle_signals+0x198>
      else if(p->signalHandlers[i] == (void*) SIGCONT)
    800033f2:	46cd                	li	a3,19
    800033f4:	0cd78963          	beq	a5,a3,800034c6 <handle_signals+0x1a4>
        if(p->handlesUserSignalHandler)
    800033f8:	1b0a2783          	lw	a5,432(s4)
    800033fc:	e3ed                	bnez	a5,800034de <handle_signals+0x1bc>
        p->oldSignalMask = p->signalMask;
    800033fe:	1aea2a23          	sw	a4,436(s4)
        p->signalMask = p->signalHandlersMasks[i];
    80003402:	000aa783          	lw	a5,0(s5)
    80003406:	02fa2623          	sw	a5,44(s4)
        p->handlesUserSignalHandler = 1;
    8000340a:	1b9a2823          	sw	s9,432(s4)
        t->trapframe->sp -= sizeof(struct trapframe);
    8000340e:	080c3703          	ld	a4,128(s8)
    80003412:	7b1c                	ld	a5,48(a4)
    80003414:	ee078793          	addi	a5,a5,-288
    80003418:	fb1c                	sd	a5,48(a4)
        t->userTrapFrameBackup = (struct trapframe*) t->trapframe->sp;
    8000341a:	080c3603          	ld	a2,128(s8)
    8000341e:	7a0c                	ld	a1,48(a2)
    80003420:	08bc3423          	sd	a1,136(s8)
        copyout(p->pagetable, (uint64)t->userTrapFrameBackup, (char*)t->trapframe, sizeof(struct trapframe));
    80003424:	12000693          	li	a3,288
    80003428:	818d3503          	ld	a0,-2024(s10) # 818 <_entry-0x7ffff7e8>
    8000342c:	ffffe097          	auipc	ra,0xffffe
    80003430:	220080e7          	jalr	544(ra) # 8000164c <copyout>
        t->trapframe->sp -= sigret_length;
    80003434:	080c3703          	ld	a4,128(s8)
    80003438:	7b1c                	ld	a5,48(a4)
    8000343a:	f8043683          	ld	a3,-128(s0)
    8000343e:	97b6                	add	a5,a5,a3
    80003440:	fb1c                	sd	a5,48(a4)
        copyout(p->pagetable, (uint64)t->trapframe->sp, (char*)sigret_start, sigret_length);
    80003442:	080c3783          	ld	a5,128(s8)
    80003446:	f7843683          	ld	a3,-136(s0)
    8000344a:	866e                	mv	a2,s11
    8000344c:	7b8c                	ld	a1,48(a5)
    8000344e:	818d3503          	ld	a0,-2024(s10)
    80003452:	ffffe097          	auipc	ra,0xffffe
    80003456:	1fa080e7          	jalr	506(ra) # 8000164c <copyout>
        t->trapframe->a0 = (uint64) i; //Which signal handler we want to run?
    8000345a:	080c3783          	ld	a5,128(s8)
    8000345e:	fba4                	sd	s1,112(a5)
        t->trapframe->ra = (uint64) t->trapframe->sp; //Return to the sigret
    80003460:	080c3783          	ld	a5,128(s8)
    80003464:	7b98                	ld	a4,48(a5)
    80003466:	f798                	sd	a4,40(a5)
        t->trapframe->epc = (uint64)p->signalHandlers[i];
    80003468:	080c3783          	ld	a5,128(s8)
    8000346c:	f8843703          	ld	a4,-120(s0)
    80003470:	6318                	ld	a4,0(a4)
    80003472:	ef98                	sd	a4,24(a5)
        p->pendingSignals &= ~(1 << i);
    80003474:	4785                	li	a5,1
    80003476:	016797bb          	sllw	a5,a5,s6
    8000347a:	fff7c793          	not	a5,a5
    8000347e:	028a2703          	lw	a4,40(s4)
    80003482:	8ff9                	and	a5,a5,a4
    80003484:	02fa2423          	sw	a5,40(s4)
    80003488:	b705                	j	800033a8 <handle_signals+0x86>
          SIGKILL_handler(p);
    8000348a:	8552                	mv	a0,s4
    8000348c:	fffff097          	auipc	ra,0xfffff
    80003490:	f58080e7          	jalr	-168(ra) # 800023e4 <SIGKILL_handler>
    80003494:	bf31                	j	800033b0 <handle_signals+0x8e>
          SIGSTOP_handler(p);
    80003496:	8552                	mv	a0,s4
    80003498:	fffff097          	auipc	ra,0xfffff
    8000349c:	368080e7          	jalr	872(ra) # 80002800 <SIGSTOP_handler>
    800034a0:	bf01                	j	800033b0 <handle_signals+0x8e>
          SIGCONT_handler(p);
    800034a2:	8552                	mv	a0,s4
    800034a4:	fffff097          	auipc	ra,0xfffff
    800034a8:	f50080e7          	jalr	-176(ra) # 800023f4 <SIGCONT_handler>
    800034ac:	b711                	j	800033b0 <handle_signals+0x8e>
        SIGKILL_handler(p);
    800034ae:	8552                	mv	a0,s4
    800034b0:	fffff097          	auipc	ra,0xfffff
    800034b4:	f34080e7          	jalr	-204(ra) # 800023e4 <SIGKILL_handler>
    800034b8:	bdc5                	j	800033a8 <handle_signals+0x86>
        SIGSTOP_handler(p);
    800034ba:	8552                	mv	a0,s4
    800034bc:	fffff097          	auipc	ra,0xfffff
    800034c0:	344080e7          	jalr	836(ra) # 80002800 <SIGSTOP_handler>
    800034c4:	b5d5                	j	800033a8 <handle_signals+0x86>
        SIGCONT_handler(p);
    800034c6:	8552                	mv	a0,s4
    800034c8:	fffff097          	auipc	ra,0xfffff
    800034cc:	f2c080e7          	jalr	-212(ra) # 800023f4 <SIGCONT_handler>
    800034d0:	bde1                	j	800033a8 <handle_signals+0x86>
        }
      }
    }
  }
  release(&t->lock);
    800034d2:	f7043503          	ld	a0,-144(s0)
    800034d6:	ffffd097          	auipc	ra,0xffffd
    800034da:	7ae080e7          	jalr	1966(ra) # 80000c84 <release>
}
    800034de:	60aa                	ld	ra,136(sp)
    800034e0:	640a                	ld	s0,128(sp)
    800034e2:	74e6                	ld	s1,120(sp)
    800034e4:	7946                	ld	s2,112(sp)
    800034e6:	79a6                	ld	s3,104(sp)
    800034e8:	7a06                	ld	s4,96(sp)
    800034ea:	6ae6                	ld	s5,88(sp)
    800034ec:	6b46                	ld	s6,80(sp)
    800034ee:	6ba6                	ld	s7,72(sp)
    800034f0:	6c06                	ld	s8,64(sp)
    800034f2:	7ce2                	ld	s9,56(sp)
    800034f4:	7d42                	ld	s10,48(sp)
    800034f6:	7da2                	ld	s11,40(sp)
    800034f8:	6149                	addi	sp,sp,144
    800034fa:	8082                	ret

00000000800034fc <usertrapret>:

// return to user space
//
void
usertrapret(void)
{
    800034fc:	1101                	addi	sp,sp,-32
    800034fe:	ec06                	sd	ra,24(sp)
    80003500:	e822                	sd	s0,16(sp)
    80003502:	e426                	sd	s1,8(sp)
    80003504:	e04a                	sd	s2,0(sp)
    80003506:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80003508:	ffffe097          	auipc	ra,0xffffe
    8000350c:	55e080e7          	jalr	1374(ra) # 80001a66 <myproc>
    80003510:	892a                	mv	s2,a0
  struct thread *t = mythread();
    80003512:	ffffe097          	auipc	ra,0xffffe
    80003516:	594080e7          	jalr	1428(ra) # 80001aa6 <mythread>
    8000351a:	84aa                	mv	s1,a0


  if(p->pendingSignals)
    8000351c:	02892783          	lw	a5,40(s2)
    80003520:	efdd                	bnez	a5,800035de <usertrapret+0xe2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003522:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80003526:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003528:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    8000352c:	00005817          	auipc	a6,0x5
    80003530:	ad480813          	addi	a6,a6,-1324 # 80008000 <_trampoline>
    80003534:	00005697          	auipc	a3,0x5
    80003538:	acc68693          	addi	a3,a3,-1332 # 80008000 <_trampoline>
    8000353c:	410686b3          	sub	a3,a3,a6
    80003540:	040007b7          	lui	a5,0x4000
    80003544:	17fd                	addi	a5,a5,-1
    80003546:	07b2                	slli	a5,a5,0xc
    80003548:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000354a:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  t->trapframe->kernel_satp = r_satp();         // kernel page table
    8000354e:	60d8                	ld	a4,128(s1)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80003550:	180026f3          	csrr	a3,satp
    80003554:	e314                	sd	a3,0(a4)
  t->trapframe->kernel_sp = t->kstack + PGSIZE; // process's kernel stack
    80003556:	60d4                	ld	a3,128(s1)
    80003558:	6705                	lui	a4,0x1
    8000355a:	7cd0                	ld	a2,184(s1)
    8000355c:	963a                	add	a2,a2,a4
    8000355e:	e690                	sd	a2,8(a3)
  t->trapframe->kernel_trap = (uint64)usertrap;
    80003560:	60d4                	ld	a3,128(s1)
    80003562:	00000617          	auipc	a2,0x0
    80003566:	17260613          	addi	a2,a2,370 # 800036d4 <usertrap>
    8000356a:	ea90                	sd	a2,16(a3)
  t->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000356c:	60d4                	ld	a3,128(s1)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000356e:	8612                	mv	a2,tp
    80003570:	f290                	sd	a2,32(a3)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003572:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80003576:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000357a:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000357e:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(t->trapframe->epc);
    80003582:	60d4                	ld	a3,128(s1)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003584:	6e94                	ld	a3,24(a3)
    80003586:	14169073          	csrw	sepc,a3

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(t->parent->pagetable);
    8000358a:	7cb4                	ld	a3,120(s1)
    8000358c:	96ba                	add	a3,a3,a4
    8000358e:	8186b583          	ld	a1,-2024(a3)
    80003592:	81b1                	srli	a1,a1,0xc
  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);

  ((void (*)(uint64,uint64))fn)(TRAPFRAME + (uint64)(sizeof(struct trapframe) * (t - p->threads)), satp);
    80003594:	1c890513          	addi	a0,s2,456
    80003598:	40a48533          	sub	a0,s1,a0
    8000359c:	850d                	srai	a0,a0,0x3
    8000359e:	00006497          	auipc	s1,0x6
    800035a2:	a6a4b483          	ld	s1,-1430(s1) # 80009008 <etext+0x8>
    800035a6:	02950533          	mul	a0,a0,s1
    800035aa:	00351493          	slli	s1,a0,0x3
    800035ae:	9526                	add	a0,a0,s1
    800035b0:	0516                	slli	a0,a0,0x5
    800035b2:	020006b7          	lui	a3,0x2000
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    800035b6:	00005717          	auipc	a4,0x5
    800035ba:	ada70713          	addi	a4,a4,-1318 # 80008090 <userret>
    800035be:	41070733          	sub	a4,a4,a6
    800035c2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME + (uint64)(sizeof(struct trapframe) * (t - p->threads)), satp);
    800035c4:	577d                	li	a4,-1
    800035c6:	177e                	slli	a4,a4,0x3f
    800035c8:	8dd9                	or	a1,a1,a4
    800035ca:	16fd                	addi	a3,a3,-1
    800035cc:	06b6                	slli	a3,a3,0xd
    800035ce:	9536                	add	a0,a0,a3
    800035d0:	9782                	jalr	a5
}
    800035d2:	60e2                	ld	ra,24(sp)
    800035d4:	6442                	ld	s0,16(sp)
    800035d6:	64a2                	ld	s1,8(sp)
    800035d8:	6902                	ld	s2,0(sp)
    800035da:	6105                	addi	sp,sp,32
    800035dc:	8082                	ret
    handle_signals(p, t);
    800035de:	85aa                	mv	a1,a0
    800035e0:	854a                	mv	a0,s2
    800035e2:	00000097          	auipc	ra,0x0
    800035e6:	d40080e7          	jalr	-704(ra) # 80003322 <handle_signals>
    800035ea:	bf25                	j	80003522 <usertrapret+0x26>

00000000800035ec <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800035ec:	1101                	addi	sp,sp,-32
    800035ee:	ec06                	sd	ra,24(sp)
    800035f0:	e822                	sd	s0,16(sp)
    800035f2:	e426                	sd	s1,8(sp)
    800035f4:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    800035f6:	00033497          	auipc	s1,0x33
    800035fa:	f3248493          	addi	s1,s1,-206 # 80036528 <tickslock>
    800035fe:	8526                	mv	a0,s1
    80003600:	ffffd097          	auipc	ra,0xffffd
    80003604:	5ca080e7          	jalr	1482(ra) # 80000bca <acquire>
  ticks++;
    80003608:	00007517          	auipc	a0,0x7
    8000360c:	a3050513          	addi	a0,a0,-1488 # 8000a038 <ticks>
    80003610:	411c                	lw	a5,0(a0)
    80003612:	2785                	addiw	a5,a5,1
    80003614:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80003616:	fffff097          	auipc	ra,0xfffff
    8000361a:	5ac080e7          	jalr	1452(ra) # 80002bc2 <wakeup>
  release(&tickslock);
    8000361e:	8526                	mv	a0,s1
    80003620:	ffffd097          	auipc	ra,0xffffd
    80003624:	664080e7          	jalr	1636(ra) # 80000c84 <release>
}
    80003628:	60e2                	ld	ra,24(sp)
    8000362a:	6442                	ld	s0,16(sp)
    8000362c:	64a2                	ld	s1,8(sp)
    8000362e:	6105                	addi	sp,sp,32
    80003630:	8082                	ret

0000000080003632 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80003632:	1101                	addi	sp,sp,-32
    80003634:	ec06                	sd	ra,24(sp)
    80003636:	e822                	sd	s0,16(sp)
    80003638:	e426                	sd	s1,8(sp)
    8000363a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000363c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80003640:	00074d63          	bltz	a4,8000365a <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80003644:	57fd                	li	a5,-1
    80003646:	17fe                	slli	a5,a5,0x3f
    80003648:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    8000364a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    8000364c:	06f70363          	beq	a4,a5,800036b2 <devintr+0x80>
  }
}
    80003650:	60e2                	ld	ra,24(sp)
    80003652:	6442                	ld	s0,16(sp)
    80003654:	64a2                	ld	s1,8(sp)
    80003656:	6105                	addi	sp,sp,32
    80003658:	8082                	ret
     (scause & 0xff) == 9){
    8000365a:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    8000365e:	46a5                	li	a3,9
    80003660:	fed792e3          	bne	a5,a3,80003644 <devintr+0x12>
    int irq = plic_claim();
    80003664:	00003097          	auipc	ra,0x3
    80003668:	7b4080e7          	jalr	1972(ra) # 80006e18 <plic_claim>
    8000366c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000366e:	47a9                	li	a5,10
    80003670:	02f50763          	beq	a0,a5,8000369e <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80003674:	4785                	li	a5,1
    80003676:	02f50963          	beq	a0,a5,800036a8 <devintr+0x76>
    return 1;
    8000367a:	4505                	li	a0,1
    } else if(irq){
    8000367c:	d8f1                	beqz	s1,80003650 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    8000367e:	85a6                	mv	a1,s1
    80003680:	00006517          	auipc	a0,0x6
    80003684:	c5850513          	addi	a0,a0,-936 # 800092d8 <states.0+0x20>
    80003688:	ffffd097          	auipc	ra,0xffffd
    8000368c:	eec080e7          	jalr	-276(ra) # 80000574 <printf>
      plic_complete(irq);
    80003690:	8526                	mv	a0,s1
    80003692:	00003097          	auipc	ra,0x3
    80003696:	7aa080e7          	jalr	1962(ra) # 80006e3c <plic_complete>
    return 1;
    8000369a:	4505                	li	a0,1
    8000369c:	bf55                	j	80003650 <devintr+0x1e>
      uartintr();
    8000369e:	ffffd097          	auipc	ra,0xffffd
    800036a2:	2e8080e7          	jalr	744(ra) # 80000986 <uartintr>
    800036a6:	b7ed                	j	80003690 <devintr+0x5e>
      virtio_disk_intr();
    800036a8:	00004097          	auipc	ra,0x4
    800036ac:	c26080e7          	jalr	-986(ra) # 800072ce <virtio_disk_intr>
    800036b0:	b7c5                	j	80003690 <devintr+0x5e>
    if(cpuid() == 0){
    800036b2:	ffffe097          	auipc	ra,0xffffe
    800036b6:	380080e7          	jalr	896(ra) # 80001a32 <cpuid>
    800036ba:	c901                	beqz	a0,800036ca <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800036bc:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800036c0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800036c2:	14479073          	csrw	sip,a5
    return 2;
    800036c6:	4509                	li	a0,2
    800036c8:	b761                	j	80003650 <devintr+0x1e>
      clockintr();
    800036ca:	00000097          	auipc	ra,0x0
    800036ce:	f22080e7          	jalr	-222(ra) # 800035ec <clockintr>
    800036d2:	b7ed                	j	800036bc <devintr+0x8a>

00000000800036d4 <usertrap>:
{
    800036d4:	7179                	addi	sp,sp,-48
    800036d6:	f406                	sd	ra,40(sp)
    800036d8:	f022                	sd	s0,32(sp)
    800036da:	ec26                	sd	s1,24(sp)
    800036dc:	e84a                	sd	s2,16(sp)
    800036de:	e44e                	sd	s3,8(sp)
    800036e0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800036e2:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800036e6:	1007f793          	andi	a5,a5,256
    800036ea:	e3d9                	bnez	a5,80003770 <usertrap+0x9c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800036ec:	00003797          	auipc	a5,0x3
    800036f0:	62478793          	addi	a5,a5,1572 # 80006d10 <kernelvec>
    800036f4:	10579073          	csrw	stvec,a5
  struct thread *t = mythread();
    800036f8:	ffffe097          	auipc	ra,0xffffe
    800036fc:	3ae080e7          	jalr	942(ra) # 80001aa6 <mythread>
    80003700:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80003702:	ffffe097          	auipc	ra,0xffffe
    80003706:	364080e7          	jalr	868(ra) # 80001a66 <myproc>
    8000370a:	892a                	mv	s2,a0
  t->trapframe->epc = r_sepc();
    8000370c:	60dc                	ld	a5,128(s1)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000370e:	14102773          	csrr	a4,sepc
    80003712:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003714:	14202773          	csrr	a4,scause
  if(r_scause() == 8) {
    80003718:	47a1                	li	a5,8
    8000371a:	06f71e63          	bne	a4,a5,80003796 <usertrap+0xc2>
    if(t->killed)
    8000371e:	0c04a783          	lw	a5,192(s1)
    80003722:	efb9                	bnez	a5,80003780 <usertrap+0xac>
    if(p->killed)
    80003724:	01c92783          	lw	a5,28(s2)
    80003728:	e3ad                	bnez	a5,8000378a <usertrap+0xb6>
    t->trapframe->epc += 4;
    8000372a:	60d8                	ld	a4,128(s1)
    8000372c:	6f1c                	ld	a5,24(a4)
    8000372e:	0791                	addi	a5,a5,4
    80003730:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003732:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80003736:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000373a:	10079073          	csrw	sstatus,a5
    syscall();
    8000373e:	00000097          	auipc	ra,0x0
    80003742:	316080e7          	jalr	790(ra) # 80003a54 <syscall>
  int which_dev = 0;
    80003746:	4981                	li	s3,0
  if(t->killed)
    80003748:	0c04a783          	lw	a5,192(s1)
    8000374c:	e3c5                	bnez	a5,800037ec <usertrap+0x118>
  if(p->killed)
    8000374e:	01c92783          	lw	a5,28(s2)
    80003752:	e7d9                	bnez	a5,800037e0 <usertrap+0x10c>
  if(which_dev == 2)
    80003754:	4789                	li	a5,2
    80003756:	0af98063          	beq	s3,a5,800037f6 <usertrap+0x122>
  usertrapret();
    8000375a:	00000097          	auipc	ra,0x0
    8000375e:	da2080e7          	jalr	-606(ra) # 800034fc <usertrapret>
}
    80003762:	70a2                	ld	ra,40(sp)
    80003764:	7402                	ld	s0,32(sp)
    80003766:	64e2                	ld	s1,24(sp)
    80003768:	6942                	ld	s2,16(sp)
    8000376a:	69a2                	ld	s3,8(sp)
    8000376c:	6145                	addi	sp,sp,48
    8000376e:	8082                	ret
    panic("usertrap: not from user mode");
    80003770:	00006517          	auipc	a0,0x6
    80003774:	b8850513          	addi	a0,a0,-1144 # 800092f8 <states.0+0x40>
    80003778:	ffffd097          	auipc	ra,0xffffd
    8000377c:	db2080e7          	jalr	-590(ra) # 8000052a <panic>
      killCurThread();
    80003780:	fffff097          	auipc	ra,0xfffff
    80003784:	63a080e7          	jalr	1594(ra) # 80002dba <killCurThread>
    80003788:	bf71                	j	80003724 <usertrap+0x50>
      exit(-1);
    8000378a:	557d                	li	a0,-1
    8000378c:	fffff097          	auipc	ra,0xfffff
    80003790:	6be080e7          	jalr	1726(ra) # 80002e4a <exit>
    80003794:	bf59                	j	8000372a <usertrap+0x56>
  } else if((which_dev = devintr()) != 0){
    80003796:	00000097          	auipc	ra,0x0
    8000379a:	e9c080e7          	jalr	-356(ra) # 80003632 <devintr>
    8000379e:	89aa                	mv	s3,a0
    800037a0:	f545                	bnez	a0,80003748 <usertrap+0x74>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800037a2:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800037a6:	02492603          	lw	a2,36(s2)
    800037aa:	00006517          	auipc	a0,0x6
    800037ae:	b6e50513          	addi	a0,a0,-1170 # 80009318 <states.0+0x60>
    800037b2:	ffffd097          	auipc	ra,0xffffd
    800037b6:	dc2080e7          	jalr	-574(ra) # 80000574 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800037ba:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800037be:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800037c2:	00006517          	auipc	a0,0x6
    800037c6:	b8650513          	addi	a0,a0,-1146 # 80009348 <states.0+0x90>
    800037ca:	ffffd097          	auipc	ra,0xffffd
    800037ce:	daa080e7          	jalr	-598(ra) # 80000574 <printf>
    p->killed = 1;
    800037d2:	4785                	li	a5,1
    800037d4:	00f92e23          	sw	a5,28(s2)
  if(t->killed)
    800037d8:	0c04a783          	lw	a5,192(s1)
    800037dc:	eb81                	bnez	a5,800037ec <usertrap+0x118>
  } else if((which_dev = devintr()) != 0){
    800037de:	89be                	mv	s3,a5
    exit(-1);
    800037e0:	557d                	li	a0,-1
    800037e2:	fffff097          	auipc	ra,0xfffff
    800037e6:	668080e7          	jalr	1640(ra) # 80002e4a <exit>
    800037ea:	b7ad                	j	80003754 <usertrap+0x80>
    killCurThread();
    800037ec:	fffff097          	auipc	ra,0xfffff
    800037f0:	5ce080e7          	jalr	1486(ra) # 80002dba <killCurThread>
    800037f4:	bfa9                	j	8000374e <usertrap+0x7a>
    yield();
    800037f6:	fffff097          	auipc	ra,0xfffff
    800037fa:	fc4080e7          	jalr	-60(ra) # 800027ba <yield>
    800037fe:	bfb1                	j	8000375a <usertrap+0x86>

0000000080003800 <kerneltrap>:
{
    80003800:	7179                	addi	sp,sp,-48
    80003802:	f406                	sd	ra,40(sp)
    80003804:	f022                	sd	s0,32(sp)
    80003806:	ec26                	sd	s1,24(sp)
    80003808:	e84a                	sd	s2,16(sp)
    8000380a:	e44e                	sd	s3,8(sp)
    8000380c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000380e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003812:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003816:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    8000381a:	1004f793          	andi	a5,s1,256
    8000381e:	cb85                	beqz	a5,8000384e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003820:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80003824:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80003826:	ef85                	bnez	a5,8000385e <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80003828:	00000097          	auipc	ra,0x0
    8000382c:	e0a080e7          	jalr	-502(ra) # 80003632 <devintr>
    80003830:	cd1d                	beqz	a0,8000386e <kerneltrap+0x6e>
  if(which_dev == 2 && mythread() != 0 && mythread()->state == TRUNNING)
    80003832:	4789                	li	a5,2
    80003834:	06f50a63          	beq	a0,a5,800038a8 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003838:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000383c:	10049073          	csrw	sstatus,s1
}
    80003840:	70a2                	ld	ra,40(sp)
    80003842:	7402                	ld	s0,32(sp)
    80003844:	64e2                	ld	s1,24(sp)
    80003846:	6942                	ld	s2,16(sp)
    80003848:	69a2                	ld	s3,8(sp)
    8000384a:	6145                	addi	sp,sp,48
    8000384c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000384e:	00006517          	auipc	a0,0x6
    80003852:	b1a50513          	addi	a0,a0,-1254 # 80009368 <states.0+0xb0>
    80003856:	ffffd097          	auipc	ra,0xffffd
    8000385a:	cd4080e7          	jalr	-812(ra) # 8000052a <panic>
    panic("kerneltrap: interrupts enabled");
    8000385e:	00006517          	auipc	a0,0x6
    80003862:	b3250513          	addi	a0,a0,-1230 # 80009390 <states.0+0xd8>
    80003866:	ffffd097          	auipc	ra,0xffffd
    8000386a:	cc4080e7          	jalr	-828(ra) # 8000052a <panic>
    printf("scause %p\n", scause);
    8000386e:	85ce                	mv	a1,s3
    80003870:	00006517          	auipc	a0,0x6
    80003874:	b4050513          	addi	a0,a0,-1216 # 800093b0 <states.0+0xf8>
    80003878:	ffffd097          	auipc	ra,0xffffd
    8000387c:	cfc080e7          	jalr	-772(ra) # 80000574 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003880:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003884:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003888:	00006517          	auipc	a0,0x6
    8000388c:	b3850513          	addi	a0,a0,-1224 # 800093c0 <states.0+0x108>
    80003890:	ffffd097          	auipc	ra,0xffffd
    80003894:	ce4080e7          	jalr	-796(ra) # 80000574 <printf>
    panic("kerneltrap");
    80003898:	00006517          	auipc	a0,0x6
    8000389c:	b4050513          	addi	a0,a0,-1216 # 800093d8 <states.0+0x120>
    800038a0:	ffffd097          	auipc	ra,0xffffd
    800038a4:	c8a080e7          	jalr	-886(ra) # 8000052a <panic>
  if(which_dev == 2 && mythread() != 0 && mythread()->state == TRUNNING)
    800038a8:	ffffe097          	auipc	ra,0xffffe
    800038ac:	1fe080e7          	jalr	510(ra) # 80001aa6 <mythread>
    800038b0:	d541                	beqz	a0,80003838 <kerneltrap+0x38>
    800038b2:	ffffe097          	auipc	ra,0xffffe
    800038b6:	1f4080e7          	jalr	500(ra) # 80001aa6 <mythread>
    800038ba:	4158                	lw	a4,4(a0)
    800038bc:	4791                	li	a5,4
    800038be:	f6f71de3          	bne	a4,a5,80003838 <kerneltrap+0x38>
    yield();
    800038c2:	fffff097          	auipc	ra,0xfffff
    800038c6:	ef8080e7          	jalr	-264(ra) # 800027ba <yield>
    800038ca:	b7bd                	j	80003838 <kerneltrap+0x38>

00000000800038cc <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800038cc:	1101                	addi	sp,sp,-32
    800038ce:	ec06                	sd	ra,24(sp)
    800038d0:	e822                	sd	s0,16(sp)
    800038d2:	e426                	sd	s1,8(sp)
    800038d4:	1000                	addi	s0,sp,32
    800038d6:	84aa                	mv	s1,a0
  struct thread *tr = mythread();
    800038d8:	ffffe097          	auipc	ra,0xffffe
    800038dc:	1ce080e7          	jalr	462(ra) # 80001aa6 <mythread>
  switch (n) {
    800038e0:	4795                	li	a5,5
    800038e2:	0497e163          	bltu	a5,s1,80003924 <argraw+0x58>
    800038e6:	048a                	slli	s1,s1,0x2
    800038e8:	00006717          	auipc	a4,0x6
    800038ec:	b2870713          	addi	a4,a4,-1240 # 80009410 <states.0+0x158>
    800038f0:	94ba                	add	s1,s1,a4
    800038f2:	409c                	lw	a5,0(s1)
    800038f4:	97ba                	add	a5,a5,a4
    800038f6:	8782                	jr	a5
  case 0:
    return tr->trapframe->a0;
    800038f8:	615c                	ld	a5,128(a0)
    800038fa:	7ba8                	ld	a0,112(a5)
  case 5:
    return tr->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800038fc:	60e2                	ld	ra,24(sp)
    800038fe:	6442                	ld	s0,16(sp)
    80003900:	64a2                	ld	s1,8(sp)
    80003902:	6105                	addi	sp,sp,32
    80003904:	8082                	ret
    return tr->trapframe->a1;
    80003906:	615c                	ld	a5,128(a0)
    80003908:	7fa8                	ld	a0,120(a5)
    8000390a:	bfcd                	j	800038fc <argraw+0x30>
    return tr->trapframe->a2;
    8000390c:	615c                	ld	a5,128(a0)
    8000390e:	63c8                	ld	a0,128(a5)
    80003910:	b7f5                	j	800038fc <argraw+0x30>
    return tr->trapframe->a3;
    80003912:	615c                	ld	a5,128(a0)
    80003914:	67c8                	ld	a0,136(a5)
    80003916:	b7dd                	j	800038fc <argraw+0x30>
    return tr->trapframe->a4;
    80003918:	615c                	ld	a5,128(a0)
    8000391a:	6bc8                	ld	a0,144(a5)
    8000391c:	b7c5                	j	800038fc <argraw+0x30>
    return tr->trapframe->a5;
    8000391e:	615c                	ld	a5,128(a0)
    80003920:	6fc8                	ld	a0,152(a5)
    80003922:	bfe9                	j	800038fc <argraw+0x30>
  panic("argraw");
    80003924:	00006517          	auipc	a0,0x6
    80003928:	ac450513          	addi	a0,a0,-1340 # 800093e8 <states.0+0x130>
    8000392c:	ffffd097          	auipc	ra,0xffffd
    80003930:	bfe080e7          	jalr	-1026(ra) # 8000052a <panic>

0000000080003934 <fetchaddr>:
{
    80003934:	1101                	addi	sp,sp,-32
    80003936:	ec06                	sd	ra,24(sp)
    80003938:	e822                	sd	s0,16(sp)
    8000393a:	e426                	sd	s1,8(sp)
    8000393c:	e04a                	sd	s2,0(sp)
    8000393e:	1000                	addi	s0,sp,32
    80003940:	84aa                	mv	s1,a0
    80003942:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80003944:	ffffe097          	auipc	ra,0xffffe
    80003948:	122080e7          	jalr	290(ra) # 80001a66 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    8000394c:	6785                	lui	a5,0x1
    8000394e:	97aa                	add	a5,a5,a0
    80003950:	8107b783          	ld	a5,-2032(a5) # 810 <_entry-0x7ffff7f0>
    80003954:	02f4fb63          	bgeu	s1,a5,8000398a <fetchaddr+0x56>
    80003958:	00848713          	addi	a4,s1,8
    8000395c:	02e7e963          	bltu	a5,a4,8000398e <fetchaddr+0x5a>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003960:	6785                	lui	a5,0x1
    80003962:	97aa                	add	a5,a5,a0
    80003964:	46a1                	li	a3,8
    80003966:	8626                	mv	a2,s1
    80003968:	85ca                	mv	a1,s2
    8000396a:	8187b503          	ld	a0,-2024(a5) # 818 <_entry-0x7ffff7e8>
    8000396e:	ffffe097          	auipc	ra,0xffffe
    80003972:	d6a080e7          	jalr	-662(ra) # 800016d8 <copyin>
    80003976:	00a03533          	snez	a0,a0
    8000397a:	40a00533          	neg	a0,a0
}
    8000397e:	60e2                	ld	ra,24(sp)
    80003980:	6442                	ld	s0,16(sp)
    80003982:	64a2                	ld	s1,8(sp)
    80003984:	6902                	ld	s2,0(sp)
    80003986:	6105                	addi	sp,sp,32
    80003988:	8082                	ret
    return -1;
    8000398a:	557d                	li	a0,-1
    8000398c:	bfcd                	j	8000397e <fetchaddr+0x4a>
    8000398e:	557d                	li	a0,-1
    80003990:	b7fd                	j	8000397e <fetchaddr+0x4a>

0000000080003992 <fetchstr>:
{
    80003992:	7179                	addi	sp,sp,-48
    80003994:	f406                	sd	ra,40(sp)
    80003996:	f022                	sd	s0,32(sp)
    80003998:	ec26                	sd	s1,24(sp)
    8000399a:	e84a                	sd	s2,16(sp)
    8000399c:	e44e                	sd	s3,8(sp)
    8000399e:	1800                	addi	s0,sp,48
    800039a0:	892a                	mv	s2,a0
    800039a2:	84ae                	mv	s1,a1
    800039a4:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800039a6:	ffffe097          	auipc	ra,0xffffe
    800039aa:	0c0080e7          	jalr	192(ra) # 80001a66 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800039ae:	6785                	lui	a5,0x1
    800039b0:	97aa                	add	a5,a5,a0
    800039b2:	86ce                	mv	a3,s3
    800039b4:	864a                	mv	a2,s2
    800039b6:	85a6                	mv	a1,s1
    800039b8:	8187b503          	ld	a0,-2024(a5) # 818 <_entry-0x7ffff7e8>
    800039bc:	ffffe097          	auipc	ra,0xffffe
    800039c0:	daa080e7          	jalr	-598(ra) # 80001766 <copyinstr>
  if(err < 0)
    800039c4:	00054763          	bltz	a0,800039d2 <fetchstr+0x40>
  return strlen(buf);
    800039c8:	8526                	mv	a0,s1
    800039ca:	ffffd097          	auipc	ra,0xffffd
    800039ce:	486080e7          	jalr	1158(ra) # 80000e50 <strlen>
}
    800039d2:	70a2                	ld	ra,40(sp)
    800039d4:	7402                	ld	s0,32(sp)
    800039d6:	64e2                	ld	s1,24(sp)
    800039d8:	6942                	ld	s2,16(sp)
    800039da:	69a2                	ld	s3,8(sp)
    800039dc:	6145                	addi	sp,sp,48
    800039de:	8082                	ret

00000000800039e0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800039e0:	1101                	addi	sp,sp,-32
    800039e2:	ec06                	sd	ra,24(sp)
    800039e4:	e822                	sd	s0,16(sp)
    800039e6:	e426                	sd	s1,8(sp)
    800039e8:	1000                	addi	s0,sp,32
    800039ea:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800039ec:	00000097          	auipc	ra,0x0
    800039f0:	ee0080e7          	jalr	-288(ra) # 800038cc <argraw>
    800039f4:	c088                	sw	a0,0(s1)
  return 0;
}
    800039f6:	4501                	li	a0,0
    800039f8:	60e2                	ld	ra,24(sp)
    800039fa:	6442                	ld	s0,16(sp)
    800039fc:	64a2                	ld	s1,8(sp)
    800039fe:	6105                	addi	sp,sp,32
    80003a00:	8082                	ret

0000000080003a02 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80003a02:	1101                	addi	sp,sp,-32
    80003a04:	ec06                	sd	ra,24(sp)
    80003a06:	e822                	sd	s0,16(sp)
    80003a08:	e426                	sd	s1,8(sp)
    80003a0a:	1000                	addi	s0,sp,32
    80003a0c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003a0e:	00000097          	auipc	ra,0x0
    80003a12:	ebe080e7          	jalr	-322(ra) # 800038cc <argraw>
    80003a16:	e088                	sd	a0,0(s1)
  return 0;
}
    80003a18:	4501                	li	a0,0
    80003a1a:	60e2                	ld	ra,24(sp)
    80003a1c:	6442                	ld	s0,16(sp)
    80003a1e:	64a2                	ld	s1,8(sp)
    80003a20:	6105                	addi	sp,sp,32
    80003a22:	8082                	ret

0000000080003a24 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80003a24:	1101                	addi	sp,sp,-32
    80003a26:	ec06                	sd	ra,24(sp)
    80003a28:	e822                	sd	s0,16(sp)
    80003a2a:	e426                	sd	s1,8(sp)
    80003a2c:	e04a                	sd	s2,0(sp)
    80003a2e:	1000                	addi	s0,sp,32
    80003a30:	84ae                	mv	s1,a1
    80003a32:	8932                	mv	s2,a2
  *ip = argraw(n);
    80003a34:	00000097          	auipc	ra,0x0
    80003a38:	e98080e7          	jalr	-360(ra) # 800038cc <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80003a3c:	864a                	mv	a2,s2
    80003a3e:	85a6                	mv	a1,s1
    80003a40:	00000097          	auipc	ra,0x0
    80003a44:	f52080e7          	jalr	-174(ra) # 80003992 <fetchstr>
}
    80003a48:	60e2                	ld	ra,24(sp)
    80003a4a:	6442                	ld	s0,16(sp)
    80003a4c:	64a2                	ld	s1,8(sp)
    80003a4e:	6902                	ld	s2,0(sp)
    80003a50:	6105                	addi	sp,sp,32
    80003a52:	8082                	ret

0000000080003a54 <syscall>:

};

void
syscall(void)
{
    80003a54:	1101                	addi	sp,sp,-32
    80003a56:	ec06                	sd	ra,24(sp)
    80003a58:	e822                	sd	s0,16(sp)
    80003a5a:	e426                	sd	s1,8(sp)
    80003a5c:	e04a                	sd	s2,0(sp)
    80003a5e:	1000                	addi	s0,sp,32
  int num;
  struct thread *tr = mythread();
    80003a60:	ffffe097          	auipc	ra,0xffffe
    80003a64:	046080e7          	jalr	70(ra) # 80001aa6 <mythread>
    80003a68:	84aa                	mv	s1,a0
  num = tr->trapframe->a7;
    80003a6a:	08053903          	ld	s2,128(a0)
    80003a6e:	0a893783          	ld	a5,168(s2)
    80003a72:	0007861b          	sext.w	a2,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003a76:	37fd                	addiw	a5,a5,-1
    80003a78:	477d                	li	a4,31
    80003a7a:	00f76f63          	bltu	a4,a5,80003a98 <syscall+0x44>
    80003a7e:	00361713          	slli	a4,a2,0x3
    80003a82:	00006797          	auipc	a5,0x6
    80003a86:	9a678793          	addi	a5,a5,-1626 # 80009428 <syscalls>
    80003a8a:	97ba                	add	a5,a5,a4
    80003a8c:	639c                	ld	a5,0(a5)
    80003a8e:	c789                	beqz	a5,80003a98 <syscall+0x44>
    tr->trapframe->a0 = syscalls[num]();
    80003a90:	9782                	jalr	a5
    80003a92:	06a93823          	sd	a0,112(s2)
    80003a96:	a829                	j	80003ab0 <syscall+0x5c>
  } else {
    printf("%d : unknown sys call %d\n",
    80003a98:	408c                	lw	a1,0(s1)
    80003a9a:	00006517          	auipc	a0,0x6
    80003a9e:	95650513          	addi	a0,a0,-1706 # 800093f0 <states.0+0x138>
    80003aa2:	ffffd097          	auipc	ra,0xffffd
    80003aa6:	ad2080e7          	jalr	-1326(ra) # 80000574 <printf>
            tr->tid, num);
    tr->trapframe->a0 = -1;
    80003aaa:	60dc                	ld	a5,128(s1)
    80003aac:	577d                	li	a4,-1
    80003aae:	fbb8                	sd	a4,112(a5)
  }
}
    80003ab0:	60e2                	ld	ra,24(sp)
    80003ab2:	6442                	ld	s0,16(sp)
    80003ab4:	64a2                	ld	s1,8(sp)
    80003ab6:	6902                	ld	s2,0(sp)
    80003ab8:	6105                	addi	sp,sp,32
    80003aba:	8082                	ret

0000000080003abc <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80003abc:	1101                	addi	sp,sp,-32
    80003abe:	ec06                	sd	ra,24(sp)
    80003ac0:	e822                	sd	s0,16(sp)
    80003ac2:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80003ac4:	fec40593          	addi	a1,s0,-20
    80003ac8:	4501                	li	a0,0
    80003aca:	00000097          	auipc	ra,0x0
    80003ace:	f16080e7          	jalr	-234(ra) # 800039e0 <argint>
    return -1;
    80003ad2:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80003ad4:	00054963          	bltz	a0,80003ae6 <sys_exit+0x2a>
  exit(n);
    80003ad8:	fec42503          	lw	a0,-20(s0)
    80003adc:	fffff097          	auipc	ra,0xfffff
    80003ae0:	36e080e7          	jalr	878(ra) # 80002e4a <exit>
  return 0;  // not reached
    80003ae4:	4781                	li	a5,0
}
    80003ae6:	853e                	mv	a0,a5
    80003ae8:	60e2                	ld	ra,24(sp)
    80003aea:	6442                	ld	s0,16(sp)
    80003aec:	6105                	addi	sp,sp,32
    80003aee:	8082                	ret

0000000080003af0 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003af0:	1141                	addi	sp,sp,-16
    80003af2:	e406                	sd	ra,8(sp)
    80003af4:	e022                	sd	s0,0(sp)
    80003af6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80003af8:	ffffe097          	auipc	ra,0xffffe
    80003afc:	f6e080e7          	jalr	-146(ra) # 80001a66 <myproc>
}
    80003b00:	5148                	lw	a0,36(a0)
    80003b02:	60a2                	ld	ra,8(sp)
    80003b04:	6402                	ld	s0,0(sp)
    80003b06:	0141                	addi	sp,sp,16
    80003b08:	8082                	ret

0000000080003b0a <sys_fork>:

uint64
sys_fork(void)
{
    80003b0a:	1141                	addi	sp,sp,-16
    80003b0c:	e406                	sd	ra,8(sp)
    80003b0e:	e022                	sd	s0,0(sp)
    80003b10:	0800                	addi	s0,sp,16
  return fork();
    80003b12:	ffffe097          	auipc	ra,0xffffe
    80003b16:	544080e7          	jalr	1348(ra) # 80002056 <fork>
}
    80003b1a:	60a2                	ld	ra,8(sp)
    80003b1c:	6402                	ld	s0,0(sp)
    80003b1e:	0141                	addi	sp,sp,16
    80003b20:	8082                	ret

0000000080003b22 <sys_wait>:

uint64
sys_wait(void)
{
    80003b22:	1101                	addi	sp,sp,-32
    80003b24:	ec06                	sd	ra,24(sp)
    80003b26:	e822                	sd	s0,16(sp)
    80003b28:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80003b2a:	fe840593          	addi	a1,s0,-24
    80003b2e:	4501                	li	a0,0
    80003b30:	00000097          	auipc	ra,0x0
    80003b34:	ed2080e7          	jalr	-302(ra) # 80003a02 <argaddr>
    80003b38:	87aa                	mv	a5,a0
    return -1;
    80003b3a:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80003b3c:	0007c863          	bltz	a5,80003b4c <sys_wait+0x2a>
  return wait(p);
    80003b40:	fe843503          	ld	a0,-24(s0)
    80003b44:	fffff097          	auipc	ra,0xfffff
    80003b48:	f18080e7          	jalr	-232(ra) # 80002a5c <wait>
}
    80003b4c:	60e2                	ld	ra,24(sp)
    80003b4e:	6442                	ld	s0,16(sp)
    80003b50:	6105                	addi	sp,sp,32
    80003b52:	8082                	ret

0000000080003b54 <sys_sigprocmask>:

uint64
sys_sigprocmask(void)
{
    80003b54:	1101                	addi	sp,sp,-32
    80003b56:	ec06                	sd	ra,24(sp)
    80003b58:	e822                	sd	s0,16(sp)
    80003b5a:	1000                	addi	s0,sp,32
  int sigmask;
  if(argint(0, &sigmask) < 0)
    80003b5c:	fec40593          	addi	a1,s0,-20
    80003b60:	4501                	li	a0,0
    80003b62:	00000097          	auipc	ra,0x0
    80003b66:	e7e080e7          	jalr	-386(ra) # 800039e0 <argint>
    80003b6a:	87aa                	mv	a5,a0
    return -1;
    80003b6c:	557d                	li	a0,-1
  if(argint(0, &sigmask) < 0)
    80003b6e:	0007ca63          	bltz	a5,80003b82 <sys_sigprocmask+0x2e>
  return sigprocmask(sigmask);
    80003b72:	fec42503          	lw	a0,-20(s0)
    80003b76:	ffffe097          	auipc	ra,0xffffe
    80003b7a:	6be080e7          	jalr	1726(ra) # 80002234 <sigprocmask>
    80003b7e:	1502                	slli	a0,a0,0x20
    80003b80:	9101                	srli	a0,a0,0x20
}
    80003b82:	60e2                	ld	ra,24(sp)
    80003b84:	6442                	ld	s0,16(sp)
    80003b86:	6105                	addi	sp,sp,32
    80003b88:	8082                	ret

0000000080003b8a <sys_sigaction>:


uint64
sys_sigaction(void)
{
    80003b8a:	7179                	addi	sp,sp,-48
    80003b8c:	f406                	sd	ra,40(sp)
    80003b8e:	f022                	sd	s0,32(sp)
    80003b90:	1800                	addi	s0,sp,48
  int signum;
  uint64 act;
  uint64 oldact;
  if(argint(0, &signum) < 0)
    80003b92:	fec40593          	addi	a1,s0,-20
    80003b96:	4501                	li	a0,0
    80003b98:	00000097          	auipc	ra,0x0
    80003b9c:	e48080e7          	jalr	-440(ra) # 800039e0 <argint>
    return -1;
    80003ba0:	57fd                	li	a5,-1
  if(argint(0, &signum) < 0)
    80003ba2:	04054163          	bltz	a0,80003be4 <sys_sigaction+0x5a>
  if(argaddr(1, &act) < 0)
    80003ba6:	fe040593          	addi	a1,s0,-32
    80003baa:	4505                	li	a0,1
    80003bac:	00000097          	auipc	ra,0x0
    80003bb0:	e56080e7          	jalr	-426(ra) # 80003a02 <argaddr>
    return -1;
    80003bb4:	57fd                	li	a5,-1
  if(argaddr(1, &act) < 0)
    80003bb6:	02054763          	bltz	a0,80003be4 <sys_sigaction+0x5a>
  if(argaddr(2, &oldact) < 0)
    80003bba:	fd840593          	addi	a1,s0,-40
    80003bbe:	4509                	li	a0,2
    80003bc0:	00000097          	auipc	ra,0x0
    80003bc4:	e42080e7          	jalr	-446(ra) # 80003a02 <argaddr>
    return -1;
    80003bc8:	57fd                	li	a5,-1
  if(argaddr(2, &oldact) < 0)
    80003bca:	00054d63          	bltz	a0,80003be4 <sys_sigaction+0x5a>
  return sigaction(signum, act, oldact);
    80003bce:	fd843603          	ld	a2,-40(s0)
    80003bd2:	fe043583          	ld	a1,-32(s0)
    80003bd6:	fec42503          	lw	a0,-20(s0)
    80003bda:	ffffe097          	auipc	ra,0xffffe
    80003bde:	69e080e7          	jalr	1694(ra) # 80002278 <sigaction>
    80003be2:	87aa                	mv	a5,a0
}
    80003be4:	853e                	mv	a0,a5
    80003be6:	70a2                	ld	ra,40(sp)
    80003be8:	7402                	ld	s0,32(sp)
    80003bea:	6145                	addi	sp,sp,48
    80003bec:	8082                	ret

0000000080003bee <sys_sigret>:

uint64
sys_sigret(void){
    80003bee:	1141                	addi	sp,sp,-16
    80003bf0:	e406                	sd	ra,8(sp)
    80003bf2:	e022                	sd	s0,0(sp)
    80003bf4:	0800                	addi	s0,sp,16
  sigret();
    80003bf6:	ffffe097          	auipc	ra,0xffffe
    80003bfa:	7a6080e7          	jalr	1958(ra) # 8000239c <sigret>
  return 0;
}
    80003bfe:	4501                	li	a0,0
    80003c00:	60a2                	ld	ra,8(sp)
    80003c02:	6402                	ld	s0,0(sp)
    80003c04:	0141                	addi	sp,sp,16
    80003c06:	8082                	ret

0000000080003c08 <sys_sbrk>:


uint64
sys_sbrk(void)
{
    80003c08:	7179                	addi	sp,sp,-48
    80003c0a:	f406                	sd	ra,40(sp)
    80003c0c:	f022                	sd	s0,32(sp)
    80003c0e:	ec26                	sd	s1,24(sp)
    80003c10:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80003c12:	fdc40593          	addi	a1,s0,-36
    80003c16:	4501                	li	a0,0
    80003c18:	00000097          	auipc	ra,0x0
    80003c1c:	dc8080e7          	jalr	-568(ra) # 800039e0 <argint>
    return -1;
    80003c20:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    80003c22:	02054263          	bltz	a0,80003c46 <sys_sbrk+0x3e>
  addr = myproc()->sz;
    80003c26:	ffffe097          	auipc	ra,0xffffe
    80003c2a:	e40080e7          	jalr	-448(ra) # 80001a66 <myproc>
    80003c2e:	6785                	lui	a5,0x1
    80003c30:	953e                	add	a0,a0,a5
    80003c32:	81052483          	lw	s1,-2032(a0)
  if(growproc(n) < 0)
    80003c36:	fdc42503          	lw	a0,-36(s0)
    80003c3a:	ffffe097          	auipc	ra,0xffffe
    80003c3e:	38e080e7          	jalr	910(ra) # 80001fc8 <growproc>
    80003c42:	00054863          	bltz	a0,80003c52 <sys_sbrk+0x4a>
    return -1;
  return addr;
}
    80003c46:	8526                	mv	a0,s1
    80003c48:	70a2                	ld	ra,40(sp)
    80003c4a:	7402                	ld	s0,32(sp)
    80003c4c:	64e2                	ld	s1,24(sp)
    80003c4e:	6145                	addi	sp,sp,48
    80003c50:	8082                	ret
    return -1;
    80003c52:	54fd                	li	s1,-1
    80003c54:	bfcd                	j	80003c46 <sys_sbrk+0x3e>

0000000080003c56 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003c56:	7139                	addi	sp,sp,-64
    80003c58:	fc06                	sd	ra,56(sp)
    80003c5a:	f822                	sd	s0,48(sp)
    80003c5c:	f426                	sd	s1,40(sp)
    80003c5e:	f04a                	sd	s2,32(sp)
    80003c60:	ec4e                	sd	s3,24(sp)
    80003c62:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80003c64:	fcc40593          	addi	a1,s0,-52
    80003c68:	4501                	li	a0,0
    80003c6a:	00000097          	auipc	ra,0x0
    80003c6e:	d76080e7          	jalr	-650(ra) # 800039e0 <argint>
    return -1;
    80003c72:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80003c74:	06054563          	bltz	a0,80003cde <sys_sleep+0x88>
  acquire(&tickslock);
    80003c78:	00033517          	auipc	a0,0x33
    80003c7c:	8b050513          	addi	a0,a0,-1872 # 80036528 <tickslock>
    80003c80:	ffffd097          	auipc	ra,0xffffd
    80003c84:	f4a080e7          	jalr	-182(ra) # 80000bca <acquire>
  ticks0 = ticks;
    80003c88:	00006917          	auipc	s2,0x6
    80003c8c:	3b092903          	lw	s2,944(s2) # 8000a038 <ticks>
  while(ticks - ticks0 < n){
    80003c90:	fcc42783          	lw	a5,-52(s0)
    80003c94:	cf85                	beqz	a5,80003ccc <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003c96:	00033997          	auipc	s3,0x33
    80003c9a:	89298993          	addi	s3,s3,-1902 # 80036528 <tickslock>
    80003c9e:	00006497          	auipc	s1,0x6
    80003ca2:	39a48493          	addi	s1,s1,922 # 8000a038 <ticks>
    if(myproc()->killed){
    80003ca6:	ffffe097          	auipc	ra,0xffffe
    80003caa:	dc0080e7          	jalr	-576(ra) # 80001a66 <myproc>
    80003cae:	4d5c                	lw	a5,28(a0)
    80003cb0:	ef9d                	bnez	a5,80003cee <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80003cb2:	85ce                	mv	a1,s3
    80003cb4:	8526                	mv	a0,s1
    80003cb6:	fffff097          	auipc	ra,0xfffff
    80003cba:	b9e080e7          	jalr	-1122(ra) # 80002854 <sleep>
  while(ticks - ticks0 < n){
    80003cbe:	409c                	lw	a5,0(s1)
    80003cc0:	412787bb          	subw	a5,a5,s2
    80003cc4:	fcc42703          	lw	a4,-52(s0)
    80003cc8:	fce7efe3          	bltu	a5,a4,80003ca6 <sys_sleep+0x50>
  }
  release(&tickslock);
    80003ccc:	00033517          	auipc	a0,0x33
    80003cd0:	85c50513          	addi	a0,a0,-1956 # 80036528 <tickslock>
    80003cd4:	ffffd097          	auipc	ra,0xffffd
    80003cd8:	fb0080e7          	jalr	-80(ra) # 80000c84 <release>
  return 0;
    80003cdc:	4781                	li	a5,0
}
    80003cde:	853e                	mv	a0,a5
    80003ce0:	70e2                	ld	ra,56(sp)
    80003ce2:	7442                	ld	s0,48(sp)
    80003ce4:	74a2                	ld	s1,40(sp)
    80003ce6:	7902                	ld	s2,32(sp)
    80003ce8:	69e2                	ld	s3,24(sp)
    80003cea:	6121                	addi	sp,sp,64
    80003cec:	8082                	ret
      release(&tickslock);
    80003cee:	00033517          	auipc	a0,0x33
    80003cf2:	83a50513          	addi	a0,a0,-1990 # 80036528 <tickslock>
    80003cf6:	ffffd097          	auipc	ra,0xffffd
    80003cfa:	f8e080e7          	jalr	-114(ra) # 80000c84 <release>
      return -1;
    80003cfe:	57fd                	li	a5,-1
    80003d00:	bff9                	j	80003cde <sys_sleep+0x88>

0000000080003d02 <sys_kill>:

uint64
sys_kill(void)
{
    80003d02:	1101                	addi	sp,sp,-32
    80003d04:	ec06                	sd	ra,24(sp)
    80003d06:	e822                	sd	s0,16(sp)
    80003d08:	1000                	addi	s0,sp,32
  int pid;
  int signum;

  if(argint(0, &pid) < 0)
    80003d0a:	fec40593          	addi	a1,s0,-20
    80003d0e:	4501                	li	a0,0
    80003d10:	00000097          	auipc	ra,0x0
    80003d14:	cd0080e7          	jalr	-816(ra) # 800039e0 <argint>
    return -1;
    80003d18:	57fd                	li	a5,-1
  if(argint(0, &pid) < 0)
    80003d1a:	02054563          	bltz	a0,80003d44 <sys_kill+0x42>
  if(argint(1, &signum) < 0)
    80003d1e:	fe840593          	addi	a1,s0,-24
    80003d22:	4505                	li	a0,1
    80003d24:	00000097          	auipc	ra,0x0
    80003d28:	cbc080e7          	jalr	-836(ra) # 800039e0 <argint>
    return -1;
    80003d2c:	57fd                	li	a5,-1
  if(argint(1, &signum) < 0)
    80003d2e:	00054b63          	bltz	a0,80003d44 <sys_kill+0x42>
  return kill(pid, signum);
    80003d32:	fe842583          	lw	a1,-24(s0)
    80003d36:	fec42503          	lw	a0,-20(s0)
    80003d3a:	fffff097          	auipc	ra,0xfffff
    80003d3e:	2dc080e7          	jalr	732(ra) # 80003016 <kill>
    80003d42:	87aa                	mv	a5,a0
}
    80003d44:	853e                	mv	a0,a5
    80003d46:	60e2                	ld	ra,24(sp)
    80003d48:	6442                	ld	s0,16(sp)
    80003d4a:	6105                	addi	sp,sp,32
    80003d4c:	8082                	ret

0000000080003d4e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003d4e:	1101                	addi	sp,sp,-32
    80003d50:	ec06                	sd	ra,24(sp)
    80003d52:	e822                	sd	s0,16(sp)
    80003d54:	e426                	sd	s1,8(sp)
    80003d56:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003d58:	00032517          	auipc	a0,0x32
    80003d5c:	7d050513          	addi	a0,a0,2000 # 80036528 <tickslock>
    80003d60:	ffffd097          	auipc	ra,0xffffd
    80003d64:	e6a080e7          	jalr	-406(ra) # 80000bca <acquire>
  xticks = ticks;
    80003d68:	00006497          	auipc	s1,0x6
    80003d6c:	2d04a483          	lw	s1,720(s1) # 8000a038 <ticks>
  release(&tickslock);
    80003d70:	00032517          	auipc	a0,0x32
    80003d74:	7b850513          	addi	a0,a0,1976 # 80036528 <tickslock>
    80003d78:	ffffd097          	auipc	ra,0xffffd
    80003d7c:	f0c080e7          	jalr	-244(ra) # 80000c84 <release>
  return xticks;
}
    80003d80:	02049513          	slli	a0,s1,0x20
    80003d84:	9101                	srli	a0,a0,0x20
    80003d86:	60e2                	ld	ra,24(sp)
    80003d88:	6442                	ld	s0,16(sp)
    80003d8a:	64a2                	ld	s1,8(sp)
    80003d8c:	6105                	addi	sp,sp,32
    80003d8e:	8082                	ret

0000000080003d90 <sys_kthread_create>:



uint64
sys_kthread_create(void)
{
    80003d90:	1101                	addi	sp,sp,-32
    80003d92:	ec06                	sd	ra,24(sp)
    80003d94:	e822                	sd	s0,16(sp)
    80003d96:	1000                	addi	s0,sp,32
  void (*start_func)(void);
  void* stack;
  if(argaddr(0, (void*)&start_func) < 0)
    80003d98:	fe840593          	addi	a1,s0,-24
    80003d9c:	4501                	li	a0,0
    80003d9e:	00000097          	auipc	ra,0x0
    80003da2:	c64080e7          	jalr	-924(ra) # 80003a02 <argaddr>
    return -1;
    80003da6:	57fd                	li	a5,-1
  if(argaddr(0, (void*)&start_func) < 0)
    80003da8:	02054563          	bltz	a0,80003dd2 <sys_kthread_create+0x42>
  if(argaddr(1, (void*)&stack) < 0)
    80003dac:	fe040593          	addi	a1,s0,-32
    80003db0:	4505                	li	a0,1
    80003db2:	00000097          	auipc	ra,0x0
    80003db6:	c50080e7          	jalr	-944(ra) # 80003a02 <argaddr>
    return -1;
    80003dba:	57fd                	li	a5,-1
  if(argaddr(1, (void*)&stack) < 0)
    80003dbc:	00054b63          	bltz	a0,80003dd2 <sys_kthread_create+0x42>
  return kthread_create(start_func, stack);
    80003dc0:	fe043583          	ld	a1,-32(s0)
    80003dc4:	fe843503          	ld	a0,-24(s0)
    80003dc8:	ffffe097          	auipc	ra,0xffffe
    80003dcc:	64e080e7          	jalr	1614(ra) # 80002416 <kthread_create>
    80003dd0:	87aa                	mv	a5,a0
}
    80003dd2:	853e                	mv	a0,a5
    80003dd4:	60e2                	ld	ra,24(sp)
    80003dd6:	6442                	ld	s0,16(sp)
    80003dd8:	6105                	addi	sp,sp,32
    80003dda:	8082                	ret

0000000080003ddc <sys_kthread_id>:

uint64
sys_kthread_id(void){
    80003ddc:	1141                	addi	sp,sp,-16
    80003dde:	e406                	sd	ra,8(sp)
    80003de0:	e022                	sd	s0,0(sp)
    80003de2:	0800                	addi	s0,sp,16
  return kthread_id();
    80003de4:	ffffe097          	auipc	ra,0xffffe
    80003de8:	6fa080e7          	jalr	1786(ra) # 800024de <kthread_id>
}
    80003dec:	60a2                	ld	ra,8(sp)
    80003dee:	6402                	ld	s0,0(sp)
    80003df0:	0141                	addi	sp,sp,16
    80003df2:	8082                	ret

0000000080003df4 <sys_kthread_exit>:

uint64
sys_kthread_exit(void){
    80003df4:	1101                	addi	sp,sp,-32
    80003df6:	ec06                	sd	ra,24(sp)
    80003df8:	e822                	sd	s0,16(sp)
    80003dfa:	1000                	addi	s0,sp,32
  int status;

  if(argint(0, &status) < 0)
    80003dfc:	fec40593          	addi	a1,s0,-20
    80003e00:	4501                	li	a0,0
    80003e02:	00000097          	auipc	ra,0x0
    80003e06:	bde080e7          	jalr	-1058(ra) # 800039e0 <argint>
    return -1;
    80003e0a:	57fd                	li	a5,-1
  if(argint(0, &status) < 0)
    80003e0c:	00054963          	bltz	a0,80003e1e <sys_kthread_exit+0x2a>
  kthread_exit(status);
    80003e10:	fec42503          	lw	a0,-20(s0)
    80003e14:	fffff097          	auipc	ra,0xfffff
    80003e18:	14a080e7          	jalr	330(ra) # 80002f5e <kthread_exit>
  return 0; //not reached
    80003e1c:	4781                	li	a5,0
}
    80003e1e:	853e                	mv	a0,a5
    80003e20:	60e2                	ld	ra,24(sp)
    80003e22:	6442                	ld	s0,16(sp)
    80003e24:	6105                	addi	sp,sp,32
    80003e26:	8082                	ret

0000000080003e28 <sys_kthread_join>:

uint64
sys_kthread_join(void)
{
    80003e28:	1101                	addi	sp,sp,-32
    80003e2a:	ec06                	sd	ra,24(sp)
    80003e2c:	e822                	sd	s0,16(sp)
    80003e2e:	1000                	addi	s0,sp,32
  int thread_id;
  uint64 status;
  if(argint(0, &thread_id) < 0)
    80003e30:	fec40593          	addi	a1,s0,-20
    80003e34:	4501                	li	a0,0
    80003e36:	00000097          	auipc	ra,0x0
    80003e3a:	baa080e7          	jalr	-1110(ra) # 800039e0 <argint>
    return -1;
    80003e3e:	57fd                	li	a5,-1
  if(argint(0, &thread_id) < 0)
    80003e40:	02054563          	bltz	a0,80003e6a <sys_kthread_join+0x42>
  if(argaddr(1, &status) < 0)
    80003e44:	fe040593          	addi	a1,s0,-32
    80003e48:	4505                	li	a0,1
    80003e4a:	00000097          	auipc	ra,0x0
    80003e4e:	bb8080e7          	jalr	-1096(ra) # 80003a02 <argaddr>
    return -1;
    80003e52:	57fd                	li	a5,-1
  if(argaddr(1, &status) < 0)
    80003e54:	00054b63          	bltz	a0,80003e6a <sys_kthread_join+0x42>
  return kthread_join(thread_id,(int *)status);
    80003e58:	fe043583          	ld	a1,-32(s0)
    80003e5c:	fec42503          	lw	a0,-20(s0)
    80003e60:	fffff097          	auipc	ra,0xfffff
    80003e64:	a62080e7          	jalr	-1438(ra) # 800028c2 <kthread_join>
    80003e68:	87aa                	mv	a5,a0
}
    80003e6a:	853e                	mv	a0,a5
    80003e6c:	60e2                	ld	ra,24(sp)
    80003e6e:	6442                	ld	s0,16(sp)
    80003e70:	6105                	addi	sp,sp,32
    80003e72:	8082                	ret

0000000080003e74 <sys_bsem_alloc>:

uint64
sys_bsem_alloc(void){
    80003e74:	1141                	addi	sp,sp,-16
    80003e76:	e406                	sd	ra,8(sp)
    80003e78:	e022                	sd	s0,0(sp)
    80003e7a:	0800                	addi	s0,sp,16
  return bsem_alloc();
    80003e7c:	ffffe097          	auipc	ra,0xffffe
    80003e80:	682080e7          	jalr	1666(ra) # 800024fe <bsem_alloc>
}
    80003e84:	60a2                	ld	ra,8(sp)
    80003e86:	6402                	ld	s0,0(sp)
    80003e88:	0141                	addi	sp,sp,16
    80003e8a:	8082                	ret

0000000080003e8c <sys_bsem_free>:

uint64
sys_bsem_free(void){
    80003e8c:	1101                	addi	sp,sp,-32
    80003e8e:	ec06                	sd	ra,24(sp)
    80003e90:	e822                	sd	s0,16(sp)
    80003e92:	1000                	addi	s0,sp,32
  int desc;

  if(argint(0, &desc) < 0)
    80003e94:	fec40593          	addi	a1,s0,-20
    80003e98:	4501                	li	a0,0
    80003e9a:	00000097          	auipc	ra,0x0
    80003e9e:	b46080e7          	jalr	-1210(ra) # 800039e0 <argint>
    return -1;
    80003ea2:	57fd                	li	a5,-1
  if(argint(0, &desc) < 0)
    80003ea4:	00054963          	bltz	a0,80003eb6 <sys_bsem_free+0x2a>
  bsem_free(desc);
    80003ea8:	fec42503          	lw	a0,-20(s0)
    80003eac:	ffffe097          	auipc	ra,0xffffe
    80003eb0:	6e2080e7          	jalr	1762(ra) # 8000258e <bsem_free>
  return 0;
    80003eb4:	4781                	li	a5,0
}
    80003eb6:	853e                	mv	a0,a5
    80003eb8:	60e2                	ld	ra,24(sp)
    80003eba:	6442                	ld	s0,16(sp)
    80003ebc:	6105                	addi	sp,sp,32
    80003ebe:	8082                	ret

0000000080003ec0 <sys_bsem_down>:

uint64
sys_bsem_down(void){
    80003ec0:	1101                	addi	sp,sp,-32
    80003ec2:	ec06                	sd	ra,24(sp)
    80003ec4:	e822                	sd	s0,16(sp)
    80003ec6:	1000                	addi	s0,sp,32
  int semaphore;

  if(argint(0, &semaphore) < 0)
    80003ec8:	fec40593          	addi	a1,s0,-20
    80003ecc:	4501                	li	a0,0
    80003ece:	00000097          	auipc	ra,0x0
    80003ed2:	b12080e7          	jalr	-1262(ra) # 800039e0 <argint>
    return -1;
    80003ed6:	57fd                	li	a5,-1
  if(argint(0, &semaphore) < 0)
    80003ed8:	00054963          	bltz	a0,80003eea <sys_bsem_down+0x2a>
  bsem_down(semaphore);
    80003edc:	fec42503          	lw	a0,-20(s0)
    80003ee0:	fffff097          	auipc	ra,0xfffff
    80003ee4:	b08080e7          	jalr	-1272(ra) # 800029e8 <bsem_down>
  return 0;
    80003ee8:	4781                	li	a5,0
}
    80003eea:	853e                	mv	a0,a5
    80003eec:	60e2                	ld	ra,24(sp)
    80003eee:	6442                	ld	s0,16(sp)
    80003ef0:	6105                	addi	sp,sp,32
    80003ef2:	8082                	ret

0000000080003ef4 <sys_bsem_up>:

uint64
sys_bsem_up(void){
    80003ef4:	1101                	addi	sp,sp,-32
    80003ef6:	ec06                	sd	ra,24(sp)
    80003ef8:	e822                	sd	s0,16(sp)
    80003efa:	1000                	addi	s0,sp,32
  int semaphore;

  if(argint(0, &semaphore) < 0)
    80003efc:	fec40593          	addi	a1,s0,-20
    80003f00:	4501                	li	a0,0
    80003f02:	00000097          	auipc	ra,0x0
    80003f06:	ade080e7          	jalr	-1314(ra) # 800039e0 <argint>
    return -1;
    80003f0a:	57fd                	li	a5,-1
  if(argint(0, &semaphore) < 0)
    80003f0c:	00054963          	bltz	a0,80003f1e <sys_bsem_up+0x2a>
  bsem_up(semaphore);
    80003f10:	fec42503          	lw	a0,-20(s0)
    80003f14:	fffff097          	auipc	ra,0xfffff
    80003f18:	ee4080e7          	jalr	-284(ra) # 80002df8 <bsem_up>
  return 0;
    80003f1c:	4781                	li	a5,0
    80003f1e:	853e                	mv	a0,a5
    80003f20:	60e2                	ld	ra,24(sp)
    80003f22:	6442                	ld	s0,16(sp)
    80003f24:	6105                	addi	sp,sp,32
    80003f26:	8082                	ret

0000000080003f28 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003f28:	7179                	addi	sp,sp,-48
    80003f2a:	f406                	sd	ra,40(sp)
    80003f2c:	f022                	sd	s0,32(sp)
    80003f2e:	ec26                	sd	s1,24(sp)
    80003f30:	e84a                	sd	s2,16(sp)
    80003f32:	e44e                	sd	s3,8(sp)
    80003f34:	e052                	sd	s4,0(sp)
    80003f36:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003f38:	00005597          	auipc	a1,0x5
    80003f3c:	5f858593          	addi	a1,a1,1528 # 80009530 <syscalls+0x108>
    80003f40:	00032517          	auipc	a0,0x32
    80003f44:	60050513          	addi	a0,a0,1536 # 80036540 <bcache>
    80003f48:	ffffd097          	auipc	ra,0xffffd
    80003f4c:	bea080e7          	jalr	-1046(ra) # 80000b32 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003f50:	0003a797          	auipc	a5,0x3a
    80003f54:	5f078793          	addi	a5,a5,1520 # 8003e540 <bcache+0x8000>
    80003f58:	0003b717          	auipc	a4,0x3b
    80003f5c:	85070713          	addi	a4,a4,-1968 # 8003e7a8 <bcache+0x8268>
    80003f60:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003f64:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003f68:	00032497          	auipc	s1,0x32
    80003f6c:	5f048493          	addi	s1,s1,1520 # 80036558 <bcache+0x18>
    b->next = bcache.head.next;
    80003f70:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003f72:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003f74:	00005a17          	auipc	s4,0x5
    80003f78:	5c4a0a13          	addi	s4,s4,1476 # 80009538 <syscalls+0x110>
    b->next = bcache.head.next;
    80003f7c:	2b893783          	ld	a5,696(s2)
    80003f80:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003f82:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003f86:	85d2                	mv	a1,s4
    80003f88:	01048513          	addi	a0,s1,16
    80003f8c:	00001097          	auipc	ra,0x1
    80003f90:	4c6080e7          	jalr	1222(ra) # 80005452 <initsleeplock>
    bcache.head.next->prev = b;
    80003f94:	2b893783          	ld	a5,696(s2)
    80003f98:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003f9a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003f9e:	45848493          	addi	s1,s1,1112
    80003fa2:	fd349de3          	bne	s1,s3,80003f7c <binit+0x54>
  }
}
    80003fa6:	70a2                	ld	ra,40(sp)
    80003fa8:	7402                	ld	s0,32(sp)
    80003faa:	64e2                	ld	s1,24(sp)
    80003fac:	6942                	ld	s2,16(sp)
    80003fae:	69a2                	ld	s3,8(sp)
    80003fb0:	6a02                	ld	s4,0(sp)
    80003fb2:	6145                	addi	sp,sp,48
    80003fb4:	8082                	ret

0000000080003fb6 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003fb6:	7179                	addi	sp,sp,-48
    80003fb8:	f406                	sd	ra,40(sp)
    80003fba:	f022                	sd	s0,32(sp)
    80003fbc:	ec26                	sd	s1,24(sp)
    80003fbe:	e84a                	sd	s2,16(sp)
    80003fc0:	e44e                	sd	s3,8(sp)
    80003fc2:	1800                	addi	s0,sp,48
    80003fc4:	892a                	mv	s2,a0
    80003fc6:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003fc8:	00032517          	auipc	a0,0x32
    80003fcc:	57850513          	addi	a0,a0,1400 # 80036540 <bcache>
    80003fd0:	ffffd097          	auipc	ra,0xffffd
    80003fd4:	bfa080e7          	jalr	-1030(ra) # 80000bca <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003fd8:	0003b497          	auipc	s1,0x3b
    80003fdc:	8204b483          	ld	s1,-2016(s1) # 8003e7f8 <bcache+0x82b8>
    80003fe0:	0003a797          	auipc	a5,0x3a
    80003fe4:	7c878793          	addi	a5,a5,1992 # 8003e7a8 <bcache+0x8268>
    80003fe8:	02f48f63          	beq	s1,a5,80004026 <bread+0x70>
    80003fec:	873e                	mv	a4,a5
    80003fee:	a021                	j	80003ff6 <bread+0x40>
    80003ff0:	68a4                	ld	s1,80(s1)
    80003ff2:	02e48a63          	beq	s1,a4,80004026 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003ff6:	449c                	lw	a5,8(s1)
    80003ff8:	ff279ce3          	bne	a5,s2,80003ff0 <bread+0x3a>
    80003ffc:	44dc                	lw	a5,12(s1)
    80003ffe:	ff3799e3          	bne	a5,s3,80003ff0 <bread+0x3a>
      b->refcnt++;
    80004002:	40bc                	lw	a5,64(s1)
    80004004:	2785                	addiw	a5,a5,1
    80004006:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80004008:	00032517          	auipc	a0,0x32
    8000400c:	53850513          	addi	a0,a0,1336 # 80036540 <bcache>
    80004010:	ffffd097          	auipc	ra,0xffffd
    80004014:	c74080e7          	jalr	-908(ra) # 80000c84 <release>
      acquiresleep(&b->lock);
    80004018:	01048513          	addi	a0,s1,16
    8000401c:	00001097          	auipc	ra,0x1
    80004020:	470080e7          	jalr	1136(ra) # 8000548c <acquiresleep>
      return b;
    80004024:	a8b9                	j	80004082 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80004026:	0003a497          	auipc	s1,0x3a
    8000402a:	7ca4b483          	ld	s1,1994(s1) # 8003e7f0 <bcache+0x82b0>
    8000402e:	0003a797          	auipc	a5,0x3a
    80004032:	77a78793          	addi	a5,a5,1914 # 8003e7a8 <bcache+0x8268>
    80004036:	00f48863          	beq	s1,a5,80004046 <bread+0x90>
    8000403a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000403c:	40bc                	lw	a5,64(s1)
    8000403e:	cf81                	beqz	a5,80004056 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80004040:	64a4                	ld	s1,72(s1)
    80004042:	fee49de3          	bne	s1,a4,8000403c <bread+0x86>
  panic("bget: no buffers");
    80004046:	00005517          	auipc	a0,0x5
    8000404a:	4fa50513          	addi	a0,a0,1274 # 80009540 <syscalls+0x118>
    8000404e:	ffffc097          	auipc	ra,0xffffc
    80004052:	4dc080e7          	jalr	1244(ra) # 8000052a <panic>
      b->dev = dev;
    80004056:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000405a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000405e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80004062:	4785                	li	a5,1
    80004064:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80004066:	00032517          	auipc	a0,0x32
    8000406a:	4da50513          	addi	a0,a0,1242 # 80036540 <bcache>
    8000406e:	ffffd097          	auipc	ra,0xffffd
    80004072:	c16080e7          	jalr	-1002(ra) # 80000c84 <release>
      acquiresleep(&b->lock);
    80004076:	01048513          	addi	a0,s1,16
    8000407a:	00001097          	auipc	ra,0x1
    8000407e:	412080e7          	jalr	1042(ra) # 8000548c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80004082:	409c                	lw	a5,0(s1)
    80004084:	cb89                	beqz	a5,80004096 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80004086:	8526                	mv	a0,s1
    80004088:	70a2                	ld	ra,40(sp)
    8000408a:	7402                	ld	s0,32(sp)
    8000408c:	64e2                	ld	s1,24(sp)
    8000408e:	6942                	ld	s2,16(sp)
    80004090:	69a2                	ld	s3,8(sp)
    80004092:	6145                	addi	sp,sp,48
    80004094:	8082                	ret
    virtio_disk_rw(b, 0);
    80004096:	4581                	li	a1,0
    80004098:	8526                	mv	a0,s1
    8000409a:	00003097          	auipc	ra,0x3
    8000409e:	fac080e7          	jalr	-84(ra) # 80007046 <virtio_disk_rw>
    b->valid = 1;
    800040a2:	4785                	li	a5,1
    800040a4:	c09c                	sw	a5,0(s1)
  return b;
    800040a6:	b7c5                	j	80004086 <bread+0xd0>

00000000800040a8 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800040a8:	1101                	addi	sp,sp,-32
    800040aa:	ec06                	sd	ra,24(sp)
    800040ac:	e822                	sd	s0,16(sp)
    800040ae:	e426                	sd	s1,8(sp)
    800040b0:	1000                	addi	s0,sp,32
    800040b2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800040b4:	0541                	addi	a0,a0,16
    800040b6:	00001097          	auipc	ra,0x1
    800040ba:	470080e7          	jalr	1136(ra) # 80005526 <holdingsleep>
    800040be:	cd01                	beqz	a0,800040d6 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800040c0:	4585                	li	a1,1
    800040c2:	8526                	mv	a0,s1
    800040c4:	00003097          	auipc	ra,0x3
    800040c8:	f82080e7          	jalr	-126(ra) # 80007046 <virtio_disk_rw>
}
    800040cc:	60e2                	ld	ra,24(sp)
    800040ce:	6442                	ld	s0,16(sp)
    800040d0:	64a2                	ld	s1,8(sp)
    800040d2:	6105                	addi	sp,sp,32
    800040d4:	8082                	ret
    panic("bwrite");
    800040d6:	00005517          	auipc	a0,0x5
    800040da:	48250513          	addi	a0,a0,1154 # 80009558 <syscalls+0x130>
    800040de:	ffffc097          	auipc	ra,0xffffc
    800040e2:	44c080e7          	jalr	1100(ra) # 8000052a <panic>

00000000800040e6 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800040e6:	1101                	addi	sp,sp,-32
    800040e8:	ec06                	sd	ra,24(sp)
    800040ea:	e822                	sd	s0,16(sp)
    800040ec:	e426                	sd	s1,8(sp)
    800040ee:	e04a                	sd	s2,0(sp)
    800040f0:	1000                	addi	s0,sp,32
    800040f2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800040f4:	01050913          	addi	s2,a0,16
    800040f8:	854a                	mv	a0,s2
    800040fa:	00001097          	auipc	ra,0x1
    800040fe:	42c080e7          	jalr	1068(ra) # 80005526 <holdingsleep>
    80004102:	c92d                	beqz	a0,80004174 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80004104:	854a                	mv	a0,s2
    80004106:	00001097          	auipc	ra,0x1
    8000410a:	3dc080e7          	jalr	988(ra) # 800054e2 <releasesleep>

  acquire(&bcache.lock);
    8000410e:	00032517          	auipc	a0,0x32
    80004112:	43250513          	addi	a0,a0,1074 # 80036540 <bcache>
    80004116:	ffffd097          	auipc	ra,0xffffd
    8000411a:	ab4080e7          	jalr	-1356(ra) # 80000bca <acquire>
  b->refcnt--;
    8000411e:	40bc                	lw	a5,64(s1)
    80004120:	37fd                	addiw	a5,a5,-1
    80004122:	0007871b          	sext.w	a4,a5
    80004126:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80004128:	eb05                	bnez	a4,80004158 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000412a:	68bc                	ld	a5,80(s1)
    8000412c:	64b8                	ld	a4,72(s1)
    8000412e:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80004130:	64bc                	ld	a5,72(s1)
    80004132:	68b8                	ld	a4,80(s1)
    80004134:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80004136:	0003a797          	auipc	a5,0x3a
    8000413a:	40a78793          	addi	a5,a5,1034 # 8003e540 <bcache+0x8000>
    8000413e:	2b87b703          	ld	a4,696(a5)
    80004142:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80004144:	0003a717          	auipc	a4,0x3a
    80004148:	66470713          	addi	a4,a4,1636 # 8003e7a8 <bcache+0x8268>
    8000414c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000414e:	2b87b703          	ld	a4,696(a5)
    80004152:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80004154:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80004158:	00032517          	auipc	a0,0x32
    8000415c:	3e850513          	addi	a0,a0,1000 # 80036540 <bcache>
    80004160:	ffffd097          	auipc	ra,0xffffd
    80004164:	b24080e7          	jalr	-1244(ra) # 80000c84 <release>
}
    80004168:	60e2                	ld	ra,24(sp)
    8000416a:	6442                	ld	s0,16(sp)
    8000416c:	64a2                	ld	s1,8(sp)
    8000416e:	6902                	ld	s2,0(sp)
    80004170:	6105                	addi	sp,sp,32
    80004172:	8082                	ret
    panic("brelse");
    80004174:	00005517          	auipc	a0,0x5
    80004178:	3ec50513          	addi	a0,a0,1004 # 80009560 <syscalls+0x138>
    8000417c:	ffffc097          	auipc	ra,0xffffc
    80004180:	3ae080e7          	jalr	942(ra) # 8000052a <panic>

0000000080004184 <bpin>:

void
bpin(struct buf *b) {
    80004184:	1101                	addi	sp,sp,-32
    80004186:	ec06                	sd	ra,24(sp)
    80004188:	e822                	sd	s0,16(sp)
    8000418a:	e426                	sd	s1,8(sp)
    8000418c:	1000                	addi	s0,sp,32
    8000418e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80004190:	00032517          	auipc	a0,0x32
    80004194:	3b050513          	addi	a0,a0,944 # 80036540 <bcache>
    80004198:	ffffd097          	auipc	ra,0xffffd
    8000419c:	a32080e7          	jalr	-1486(ra) # 80000bca <acquire>
  b->refcnt++;
    800041a0:	40bc                	lw	a5,64(s1)
    800041a2:	2785                	addiw	a5,a5,1
    800041a4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800041a6:	00032517          	auipc	a0,0x32
    800041aa:	39a50513          	addi	a0,a0,922 # 80036540 <bcache>
    800041ae:	ffffd097          	auipc	ra,0xffffd
    800041b2:	ad6080e7          	jalr	-1322(ra) # 80000c84 <release>
}
    800041b6:	60e2                	ld	ra,24(sp)
    800041b8:	6442                	ld	s0,16(sp)
    800041ba:	64a2                	ld	s1,8(sp)
    800041bc:	6105                	addi	sp,sp,32
    800041be:	8082                	ret

00000000800041c0 <bunpin>:

void
bunpin(struct buf *b) {
    800041c0:	1101                	addi	sp,sp,-32
    800041c2:	ec06                	sd	ra,24(sp)
    800041c4:	e822                	sd	s0,16(sp)
    800041c6:	e426                	sd	s1,8(sp)
    800041c8:	1000                	addi	s0,sp,32
    800041ca:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800041cc:	00032517          	auipc	a0,0x32
    800041d0:	37450513          	addi	a0,a0,884 # 80036540 <bcache>
    800041d4:	ffffd097          	auipc	ra,0xffffd
    800041d8:	9f6080e7          	jalr	-1546(ra) # 80000bca <acquire>
  b->refcnt--;
    800041dc:	40bc                	lw	a5,64(s1)
    800041de:	37fd                	addiw	a5,a5,-1
    800041e0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800041e2:	00032517          	auipc	a0,0x32
    800041e6:	35e50513          	addi	a0,a0,862 # 80036540 <bcache>
    800041ea:	ffffd097          	auipc	ra,0xffffd
    800041ee:	a9a080e7          	jalr	-1382(ra) # 80000c84 <release>
}
    800041f2:	60e2                	ld	ra,24(sp)
    800041f4:	6442                	ld	s0,16(sp)
    800041f6:	64a2                	ld	s1,8(sp)
    800041f8:	6105                	addi	sp,sp,32
    800041fa:	8082                	ret

00000000800041fc <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800041fc:	1101                	addi	sp,sp,-32
    800041fe:	ec06                	sd	ra,24(sp)
    80004200:	e822                	sd	s0,16(sp)
    80004202:	e426                	sd	s1,8(sp)
    80004204:	e04a                	sd	s2,0(sp)
    80004206:	1000                	addi	s0,sp,32
    80004208:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000420a:	00d5d59b          	srliw	a1,a1,0xd
    8000420e:	0003b797          	auipc	a5,0x3b
    80004212:	a0e7a783          	lw	a5,-1522(a5) # 8003ec1c <sb+0x1c>
    80004216:	9dbd                	addw	a1,a1,a5
    80004218:	00000097          	auipc	ra,0x0
    8000421c:	d9e080e7          	jalr	-610(ra) # 80003fb6 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80004220:	0074f713          	andi	a4,s1,7
    80004224:	4785                	li	a5,1
    80004226:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000422a:	14ce                	slli	s1,s1,0x33
    8000422c:	90d9                	srli	s1,s1,0x36
    8000422e:	00950733          	add	a4,a0,s1
    80004232:	05874703          	lbu	a4,88(a4)
    80004236:	00e7f6b3          	and	a3,a5,a4
    8000423a:	c69d                	beqz	a3,80004268 <bfree+0x6c>
    8000423c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000423e:	94aa                	add	s1,s1,a0
    80004240:	fff7c793          	not	a5,a5
    80004244:	8ff9                	and	a5,a5,a4
    80004246:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000424a:	00001097          	auipc	ra,0x1
    8000424e:	122080e7          	jalr	290(ra) # 8000536c <log_write>
  brelse(bp);
    80004252:	854a                	mv	a0,s2
    80004254:	00000097          	auipc	ra,0x0
    80004258:	e92080e7          	jalr	-366(ra) # 800040e6 <brelse>
}
    8000425c:	60e2                	ld	ra,24(sp)
    8000425e:	6442                	ld	s0,16(sp)
    80004260:	64a2                	ld	s1,8(sp)
    80004262:	6902                	ld	s2,0(sp)
    80004264:	6105                	addi	sp,sp,32
    80004266:	8082                	ret
    panic("freeing free block");
    80004268:	00005517          	auipc	a0,0x5
    8000426c:	30050513          	addi	a0,a0,768 # 80009568 <syscalls+0x140>
    80004270:	ffffc097          	auipc	ra,0xffffc
    80004274:	2ba080e7          	jalr	698(ra) # 8000052a <panic>

0000000080004278 <balloc>:
{
    80004278:	711d                	addi	sp,sp,-96
    8000427a:	ec86                	sd	ra,88(sp)
    8000427c:	e8a2                	sd	s0,80(sp)
    8000427e:	e4a6                	sd	s1,72(sp)
    80004280:	e0ca                	sd	s2,64(sp)
    80004282:	fc4e                	sd	s3,56(sp)
    80004284:	f852                	sd	s4,48(sp)
    80004286:	f456                	sd	s5,40(sp)
    80004288:	f05a                	sd	s6,32(sp)
    8000428a:	ec5e                	sd	s7,24(sp)
    8000428c:	e862                	sd	s8,16(sp)
    8000428e:	e466                	sd	s9,8(sp)
    80004290:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80004292:	0003b797          	auipc	a5,0x3b
    80004296:	9727a783          	lw	a5,-1678(a5) # 8003ec04 <sb+0x4>
    8000429a:	cbd1                	beqz	a5,8000432e <balloc+0xb6>
    8000429c:	8baa                	mv	s7,a0
    8000429e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800042a0:	0003bb17          	auipc	s6,0x3b
    800042a4:	960b0b13          	addi	s6,s6,-1696 # 8003ec00 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800042a8:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800042aa:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800042ac:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800042ae:	6c89                	lui	s9,0x2
    800042b0:	a831                	j	800042cc <balloc+0x54>
    brelse(bp);
    800042b2:	854a                	mv	a0,s2
    800042b4:	00000097          	auipc	ra,0x0
    800042b8:	e32080e7          	jalr	-462(ra) # 800040e6 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800042bc:	015c87bb          	addw	a5,s9,s5
    800042c0:	00078a9b          	sext.w	s5,a5
    800042c4:	004b2703          	lw	a4,4(s6)
    800042c8:	06eaf363          	bgeu	s5,a4,8000432e <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800042cc:	41fad79b          	sraiw	a5,s5,0x1f
    800042d0:	0137d79b          	srliw	a5,a5,0x13
    800042d4:	015787bb          	addw	a5,a5,s5
    800042d8:	40d7d79b          	sraiw	a5,a5,0xd
    800042dc:	01cb2583          	lw	a1,28(s6)
    800042e0:	9dbd                	addw	a1,a1,a5
    800042e2:	855e                	mv	a0,s7
    800042e4:	00000097          	auipc	ra,0x0
    800042e8:	cd2080e7          	jalr	-814(ra) # 80003fb6 <bread>
    800042ec:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800042ee:	004b2503          	lw	a0,4(s6)
    800042f2:	000a849b          	sext.w	s1,s5
    800042f6:	8662                	mv	a2,s8
    800042f8:	faa4fde3          	bgeu	s1,a0,800042b2 <balloc+0x3a>
      m = 1 << (bi % 8);
    800042fc:	41f6579b          	sraiw	a5,a2,0x1f
    80004300:	01d7d69b          	srliw	a3,a5,0x1d
    80004304:	00c6873b          	addw	a4,a3,a2
    80004308:	00777793          	andi	a5,a4,7
    8000430c:	9f95                	subw	a5,a5,a3
    8000430e:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80004312:	4037571b          	sraiw	a4,a4,0x3
    80004316:	00e906b3          	add	a3,s2,a4
    8000431a:	0586c683          	lbu	a3,88(a3) # 2000058 <_entry-0x7dffffa8>
    8000431e:	00d7f5b3          	and	a1,a5,a3
    80004322:	cd91                	beqz	a1,8000433e <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004324:	2605                	addiw	a2,a2,1
    80004326:	2485                	addiw	s1,s1,1
    80004328:	fd4618e3          	bne	a2,s4,800042f8 <balloc+0x80>
    8000432c:	b759                	j	800042b2 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000432e:	00005517          	auipc	a0,0x5
    80004332:	25250513          	addi	a0,a0,594 # 80009580 <syscalls+0x158>
    80004336:	ffffc097          	auipc	ra,0xffffc
    8000433a:	1f4080e7          	jalr	500(ra) # 8000052a <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000433e:	974a                	add	a4,a4,s2
    80004340:	8fd5                	or	a5,a5,a3
    80004342:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80004346:	854a                	mv	a0,s2
    80004348:	00001097          	auipc	ra,0x1
    8000434c:	024080e7          	jalr	36(ra) # 8000536c <log_write>
        brelse(bp);
    80004350:	854a                	mv	a0,s2
    80004352:	00000097          	auipc	ra,0x0
    80004356:	d94080e7          	jalr	-620(ra) # 800040e6 <brelse>
  bp = bread(dev, bno);
    8000435a:	85a6                	mv	a1,s1
    8000435c:	855e                	mv	a0,s7
    8000435e:	00000097          	auipc	ra,0x0
    80004362:	c58080e7          	jalr	-936(ra) # 80003fb6 <bread>
    80004366:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80004368:	40000613          	li	a2,1024
    8000436c:	4581                	li	a1,0
    8000436e:	05850513          	addi	a0,a0,88
    80004372:	ffffd097          	auipc	ra,0xffffd
    80004376:	95a080e7          	jalr	-1702(ra) # 80000ccc <memset>
  log_write(bp);
    8000437a:	854a                	mv	a0,s2
    8000437c:	00001097          	auipc	ra,0x1
    80004380:	ff0080e7          	jalr	-16(ra) # 8000536c <log_write>
  brelse(bp);
    80004384:	854a                	mv	a0,s2
    80004386:	00000097          	auipc	ra,0x0
    8000438a:	d60080e7          	jalr	-672(ra) # 800040e6 <brelse>
}
    8000438e:	8526                	mv	a0,s1
    80004390:	60e6                	ld	ra,88(sp)
    80004392:	6446                	ld	s0,80(sp)
    80004394:	64a6                	ld	s1,72(sp)
    80004396:	6906                	ld	s2,64(sp)
    80004398:	79e2                	ld	s3,56(sp)
    8000439a:	7a42                	ld	s4,48(sp)
    8000439c:	7aa2                	ld	s5,40(sp)
    8000439e:	7b02                	ld	s6,32(sp)
    800043a0:	6be2                	ld	s7,24(sp)
    800043a2:	6c42                	ld	s8,16(sp)
    800043a4:	6ca2                	ld	s9,8(sp)
    800043a6:	6125                	addi	sp,sp,96
    800043a8:	8082                	ret

00000000800043aa <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800043aa:	7179                	addi	sp,sp,-48
    800043ac:	f406                	sd	ra,40(sp)
    800043ae:	f022                	sd	s0,32(sp)
    800043b0:	ec26                	sd	s1,24(sp)
    800043b2:	e84a                	sd	s2,16(sp)
    800043b4:	e44e                	sd	s3,8(sp)
    800043b6:	e052                	sd	s4,0(sp)
    800043b8:	1800                	addi	s0,sp,48
    800043ba:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800043bc:	47ad                	li	a5,11
    800043be:	04b7fe63          	bgeu	a5,a1,8000441a <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800043c2:	ff45849b          	addiw	s1,a1,-12
    800043c6:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800043ca:	0ff00793          	li	a5,255
    800043ce:	0ae7e463          	bltu	a5,a4,80004476 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800043d2:	08052583          	lw	a1,128(a0)
    800043d6:	c5b5                	beqz	a1,80004442 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800043d8:	00092503          	lw	a0,0(s2)
    800043dc:	00000097          	auipc	ra,0x0
    800043e0:	bda080e7          	jalr	-1062(ra) # 80003fb6 <bread>
    800043e4:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800043e6:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800043ea:	02049713          	slli	a4,s1,0x20
    800043ee:	01e75593          	srli	a1,a4,0x1e
    800043f2:	00b784b3          	add	s1,a5,a1
    800043f6:	0004a983          	lw	s3,0(s1)
    800043fa:	04098e63          	beqz	s3,80004456 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800043fe:	8552                	mv	a0,s4
    80004400:	00000097          	auipc	ra,0x0
    80004404:	ce6080e7          	jalr	-794(ra) # 800040e6 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80004408:	854e                	mv	a0,s3
    8000440a:	70a2                	ld	ra,40(sp)
    8000440c:	7402                	ld	s0,32(sp)
    8000440e:	64e2                	ld	s1,24(sp)
    80004410:	6942                	ld	s2,16(sp)
    80004412:	69a2                	ld	s3,8(sp)
    80004414:	6a02                	ld	s4,0(sp)
    80004416:	6145                	addi	sp,sp,48
    80004418:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000441a:	02059793          	slli	a5,a1,0x20
    8000441e:	01e7d593          	srli	a1,a5,0x1e
    80004422:	00b504b3          	add	s1,a0,a1
    80004426:	0504a983          	lw	s3,80(s1)
    8000442a:	fc099fe3          	bnez	s3,80004408 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000442e:	4108                	lw	a0,0(a0)
    80004430:	00000097          	auipc	ra,0x0
    80004434:	e48080e7          	jalr	-440(ra) # 80004278 <balloc>
    80004438:	0005099b          	sext.w	s3,a0
    8000443c:	0534a823          	sw	s3,80(s1)
    80004440:	b7e1                	j	80004408 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80004442:	4108                	lw	a0,0(a0)
    80004444:	00000097          	auipc	ra,0x0
    80004448:	e34080e7          	jalr	-460(ra) # 80004278 <balloc>
    8000444c:	0005059b          	sext.w	a1,a0
    80004450:	08b92023          	sw	a1,128(s2)
    80004454:	b751                	j	800043d8 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80004456:	00092503          	lw	a0,0(s2)
    8000445a:	00000097          	auipc	ra,0x0
    8000445e:	e1e080e7          	jalr	-482(ra) # 80004278 <balloc>
    80004462:	0005099b          	sext.w	s3,a0
    80004466:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000446a:	8552                	mv	a0,s4
    8000446c:	00001097          	auipc	ra,0x1
    80004470:	f00080e7          	jalr	-256(ra) # 8000536c <log_write>
    80004474:	b769                	j	800043fe <bmap+0x54>
  panic("bmap: out of range");
    80004476:	00005517          	auipc	a0,0x5
    8000447a:	12250513          	addi	a0,a0,290 # 80009598 <syscalls+0x170>
    8000447e:	ffffc097          	auipc	ra,0xffffc
    80004482:	0ac080e7          	jalr	172(ra) # 8000052a <panic>

0000000080004486 <iget>:
{
    80004486:	7179                	addi	sp,sp,-48
    80004488:	f406                	sd	ra,40(sp)
    8000448a:	f022                	sd	s0,32(sp)
    8000448c:	ec26                	sd	s1,24(sp)
    8000448e:	e84a                	sd	s2,16(sp)
    80004490:	e44e                	sd	s3,8(sp)
    80004492:	e052                	sd	s4,0(sp)
    80004494:	1800                	addi	s0,sp,48
    80004496:	89aa                	mv	s3,a0
    80004498:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000449a:	0003a517          	auipc	a0,0x3a
    8000449e:	78650513          	addi	a0,a0,1926 # 8003ec20 <itable>
    800044a2:	ffffc097          	auipc	ra,0xffffc
    800044a6:	728080e7          	jalr	1832(ra) # 80000bca <acquire>
  empty = 0;
    800044aa:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800044ac:	0003a497          	auipc	s1,0x3a
    800044b0:	78c48493          	addi	s1,s1,1932 # 8003ec38 <itable+0x18>
    800044b4:	0003c697          	auipc	a3,0x3c
    800044b8:	21468693          	addi	a3,a3,532 # 800406c8 <log>
    800044bc:	a039                	j	800044ca <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800044be:	02090b63          	beqz	s2,800044f4 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800044c2:	08848493          	addi	s1,s1,136
    800044c6:	02d48a63          	beq	s1,a3,800044fa <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800044ca:	449c                	lw	a5,8(s1)
    800044cc:	fef059e3          	blez	a5,800044be <iget+0x38>
    800044d0:	4098                	lw	a4,0(s1)
    800044d2:	ff3716e3          	bne	a4,s3,800044be <iget+0x38>
    800044d6:	40d8                	lw	a4,4(s1)
    800044d8:	ff4713e3          	bne	a4,s4,800044be <iget+0x38>
      ip->ref++;
    800044dc:	2785                	addiw	a5,a5,1
    800044de:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800044e0:	0003a517          	auipc	a0,0x3a
    800044e4:	74050513          	addi	a0,a0,1856 # 8003ec20 <itable>
    800044e8:	ffffc097          	auipc	ra,0xffffc
    800044ec:	79c080e7          	jalr	1948(ra) # 80000c84 <release>
      return ip;
    800044f0:	8926                	mv	s2,s1
    800044f2:	a03d                	j	80004520 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800044f4:	f7f9                	bnez	a5,800044c2 <iget+0x3c>
    800044f6:	8926                	mv	s2,s1
    800044f8:	b7e9                	j	800044c2 <iget+0x3c>
  if(empty == 0)
    800044fa:	02090c63          	beqz	s2,80004532 <iget+0xac>
  ip->dev = dev;
    800044fe:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80004502:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80004506:	4785                	li	a5,1
    80004508:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000450c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80004510:	0003a517          	auipc	a0,0x3a
    80004514:	71050513          	addi	a0,a0,1808 # 8003ec20 <itable>
    80004518:	ffffc097          	auipc	ra,0xffffc
    8000451c:	76c080e7          	jalr	1900(ra) # 80000c84 <release>
}
    80004520:	854a                	mv	a0,s2
    80004522:	70a2                	ld	ra,40(sp)
    80004524:	7402                	ld	s0,32(sp)
    80004526:	64e2                	ld	s1,24(sp)
    80004528:	6942                	ld	s2,16(sp)
    8000452a:	69a2                	ld	s3,8(sp)
    8000452c:	6a02                	ld	s4,0(sp)
    8000452e:	6145                	addi	sp,sp,48
    80004530:	8082                	ret
    panic("iget: no inodes");
    80004532:	00005517          	auipc	a0,0x5
    80004536:	07e50513          	addi	a0,a0,126 # 800095b0 <syscalls+0x188>
    8000453a:	ffffc097          	auipc	ra,0xffffc
    8000453e:	ff0080e7          	jalr	-16(ra) # 8000052a <panic>

0000000080004542 <fsinit>:
fsinit(int dev) {
    80004542:	7179                	addi	sp,sp,-48
    80004544:	f406                	sd	ra,40(sp)
    80004546:	f022                	sd	s0,32(sp)
    80004548:	ec26                	sd	s1,24(sp)
    8000454a:	e84a                	sd	s2,16(sp)
    8000454c:	e44e                	sd	s3,8(sp)
    8000454e:	1800                	addi	s0,sp,48
    80004550:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80004552:	4585                	li	a1,1
    80004554:	00000097          	auipc	ra,0x0
    80004558:	a62080e7          	jalr	-1438(ra) # 80003fb6 <bread>
    8000455c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000455e:	0003a997          	auipc	s3,0x3a
    80004562:	6a298993          	addi	s3,s3,1698 # 8003ec00 <sb>
    80004566:	02000613          	li	a2,32
    8000456a:	05850593          	addi	a1,a0,88
    8000456e:	854e                	mv	a0,s3
    80004570:	ffffc097          	auipc	ra,0xffffc
    80004574:	7b8080e7          	jalr	1976(ra) # 80000d28 <memmove>
  brelse(bp);
    80004578:	8526                	mv	a0,s1
    8000457a:	00000097          	auipc	ra,0x0
    8000457e:	b6c080e7          	jalr	-1172(ra) # 800040e6 <brelse>
  if(sb.magic != FSMAGIC)
    80004582:	0009a703          	lw	a4,0(s3)
    80004586:	102037b7          	lui	a5,0x10203
    8000458a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000458e:	02f71263          	bne	a4,a5,800045b2 <fsinit+0x70>
  initlog(dev, &sb);
    80004592:	0003a597          	auipc	a1,0x3a
    80004596:	66e58593          	addi	a1,a1,1646 # 8003ec00 <sb>
    8000459a:	854a                	mv	a0,s2
    8000459c:	00001097          	auipc	ra,0x1
    800045a0:	b52080e7          	jalr	-1198(ra) # 800050ee <initlog>
}
    800045a4:	70a2                	ld	ra,40(sp)
    800045a6:	7402                	ld	s0,32(sp)
    800045a8:	64e2                	ld	s1,24(sp)
    800045aa:	6942                	ld	s2,16(sp)
    800045ac:	69a2                	ld	s3,8(sp)
    800045ae:	6145                	addi	sp,sp,48
    800045b0:	8082                	ret
    panic("invalid file system");
    800045b2:	00005517          	auipc	a0,0x5
    800045b6:	00e50513          	addi	a0,a0,14 # 800095c0 <syscalls+0x198>
    800045ba:	ffffc097          	auipc	ra,0xffffc
    800045be:	f70080e7          	jalr	-144(ra) # 8000052a <panic>

00000000800045c2 <iinit>:
{
    800045c2:	7179                	addi	sp,sp,-48
    800045c4:	f406                	sd	ra,40(sp)
    800045c6:	f022                	sd	s0,32(sp)
    800045c8:	ec26                	sd	s1,24(sp)
    800045ca:	e84a                	sd	s2,16(sp)
    800045cc:	e44e                	sd	s3,8(sp)
    800045ce:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800045d0:	00005597          	auipc	a1,0x5
    800045d4:	00858593          	addi	a1,a1,8 # 800095d8 <syscalls+0x1b0>
    800045d8:	0003a517          	auipc	a0,0x3a
    800045dc:	64850513          	addi	a0,a0,1608 # 8003ec20 <itable>
    800045e0:	ffffc097          	auipc	ra,0xffffc
    800045e4:	552080e7          	jalr	1362(ra) # 80000b32 <initlock>
  for(i = 0; i < NINODE; i++) {
    800045e8:	0003a497          	auipc	s1,0x3a
    800045ec:	66048493          	addi	s1,s1,1632 # 8003ec48 <itable+0x28>
    800045f0:	0003c997          	auipc	s3,0x3c
    800045f4:	0e898993          	addi	s3,s3,232 # 800406d8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800045f8:	00005917          	auipc	s2,0x5
    800045fc:	fe890913          	addi	s2,s2,-24 # 800095e0 <syscalls+0x1b8>
    80004600:	85ca                	mv	a1,s2
    80004602:	8526                	mv	a0,s1
    80004604:	00001097          	auipc	ra,0x1
    80004608:	e4e080e7          	jalr	-434(ra) # 80005452 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000460c:	08848493          	addi	s1,s1,136
    80004610:	ff3498e3          	bne	s1,s3,80004600 <iinit+0x3e>
}
    80004614:	70a2                	ld	ra,40(sp)
    80004616:	7402                	ld	s0,32(sp)
    80004618:	64e2                	ld	s1,24(sp)
    8000461a:	6942                	ld	s2,16(sp)
    8000461c:	69a2                	ld	s3,8(sp)
    8000461e:	6145                	addi	sp,sp,48
    80004620:	8082                	ret

0000000080004622 <ialloc>:
{
    80004622:	715d                	addi	sp,sp,-80
    80004624:	e486                	sd	ra,72(sp)
    80004626:	e0a2                	sd	s0,64(sp)
    80004628:	fc26                	sd	s1,56(sp)
    8000462a:	f84a                	sd	s2,48(sp)
    8000462c:	f44e                	sd	s3,40(sp)
    8000462e:	f052                	sd	s4,32(sp)
    80004630:	ec56                	sd	s5,24(sp)
    80004632:	e85a                	sd	s6,16(sp)
    80004634:	e45e                	sd	s7,8(sp)
    80004636:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80004638:	0003a717          	auipc	a4,0x3a
    8000463c:	5d472703          	lw	a4,1492(a4) # 8003ec0c <sb+0xc>
    80004640:	4785                	li	a5,1
    80004642:	04e7fa63          	bgeu	a5,a4,80004696 <ialloc+0x74>
    80004646:	8aaa                	mv	s5,a0
    80004648:	8bae                	mv	s7,a1
    8000464a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000464c:	0003aa17          	auipc	s4,0x3a
    80004650:	5b4a0a13          	addi	s4,s4,1460 # 8003ec00 <sb>
    80004654:	00048b1b          	sext.w	s6,s1
    80004658:	0044d793          	srli	a5,s1,0x4
    8000465c:	018a2583          	lw	a1,24(s4)
    80004660:	9dbd                	addw	a1,a1,a5
    80004662:	8556                	mv	a0,s5
    80004664:	00000097          	auipc	ra,0x0
    80004668:	952080e7          	jalr	-1710(ra) # 80003fb6 <bread>
    8000466c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000466e:	05850993          	addi	s3,a0,88
    80004672:	00f4f793          	andi	a5,s1,15
    80004676:	079a                	slli	a5,a5,0x6
    80004678:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000467a:	00099783          	lh	a5,0(s3)
    8000467e:	c785                	beqz	a5,800046a6 <ialloc+0x84>
    brelse(bp);
    80004680:	00000097          	auipc	ra,0x0
    80004684:	a66080e7          	jalr	-1434(ra) # 800040e6 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80004688:	0485                	addi	s1,s1,1
    8000468a:	00ca2703          	lw	a4,12(s4)
    8000468e:	0004879b          	sext.w	a5,s1
    80004692:	fce7e1e3          	bltu	a5,a4,80004654 <ialloc+0x32>
  panic("ialloc: no inodes");
    80004696:	00005517          	auipc	a0,0x5
    8000469a:	f5250513          	addi	a0,a0,-174 # 800095e8 <syscalls+0x1c0>
    8000469e:	ffffc097          	auipc	ra,0xffffc
    800046a2:	e8c080e7          	jalr	-372(ra) # 8000052a <panic>
      memset(dip, 0, sizeof(*dip));
    800046a6:	04000613          	li	a2,64
    800046aa:	4581                	li	a1,0
    800046ac:	854e                	mv	a0,s3
    800046ae:	ffffc097          	auipc	ra,0xffffc
    800046b2:	61e080e7          	jalr	1566(ra) # 80000ccc <memset>
      dip->type = type;
    800046b6:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800046ba:	854a                	mv	a0,s2
    800046bc:	00001097          	auipc	ra,0x1
    800046c0:	cb0080e7          	jalr	-848(ra) # 8000536c <log_write>
      brelse(bp);
    800046c4:	854a                	mv	a0,s2
    800046c6:	00000097          	auipc	ra,0x0
    800046ca:	a20080e7          	jalr	-1504(ra) # 800040e6 <brelse>
      return iget(dev, inum);
    800046ce:	85da                	mv	a1,s6
    800046d0:	8556                	mv	a0,s5
    800046d2:	00000097          	auipc	ra,0x0
    800046d6:	db4080e7          	jalr	-588(ra) # 80004486 <iget>
}
    800046da:	60a6                	ld	ra,72(sp)
    800046dc:	6406                	ld	s0,64(sp)
    800046de:	74e2                	ld	s1,56(sp)
    800046e0:	7942                	ld	s2,48(sp)
    800046e2:	79a2                	ld	s3,40(sp)
    800046e4:	7a02                	ld	s4,32(sp)
    800046e6:	6ae2                	ld	s5,24(sp)
    800046e8:	6b42                	ld	s6,16(sp)
    800046ea:	6ba2                	ld	s7,8(sp)
    800046ec:	6161                	addi	sp,sp,80
    800046ee:	8082                	ret

00000000800046f0 <iupdate>:
{
    800046f0:	1101                	addi	sp,sp,-32
    800046f2:	ec06                	sd	ra,24(sp)
    800046f4:	e822                	sd	s0,16(sp)
    800046f6:	e426                	sd	s1,8(sp)
    800046f8:	e04a                	sd	s2,0(sp)
    800046fa:	1000                	addi	s0,sp,32
    800046fc:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800046fe:	415c                	lw	a5,4(a0)
    80004700:	0047d79b          	srliw	a5,a5,0x4
    80004704:	0003a597          	auipc	a1,0x3a
    80004708:	5145a583          	lw	a1,1300(a1) # 8003ec18 <sb+0x18>
    8000470c:	9dbd                	addw	a1,a1,a5
    8000470e:	4108                	lw	a0,0(a0)
    80004710:	00000097          	auipc	ra,0x0
    80004714:	8a6080e7          	jalr	-1882(ra) # 80003fb6 <bread>
    80004718:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000471a:	05850793          	addi	a5,a0,88
    8000471e:	40c8                	lw	a0,4(s1)
    80004720:	893d                	andi	a0,a0,15
    80004722:	051a                	slli	a0,a0,0x6
    80004724:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80004726:	04449703          	lh	a4,68(s1)
    8000472a:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    8000472e:	04649703          	lh	a4,70(s1)
    80004732:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80004736:	04849703          	lh	a4,72(s1)
    8000473a:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    8000473e:	04a49703          	lh	a4,74(s1)
    80004742:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80004746:	44f8                	lw	a4,76(s1)
    80004748:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000474a:	03400613          	li	a2,52
    8000474e:	05048593          	addi	a1,s1,80
    80004752:	0531                	addi	a0,a0,12
    80004754:	ffffc097          	auipc	ra,0xffffc
    80004758:	5d4080e7          	jalr	1492(ra) # 80000d28 <memmove>
  log_write(bp);
    8000475c:	854a                	mv	a0,s2
    8000475e:	00001097          	auipc	ra,0x1
    80004762:	c0e080e7          	jalr	-1010(ra) # 8000536c <log_write>
  brelse(bp);
    80004766:	854a                	mv	a0,s2
    80004768:	00000097          	auipc	ra,0x0
    8000476c:	97e080e7          	jalr	-1666(ra) # 800040e6 <brelse>
}
    80004770:	60e2                	ld	ra,24(sp)
    80004772:	6442                	ld	s0,16(sp)
    80004774:	64a2                	ld	s1,8(sp)
    80004776:	6902                	ld	s2,0(sp)
    80004778:	6105                	addi	sp,sp,32
    8000477a:	8082                	ret

000000008000477c <idup>:
{
    8000477c:	1101                	addi	sp,sp,-32
    8000477e:	ec06                	sd	ra,24(sp)
    80004780:	e822                	sd	s0,16(sp)
    80004782:	e426                	sd	s1,8(sp)
    80004784:	1000                	addi	s0,sp,32
    80004786:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80004788:	0003a517          	auipc	a0,0x3a
    8000478c:	49850513          	addi	a0,a0,1176 # 8003ec20 <itable>
    80004790:	ffffc097          	auipc	ra,0xffffc
    80004794:	43a080e7          	jalr	1082(ra) # 80000bca <acquire>
  ip->ref++;
    80004798:	449c                	lw	a5,8(s1)
    8000479a:	2785                	addiw	a5,a5,1
    8000479c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000479e:	0003a517          	auipc	a0,0x3a
    800047a2:	48250513          	addi	a0,a0,1154 # 8003ec20 <itable>
    800047a6:	ffffc097          	auipc	ra,0xffffc
    800047aa:	4de080e7          	jalr	1246(ra) # 80000c84 <release>
}
    800047ae:	8526                	mv	a0,s1
    800047b0:	60e2                	ld	ra,24(sp)
    800047b2:	6442                	ld	s0,16(sp)
    800047b4:	64a2                	ld	s1,8(sp)
    800047b6:	6105                	addi	sp,sp,32
    800047b8:	8082                	ret

00000000800047ba <ilock>:
{
    800047ba:	1101                	addi	sp,sp,-32
    800047bc:	ec06                	sd	ra,24(sp)
    800047be:	e822                	sd	s0,16(sp)
    800047c0:	e426                	sd	s1,8(sp)
    800047c2:	e04a                	sd	s2,0(sp)
    800047c4:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800047c6:	c115                	beqz	a0,800047ea <ilock+0x30>
    800047c8:	84aa                	mv	s1,a0
    800047ca:	451c                	lw	a5,8(a0)
    800047cc:	00f05f63          	blez	a5,800047ea <ilock+0x30>
  acquiresleep(&ip->lock);
    800047d0:	0541                	addi	a0,a0,16
    800047d2:	00001097          	auipc	ra,0x1
    800047d6:	cba080e7          	jalr	-838(ra) # 8000548c <acquiresleep>
  if(ip->valid == 0){
    800047da:	40bc                	lw	a5,64(s1)
    800047dc:	cf99                	beqz	a5,800047fa <ilock+0x40>
}
    800047de:	60e2                	ld	ra,24(sp)
    800047e0:	6442                	ld	s0,16(sp)
    800047e2:	64a2                	ld	s1,8(sp)
    800047e4:	6902                	ld	s2,0(sp)
    800047e6:	6105                	addi	sp,sp,32
    800047e8:	8082                	ret
    panic("ilock");
    800047ea:	00005517          	auipc	a0,0x5
    800047ee:	e1650513          	addi	a0,a0,-490 # 80009600 <syscalls+0x1d8>
    800047f2:	ffffc097          	auipc	ra,0xffffc
    800047f6:	d38080e7          	jalr	-712(ra) # 8000052a <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800047fa:	40dc                	lw	a5,4(s1)
    800047fc:	0047d79b          	srliw	a5,a5,0x4
    80004800:	0003a597          	auipc	a1,0x3a
    80004804:	4185a583          	lw	a1,1048(a1) # 8003ec18 <sb+0x18>
    80004808:	9dbd                	addw	a1,a1,a5
    8000480a:	4088                	lw	a0,0(s1)
    8000480c:	fffff097          	auipc	ra,0xfffff
    80004810:	7aa080e7          	jalr	1962(ra) # 80003fb6 <bread>
    80004814:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004816:	05850593          	addi	a1,a0,88
    8000481a:	40dc                	lw	a5,4(s1)
    8000481c:	8bbd                	andi	a5,a5,15
    8000481e:	079a                	slli	a5,a5,0x6
    80004820:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80004822:	00059783          	lh	a5,0(a1)
    80004826:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000482a:	00259783          	lh	a5,2(a1)
    8000482e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80004832:	00459783          	lh	a5,4(a1)
    80004836:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000483a:	00659783          	lh	a5,6(a1)
    8000483e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80004842:	459c                	lw	a5,8(a1)
    80004844:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80004846:	03400613          	li	a2,52
    8000484a:	05b1                	addi	a1,a1,12
    8000484c:	05048513          	addi	a0,s1,80
    80004850:	ffffc097          	auipc	ra,0xffffc
    80004854:	4d8080e7          	jalr	1240(ra) # 80000d28 <memmove>
    brelse(bp);
    80004858:	854a                	mv	a0,s2
    8000485a:	00000097          	auipc	ra,0x0
    8000485e:	88c080e7          	jalr	-1908(ra) # 800040e6 <brelse>
    ip->valid = 1;
    80004862:	4785                	li	a5,1
    80004864:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80004866:	04449783          	lh	a5,68(s1)
    8000486a:	fbb5                	bnez	a5,800047de <ilock+0x24>
      panic("ilock: no type");
    8000486c:	00005517          	auipc	a0,0x5
    80004870:	d9c50513          	addi	a0,a0,-612 # 80009608 <syscalls+0x1e0>
    80004874:	ffffc097          	auipc	ra,0xffffc
    80004878:	cb6080e7          	jalr	-842(ra) # 8000052a <panic>

000000008000487c <iunlock>:
{
    8000487c:	1101                	addi	sp,sp,-32
    8000487e:	ec06                	sd	ra,24(sp)
    80004880:	e822                	sd	s0,16(sp)
    80004882:	e426                	sd	s1,8(sp)
    80004884:	e04a                	sd	s2,0(sp)
    80004886:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80004888:	c905                	beqz	a0,800048b8 <iunlock+0x3c>
    8000488a:	84aa                	mv	s1,a0
    8000488c:	01050913          	addi	s2,a0,16
    80004890:	854a                	mv	a0,s2
    80004892:	00001097          	auipc	ra,0x1
    80004896:	c94080e7          	jalr	-876(ra) # 80005526 <holdingsleep>
    8000489a:	cd19                	beqz	a0,800048b8 <iunlock+0x3c>
    8000489c:	449c                	lw	a5,8(s1)
    8000489e:	00f05d63          	blez	a5,800048b8 <iunlock+0x3c>
  releasesleep(&ip->lock);
    800048a2:	854a                	mv	a0,s2
    800048a4:	00001097          	auipc	ra,0x1
    800048a8:	c3e080e7          	jalr	-962(ra) # 800054e2 <releasesleep>
}
    800048ac:	60e2                	ld	ra,24(sp)
    800048ae:	6442                	ld	s0,16(sp)
    800048b0:	64a2                	ld	s1,8(sp)
    800048b2:	6902                	ld	s2,0(sp)
    800048b4:	6105                	addi	sp,sp,32
    800048b6:	8082                	ret
    panic("iunlock");
    800048b8:	00005517          	auipc	a0,0x5
    800048bc:	d6050513          	addi	a0,a0,-672 # 80009618 <syscalls+0x1f0>
    800048c0:	ffffc097          	auipc	ra,0xffffc
    800048c4:	c6a080e7          	jalr	-918(ra) # 8000052a <panic>

00000000800048c8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800048c8:	7179                	addi	sp,sp,-48
    800048ca:	f406                	sd	ra,40(sp)
    800048cc:	f022                	sd	s0,32(sp)
    800048ce:	ec26                	sd	s1,24(sp)
    800048d0:	e84a                	sd	s2,16(sp)
    800048d2:	e44e                	sd	s3,8(sp)
    800048d4:	e052                	sd	s4,0(sp)
    800048d6:	1800                	addi	s0,sp,48
    800048d8:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800048da:	05050493          	addi	s1,a0,80
    800048de:	08050913          	addi	s2,a0,128
    800048e2:	a021                	j	800048ea <itrunc+0x22>
    800048e4:	0491                	addi	s1,s1,4
    800048e6:	01248d63          	beq	s1,s2,80004900 <itrunc+0x38>
    if(ip->addrs[i]){
    800048ea:	408c                	lw	a1,0(s1)
    800048ec:	dde5                	beqz	a1,800048e4 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    800048ee:	0009a503          	lw	a0,0(s3)
    800048f2:	00000097          	auipc	ra,0x0
    800048f6:	90a080e7          	jalr	-1782(ra) # 800041fc <bfree>
      ip->addrs[i] = 0;
    800048fa:	0004a023          	sw	zero,0(s1)
    800048fe:	b7dd                	j	800048e4 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80004900:	0809a583          	lw	a1,128(s3)
    80004904:	e185                	bnez	a1,80004924 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80004906:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000490a:	854e                	mv	a0,s3
    8000490c:	00000097          	auipc	ra,0x0
    80004910:	de4080e7          	jalr	-540(ra) # 800046f0 <iupdate>
}
    80004914:	70a2                	ld	ra,40(sp)
    80004916:	7402                	ld	s0,32(sp)
    80004918:	64e2                	ld	s1,24(sp)
    8000491a:	6942                	ld	s2,16(sp)
    8000491c:	69a2                	ld	s3,8(sp)
    8000491e:	6a02                	ld	s4,0(sp)
    80004920:	6145                	addi	sp,sp,48
    80004922:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80004924:	0009a503          	lw	a0,0(s3)
    80004928:	fffff097          	auipc	ra,0xfffff
    8000492c:	68e080e7          	jalr	1678(ra) # 80003fb6 <bread>
    80004930:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80004932:	05850493          	addi	s1,a0,88
    80004936:	45850913          	addi	s2,a0,1112
    8000493a:	a021                	j	80004942 <itrunc+0x7a>
    8000493c:	0491                	addi	s1,s1,4
    8000493e:	01248b63          	beq	s1,s2,80004954 <itrunc+0x8c>
      if(a[j])
    80004942:	408c                	lw	a1,0(s1)
    80004944:	dde5                	beqz	a1,8000493c <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80004946:	0009a503          	lw	a0,0(s3)
    8000494a:	00000097          	auipc	ra,0x0
    8000494e:	8b2080e7          	jalr	-1870(ra) # 800041fc <bfree>
    80004952:	b7ed                	j	8000493c <itrunc+0x74>
    brelse(bp);
    80004954:	8552                	mv	a0,s4
    80004956:	fffff097          	auipc	ra,0xfffff
    8000495a:	790080e7          	jalr	1936(ra) # 800040e6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000495e:	0809a583          	lw	a1,128(s3)
    80004962:	0009a503          	lw	a0,0(s3)
    80004966:	00000097          	auipc	ra,0x0
    8000496a:	896080e7          	jalr	-1898(ra) # 800041fc <bfree>
    ip->addrs[NDIRECT] = 0;
    8000496e:	0809a023          	sw	zero,128(s3)
    80004972:	bf51                	j	80004906 <itrunc+0x3e>

0000000080004974 <iput>:
{
    80004974:	1101                	addi	sp,sp,-32
    80004976:	ec06                	sd	ra,24(sp)
    80004978:	e822                	sd	s0,16(sp)
    8000497a:	e426                	sd	s1,8(sp)
    8000497c:	e04a                	sd	s2,0(sp)
    8000497e:	1000                	addi	s0,sp,32
    80004980:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80004982:	0003a517          	auipc	a0,0x3a
    80004986:	29e50513          	addi	a0,a0,670 # 8003ec20 <itable>
    8000498a:	ffffc097          	auipc	ra,0xffffc
    8000498e:	240080e7          	jalr	576(ra) # 80000bca <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004992:	4498                	lw	a4,8(s1)
    80004994:	4785                	li	a5,1
    80004996:	02f70363          	beq	a4,a5,800049bc <iput+0x48>
  ip->ref--;
    8000499a:	449c                	lw	a5,8(s1)
    8000499c:	37fd                	addiw	a5,a5,-1
    8000499e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800049a0:	0003a517          	auipc	a0,0x3a
    800049a4:	28050513          	addi	a0,a0,640 # 8003ec20 <itable>
    800049a8:	ffffc097          	auipc	ra,0xffffc
    800049ac:	2dc080e7          	jalr	732(ra) # 80000c84 <release>
}
    800049b0:	60e2                	ld	ra,24(sp)
    800049b2:	6442                	ld	s0,16(sp)
    800049b4:	64a2                	ld	s1,8(sp)
    800049b6:	6902                	ld	s2,0(sp)
    800049b8:	6105                	addi	sp,sp,32
    800049ba:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800049bc:	40bc                	lw	a5,64(s1)
    800049be:	dff1                	beqz	a5,8000499a <iput+0x26>
    800049c0:	04a49783          	lh	a5,74(s1)
    800049c4:	fbf9                	bnez	a5,8000499a <iput+0x26>
    acquiresleep(&ip->lock);
    800049c6:	01048913          	addi	s2,s1,16
    800049ca:	854a                	mv	a0,s2
    800049cc:	00001097          	auipc	ra,0x1
    800049d0:	ac0080e7          	jalr	-1344(ra) # 8000548c <acquiresleep>
    release(&itable.lock);
    800049d4:	0003a517          	auipc	a0,0x3a
    800049d8:	24c50513          	addi	a0,a0,588 # 8003ec20 <itable>
    800049dc:	ffffc097          	auipc	ra,0xffffc
    800049e0:	2a8080e7          	jalr	680(ra) # 80000c84 <release>
    itrunc(ip);
    800049e4:	8526                	mv	a0,s1
    800049e6:	00000097          	auipc	ra,0x0
    800049ea:	ee2080e7          	jalr	-286(ra) # 800048c8 <itrunc>
    ip->type = 0;
    800049ee:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800049f2:	8526                	mv	a0,s1
    800049f4:	00000097          	auipc	ra,0x0
    800049f8:	cfc080e7          	jalr	-772(ra) # 800046f0 <iupdate>
    ip->valid = 0;
    800049fc:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80004a00:	854a                	mv	a0,s2
    80004a02:	00001097          	auipc	ra,0x1
    80004a06:	ae0080e7          	jalr	-1312(ra) # 800054e2 <releasesleep>
    acquire(&itable.lock);
    80004a0a:	0003a517          	auipc	a0,0x3a
    80004a0e:	21650513          	addi	a0,a0,534 # 8003ec20 <itable>
    80004a12:	ffffc097          	auipc	ra,0xffffc
    80004a16:	1b8080e7          	jalr	440(ra) # 80000bca <acquire>
    80004a1a:	b741                	j	8000499a <iput+0x26>

0000000080004a1c <iunlockput>:
{
    80004a1c:	1101                	addi	sp,sp,-32
    80004a1e:	ec06                	sd	ra,24(sp)
    80004a20:	e822                	sd	s0,16(sp)
    80004a22:	e426                	sd	s1,8(sp)
    80004a24:	1000                	addi	s0,sp,32
    80004a26:	84aa                	mv	s1,a0
  iunlock(ip);
    80004a28:	00000097          	auipc	ra,0x0
    80004a2c:	e54080e7          	jalr	-428(ra) # 8000487c <iunlock>
  iput(ip);
    80004a30:	8526                	mv	a0,s1
    80004a32:	00000097          	auipc	ra,0x0
    80004a36:	f42080e7          	jalr	-190(ra) # 80004974 <iput>
}
    80004a3a:	60e2                	ld	ra,24(sp)
    80004a3c:	6442                	ld	s0,16(sp)
    80004a3e:	64a2                	ld	s1,8(sp)
    80004a40:	6105                	addi	sp,sp,32
    80004a42:	8082                	ret

0000000080004a44 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80004a44:	1141                	addi	sp,sp,-16
    80004a46:	e422                	sd	s0,8(sp)
    80004a48:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80004a4a:	411c                	lw	a5,0(a0)
    80004a4c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80004a4e:	415c                	lw	a5,4(a0)
    80004a50:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80004a52:	04451783          	lh	a5,68(a0)
    80004a56:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004a5a:	04a51783          	lh	a5,74(a0)
    80004a5e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80004a62:	04c56783          	lwu	a5,76(a0)
    80004a66:	e99c                	sd	a5,16(a1)
}
    80004a68:	6422                	ld	s0,8(sp)
    80004a6a:	0141                	addi	sp,sp,16
    80004a6c:	8082                	ret

0000000080004a6e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004a6e:	457c                	lw	a5,76(a0)
    80004a70:	0ed7e963          	bltu	a5,a3,80004b62 <readi+0xf4>
{
    80004a74:	7159                	addi	sp,sp,-112
    80004a76:	f486                	sd	ra,104(sp)
    80004a78:	f0a2                	sd	s0,96(sp)
    80004a7a:	eca6                	sd	s1,88(sp)
    80004a7c:	e8ca                	sd	s2,80(sp)
    80004a7e:	e4ce                	sd	s3,72(sp)
    80004a80:	e0d2                	sd	s4,64(sp)
    80004a82:	fc56                	sd	s5,56(sp)
    80004a84:	f85a                	sd	s6,48(sp)
    80004a86:	f45e                	sd	s7,40(sp)
    80004a88:	f062                	sd	s8,32(sp)
    80004a8a:	ec66                	sd	s9,24(sp)
    80004a8c:	e86a                	sd	s10,16(sp)
    80004a8e:	e46e                	sd	s11,8(sp)
    80004a90:	1880                	addi	s0,sp,112
    80004a92:	8baa                	mv	s7,a0
    80004a94:	8c2e                	mv	s8,a1
    80004a96:	8ab2                	mv	s5,a2
    80004a98:	84b6                	mv	s1,a3
    80004a9a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004a9c:	9f35                	addw	a4,a4,a3
    return 0;
    80004a9e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80004aa0:	0ad76063          	bltu	a4,a3,80004b40 <readi+0xd2>
  if(off + n > ip->size)
    80004aa4:	00e7f463          	bgeu	a5,a4,80004aac <readi+0x3e>
    n = ip->size - off;
    80004aa8:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004aac:	0a0b0963          	beqz	s6,80004b5e <readi+0xf0>
    80004ab0:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80004ab2:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004ab6:	5cfd                	li	s9,-1
    80004ab8:	a82d                	j	80004af2 <readi+0x84>
    80004aba:	020a1d93          	slli	s11,s4,0x20
    80004abe:	020ddd93          	srli	s11,s11,0x20
    80004ac2:	05890793          	addi	a5,s2,88
    80004ac6:	86ee                	mv	a3,s11
    80004ac8:	963e                	add	a2,a2,a5
    80004aca:	85d6                	mv	a1,s5
    80004acc:	8562                	mv	a0,s8
    80004ace:	ffffe097          	auipc	ra,0xffffe
    80004ad2:	632080e7          	jalr	1586(ra) # 80003100 <either_copyout>
    80004ad6:	05950d63          	beq	a0,s9,80004b30 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004ada:	854a                	mv	a0,s2
    80004adc:	fffff097          	auipc	ra,0xfffff
    80004ae0:	60a080e7          	jalr	1546(ra) # 800040e6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004ae4:	013a09bb          	addw	s3,s4,s3
    80004ae8:	009a04bb          	addw	s1,s4,s1
    80004aec:	9aee                	add	s5,s5,s11
    80004aee:	0569f763          	bgeu	s3,s6,80004b3c <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80004af2:	000ba903          	lw	s2,0(s7)
    80004af6:	00a4d59b          	srliw	a1,s1,0xa
    80004afa:	855e                	mv	a0,s7
    80004afc:	00000097          	auipc	ra,0x0
    80004b00:	8ae080e7          	jalr	-1874(ra) # 800043aa <bmap>
    80004b04:	0005059b          	sext.w	a1,a0
    80004b08:	854a                	mv	a0,s2
    80004b0a:	fffff097          	auipc	ra,0xfffff
    80004b0e:	4ac080e7          	jalr	1196(ra) # 80003fb6 <bread>
    80004b12:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004b14:	3ff4f613          	andi	a2,s1,1023
    80004b18:	40cd07bb          	subw	a5,s10,a2
    80004b1c:	413b073b          	subw	a4,s6,s3
    80004b20:	8a3e                	mv	s4,a5
    80004b22:	2781                	sext.w	a5,a5
    80004b24:	0007069b          	sext.w	a3,a4
    80004b28:	f8f6f9e3          	bgeu	a3,a5,80004aba <readi+0x4c>
    80004b2c:	8a3a                	mv	s4,a4
    80004b2e:	b771                	j	80004aba <readi+0x4c>
      brelse(bp);
    80004b30:	854a                	mv	a0,s2
    80004b32:	fffff097          	auipc	ra,0xfffff
    80004b36:	5b4080e7          	jalr	1460(ra) # 800040e6 <brelse>
      tot = -1;
    80004b3a:	59fd                	li	s3,-1
  }
  return tot;
    80004b3c:	0009851b          	sext.w	a0,s3
}
    80004b40:	70a6                	ld	ra,104(sp)
    80004b42:	7406                	ld	s0,96(sp)
    80004b44:	64e6                	ld	s1,88(sp)
    80004b46:	6946                	ld	s2,80(sp)
    80004b48:	69a6                	ld	s3,72(sp)
    80004b4a:	6a06                	ld	s4,64(sp)
    80004b4c:	7ae2                	ld	s5,56(sp)
    80004b4e:	7b42                	ld	s6,48(sp)
    80004b50:	7ba2                	ld	s7,40(sp)
    80004b52:	7c02                	ld	s8,32(sp)
    80004b54:	6ce2                	ld	s9,24(sp)
    80004b56:	6d42                	ld	s10,16(sp)
    80004b58:	6da2                	ld	s11,8(sp)
    80004b5a:	6165                	addi	sp,sp,112
    80004b5c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004b5e:	89da                	mv	s3,s6
    80004b60:	bff1                	j	80004b3c <readi+0xce>
    return 0;
    80004b62:	4501                	li	a0,0
}
    80004b64:	8082                	ret

0000000080004b66 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004b66:	457c                	lw	a5,76(a0)
    80004b68:	10d7e863          	bltu	a5,a3,80004c78 <writei+0x112>
{
    80004b6c:	7159                	addi	sp,sp,-112
    80004b6e:	f486                	sd	ra,104(sp)
    80004b70:	f0a2                	sd	s0,96(sp)
    80004b72:	eca6                	sd	s1,88(sp)
    80004b74:	e8ca                	sd	s2,80(sp)
    80004b76:	e4ce                	sd	s3,72(sp)
    80004b78:	e0d2                	sd	s4,64(sp)
    80004b7a:	fc56                	sd	s5,56(sp)
    80004b7c:	f85a                	sd	s6,48(sp)
    80004b7e:	f45e                	sd	s7,40(sp)
    80004b80:	f062                	sd	s8,32(sp)
    80004b82:	ec66                	sd	s9,24(sp)
    80004b84:	e86a                	sd	s10,16(sp)
    80004b86:	e46e                	sd	s11,8(sp)
    80004b88:	1880                	addi	s0,sp,112
    80004b8a:	8b2a                	mv	s6,a0
    80004b8c:	8c2e                	mv	s8,a1
    80004b8e:	8ab2                	mv	s5,a2
    80004b90:	8936                	mv	s2,a3
    80004b92:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80004b94:	00e687bb          	addw	a5,a3,a4
    80004b98:	0ed7e263          	bltu	a5,a3,80004c7c <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004b9c:	00043737          	lui	a4,0x43
    80004ba0:	0ef76063          	bltu	a4,a5,80004c80 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004ba4:	0c0b8863          	beqz	s7,80004c74 <writei+0x10e>
    80004ba8:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80004baa:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004bae:	5cfd                	li	s9,-1
    80004bb0:	a091                	j	80004bf4 <writei+0x8e>
    80004bb2:	02099d93          	slli	s11,s3,0x20
    80004bb6:	020ddd93          	srli	s11,s11,0x20
    80004bba:	05848793          	addi	a5,s1,88
    80004bbe:	86ee                	mv	a3,s11
    80004bc0:	8656                	mv	a2,s5
    80004bc2:	85e2                	mv	a1,s8
    80004bc4:	953e                	add	a0,a0,a5
    80004bc6:	ffffe097          	auipc	ra,0xffffe
    80004bca:	596080e7          	jalr	1430(ra) # 8000315c <either_copyin>
    80004bce:	07950263          	beq	a0,s9,80004c32 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004bd2:	8526                	mv	a0,s1
    80004bd4:	00000097          	auipc	ra,0x0
    80004bd8:	798080e7          	jalr	1944(ra) # 8000536c <log_write>
    brelse(bp);
    80004bdc:	8526                	mv	a0,s1
    80004bde:	fffff097          	auipc	ra,0xfffff
    80004be2:	508080e7          	jalr	1288(ra) # 800040e6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004be6:	01498a3b          	addw	s4,s3,s4
    80004bea:	0129893b          	addw	s2,s3,s2
    80004bee:	9aee                	add	s5,s5,s11
    80004bf0:	057a7663          	bgeu	s4,s7,80004c3c <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80004bf4:	000b2483          	lw	s1,0(s6)
    80004bf8:	00a9559b          	srliw	a1,s2,0xa
    80004bfc:	855a                	mv	a0,s6
    80004bfe:	fffff097          	auipc	ra,0xfffff
    80004c02:	7ac080e7          	jalr	1964(ra) # 800043aa <bmap>
    80004c06:	0005059b          	sext.w	a1,a0
    80004c0a:	8526                	mv	a0,s1
    80004c0c:	fffff097          	auipc	ra,0xfffff
    80004c10:	3aa080e7          	jalr	938(ra) # 80003fb6 <bread>
    80004c14:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004c16:	3ff97513          	andi	a0,s2,1023
    80004c1a:	40ad07bb          	subw	a5,s10,a0
    80004c1e:	414b873b          	subw	a4,s7,s4
    80004c22:	89be                	mv	s3,a5
    80004c24:	2781                	sext.w	a5,a5
    80004c26:	0007069b          	sext.w	a3,a4
    80004c2a:	f8f6f4e3          	bgeu	a3,a5,80004bb2 <writei+0x4c>
    80004c2e:	89ba                	mv	s3,a4
    80004c30:	b749                	j	80004bb2 <writei+0x4c>
      brelse(bp);
    80004c32:	8526                	mv	a0,s1
    80004c34:	fffff097          	auipc	ra,0xfffff
    80004c38:	4b2080e7          	jalr	1202(ra) # 800040e6 <brelse>
  }

  if(off > ip->size)
    80004c3c:	04cb2783          	lw	a5,76(s6)
    80004c40:	0127f463          	bgeu	a5,s2,80004c48 <writei+0xe2>
    ip->size = off;
    80004c44:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004c48:	855a                	mv	a0,s6
    80004c4a:	00000097          	auipc	ra,0x0
    80004c4e:	aa6080e7          	jalr	-1370(ra) # 800046f0 <iupdate>

  return tot;
    80004c52:	000a051b          	sext.w	a0,s4
}
    80004c56:	70a6                	ld	ra,104(sp)
    80004c58:	7406                	ld	s0,96(sp)
    80004c5a:	64e6                	ld	s1,88(sp)
    80004c5c:	6946                	ld	s2,80(sp)
    80004c5e:	69a6                	ld	s3,72(sp)
    80004c60:	6a06                	ld	s4,64(sp)
    80004c62:	7ae2                	ld	s5,56(sp)
    80004c64:	7b42                	ld	s6,48(sp)
    80004c66:	7ba2                	ld	s7,40(sp)
    80004c68:	7c02                	ld	s8,32(sp)
    80004c6a:	6ce2                	ld	s9,24(sp)
    80004c6c:	6d42                	ld	s10,16(sp)
    80004c6e:	6da2                	ld	s11,8(sp)
    80004c70:	6165                	addi	sp,sp,112
    80004c72:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004c74:	8a5e                	mv	s4,s7
    80004c76:	bfc9                	j	80004c48 <writei+0xe2>
    return -1;
    80004c78:	557d                	li	a0,-1
}
    80004c7a:	8082                	ret
    return -1;
    80004c7c:	557d                	li	a0,-1
    80004c7e:	bfe1                	j	80004c56 <writei+0xf0>
    return -1;
    80004c80:	557d                	li	a0,-1
    80004c82:	bfd1                	j	80004c56 <writei+0xf0>

0000000080004c84 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004c84:	1141                	addi	sp,sp,-16
    80004c86:	e406                	sd	ra,8(sp)
    80004c88:	e022                	sd	s0,0(sp)
    80004c8a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004c8c:	4639                	li	a2,14
    80004c8e:	ffffc097          	auipc	ra,0xffffc
    80004c92:	116080e7          	jalr	278(ra) # 80000da4 <strncmp>
}
    80004c96:	60a2                	ld	ra,8(sp)
    80004c98:	6402                	ld	s0,0(sp)
    80004c9a:	0141                	addi	sp,sp,16
    80004c9c:	8082                	ret

0000000080004c9e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004c9e:	7139                	addi	sp,sp,-64
    80004ca0:	fc06                	sd	ra,56(sp)
    80004ca2:	f822                	sd	s0,48(sp)
    80004ca4:	f426                	sd	s1,40(sp)
    80004ca6:	f04a                	sd	s2,32(sp)
    80004ca8:	ec4e                	sd	s3,24(sp)
    80004caa:	e852                	sd	s4,16(sp)
    80004cac:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004cae:	04451703          	lh	a4,68(a0)
    80004cb2:	4785                	li	a5,1
    80004cb4:	00f71a63          	bne	a4,a5,80004cc8 <dirlookup+0x2a>
    80004cb8:	892a                	mv	s2,a0
    80004cba:	89ae                	mv	s3,a1
    80004cbc:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004cbe:	457c                	lw	a5,76(a0)
    80004cc0:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004cc2:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004cc4:	e79d                	bnez	a5,80004cf2 <dirlookup+0x54>
    80004cc6:	a8a5                	j	80004d3e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80004cc8:	00005517          	auipc	a0,0x5
    80004ccc:	95850513          	addi	a0,a0,-1704 # 80009620 <syscalls+0x1f8>
    80004cd0:	ffffc097          	auipc	ra,0xffffc
    80004cd4:	85a080e7          	jalr	-1958(ra) # 8000052a <panic>
      panic("dirlookup read");
    80004cd8:	00005517          	auipc	a0,0x5
    80004cdc:	96050513          	addi	a0,a0,-1696 # 80009638 <syscalls+0x210>
    80004ce0:	ffffc097          	auipc	ra,0xffffc
    80004ce4:	84a080e7          	jalr	-1974(ra) # 8000052a <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004ce8:	24c1                	addiw	s1,s1,16
    80004cea:	04c92783          	lw	a5,76(s2)
    80004cee:	04f4f763          	bgeu	s1,a5,80004d3c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cf2:	4741                	li	a4,16
    80004cf4:	86a6                	mv	a3,s1
    80004cf6:	fc040613          	addi	a2,s0,-64
    80004cfa:	4581                	li	a1,0
    80004cfc:	854a                	mv	a0,s2
    80004cfe:	00000097          	auipc	ra,0x0
    80004d02:	d70080e7          	jalr	-656(ra) # 80004a6e <readi>
    80004d06:	47c1                	li	a5,16
    80004d08:	fcf518e3          	bne	a0,a5,80004cd8 <dirlookup+0x3a>
    if(de.inum == 0)
    80004d0c:	fc045783          	lhu	a5,-64(s0)
    80004d10:	dfe1                	beqz	a5,80004ce8 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80004d12:	fc240593          	addi	a1,s0,-62
    80004d16:	854e                	mv	a0,s3
    80004d18:	00000097          	auipc	ra,0x0
    80004d1c:	f6c080e7          	jalr	-148(ra) # 80004c84 <namecmp>
    80004d20:	f561                	bnez	a0,80004ce8 <dirlookup+0x4a>
      if(poff)
    80004d22:	000a0463          	beqz	s4,80004d2a <dirlookup+0x8c>
        *poff = off;
    80004d26:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80004d2a:	fc045583          	lhu	a1,-64(s0)
    80004d2e:	00092503          	lw	a0,0(s2)
    80004d32:	fffff097          	auipc	ra,0xfffff
    80004d36:	754080e7          	jalr	1876(ra) # 80004486 <iget>
    80004d3a:	a011                	j	80004d3e <dirlookup+0xa0>
  return 0;
    80004d3c:	4501                	li	a0,0
}
    80004d3e:	70e2                	ld	ra,56(sp)
    80004d40:	7442                	ld	s0,48(sp)
    80004d42:	74a2                	ld	s1,40(sp)
    80004d44:	7902                	ld	s2,32(sp)
    80004d46:	69e2                	ld	s3,24(sp)
    80004d48:	6a42                	ld	s4,16(sp)
    80004d4a:	6121                	addi	sp,sp,64
    80004d4c:	8082                	ret

0000000080004d4e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004d4e:	711d                	addi	sp,sp,-96
    80004d50:	ec86                	sd	ra,88(sp)
    80004d52:	e8a2                	sd	s0,80(sp)
    80004d54:	e4a6                	sd	s1,72(sp)
    80004d56:	e0ca                	sd	s2,64(sp)
    80004d58:	fc4e                	sd	s3,56(sp)
    80004d5a:	f852                	sd	s4,48(sp)
    80004d5c:	f456                	sd	s5,40(sp)
    80004d5e:	f05a                	sd	s6,32(sp)
    80004d60:	ec5e                	sd	s7,24(sp)
    80004d62:	e862                	sd	s8,16(sp)
    80004d64:	e466                	sd	s9,8(sp)
    80004d66:	1080                	addi	s0,sp,96
    80004d68:	84aa                	mv	s1,a0
    80004d6a:	8aae                	mv	s5,a1
    80004d6c:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004d6e:	00054703          	lbu	a4,0(a0)
    80004d72:	02f00793          	li	a5,47
    80004d76:	02f70563          	beq	a4,a5,80004da0 <namex+0x52>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004d7a:	ffffd097          	auipc	ra,0xffffd
    80004d7e:	cec080e7          	jalr	-788(ra) # 80001a66 <myproc>
    80004d82:	6785                	lui	a5,0x1
    80004d84:	97aa                	add	a5,a5,a0
    80004d86:	8a07b503          	ld	a0,-1888(a5) # 8a0 <_entry-0x7ffff760>
    80004d8a:	00000097          	auipc	ra,0x0
    80004d8e:	9f2080e7          	jalr	-1550(ra) # 8000477c <idup>
    80004d92:	89aa                	mv	s3,a0
  while(*path == '/')
    80004d94:	02f00913          	li	s2,47
  len = path - s;
    80004d98:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80004d9a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004d9c:	4b85                	li	s7,1
    80004d9e:	a865                	j	80004e56 <namex+0x108>
    ip = iget(ROOTDEV, ROOTINO);
    80004da0:	4585                	li	a1,1
    80004da2:	4505                	li	a0,1
    80004da4:	fffff097          	auipc	ra,0xfffff
    80004da8:	6e2080e7          	jalr	1762(ra) # 80004486 <iget>
    80004dac:	89aa                	mv	s3,a0
    80004dae:	b7dd                	j	80004d94 <namex+0x46>
      iunlockput(ip);
    80004db0:	854e                	mv	a0,s3
    80004db2:	00000097          	auipc	ra,0x0
    80004db6:	c6a080e7          	jalr	-918(ra) # 80004a1c <iunlockput>
      return 0;
    80004dba:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004dbc:	854e                	mv	a0,s3
    80004dbe:	60e6                	ld	ra,88(sp)
    80004dc0:	6446                	ld	s0,80(sp)
    80004dc2:	64a6                	ld	s1,72(sp)
    80004dc4:	6906                	ld	s2,64(sp)
    80004dc6:	79e2                	ld	s3,56(sp)
    80004dc8:	7a42                	ld	s4,48(sp)
    80004dca:	7aa2                	ld	s5,40(sp)
    80004dcc:	7b02                	ld	s6,32(sp)
    80004dce:	6be2                	ld	s7,24(sp)
    80004dd0:	6c42                	ld	s8,16(sp)
    80004dd2:	6ca2                	ld	s9,8(sp)
    80004dd4:	6125                	addi	sp,sp,96
    80004dd6:	8082                	ret
      iunlock(ip);
    80004dd8:	854e                	mv	a0,s3
    80004dda:	00000097          	auipc	ra,0x0
    80004dde:	aa2080e7          	jalr	-1374(ra) # 8000487c <iunlock>
      return ip;
    80004de2:	bfe9                	j	80004dbc <namex+0x6e>
      iunlockput(ip);
    80004de4:	854e                	mv	a0,s3
    80004de6:	00000097          	auipc	ra,0x0
    80004dea:	c36080e7          	jalr	-970(ra) # 80004a1c <iunlockput>
      return 0;
    80004dee:	89e6                	mv	s3,s9
    80004df0:	b7f1                	j	80004dbc <namex+0x6e>
  len = path - s;
    80004df2:	40b48633          	sub	a2,s1,a1
    80004df6:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80004dfa:	099c5463          	bge	s8,s9,80004e82 <namex+0x134>
    memmove(name, s, DIRSIZ);
    80004dfe:	4639                	li	a2,14
    80004e00:	8552                	mv	a0,s4
    80004e02:	ffffc097          	auipc	ra,0xffffc
    80004e06:	f26080e7          	jalr	-218(ra) # 80000d28 <memmove>
  while(*path == '/')
    80004e0a:	0004c783          	lbu	a5,0(s1)
    80004e0e:	01279763          	bne	a5,s2,80004e1c <namex+0xce>
    path++;
    80004e12:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004e14:	0004c783          	lbu	a5,0(s1)
    80004e18:	ff278de3          	beq	a5,s2,80004e12 <namex+0xc4>
    ilock(ip);
    80004e1c:	854e                	mv	a0,s3
    80004e1e:	00000097          	auipc	ra,0x0
    80004e22:	99c080e7          	jalr	-1636(ra) # 800047ba <ilock>
    if(ip->type != T_DIR){
    80004e26:	04499783          	lh	a5,68(s3)
    80004e2a:	f97793e3          	bne	a5,s7,80004db0 <namex+0x62>
    if(nameiparent && *path == '\0'){
    80004e2e:	000a8563          	beqz	s5,80004e38 <namex+0xea>
    80004e32:	0004c783          	lbu	a5,0(s1)
    80004e36:	d3cd                	beqz	a5,80004dd8 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004e38:	865a                	mv	a2,s6
    80004e3a:	85d2                	mv	a1,s4
    80004e3c:	854e                	mv	a0,s3
    80004e3e:	00000097          	auipc	ra,0x0
    80004e42:	e60080e7          	jalr	-416(ra) # 80004c9e <dirlookup>
    80004e46:	8caa                	mv	s9,a0
    80004e48:	dd51                	beqz	a0,80004de4 <namex+0x96>
    iunlockput(ip);
    80004e4a:	854e                	mv	a0,s3
    80004e4c:	00000097          	auipc	ra,0x0
    80004e50:	bd0080e7          	jalr	-1072(ra) # 80004a1c <iunlockput>
    ip = next;
    80004e54:	89e6                	mv	s3,s9
  while(*path == '/')
    80004e56:	0004c783          	lbu	a5,0(s1)
    80004e5a:	05279763          	bne	a5,s2,80004ea8 <namex+0x15a>
    path++;
    80004e5e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004e60:	0004c783          	lbu	a5,0(s1)
    80004e64:	ff278de3          	beq	a5,s2,80004e5e <namex+0x110>
  if(*path == 0)
    80004e68:	c79d                	beqz	a5,80004e96 <namex+0x148>
    path++;
    80004e6a:	85a6                	mv	a1,s1
  len = path - s;
    80004e6c:	8cda                	mv	s9,s6
    80004e6e:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80004e70:	01278963          	beq	a5,s2,80004e82 <namex+0x134>
    80004e74:	dfbd                	beqz	a5,80004df2 <namex+0xa4>
    path++;
    80004e76:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80004e78:	0004c783          	lbu	a5,0(s1)
    80004e7c:	ff279ce3          	bne	a5,s2,80004e74 <namex+0x126>
    80004e80:	bf8d                	j	80004df2 <namex+0xa4>
    memmove(name, s, len);
    80004e82:	2601                	sext.w	a2,a2
    80004e84:	8552                	mv	a0,s4
    80004e86:	ffffc097          	auipc	ra,0xffffc
    80004e8a:	ea2080e7          	jalr	-350(ra) # 80000d28 <memmove>
    name[len] = 0;
    80004e8e:	9cd2                	add	s9,s9,s4
    80004e90:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004e94:	bf9d                	j	80004e0a <namex+0xbc>
  if(nameiparent){
    80004e96:	f20a83e3          	beqz	s5,80004dbc <namex+0x6e>
    iput(ip);
    80004e9a:	854e                	mv	a0,s3
    80004e9c:	00000097          	auipc	ra,0x0
    80004ea0:	ad8080e7          	jalr	-1320(ra) # 80004974 <iput>
    return 0;
    80004ea4:	4981                	li	s3,0
    80004ea6:	bf19                	j	80004dbc <namex+0x6e>
  if(*path == 0)
    80004ea8:	d7fd                	beqz	a5,80004e96 <namex+0x148>
  while(*path != '/' && *path != 0)
    80004eaa:	0004c783          	lbu	a5,0(s1)
    80004eae:	85a6                	mv	a1,s1
    80004eb0:	b7d1                	j	80004e74 <namex+0x126>

0000000080004eb2 <dirlink>:
{
    80004eb2:	7139                	addi	sp,sp,-64
    80004eb4:	fc06                	sd	ra,56(sp)
    80004eb6:	f822                	sd	s0,48(sp)
    80004eb8:	f426                	sd	s1,40(sp)
    80004eba:	f04a                	sd	s2,32(sp)
    80004ebc:	ec4e                	sd	s3,24(sp)
    80004ebe:	e852                	sd	s4,16(sp)
    80004ec0:	0080                	addi	s0,sp,64
    80004ec2:	892a                	mv	s2,a0
    80004ec4:	8a2e                	mv	s4,a1
    80004ec6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004ec8:	4601                	li	a2,0
    80004eca:	00000097          	auipc	ra,0x0
    80004ece:	dd4080e7          	jalr	-556(ra) # 80004c9e <dirlookup>
    80004ed2:	e93d                	bnez	a0,80004f48 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004ed4:	04c92483          	lw	s1,76(s2)
    80004ed8:	c49d                	beqz	s1,80004f06 <dirlink+0x54>
    80004eda:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004edc:	4741                	li	a4,16
    80004ede:	86a6                	mv	a3,s1
    80004ee0:	fc040613          	addi	a2,s0,-64
    80004ee4:	4581                	li	a1,0
    80004ee6:	854a                	mv	a0,s2
    80004ee8:	00000097          	auipc	ra,0x0
    80004eec:	b86080e7          	jalr	-1146(ra) # 80004a6e <readi>
    80004ef0:	47c1                	li	a5,16
    80004ef2:	06f51163          	bne	a0,a5,80004f54 <dirlink+0xa2>
    if(de.inum == 0)
    80004ef6:	fc045783          	lhu	a5,-64(s0)
    80004efa:	c791                	beqz	a5,80004f06 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004efc:	24c1                	addiw	s1,s1,16
    80004efe:	04c92783          	lw	a5,76(s2)
    80004f02:	fcf4ede3          	bltu	s1,a5,80004edc <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004f06:	4639                	li	a2,14
    80004f08:	85d2                	mv	a1,s4
    80004f0a:	fc240513          	addi	a0,s0,-62
    80004f0e:	ffffc097          	auipc	ra,0xffffc
    80004f12:	ed2080e7          	jalr	-302(ra) # 80000de0 <strncpy>
  de.inum = inum;
    80004f16:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004f1a:	4741                	li	a4,16
    80004f1c:	86a6                	mv	a3,s1
    80004f1e:	fc040613          	addi	a2,s0,-64
    80004f22:	4581                	li	a1,0
    80004f24:	854a                	mv	a0,s2
    80004f26:	00000097          	auipc	ra,0x0
    80004f2a:	c40080e7          	jalr	-960(ra) # 80004b66 <writei>
    80004f2e:	872a                	mv	a4,a0
    80004f30:	47c1                	li	a5,16
  return 0;
    80004f32:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004f34:	02f71863          	bne	a4,a5,80004f64 <dirlink+0xb2>
}
    80004f38:	70e2                	ld	ra,56(sp)
    80004f3a:	7442                	ld	s0,48(sp)
    80004f3c:	74a2                	ld	s1,40(sp)
    80004f3e:	7902                	ld	s2,32(sp)
    80004f40:	69e2                	ld	s3,24(sp)
    80004f42:	6a42                	ld	s4,16(sp)
    80004f44:	6121                	addi	sp,sp,64
    80004f46:	8082                	ret
    iput(ip);
    80004f48:	00000097          	auipc	ra,0x0
    80004f4c:	a2c080e7          	jalr	-1492(ra) # 80004974 <iput>
    return -1;
    80004f50:	557d                	li	a0,-1
    80004f52:	b7dd                	j	80004f38 <dirlink+0x86>
      panic("dirlink read");
    80004f54:	00004517          	auipc	a0,0x4
    80004f58:	6f450513          	addi	a0,a0,1780 # 80009648 <syscalls+0x220>
    80004f5c:	ffffb097          	auipc	ra,0xffffb
    80004f60:	5ce080e7          	jalr	1486(ra) # 8000052a <panic>
    panic("dirlink");
    80004f64:	00004517          	auipc	a0,0x4
    80004f68:	7f450513          	addi	a0,a0,2036 # 80009758 <syscalls+0x330>
    80004f6c:	ffffb097          	auipc	ra,0xffffb
    80004f70:	5be080e7          	jalr	1470(ra) # 8000052a <panic>

0000000080004f74 <namei>:

struct inode*
namei(char *path)
{
    80004f74:	1101                	addi	sp,sp,-32
    80004f76:	ec06                	sd	ra,24(sp)
    80004f78:	e822                	sd	s0,16(sp)
    80004f7a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004f7c:	fe040613          	addi	a2,s0,-32
    80004f80:	4581                	li	a1,0
    80004f82:	00000097          	auipc	ra,0x0
    80004f86:	dcc080e7          	jalr	-564(ra) # 80004d4e <namex>
}
    80004f8a:	60e2                	ld	ra,24(sp)
    80004f8c:	6442                	ld	s0,16(sp)
    80004f8e:	6105                	addi	sp,sp,32
    80004f90:	8082                	ret

0000000080004f92 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004f92:	1141                	addi	sp,sp,-16
    80004f94:	e406                	sd	ra,8(sp)
    80004f96:	e022                	sd	s0,0(sp)
    80004f98:	0800                	addi	s0,sp,16
    80004f9a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004f9c:	4585                	li	a1,1
    80004f9e:	00000097          	auipc	ra,0x0
    80004fa2:	db0080e7          	jalr	-592(ra) # 80004d4e <namex>
}
    80004fa6:	60a2                	ld	ra,8(sp)
    80004fa8:	6402                	ld	s0,0(sp)
    80004faa:	0141                	addi	sp,sp,16
    80004fac:	8082                	ret

0000000080004fae <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004fae:	1101                	addi	sp,sp,-32
    80004fb0:	ec06                	sd	ra,24(sp)
    80004fb2:	e822                	sd	s0,16(sp)
    80004fb4:	e426                	sd	s1,8(sp)
    80004fb6:	e04a                	sd	s2,0(sp)
    80004fb8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004fba:	0003b917          	auipc	s2,0x3b
    80004fbe:	70e90913          	addi	s2,s2,1806 # 800406c8 <log>
    80004fc2:	01892583          	lw	a1,24(s2)
    80004fc6:	02892503          	lw	a0,40(s2)
    80004fca:	fffff097          	auipc	ra,0xfffff
    80004fce:	fec080e7          	jalr	-20(ra) # 80003fb6 <bread>
    80004fd2:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004fd4:	02c92683          	lw	a3,44(s2)
    80004fd8:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004fda:	02d05863          	blez	a3,8000500a <write_head+0x5c>
    80004fde:	0003b797          	auipc	a5,0x3b
    80004fe2:	71a78793          	addi	a5,a5,1818 # 800406f8 <log+0x30>
    80004fe6:	05c50713          	addi	a4,a0,92
    80004fea:	36fd                	addiw	a3,a3,-1
    80004fec:	02069613          	slli	a2,a3,0x20
    80004ff0:	01e65693          	srli	a3,a2,0x1e
    80004ff4:	0003b617          	auipc	a2,0x3b
    80004ff8:	70860613          	addi	a2,a2,1800 # 800406fc <log+0x34>
    80004ffc:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80004ffe:	4390                	lw	a2,0(a5)
    80005000:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80005002:	0791                	addi	a5,a5,4
    80005004:	0711                	addi	a4,a4,4
    80005006:	fed79ce3          	bne	a5,a3,80004ffe <write_head+0x50>
  }
  bwrite(buf);
    8000500a:	8526                	mv	a0,s1
    8000500c:	fffff097          	auipc	ra,0xfffff
    80005010:	09c080e7          	jalr	156(ra) # 800040a8 <bwrite>
  brelse(buf);
    80005014:	8526                	mv	a0,s1
    80005016:	fffff097          	auipc	ra,0xfffff
    8000501a:	0d0080e7          	jalr	208(ra) # 800040e6 <brelse>
}
    8000501e:	60e2                	ld	ra,24(sp)
    80005020:	6442                	ld	s0,16(sp)
    80005022:	64a2                	ld	s1,8(sp)
    80005024:	6902                	ld	s2,0(sp)
    80005026:	6105                	addi	sp,sp,32
    80005028:	8082                	ret

000000008000502a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000502a:	0003b797          	auipc	a5,0x3b
    8000502e:	6ca7a783          	lw	a5,1738(a5) # 800406f4 <log+0x2c>
    80005032:	0af05d63          	blez	a5,800050ec <install_trans+0xc2>
{
    80005036:	7139                	addi	sp,sp,-64
    80005038:	fc06                	sd	ra,56(sp)
    8000503a:	f822                	sd	s0,48(sp)
    8000503c:	f426                	sd	s1,40(sp)
    8000503e:	f04a                	sd	s2,32(sp)
    80005040:	ec4e                	sd	s3,24(sp)
    80005042:	e852                	sd	s4,16(sp)
    80005044:	e456                	sd	s5,8(sp)
    80005046:	e05a                	sd	s6,0(sp)
    80005048:	0080                	addi	s0,sp,64
    8000504a:	8b2a                	mv	s6,a0
    8000504c:	0003ba97          	auipc	s5,0x3b
    80005050:	6aca8a93          	addi	s5,s5,1708 # 800406f8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80005054:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80005056:	0003b997          	auipc	s3,0x3b
    8000505a:	67298993          	addi	s3,s3,1650 # 800406c8 <log>
    8000505e:	a00d                	j	80005080 <install_trans+0x56>
    brelse(lbuf);
    80005060:	854a                	mv	a0,s2
    80005062:	fffff097          	auipc	ra,0xfffff
    80005066:	084080e7          	jalr	132(ra) # 800040e6 <brelse>
    brelse(dbuf);
    8000506a:	8526                	mv	a0,s1
    8000506c:	fffff097          	auipc	ra,0xfffff
    80005070:	07a080e7          	jalr	122(ra) # 800040e6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80005074:	2a05                	addiw	s4,s4,1
    80005076:	0a91                	addi	s5,s5,4
    80005078:	02c9a783          	lw	a5,44(s3)
    8000507c:	04fa5e63          	bge	s4,a5,800050d8 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80005080:	0189a583          	lw	a1,24(s3)
    80005084:	014585bb          	addw	a1,a1,s4
    80005088:	2585                	addiw	a1,a1,1
    8000508a:	0289a503          	lw	a0,40(s3)
    8000508e:	fffff097          	auipc	ra,0xfffff
    80005092:	f28080e7          	jalr	-216(ra) # 80003fb6 <bread>
    80005096:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80005098:	000aa583          	lw	a1,0(s5)
    8000509c:	0289a503          	lw	a0,40(s3)
    800050a0:	fffff097          	auipc	ra,0xfffff
    800050a4:	f16080e7          	jalr	-234(ra) # 80003fb6 <bread>
    800050a8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800050aa:	40000613          	li	a2,1024
    800050ae:	05890593          	addi	a1,s2,88
    800050b2:	05850513          	addi	a0,a0,88
    800050b6:	ffffc097          	auipc	ra,0xffffc
    800050ba:	c72080e7          	jalr	-910(ra) # 80000d28 <memmove>
    bwrite(dbuf);  // write dst to disk
    800050be:	8526                	mv	a0,s1
    800050c0:	fffff097          	auipc	ra,0xfffff
    800050c4:	fe8080e7          	jalr	-24(ra) # 800040a8 <bwrite>
    if(recovering == 0)
    800050c8:	f80b1ce3          	bnez	s6,80005060 <install_trans+0x36>
      bunpin(dbuf);
    800050cc:	8526                	mv	a0,s1
    800050ce:	fffff097          	auipc	ra,0xfffff
    800050d2:	0f2080e7          	jalr	242(ra) # 800041c0 <bunpin>
    800050d6:	b769                	j	80005060 <install_trans+0x36>
}
    800050d8:	70e2                	ld	ra,56(sp)
    800050da:	7442                	ld	s0,48(sp)
    800050dc:	74a2                	ld	s1,40(sp)
    800050de:	7902                	ld	s2,32(sp)
    800050e0:	69e2                	ld	s3,24(sp)
    800050e2:	6a42                	ld	s4,16(sp)
    800050e4:	6aa2                	ld	s5,8(sp)
    800050e6:	6b02                	ld	s6,0(sp)
    800050e8:	6121                	addi	sp,sp,64
    800050ea:	8082                	ret
    800050ec:	8082                	ret

00000000800050ee <initlog>:
{
    800050ee:	7179                	addi	sp,sp,-48
    800050f0:	f406                	sd	ra,40(sp)
    800050f2:	f022                	sd	s0,32(sp)
    800050f4:	ec26                	sd	s1,24(sp)
    800050f6:	e84a                	sd	s2,16(sp)
    800050f8:	e44e                	sd	s3,8(sp)
    800050fa:	1800                	addi	s0,sp,48
    800050fc:	892a                	mv	s2,a0
    800050fe:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80005100:	0003b497          	auipc	s1,0x3b
    80005104:	5c848493          	addi	s1,s1,1480 # 800406c8 <log>
    80005108:	00004597          	auipc	a1,0x4
    8000510c:	55058593          	addi	a1,a1,1360 # 80009658 <syscalls+0x230>
    80005110:	8526                	mv	a0,s1
    80005112:	ffffc097          	auipc	ra,0xffffc
    80005116:	a20080e7          	jalr	-1504(ra) # 80000b32 <initlock>
  log.start = sb->logstart;
    8000511a:	0149a583          	lw	a1,20(s3)
    8000511e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80005120:	0109a783          	lw	a5,16(s3)
    80005124:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80005126:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000512a:	854a                	mv	a0,s2
    8000512c:	fffff097          	auipc	ra,0xfffff
    80005130:	e8a080e7          	jalr	-374(ra) # 80003fb6 <bread>
  log.lh.n = lh->n;
    80005134:	4d34                	lw	a3,88(a0)
    80005136:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80005138:	02d05663          	blez	a3,80005164 <initlog+0x76>
    8000513c:	05c50793          	addi	a5,a0,92
    80005140:	0003b717          	auipc	a4,0x3b
    80005144:	5b870713          	addi	a4,a4,1464 # 800406f8 <log+0x30>
    80005148:	36fd                	addiw	a3,a3,-1
    8000514a:	02069613          	slli	a2,a3,0x20
    8000514e:	01e65693          	srli	a3,a2,0x1e
    80005152:	06050613          	addi	a2,a0,96
    80005156:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80005158:	4390                	lw	a2,0(a5)
    8000515a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000515c:	0791                	addi	a5,a5,4
    8000515e:	0711                	addi	a4,a4,4
    80005160:	fed79ce3          	bne	a5,a3,80005158 <initlog+0x6a>
  brelse(buf);
    80005164:	fffff097          	auipc	ra,0xfffff
    80005168:	f82080e7          	jalr	-126(ra) # 800040e6 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000516c:	4505                	li	a0,1
    8000516e:	00000097          	auipc	ra,0x0
    80005172:	ebc080e7          	jalr	-324(ra) # 8000502a <install_trans>
  log.lh.n = 0;
    80005176:	0003b797          	auipc	a5,0x3b
    8000517a:	5607af23          	sw	zero,1406(a5) # 800406f4 <log+0x2c>
  write_head(); // clear the log
    8000517e:	00000097          	auipc	ra,0x0
    80005182:	e30080e7          	jalr	-464(ra) # 80004fae <write_head>
}
    80005186:	70a2                	ld	ra,40(sp)
    80005188:	7402                	ld	s0,32(sp)
    8000518a:	64e2                	ld	s1,24(sp)
    8000518c:	6942                	ld	s2,16(sp)
    8000518e:	69a2                	ld	s3,8(sp)
    80005190:	6145                	addi	sp,sp,48
    80005192:	8082                	ret

0000000080005194 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80005194:	1101                	addi	sp,sp,-32
    80005196:	ec06                	sd	ra,24(sp)
    80005198:	e822                	sd	s0,16(sp)
    8000519a:	e426                	sd	s1,8(sp)
    8000519c:	e04a                	sd	s2,0(sp)
    8000519e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800051a0:	0003b517          	auipc	a0,0x3b
    800051a4:	52850513          	addi	a0,a0,1320 # 800406c8 <log>
    800051a8:	ffffc097          	auipc	ra,0xffffc
    800051ac:	a22080e7          	jalr	-1502(ra) # 80000bca <acquire>
  while(1){
    if(log.committing){
    800051b0:	0003b497          	auipc	s1,0x3b
    800051b4:	51848493          	addi	s1,s1,1304 # 800406c8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800051b8:	4979                	li	s2,30
    800051ba:	a039                	j	800051c8 <begin_op+0x34>
      sleep(&log, &log.lock);
    800051bc:	85a6                	mv	a1,s1
    800051be:	8526                	mv	a0,s1
    800051c0:	ffffd097          	auipc	ra,0xffffd
    800051c4:	694080e7          	jalr	1684(ra) # 80002854 <sleep>
    if(log.committing){
    800051c8:	50dc                	lw	a5,36(s1)
    800051ca:	fbed                	bnez	a5,800051bc <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800051cc:	509c                	lw	a5,32(s1)
    800051ce:	0017871b          	addiw	a4,a5,1
    800051d2:	0007069b          	sext.w	a3,a4
    800051d6:	0027179b          	slliw	a5,a4,0x2
    800051da:	9fb9                	addw	a5,a5,a4
    800051dc:	0017979b          	slliw	a5,a5,0x1
    800051e0:	54d8                	lw	a4,44(s1)
    800051e2:	9fb9                	addw	a5,a5,a4
    800051e4:	00f95963          	bge	s2,a5,800051f6 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800051e8:	85a6                	mv	a1,s1
    800051ea:	8526                	mv	a0,s1
    800051ec:	ffffd097          	auipc	ra,0xffffd
    800051f0:	668080e7          	jalr	1640(ra) # 80002854 <sleep>
    800051f4:	bfd1                	j	800051c8 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800051f6:	0003b517          	auipc	a0,0x3b
    800051fa:	4d250513          	addi	a0,a0,1234 # 800406c8 <log>
    800051fe:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80005200:	ffffc097          	auipc	ra,0xffffc
    80005204:	a84080e7          	jalr	-1404(ra) # 80000c84 <release>
      break;
    }
  }
}
    80005208:	60e2                	ld	ra,24(sp)
    8000520a:	6442                	ld	s0,16(sp)
    8000520c:	64a2                	ld	s1,8(sp)
    8000520e:	6902                	ld	s2,0(sp)
    80005210:	6105                	addi	sp,sp,32
    80005212:	8082                	ret

0000000080005214 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80005214:	7139                	addi	sp,sp,-64
    80005216:	fc06                	sd	ra,56(sp)
    80005218:	f822                	sd	s0,48(sp)
    8000521a:	f426                	sd	s1,40(sp)
    8000521c:	f04a                	sd	s2,32(sp)
    8000521e:	ec4e                	sd	s3,24(sp)
    80005220:	e852                	sd	s4,16(sp)
    80005222:	e456                	sd	s5,8(sp)
    80005224:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80005226:	0003b497          	auipc	s1,0x3b
    8000522a:	4a248493          	addi	s1,s1,1186 # 800406c8 <log>
    8000522e:	8526                	mv	a0,s1
    80005230:	ffffc097          	auipc	ra,0xffffc
    80005234:	99a080e7          	jalr	-1638(ra) # 80000bca <acquire>
  log.outstanding -= 1;
    80005238:	509c                	lw	a5,32(s1)
    8000523a:	37fd                	addiw	a5,a5,-1
    8000523c:	0007891b          	sext.w	s2,a5
    80005240:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80005242:	50dc                	lw	a5,36(s1)
    80005244:	e7b9                	bnez	a5,80005292 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80005246:	04091e63          	bnez	s2,800052a2 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000524a:	0003b497          	auipc	s1,0x3b
    8000524e:	47e48493          	addi	s1,s1,1150 # 800406c8 <log>
    80005252:	4785                	li	a5,1
    80005254:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80005256:	8526                	mv	a0,s1
    80005258:	ffffc097          	auipc	ra,0xffffc
    8000525c:	a2c080e7          	jalr	-1492(ra) # 80000c84 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80005260:	54dc                	lw	a5,44(s1)
    80005262:	06f04763          	bgtz	a5,800052d0 <end_op+0xbc>
    acquire(&log.lock);
    80005266:	0003b497          	auipc	s1,0x3b
    8000526a:	46248493          	addi	s1,s1,1122 # 800406c8 <log>
    8000526e:	8526                	mv	a0,s1
    80005270:	ffffc097          	auipc	ra,0xffffc
    80005274:	95a080e7          	jalr	-1702(ra) # 80000bca <acquire>
    log.committing = 0;
    80005278:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000527c:	8526                	mv	a0,s1
    8000527e:	ffffe097          	auipc	ra,0xffffe
    80005282:	944080e7          	jalr	-1724(ra) # 80002bc2 <wakeup>
    release(&log.lock);
    80005286:	8526                	mv	a0,s1
    80005288:	ffffc097          	auipc	ra,0xffffc
    8000528c:	9fc080e7          	jalr	-1540(ra) # 80000c84 <release>
}
    80005290:	a03d                	j	800052be <end_op+0xaa>
    panic("log.committing");
    80005292:	00004517          	auipc	a0,0x4
    80005296:	3ce50513          	addi	a0,a0,974 # 80009660 <syscalls+0x238>
    8000529a:	ffffb097          	auipc	ra,0xffffb
    8000529e:	290080e7          	jalr	656(ra) # 8000052a <panic>
    wakeup(&log);
    800052a2:	0003b497          	auipc	s1,0x3b
    800052a6:	42648493          	addi	s1,s1,1062 # 800406c8 <log>
    800052aa:	8526                	mv	a0,s1
    800052ac:	ffffe097          	auipc	ra,0xffffe
    800052b0:	916080e7          	jalr	-1770(ra) # 80002bc2 <wakeup>
  release(&log.lock);
    800052b4:	8526                	mv	a0,s1
    800052b6:	ffffc097          	auipc	ra,0xffffc
    800052ba:	9ce080e7          	jalr	-1586(ra) # 80000c84 <release>
}
    800052be:	70e2                	ld	ra,56(sp)
    800052c0:	7442                	ld	s0,48(sp)
    800052c2:	74a2                	ld	s1,40(sp)
    800052c4:	7902                	ld	s2,32(sp)
    800052c6:	69e2                	ld	s3,24(sp)
    800052c8:	6a42                	ld	s4,16(sp)
    800052ca:	6aa2                	ld	s5,8(sp)
    800052cc:	6121                	addi	sp,sp,64
    800052ce:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800052d0:	0003ba97          	auipc	s5,0x3b
    800052d4:	428a8a93          	addi	s5,s5,1064 # 800406f8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800052d8:	0003ba17          	auipc	s4,0x3b
    800052dc:	3f0a0a13          	addi	s4,s4,1008 # 800406c8 <log>
    800052e0:	018a2583          	lw	a1,24(s4)
    800052e4:	012585bb          	addw	a1,a1,s2
    800052e8:	2585                	addiw	a1,a1,1
    800052ea:	028a2503          	lw	a0,40(s4)
    800052ee:	fffff097          	auipc	ra,0xfffff
    800052f2:	cc8080e7          	jalr	-824(ra) # 80003fb6 <bread>
    800052f6:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800052f8:	000aa583          	lw	a1,0(s5)
    800052fc:	028a2503          	lw	a0,40(s4)
    80005300:	fffff097          	auipc	ra,0xfffff
    80005304:	cb6080e7          	jalr	-842(ra) # 80003fb6 <bread>
    80005308:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000530a:	40000613          	li	a2,1024
    8000530e:	05850593          	addi	a1,a0,88
    80005312:	05848513          	addi	a0,s1,88
    80005316:	ffffc097          	auipc	ra,0xffffc
    8000531a:	a12080e7          	jalr	-1518(ra) # 80000d28 <memmove>
    bwrite(to);  // write the log
    8000531e:	8526                	mv	a0,s1
    80005320:	fffff097          	auipc	ra,0xfffff
    80005324:	d88080e7          	jalr	-632(ra) # 800040a8 <bwrite>
    brelse(from);
    80005328:	854e                	mv	a0,s3
    8000532a:	fffff097          	auipc	ra,0xfffff
    8000532e:	dbc080e7          	jalr	-580(ra) # 800040e6 <brelse>
    brelse(to);
    80005332:	8526                	mv	a0,s1
    80005334:	fffff097          	auipc	ra,0xfffff
    80005338:	db2080e7          	jalr	-590(ra) # 800040e6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000533c:	2905                	addiw	s2,s2,1
    8000533e:	0a91                	addi	s5,s5,4
    80005340:	02ca2783          	lw	a5,44(s4)
    80005344:	f8f94ee3          	blt	s2,a5,800052e0 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80005348:	00000097          	auipc	ra,0x0
    8000534c:	c66080e7          	jalr	-922(ra) # 80004fae <write_head>
    install_trans(0); // Now install writes to home locations
    80005350:	4501                	li	a0,0
    80005352:	00000097          	auipc	ra,0x0
    80005356:	cd8080e7          	jalr	-808(ra) # 8000502a <install_trans>
    log.lh.n = 0;
    8000535a:	0003b797          	auipc	a5,0x3b
    8000535e:	3807ad23          	sw	zero,922(a5) # 800406f4 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80005362:	00000097          	auipc	ra,0x0
    80005366:	c4c080e7          	jalr	-948(ra) # 80004fae <write_head>
    8000536a:	bdf5                	j	80005266 <end_op+0x52>

000000008000536c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000536c:	1101                	addi	sp,sp,-32
    8000536e:	ec06                	sd	ra,24(sp)
    80005370:	e822                	sd	s0,16(sp)
    80005372:	e426                	sd	s1,8(sp)
    80005374:	e04a                	sd	s2,0(sp)
    80005376:	1000                	addi	s0,sp,32
    80005378:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000537a:	0003b917          	auipc	s2,0x3b
    8000537e:	34e90913          	addi	s2,s2,846 # 800406c8 <log>
    80005382:	854a                	mv	a0,s2
    80005384:	ffffc097          	auipc	ra,0xffffc
    80005388:	846080e7          	jalr	-1978(ra) # 80000bca <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000538c:	02c92603          	lw	a2,44(s2)
    80005390:	47f5                	li	a5,29
    80005392:	06c7c563          	blt	a5,a2,800053fc <log_write+0x90>
    80005396:	0003b797          	auipc	a5,0x3b
    8000539a:	34e7a783          	lw	a5,846(a5) # 800406e4 <log+0x1c>
    8000539e:	37fd                	addiw	a5,a5,-1
    800053a0:	04f65e63          	bge	a2,a5,800053fc <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800053a4:	0003b797          	auipc	a5,0x3b
    800053a8:	3447a783          	lw	a5,836(a5) # 800406e8 <log+0x20>
    800053ac:	06f05063          	blez	a5,8000540c <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800053b0:	4781                	li	a5,0
    800053b2:	06c05563          	blez	a2,8000541c <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800053b6:	44cc                	lw	a1,12(s1)
    800053b8:	0003b717          	auipc	a4,0x3b
    800053bc:	34070713          	addi	a4,a4,832 # 800406f8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800053c0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800053c2:	4314                	lw	a3,0(a4)
    800053c4:	04b68c63          	beq	a3,a1,8000541c <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800053c8:	2785                	addiw	a5,a5,1
    800053ca:	0711                	addi	a4,a4,4
    800053cc:	fef61be3          	bne	a2,a5,800053c2 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800053d0:	0621                	addi	a2,a2,8
    800053d2:	060a                	slli	a2,a2,0x2
    800053d4:	0003b797          	auipc	a5,0x3b
    800053d8:	2f478793          	addi	a5,a5,756 # 800406c8 <log>
    800053dc:	963e                	add	a2,a2,a5
    800053de:	44dc                	lw	a5,12(s1)
    800053e0:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800053e2:	8526                	mv	a0,s1
    800053e4:	fffff097          	auipc	ra,0xfffff
    800053e8:	da0080e7          	jalr	-608(ra) # 80004184 <bpin>
    log.lh.n++;
    800053ec:	0003b717          	auipc	a4,0x3b
    800053f0:	2dc70713          	addi	a4,a4,732 # 800406c8 <log>
    800053f4:	575c                	lw	a5,44(a4)
    800053f6:	2785                	addiw	a5,a5,1
    800053f8:	d75c                	sw	a5,44(a4)
    800053fa:	a835                	j	80005436 <log_write+0xca>
    panic("too big a transaction");
    800053fc:	00004517          	auipc	a0,0x4
    80005400:	27450513          	addi	a0,a0,628 # 80009670 <syscalls+0x248>
    80005404:	ffffb097          	auipc	ra,0xffffb
    80005408:	126080e7          	jalr	294(ra) # 8000052a <panic>
    panic("log_write outside of trans");
    8000540c:	00004517          	auipc	a0,0x4
    80005410:	27c50513          	addi	a0,a0,636 # 80009688 <syscalls+0x260>
    80005414:	ffffb097          	auipc	ra,0xffffb
    80005418:	116080e7          	jalr	278(ra) # 8000052a <panic>
  log.lh.block[i] = b->blockno;
    8000541c:	00878713          	addi	a4,a5,8
    80005420:	00271693          	slli	a3,a4,0x2
    80005424:	0003b717          	auipc	a4,0x3b
    80005428:	2a470713          	addi	a4,a4,676 # 800406c8 <log>
    8000542c:	9736                	add	a4,a4,a3
    8000542e:	44d4                	lw	a3,12(s1)
    80005430:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80005432:	faf608e3          	beq	a2,a5,800053e2 <log_write+0x76>
  }
  release(&log.lock);
    80005436:	0003b517          	auipc	a0,0x3b
    8000543a:	29250513          	addi	a0,a0,658 # 800406c8 <log>
    8000543e:	ffffc097          	auipc	ra,0xffffc
    80005442:	846080e7          	jalr	-1978(ra) # 80000c84 <release>
}
    80005446:	60e2                	ld	ra,24(sp)
    80005448:	6442                	ld	s0,16(sp)
    8000544a:	64a2                	ld	s1,8(sp)
    8000544c:	6902                	ld	s2,0(sp)
    8000544e:	6105                	addi	sp,sp,32
    80005450:	8082                	ret

0000000080005452 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80005452:	1101                	addi	sp,sp,-32
    80005454:	ec06                	sd	ra,24(sp)
    80005456:	e822                	sd	s0,16(sp)
    80005458:	e426                	sd	s1,8(sp)
    8000545a:	e04a                	sd	s2,0(sp)
    8000545c:	1000                	addi	s0,sp,32
    8000545e:	84aa                	mv	s1,a0
    80005460:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80005462:	00004597          	auipc	a1,0x4
    80005466:	24658593          	addi	a1,a1,582 # 800096a8 <syscalls+0x280>
    8000546a:	0521                	addi	a0,a0,8
    8000546c:	ffffb097          	auipc	ra,0xffffb
    80005470:	6c6080e7          	jalr	1734(ra) # 80000b32 <initlock>
  lk->name = name;
    80005474:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80005478:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000547c:	0204a423          	sw	zero,40(s1)
}
    80005480:	60e2                	ld	ra,24(sp)
    80005482:	6442                	ld	s0,16(sp)
    80005484:	64a2                	ld	s1,8(sp)
    80005486:	6902                	ld	s2,0(sp)
    80005488:	6105                	addi	sp,sp,32
    8000548a:	8082                	ret

000000008000548c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000548c:	1101                	addi	sp,sp,-32
    8000548e:	ec06                	sd	ra,24(sp)
    80005490:	e822                	sd	s0,16(sp)
    80005492:	e426                	sd	s1,8(sp)
    80005494:	e04a                	sd	s2,0(sp)
    80005496:	1000                	addi	s0,sp,32
    80005498:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000549a:	00850913          	addi	s2,a0,8
    8000549e:	854a                	mv	a0,s2
    800054a0:	ffffb097          	auipc	ra,0xffffb
    800054a4:	72a080e7          	jalr	1834(ra) # 80000bca <acquire>
  while (lk->locked) {
    800054a8:	409c                	lw	a5,0(s1)
    800054aa:	cb89                	beqz	a5,800054bc <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800054ac:	85ca                	mv	a1,s2
    800054ae:	8526                	mv	a0,s1
    800054b0:	ffffd097          	auipc	ra,0xffffd
    800054b4:	3a4080e7          	jalr	932(ra) # 80002854 <sleep>
  while (lk->locked) {
    800054b8:	409c                	lw	a5,0(s1)
    800054ba:	fbed                	bnez	a5,800054ac <acquiresleep+0x20>
  }
  lk->locked = 1;
    800054bc:	4785                	li	a5,1
    800054be:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800054c0:	ffffc097          	auipc	ra,0xffffc
    800054c4:	5a6080e7          	jalr	1446(ra) # 80001a66 <myproc>
    800054c8:	515c                	lw	a5,36(a0)
    800054ca:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800054cc:	854a                	mv	a0,s2
    800054ce:	ffffb097          	auipc	ra,0xffffb
    800054d2:	7b6080e7          	jalr	1974(ra) # 80000c84 <release>
}
    800054d6:	60e2                	ld	ra,24(sp)
    800054d8:	6442                	ld	s0,16(sp)
    800054da:	64a2                	ld	s1,8(sp)
    800054dc:	6902                	ld	s2,0(sp)
    800054de:	6105                	addi	sp,sp,32
    800054e0:	8082                	ret

00000000800054e2 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800054e2:	1101                	addi	sp,sp,-32
    800054e4:	ec06                	sd	ra,24(sp)
    800054e6:	e822                	sd	s0,16(sp)
    800054e8:	e426                	sd	s1,8(sp)
    800054ea:	e04a                	sd	s2,0(sp)
    800054ec:	1000                	addi	s0,sp,32
    800054ee:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800054f0:	00850913          	addi	s2,a0,8
    800054f4:	854a                	mv	a0,s2
    800054f6:	ffffb097          	auipc	ra,0xffffb
    800054fa:	6d4080e7          	jalr	1748(ra) # 80000bca <acquire>
  lk->locked = 0;
    800054fe:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80005502:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80005506:	8526                	mv	a0,s1
    80005508:	ffffd097          	auipc	ra,0xffffd
    8000550c:	6ba080e7          	jalr	1722(ra) # 80002bc2 <wakeup>
  release(&lk->lk);
    80005510:	854a                	mv	a0,s2
    80005512:	ffffb097          	auipc	ra,0xffffb
    80005516:	772080e7          	jalr	1906(ra) # 80000c84 <release>
}
    8000551a:	60e2                	ld	ra,24(sp)
    8000551c:	6442                	ld	s0,16(sp)
    8000551e:	64a2                	ld	s1,8(sp)
    80005520:	6902                	ld	s2,0(sp)
    80005522:	6105                	addi	sp,sp,32
    80005524:	8082                	ret

0000000080005526 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80005526:	7179                	addi	sp,sp,-48
    80005528:	f406                	sd	ra,40(sp)
    8000552a:	f022                	sd	s0,32(sp)
    8000552c:	ec26                	sd	s1,24(sp)
    8000552e:	e84a                	sd	s2,16(sp)
    80005530:	e44e                	sd	s3,8(sp)
    80005532:	1800                	addi	s0,sp,48
    80005534:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80005536:	00850913          	addi	s2,a0,8
    8000553a:	854a                	mv	a0,s2
    8000553c:	ffffb097          	auipc	ra,0xffffb
    80005540:	68e080e7          	jalr	1678(ra) # 80000bca <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80005544:	409c                	lw	a5,0(s1)
    80005546:	ef99                	bnez	a5,80005564 <holdingsleep+0x3e>
    80005548:	4481                	li	s1,0
  release(&lk->lk);
    8000554a:	854a                	mv	a0,s2
    8000554c:	ffffb097          	auipc	ra,0xffffb
    80005550:	738080e7          	jalr	1848(ra) # 80000c84 <release>
  return r;
}
    80005554:	8526                	mv	a0,s1
    80005556:	70a2                	ld	ra,40(sp)
    80005558:	7402                	ld	s0,32(sp)
    8000555a:	64e2                	ld	s1,24(sp)
    8000555c:	6942                	ld	s2,16(sp)
    8000555e:	69a2                	ld	s3,8(sp)
    80005560:	6145                	addi	sp,sp,48
    80005562:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80005564:	0284a983          	lw	s3,40(s1)
    80005568:	ffffc097          	auipc	ra,0xffffc
    8000556c:	4fe080e7          	jalr	1278(ra) # 80001a66 <myproc>
    80005570:	5144                	lw	s1,36(a0)
    80005572:	413484b3          	sub	s1,s1,s3
    80005576:	0014b493          	seqz	s1,s1
    8000557a:	bfc1                	j	8000554a <holdingsleep+0x24>

000000008000557c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000557c:	1141                	addi	sp,sp,-16
    8000557e:	e406                	sd	ra,8(sp)
    80005580:	e022                	sd	s0,0(sp)
    80005582:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80005584:	00004597          	auipc	a1,0x4
    80005588:	13458593          	addi	a1,a1,308 # 800096b8 <syscalls+0x290>
    8000558c:	0003b517          	auipc	a0,0x3b
    80005590:	28450513          	addi	a0,a0,644 # 80040810 <ftable>
    80005594:	ffffb097          	auipc	ra,0xffffb
    80005598:	59e080e7          	jalr	1438(ra) # 80000b32 <initlock>
}
    8000559c:	60a2                	ld	ra,8(sp)
    8000559e:	6402                	ld	s0,0(sp)
    800055a0:	0141                	addi	sp,sp,16
    800055a2:	8082                	ret

00000000800055a4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800055a4:	1101                	addi	sp,sp,-32
    800055a6:	ec06                	sd	ra,24(sp)
    800055a8:	e822                	sd	s0,16(sp)
    800055aa:	e426                	sd	s1,8(sp)
    800055ac:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800055ae:	0003b517          	auipc	a0,0x3b
    800055b2:	26250513          	addi	a0,a0,610 # 80040810 <ftable>
    800055b6:	ffffb097          	auipc	ra,0xffffb
    800055ba:	614080e7          	jalr	1556(ra) # 80000bca <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800055be:	0003b497          	auipc	s1,0x3b
    800055c2:	26a48493          	addi	s1,s1,618 # 80040828 <ftable+0x18>
    800055c6:	0003c717          	auipc	a4,0x3c
    800055ca:	20270713          	addi	a4,a4,514 # 800417c8 <ftable+0xfb8>
    if(f->ref == 0){
    800055ce:	40dc                	lw	a5,4(s1)
    800055d0:	cf99                	beqz	a5,800055ee <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800055d2:	02848493          	addi	s1,s1,40
    800055d6:	fee49ce3          	bne	s1,a4,800055ce <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800055da:	0003b517          	auipc	a0,0x3b
    800055de:	23650513          	addi	a0,a0,566 # 80040810 <ftable>
    800055e2:	ffffb097          	auipc	ra,0xffffb
    800055e6:	6a2080e7          	jalr	1698(ra) # 80000c84 <release>
  return 0;
    800055ea:	4481                	li	s1,0
    800055ec:	a819                	j	80005602 <filealloc+0x5e>
      f->ref = 1;
    800055ee:	4785                	li	a5,1
    800055f0:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800055f2:	0003b517          	auipc	a0,0x3b
    800055f6:	21e50513          	addi	a0,a0,542 # 80040810 <ftable>
    800055fa:	ffffb097          	auipc	ra,0xffffb
    800055fe:	68a080e7          	jalr	1674(ra) # 80000c84 <release>
}
    80005602:	8526                	mv	a0,s1
    80005604:	60e2                	ld	ra,24(sp)
    80005606:	6442                	ld	s0,16(sp)
    80005608:	64a2                	ld	s1,8(sp)
    8000560a:	6105                	addi	sp,sp,32
    8000560c:	8082                	ret

000000008000560e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000560e:	1101                	addi	sp,sp,-32
    80005610:	ec06                	sd	ra,24(sp)
    80005612:	e822                	sd	s0,16(sp)
    80005614:	e426                	sd	s1,8(sp)
    80005616:	1000                	addi	s0,sp,32
    80005618:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000561a:	0003b517          	auipc	a0,0x3b
    8000561e:	1f650513          	addi	a0,a0,502 # 80040810 <ftable>
    80005622:	ffffb097          	auipc	ra,0xffffb
    80005626:	5a8080e7          	jalr	1448(ra) # 80000bca <acquire>
  if(f->ref < 1)
    8000562a:	40dc                	lw	a5,4(s1)
    8000562c:	02f05263          	blez	a5,80005650 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80005630:	2785                	addiw	a5,a5,1
    80005632:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80005634:	0003b517          	auipc	a0,0x3b
    80005638:	1dc50513          	addi	a0,a0,476 # 80040810 <ftable>
    8000563c:	ffffb097          	auipc	ra,0xffffb
    80005640:	648080e7          	jalr	1608(ra) # 80000c84 <release>
  return f;
}
    80005644:	8526                	mv	a0,s1
    80005646:	60e2                	ld	ra,24(sp)
    80005648:	6442                	ld	s0,16(sp)
    8000564a:	64a2                	ld	s1,8(sp)
    8000564c:	6105                	addi	sp,sp,32
    8000564e:	8082                	ret
    panic("filedup");
    80005650:	00004517          	auipc	a0,0x4
    80005654:	07050513          	addi	a0,a0,112 # 800096c0 <syscalls+0x298>
    80005658:	ffffb097          	auipc	ra,0xffffb
    8000565c:	ed2080e7          	jalr	-302(ra) # 8000052a <panic>

0000000080005660 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80005660:	7139                	addi	sp,sp,-64
    80005662:	fc06                	sd	ra,56(sp)
    80005664:	f822                	sd	s0,48(sp)
    80005666:	f426                	sd	s1,40(sp)
    80005668:	f04a                	sd	s2,32(sp)
    8000566a:	ec4e                	sd	s3,24(sp)
    8000566c:	e852                	sd	s4,16(sp)
    8000566e:	e456                	sd	s5,8(sp)
    80005670:	0080                	addi	s0,sp,64
    80005672:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80005674:	0003b517          	auipc	a0,0x3b
    80005678:	19c50513          	addi	a0,a0,412 # 80040810 <ftable>
    8000567c:	ffffb097          	auipc	ra,0xffffb
    80005680:	54e080e7          	jalr	1358(ra) # 80000bca <acquire>
  if(f->ref < 1)
    80005684:	40dc                	lw	a5,4(s1)
    80005686:	06f05163          	blez	a5,800056e8 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    8000568a:	37fd                	addiw	a5,a5,-1
    8000568c:	0007871b          	sext.w	a4,a5
    80005690:	c0dc                	sw	a5,4(s1)
    80005692:	06e04363          	bgtz	a4,800056f8 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80005696:	0004a903          	lw	s2,0(s1)
    8000569a:	0094ca83          	lbu	s5,9(s1)
    8000569e:	0104ba03          	ld	s4,16(s1)
    800056a2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800056a6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800056aa:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800056ae:	0003b517          	auipc	a0,0x3b
    800056b2:	16250513          	addi	a0,a0,354 # 80040810 <ftable>
    800056b6:	ffffb097          	auipc	ra,0xffffb
    800056ba:	5ce080e7          	jalr	1486(ra) # 80000c84 <release>

  if(ff.type == FD_PIPE){
    800056be:	4785                	li	a5,1
    800056c0:	04f90d63          	beq	s2,a5,8000571a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800056c4:	3979                	addiw	s2,s2,-2
    800056c6:	4785                	li	a5,1
    800056c8:	0527e063          	bltu	a5,s2,80005708 <fileclose+0xa8>
    begin_op();
    800056cc:	00000097          	auipc	ra,0x0
    800056d0:	ac8080e7          	jalr	-1336(ra) # 80005194 <begin_op>
    iput(ff.ip);
    800056d4:	854e                	mv	a0,s3
    800056d6:	fffff097          	auipc	ra,0xfffff
    800056da:	29e080e7          	jalr	670(ra) # 80004974 <iput>
    end_op();
    800056de:	00000097          	auipc	ra,0x0
    800056e2:	b36080e7          	jalr	-1226(ra) # 80005214 <end_op>
    800056e6:	a00d                	j	80005708 <fileclose+0xa8>
    panic("fileclose");
    800056e8:	00004517          	auipc	a0,0x4
    800056ec:	fe050513          	addi	a0,a0,-32 # 800096c8 <syscalls+0x2a0>
    800056f0:	ffffb097          	auipc	ra,0xffffb
    800056f4:	e3a080e7          	jalr	-454(ra) # 8000052a <panic>
    release(&ftable.lock);
    800056f8:	0003b517          	auipc	a0,0x3b
    800056fc:	11850513          	addi	a0,a0,280 # 80040810 <ftable>
    80005700:	ffffb097          	auipc	ra,0xffffb
    80005704:	584080e7          	jalr	1412(ra) # 80000c84 <release>
  }
}
    80005708:	70e2                	ld	ra,56(sp)
    8000570a:	7442                	ld	s0,48(sp)
    8000570c:	74a2                	ld	s1,40(sp)
    8000570e:	7902                	ld	s2,32(sp)
    80005710:	69e2                	ld	s3,24(sp)
    80005712:	6a42                	ld	s4,16(sp)
    80005714:	6aa2                	ld	s5,8(sp)
    80005716:	6121                	addi	sp,sp,64
    80005718:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000571a:	85d6                	mv	a1,s5
    8000571c:	8552                	mv	a0,s4
    8000571e:	00000097          	auipc	ra,0x0
    80005722:	350080e7          	jalr	848(ra) # 80005a6e <pipeclose>
    80005726:	b7cd                	j	80005708 <fileclose+0xa8>

0000000080005728 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80005728:	715d                	addi	sp,sp,-80
    8000572a:	e486                	sd	ra,72(sp)
    8000572c:	e0a2                	sd	s0,64(sp)
    8000572e:	fc26                	sd	s1,56(sp)
    80005730:	f84a                	sd	s2,48(sp)
    80005732:	f44e                	sd	s3,40(sp)
    80005734:	0880                	addi	s0,sp,80
    80005736:	84aa                	mv	s1,a0
    80005738:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000573a:	ffffc097          	auipc	ra,0xffffc
    8000573e:	32c080e7          	jalr	812(ra) # 80001a66 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80005742:	409c                	lw	a5,0(s1)
    80005744:	37f9                	addiw	a5,a5,-2
    80005746:	4705                	li	a4,1
    80005748:	04f76963          	bltu	a4,a5,8000579a <filestat+0x72>
    8000574c:	892a                	mv	s2,a0
    ilock(f->ip);
    8000574e:	6c88                	ld	a0,24(s1)
    80005750:	fffff097          	auipc	ra,0xfffff
    80005754:	06a080e7          	jalr	106(ra) # 800047ba <ilock>
    stati(f->ip, &st);
    80005758:	fb840593          	addi	a1,s0,-72
    8000575c:	6c88                	ld	a0,24(s1)
    8000575e:	fffff097          	auipc	ra,0xfffff
    80005762:	2e6080e7          	jalr	742(ra) # 80004a44 <stati>
    iunlock(f->ip);
    80005766:	6c88                	ld	a0,24(s1)
    80005768:	fffff097          	auipc	ra,0xfffff
    8000576c:	114080e7          	jalr	276(ra) # 8000487c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80005770:	6505                	lui	a0,0x1
    80005772:	954a                	add	a0,a0,s2
    80005774:	46e1                	li	a3,24
    80005776:	fb840613          	addi	a2,s0,-72
    8000577a:	85ce                	mv	a1,s3
    8000577c:	81853503          	ld	a0,-2024(a0) # 818 <_entry-0x7ffff7e8>
    80005780:	ffffc097          	auipc	ra,0xffffc
    80005784:	ecc080e7          	jalr	-308(ra) # 8000164c <copyout>
    80005788:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    8000578c:	60a6                	ld	ra,72(sp)
    8000578e:	6406                	ld	s0,64(sp)
    80005790:	74e2                	ld	s1,56(sp)
    80005792:	7942                	ld	s2,48(sp)
    80005794:	79a2                	ld	s3,40(sp)
    80005796:	6161                	addi	sp,sp,80
    80005798:	8082                	ret
  return -1;
    8000579a:	557d                	li	a0,-1
    8000579c:	bfc5                	j	8000578c <filestat+0x64>

000000008000579e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000579e:	7179                	addi	sp,sp,-48
    800057a0:	f406                	sd	ra,40(sp)
    800057a2:	f022                	sd	s0,32(sp)
    800057a4:	ec26                	sd	s1,24(sp)
    800057a6:	e84a                	sd	s2,16(sp)
    800057a8:	e44e                	sd	s3,8(sp)
    800057aa:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800057ac:	00854783          	lbu	a5,8(a0)
    800057b0:	c3d5                	beqz	a5,80005854 <fileread+0xb6>
    800057b2:	84aa                	mv	s1,a0
    800057b4:	89ae                	mv	s3,a1
    800057b6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800057b8:	411c                	lw	a5,0(a0)
    800057ba:	4705                	li	a4,1
    800057bc:	04e78963          	beq	a5,a4,8000580e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800057c0:	470d                	li	a4,3
    800057c2:	04e78d63          	beq	a5,a4,8000581c <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800057c6:	4709                	li	a4,2
    800057c8:	06e79e63          	bne	a5,a4,80005844 <fileread+0xa6>
    ilock(f->ip);
    800057cc:	6d08                	ld	a0,24(a0)
    800057ce:	fffff097          	auipc	ra,0xfffff
    800057d2:	fec080e7          	jalr	-20(ra) # 800047ba <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800057d6:	874a                	mv	a4,s2
    800057d8:	5094                	lw	a3,32(s1)
    800057da:	864e                	mv	a2,s3
    800057dc:	4585                	li	a1,1
    800057de:	6c88                	ld	a0,24(s1)
    800057e0:	fffff097          	auipc	ra,0xfffff
    800057e4:	28e080e7          	jalr	654(ra) # 80004a6e <readi>
    800057e8:	892a                	mv	s2,a0
    800057ea:	00a05563          	blez	a0,800057f4 <fileread+0x56>
      f->off += r;
    800057ee:	509c                	lw	a5,32(s1)
    800057f0:	9fa9                	addw	a5,a5,a0
    800057f2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800057f4:	6c88                	ld	a0,24(s1)
    800057f6:	fffff097          	auipc	ra,0xfffff
    800057fa:	086080e7          	jalr	134(ra) # 8000487c <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800057fe:	854a                	mv	a0,s2
    80005800:	70a2                	ld	ra,40(sp)
    80005802:	7402                	ld	s0,32(sp)
    80005804:	64e2                	ld	s1,24(sp)
    80005806:	6942                	ld	s2,16(sp)
    80005808:	69a2                	ld	s3,8(sp)
    8000580a:	6145                	addi	sp,sp,48
    8000580c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000580e:	6908                	ld	a0,16(a0)
    80005810:	00000097          	auipc	ra,0x0
    80005814:	3c8080e7          	jalr	968(ra) # 80005bd8 <piperead>
    80005818:	892a                	mv	s2,a0
    8000581a:	b7d5                	j	800057fe <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000581c:	02451783          	lh	a5,36(a0)
    80005820:	03079693          	slli	a3,a5,0x30
    80005824:	92c1                	srli	a3,a3,0x30
    80005826:	4725                	li	a4,9
    80005828:	02d76863          	bltu	a4,a3,80005858 <fileread+0xba>
    8000582c:	0792                	slli	a5,a5,0x4
    8000582e:	0003b717          	auipc	a4,0x3b
    80005832:	f4270713          	addi	a4,a4,-190 # 80040770 <devsw>
    80005836:	97ba                	add	a5,a5,a4
    80005838:	639c                	ld	a5,0(a5)
    8000583a:	c38d                	beqz	a5,8000585c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    8000583c:	4505                	li	a0,1
    8000583e:	9782                	jalr	a5
    80005840:	892a                	mv	s2,a0
    80005842:	bf75                	j	800057fe <fileread+0x60>
    panic("fileread");
    80005844:	00004517          	auipc	a0,0x4
    80005848:	e9450513          	addi	a0,a0,-364 # 800096d8 <syscalls+0x2b0>
    8000584c:	ffffb097          	auipc	ra,0xffffb
    80005850:	cde080e7          	jalr	-802(ra) # 8000052a <panic>
    return -1;
    80005854:	597d                	li	s2,-1
    80005856:	b765                	j	800057fe <fileread+0x60>
      return -1;
    80005858:	597d                	li	s2,-1
    8000585a:	b755                	j	800057fe <fileread+0x60>
    8000585c:	597d                	li	s2,-1
    8000585e:	b745                	j	800057fe <fileread+0x60>

0000000080005860 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80005860:	715d                	addi	sp,sp,-80
    80005862:	e486                	sd	ra,72(sp)
    80005864:	e0a2                	sd	s0,64(sp)
    80005866:	fc26                	sd	s1,56(sp)
    80005868:	f84a                	sd	s2,48(sp)
    8000586a:	f44e                	sd	s3,40(sp)
    8000586c:	f052                	sd	s4,32(sp)
    8000586e:	ec56                	sd	s5,24(sp)
    80005870:	e85a                	sd	s6,16(sp)
    80005872:	e45e                	sd	s7,8(sp)
    80005874:	e062                	sd	s8,0(sp)
    80005876:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80005878:	00954783          	lbu	a5,9(a0)
    8000587c:	10078663          	beqz	a5,80005988 <filewrite+0x128>
    80005880:	892a                	mv	s2,a0
    80005882:	8aae                	mv	s5,a1
    80005884:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80005886:	411c                	lw	a5,0(a0)
    80005888:	4705                	li	a4,1
    8000588a:	02e78263          	beq	a5,a4,800058ae <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000588e:	470d                	li	a4,3
    80005890:	02e78663          	beq	a5,a4,800058bc <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80005894:	4709                	li	a4,2
    80005896:	0ee79163          	bne	a5,a4,80005978 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000589a:	0ac05d63          	blez	a2,80005954 <filewrite+0xf4>
    int i = 0;
    8000589e:	4981                	li	s3,0
    800058a0:	6b05                	lui	s6,0x1
    800058a2:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800058a6:	6b85                	lui	s7,0x1
    800058a8:	c00b8b9b          	addiw	s7,s7,-1024
    800058ac:	a861                	j	80005944 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    800058ae:	6908                	ld	a0,16(a0)
    800058b0:	00000097          	auipc	ra,0x0
    800058b4:	22e080e7          	jalr	558(ra) # 80005ade <pipewrite>
    800058b8:	8a2a                	mv	s4,a0
    800058ba:	a045                	j	8000595a <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800058bc:	02451783          	lh	a5,36(a0)
    800058c0:	03079693          	slli	a3,a5,0x30
    800058c4:	92c1                	srli	a3,a3,0x30
    800058c6:	4725                	li	a4,9
    800058c8:	0cd76263          	bltu	a4,a3,8000598c <filewrite+0x12c>
    800058cc:	0792                	slli	a5,a5,0x4
    800058ce:	0003b717          	auipc	a4,0x3b
    800058d2:	ea270713          	addi	a4,a4,-350 # 80040770 <devsw>
    800058d6:	97ba                	add	a5,a5,a4
    800058d8:	679c                	ld	a5,8(a5)
    800058da:	cbdd                	beqz	a5,80005990 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    800058dc:	4505                	li	a0,1
    800058de:	9782                	jalr	a5
    800058e0:	8a2a                	mv	s4,a0
    800058e2:	a8a5                	j	8000595a <filewrite+0xfa>
    800058e4:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    800058e8:	00000097          	auipc	ra,0x0
    800058ec:	8ac080e7          	jalr	-1876(ra) # 80005194 <begin_op>
      ilock(f->ip);
    800058f0:	01893503          	ld	a0,24(s2)
    800058f4:	fffff097          	auipc	ra,0xfffff
    800058f8:	ec6080e7          	jalr	-314(ra) # 800047ba <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800058fc:	8762                	mv	a4,s8
    800058fe:	02092683          	lw	a3,32(s2)
    80005902:	01598633          	add	a2,s3,s5
    80005906:	4585                	li	a1,1
    80005908:	01893503          	ld	a0,24(s2)
    8000590c:	fffff097          	auipc	ra,0xfffff
    80005910:	25a080e7          	jalr	602(ra) # 80004b66 <writei>
    80005914:	84aa                	mv	s1,a0
    80005916:	00a05763          	blez	a0,80005924 <filewrite+0xc4>
        f->off += r;
    8000591a:	02092783          	lw	a5,32(s2)
    8000591e:	9fa9                	addw	a5,a5,a0
    80005920:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80005924:	01893503          	ld	a0,24(s2)
    80005928:	fffff097          	auipc	ra,0xfffff
    8000592c:	f54080e7          	jalr	-172(ra) # 8000487c <iunlock>
      end_op();
    80005930:	00000097          	auipc	ra,0x0
    80005934:	8e4080e7          	jalr	-1820(ra) # 80005214 <end_op>

      if(r != n1){
    80005938:	009c1f63          	bne	s8,s1,80005956 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    8000593c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80005940:	0149db63          	bge	s3,s4,80005956 <filewrite+0xf6>
      int n1 = n - i;
    80005944:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80005948:	84be                	mv	s1,a5
    8000594a:	2781                	sext.w	a5,a5
    8000594c:	f8fb5ce3          	bge	s6,a5,800058e4 <filewrite+0x84>
    80005950:	84de                	mv	s1,s7
    80005952:	bf49                	j	800058e4 <filewrite+0x84>
    int i = 0;
    80005954:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80005956:	013a1f63          	bne	s4,s3,80005974 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000595a:	8552                	mv	a0,s4
    8000595c:	60a6                	ld	ra,72(sp)
    8000595e:	6406                	ld	s0,64(sp)
    80005960:	74e2                	ld	s1,56(sp)
    80005962:	7942                	ld	s2,48(sp)
    80005964:	79a2                	ld	s3,40(sp)
    80005966:	7a02                	ld	s4,32(sp)
    80005968:	6ae2                	ld	s5,24(sp)
    8000596a:	6b42                	ld	s6,16(sp)
    8000596c:	6ba2                	ld	s7,8(sp)
    8000596e:	6c02                	ld	s8,0(sp)
    80005970:	6161                	addi	sp,sp,80
    80005972:	8082                	ret
    ret = (i == n ? n : -1);
    80005974:	5a7d                	li	s4,-1
    80005976:	b7d5                	j	8000595a <filewrite+0xfa>
    panic("filewrite");
    80005978:	00004517          	auipc	a0,0x4
    8000597c:	d7050513          	addi	a0,a0,-656 # 800096e8 <syscalls+0x2c0>
    80005980:	ffffb097          	auipc	ra,0xffffb
    80005984:	baa080e7          	jalr	-1110(ra) # 8000052a <panic>
    return -1;
    80005988:	5a7d                	li	s4,-1
    8000598a:	bfc1                	j	8000595a <filewrite+0xfa>
      return -1;
    8000598c:	5a7d                	li	s4,-1
    8000598e:	b7f1                	j	8000595a <filewrite+0xfa>
    80005990:	5a7d                	li	s4,-1
    80005992:	b7e1                	j	8000595a <filewrite+0xfa>

0000000080005994 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80005994:	7179                	addi	sp,sp,-48
    80005996:	f406                	sd	ra,40(sp)
    80005998:	f022                	sd	s0,32(sp)
    8000599a:	ec26                	sd	s1,24(sp)
    8000599c:	e84a                	sd	s2,16(sp)
    8000599e:	e44e                	sd	s3,8(sp)
    800059a0:	e052                	sd	s4,0(sp)
    800059a2:	1800                	addi	s0,sp,48
    800059a4:	84aa                	mv	s1,a0
    800059a6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800059a8:	0005b023          	sd	zero,0(a1)
    800059ac:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800059b0:	00000097          	auipc	ra,0x0
    800059b4:	bf4080e7          	jalr	-1036(ra) # 800055a4 <filealloc>
    800059b8:	e088                	sd	a0,0(s1)
    800059ba:	c551                	beqz	a0,80005a46 <pipealloc+0xb2>
    800059bc:	00000097          	auipc	ra,0x0
    800059c0:	be8080e7          	jalr	-1048(ra) # 800055a4 <filealloc>
    800059c4:	00aa3023          	sd	a0,0(s4)
    800059c8:	c92d                	beqz	a0,80005a3a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800059ca:	ffffb097          	auipc	ra,0xffffb
    800059ce:	108080e7          	jalr	264(ra) # 80000ad2 <kalloc>
    800059d2:	892a                	mv	s2,a0
    800059d4:	c125                	beqz	a0,80005a34 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    800059d6:	4985                	li	s3,1
    800059d8:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800059dc:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800059e0:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800059e4:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800059e8:	00004597          	auipc	a1,0x4
    800059ec:	d1058593          	addi	a1,a1,-752 # 800096f8 <syscalls+0x2d0>
    800059f0:	ffffb097          	auipc	ra,0xffffb
    800059f4:	142080e7          	jalr	322(ra) # 80000b32 <initlock>
  (*f0)->type = FD_PIPE;
    800059f8:	609c                	ld	a5,0(s1)
    800059fa:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800059fe:	609c                	ld	a5,0(s1)
    80005a00:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80005a04:	609c                	ld	a5,0(s1)
    80005a06:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80005a0a:	609c                	ld	a5,0(s1)
    80005a0c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80005a10:	000a3783          	ld	a5,0(s4)
    80005a14:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80005a18:	000a3783          	ld	a5,0(s4)
    80005a1c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80005a20:	000a3783          	ld	a5,0(s4)
    80005a24:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80005a28:	000a3783          	ld	a5,0(s4)
    80005a2c:	0127b823          	sd	s2,16(a5)
  return 0;
    80005a30:	4501                	li	a0,0
    80005a32:	a025                	j	80005a5a <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80005a34:	6088                	ld	a0,0(s1)
    80005a36:	e501                	bnez	a0,80005a3e <pipealloc+0xaa>
    80005a38:	a039                	j	80005a46 <pipealloc+0xb2>
    80005a3a:	6088                	ld	a0,0(s1)
    80005a3c:	c51d                	beqz	a0,80005a6a <pipealloc+0xd6>
    fileclose(*f0);
    80005a3e:	00000097          	auipc	ra,0x0
    80005a42:	c22080e7          	jalr	-990(ra) # 80005660 <fileclose>
  if(*f1)
    80005a46:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80005a4a:	557d                	li	a0,-1
  if(*f1)
    80005a4c:	c799                	beqz	a5,80005a5a <pipealloc+0xc6>
    fileclose(*f1);
    80005a4e:	853e                	mv	a0,a5
    80005a50:	00000097          	auipc	ra,0x0
    80005a54:	c10080e7          	jalr	-1008(ra) # 80005660 <fileclose>
  return -1;
    80005a58:	557d                	li	a0,-1
}
    80005a5a:	70a2                	ld	ra,40(sp)
    80005a5c:	7402                	ld	s0,32(sp)
    80005a5e:	64e2                	ld	s1,24(sp)
    80005a60:	6942                	ld	s2,16(sp)
    80005a62:	69a2                	ld	s3,8(sp)
    80005a64:	6a02                	ld	s4,0(sp)
    80005a66:	6145                	addi	sp,sp,48
    80005a68:	8082                	ret
  return -1;
    80005a6a:	557d                	li	a0,-1
    80005a6c:	b7fd                	j	80005a5a <pipealloc+0xc6>

0000000080005a6e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005a6e:	1101                	addi	sp,sp,-32
    80005a70:	ec06                	sd	ra,24(sp)
    80005a72:	e822                	sd	s0,16(sp)
    80005a74:	e426                	sd	s1,8(sp)
    80005a76:	e04a                	sd	s2,0(sp)
    80005a78:	1000                	addi	s0,sp,32
    80005a7a:	84aa                	mv	s1,a0
    80005a7c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005a7e:	ffffb097          	auipc	ra,0xffffb
    80005a82:	14c080e7          	jalr	332(ra) # 80000bca <acquire>
  if(writable){
    80005a86:	02090d63          	beqz	s2,80005ac0 <pipeclose+0x52>
    pi->writeopen = 0;
    80005a8a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005a8e:	21848513          	addi	a0,s1,536
    80005a92:	ffffd097          	auipc	ra,0xffffd
    80005a96:	130080e7          	jalr	304(ra) # 80002bc2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80005a9a:	2204b783          	ld	a5,544(s1)
    80005a9e:	eb95                	bnez	a5,80005ad2 <pipeclose+0x64>
    release(&pi->lock);
    80005aa0:	8526                	mv	a0,s1
    80005aa2:	ffffb097          	auipc	ra,0xffffb
    80005aa6:	1e2080e7          	jalr	482(ra) # 80000c84 <release>
    kfree((char*)pi);
    80005aaa:	8526                	mv	a0,s1
    80005aac:	ffffb097          	auipc	ra,0xffffb
    80005ab0:	f2a080e7          	jalr	-214(ra) # 800009d6 <kfree>
  } else
    release(&pi->lock);
}
    80005ab4:	60e2                	ld	ra,24(sp)
    80005ab6:	6442                	ld	s0,16(sp)
    80005ab8:	64a2                	ld	s1,8(sp)
    80005aba:	6902                	ld	s2,0(sp)
    80005abc:	6105                	addi	sp,sp,32
    80005abe:	8082                	ret
    pi->readopen = 0;
    80005ac0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80005ac4:	21c48513          	addi	a0,s1,540
    80005ac8:	ffffd097          	auipc	ra,0xffffd
    80005acc:	0fa080e7          	jalr	250(ra) # 80002bc2 <wakeup>
    80005ad0:	b7e9                	j	80005a9a <pipeclose+0x2c>
    release(&pi->lock);
    80005ad2:	8526                	mv	a0,s1
    80005ad4:	ffffb097          	auipc	ra,0xffffb
    80005ad8:	1b0080e7          	jalr	432(ra) # 80000c84 <release>
}
    80005adc:	bfe1                	j	80005ab4 <pipeclose+0x46>

0000000080005ade <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005ade:	7159                	addi	sp,sp,-112
    80005ae0:	f486                	sd	ra,104(sp)
    80005ae2:	f0a2                	sd	s0,96(sp)
    80005ae4:	eca6                	sd	s1,88(sp)
    80005ae6:	e8ca                	sd	s2,80(sp)
    80005ae8:	e4ce                	sd	s3,72(sp)
    80005aea:	e0d2                	sd	s4,64(sp)
    80005aec:	fc56                	sd	s5,56(sp)
    80005aee:	f85a                	sd	s6,48(sp)
    80005af0:	f45e                	sd	s7,40(sp)
    80005af2:	f062                	sd	s8,32(sp)
    80005af4:	ec66                	sd	s9,24(sp)
    80005af6:	1880                	addi	s0,sp,112
    80005af8:	84aa                	mv	s1,a0
    80005afa:	8aae                	mv	s5,a1
    80005afc:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80005afe:	ffffc097          	auipc	ra,0xffffc
    80005b02:	f68080e7          	jalr	-152(ra) # 80001a66 <myproc>
    80005b06:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80005b08:	8526                	mv	a0,s1
    80005b0a:	ffffb097          	auipc	ra,0xffffb
    80005b0e:	0c0080e7          	jalr	192(ra) # 80000bca <acquire>
  while(i < n){
    80005b12:	0b405663          	blez	s4,80005bbe <pipewrite+0xe0>
  int i = 0;
    80005b16:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005b18:	6b05                	lui	s6,0x1
    80005b1a:	9b4e                	add	s6,s6,s3
    80005b1c:	5bfd                	li	s7,-1
      wakeup(&pi->nread);
    80005b1e:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80005b22:	21c48c13          	addi	s8,s1,540
    80005b26:	a091                	j	80005b6a <pipewrite+0x8c>
      release(&pi->lock);
    80005b28:	8526                	mv	a0,s1
    80005b2a:	ffffb097          	auipc	ra,0xffffb
    80005b2e:	15a080e7          	jalr	346(ra) # 80000c84 <release>
      return -1;
    80005b32:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80005b34:	854a                	mv	a0,s2
    80005b36:	70a6                	ld	ra,104(sp)
    80005b38:	7406                	ld	s0,96(sp)
    80005b3a:	64e6                	ld	s1,88(sp)
    80005b3c:	6946                	ld	s2,80(sp)
    80005b3e:	69a6                	ld	s3,72(sp)
    80005b40:	6a06                	ld	s4,64(sp)
    80005b42:	7ae2                	ld	s5,56(sp)
    80005b44:	7b42                	ld	s6,48(sp)
    80005b46:	7ba2                	ld	s7,40(sp)
    80005b48:	7c02                	ld	s8,32(sp)
    80005b4a:	6ce2                	ld	s9,24(sp)
    80005b4c:	6165                	addi	sp,sp,112
    80005b4e:	8082                	ret
      wakeup(&pi->nread);
    80005b50:	8566                	mv	a0,s9
    80005b52:	ffffd097          	auipc	ra,0xffffd
    80005b56:	070080e7          	jalr	112(ra) # 80002bc2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80005b5a:	85a6                	mv	a1,s1
    80005b5c:	8562                	mv	a0,s8
    80005b5e:	ffffd097          	auipc	ra,0xffffd
    80005b62:	cf6080e7          	jalr	-778(ra) # 80002854 <sleep>
  while(i < n){
    80005b66:	05495d63          	bge	s2,s4,80005bc0 <pipewrite+0xe2>
    if(pi->readopen == 0 || pr->killed){
    80005b6a:	2204a783          	lw	a5,544(s1)
    80005b6e:	dfcd                	beqz	a5,80005b28 <pipewrite+0x4a>
    80005b70:	01c9a783          	lw	a5,28(s3)
    80005b74:	fbd5                	bnez	a5,80005b28 <pipewrite+0x4a>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80005b76:	2184a783          	lw	a5,536(s1)
    80005b7a:	21c4a703          	lw	a4,540(s1)
    80005b7e:	2007879b          	addiw	a5,a5,512
    80005b82:	fcf707e3          	beq	a4,a5,80005b50 <pipewrite+0x72>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005b86:	4685                	li	a3,1
    80005b88:	01590633          	add	a2,s2,s5
    80005b8c:	f9f40593          	addi	a1,s0,-97
    80005b90:	818b3503          	ld	a0,-2024(s6) # 818 <_entry-0x7ffff7e8>
    80005b94:	ffffc097          	auipc	ra,0xffffc
    80005b98:	b44080e7          	jalr	-1212(ra) # 800016d8 <copyin>
    80005b9c:	03750263          	beq	a0,s7,80005bc0 <pipewrite+0xe2>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005ba0:	21c4a783          	lw	a5,540(s1)
    80005ba4:	0017871b          	addiw	a4,a5,1
    80005ba8:	20e4ae23          	sw	a4,540(s1)
    80005bac:	1ff7f793          	andi	a5,a5,511
    80005bb0:	97a6                	add	a5,a5,s1
    80005bb2:	f9f44703          	lbu	a4,-97(s0)
    80005bb6:	00e78c23          	sb	a4,24(a5)
      i++;
    80005bba:	2905                	addiw	s2,s2,1
    80005bbc:	b76d                	j	80005b66 <pipewrite+0x88>
  int i = 0;
    80005bbe:	4901                	li	s2,0
  wakeup(&pi->nread);
    80005bc0:	21848513          	addi	a0,s1,536
    80005bc4:	ffffd097          	auipc	ra,0xffffd
    80005bc8:	ffe080e7          	jalr	-2(ra) # 80002bc2 <wakeup>
  release(&pi->lock);
    80005bcc:	8526                	mv	a0,s1
    80005bce:	ffffb097          	auipc	ra,0xffffb
    80005bd2:	0b6080e7          	jalr	182(ra) # 80000c84 <release>
  return i;
    80005bd6:	bfb9                	j	80005b34 <pipewrite+0x56>

0000000080005bd8 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005bd8:	715d                	addi	sp,sp,-80
    80005bda:	e486                	sd	ra,72(sp)
    80005bdc:	e0a2                	sd	s0,64(sp)
    80005bde:	fc26                	sd	s1,56(sp)
    80005be0:	f84a                	sd	s2,48(sp)
    80005be2:	f44e                	sd	s3,40(sp)
    80005be4:	f052                	sd	s4,32(sp)
    80005be6:	ec56                	sd	s5,24(sp)
    80005be8:	e85a                	sd	s6,16(sp)
    80005bea:	0880                	addi	s0,sp,80
    80005bec:	84aa                	mv	s1,a0
    80005bee:	892e                	mv	s2,a1
    80005bf0:	8a32                	mv	s4,a2
  int i;
  struct proc *pr = myproc();
    80005bf2:	ffffc097          	auipc	ra,0xffffc
    80005bf6:	e74080e7          	jalr	-396(ra) # 80001a66 <myproc>
    80005bfa:	8aaa                	mv	s5,a0
  char ch;

  acquire(&pi->lock);
    80005bfc:	8526                	mv	a0,s1
    80005bfe:	ffffb097          	auipc	ra,0xffffb
    80005c02:	fcc080e7          	jalr	-52(ra) # 80000bca <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005c06:	2184a703          	lw	a4,536(s1)
    80005c0a:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005c0e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005c12:	02f71463          	bne	a4,a5,80005c3a <piperead+0x62>
    80005c16:	2244a783          	lw	a5,548(s1)
    80005c1a:	c385                	beqz	a5,80005c3a <piperead+0x62>
    if(pr->killed){
    80005c1c:	01caa783          	lw	a5,28(s5)
    80005c20:	ebd1                	bnez	a5,80005cb4 <piperead+0xdc>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005c22:	85a6                	mv	a1,s1
    80005c24:	854e                	mv	a0,s3
    80005c26:	ffffd097          	auipc	ra,0xffffd
    80005c2a:	c2e080e7          	jalr	-978(ra) # 80002854 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005c2e:	2184a703          	lw	a4,536(s1)
    80005c32:	21c4a783          	lw	a5,540(s1)
    80005c36:	fef700e3          	beq	a4,a5,80005c16 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005c3a:	4981                	li	s3,0
    80005c3c:	09405363          	blez	s4,80005cc2 <piperead+0xea>
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005c40:	6505                	lui	a0,0x1
    80005c42:	9aaa                	add	s5,s5,a0
    80005c44:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80005c46:	2184a783          	lw	a5,536(s1)
    80005c4a:	21c4a703          	lw	a4,540(s1)
    80005c4e:	02f70d63          	beq	a4,a5,80005c88 <piperead+0xb0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005c52:	0017871b          	addiw	a4,a5,1
    80005c56:	20e4ac23          	sw	a4,536(s1)
    80005c5a:	1ff7f793          	andi	a5,a5,511
    80005c5e:	97a6                	add	a5,a5,s1
    80005c60:	0187c783          	lbu	a5,24(a5)
    80005c64:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005c68:	4685                	li	a3,1
    80005c6a:	fbf40613          	addi	a2,s0,-65
    80005c6e:	85ca                	mv	a1,s2
    80005c70:	818ab503          	ld	a0,-2024(s5)
    80005c74:	ffffc097          	auipc	ra,0xffffc
    80005c78:	9d8080e7          	jalr	-1576(ra) # 8000164c <copyout>
    80005c7c:	01650663          	beq	a0,s6,80005c88 <piperead+0xb0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005c80:	2985                	addiw	s3,s3,1
    80005c82:	0905                	addi	s2,s2,1
    80005c84:	fd3a11e3          	bne	s4,s3,80005c46 <piperead+0x6e>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005c88:	21c48513          	addi	a0,s1,540
    80005c8c:	ffffd097          	auipc	ra,0xffffd
    80005c90:	f36080e7          	jalr	-202(ra) # 80002bc2 <wakeup>
  release(&pi->lock);
    80005c94:	8526                	mv	a0,s1
    80005c96:	ffffb097          	auipc	ra,0xffffb
    80005c9a:	fee080e7          	jalr	-18(ra) # 80000c84 <release>
  return i;
}
    80005c9e:	854e                	mv	a0,s3
    80005ca0:	60a6                	ld	ra,72(sp)
    80005ca2:	6406                	ld	s0,64(sp)
    80005ca4:	74e2                	ld	s1,56(sp)
    80005ca6:	7942                	ld	s2,48(sp)
    80005ca8:	79a2                	ld	s3,40(sp)
    80005caa:	7a02                	ld	s4,32(sp)
    80005cac:	6ae2                	ld	s5,24(sp)
    80005cae:	6b42                	ld	s6,16(sp)
    80005cb0:	6161                	addi	sp,sp,80
    80005cb2:	8082                	ret
      release(&pi->lock);
    80005cb4:	8526                	mv	a0,s1
    80005cb6:	ffffb097          	auipc	ra,0xffffb
    80005cba:	fce080e7          	jalr	-50(ra) # 80000c84 <release>
      return -1;
    80005cbe:	59fd                	li	s3,-1
    80005cc0:	bff9                	j	80005c9e <piperead+0xc6>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005cc2:	4981                	li	s3,0
    80005cc4:	b7d1                	j	80005c88 <piperead+0xb0>

0000000080005cc6 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80005cc6:	dd010113          	addi	sp,sp,-560
    80005cca:	22113423          	sd	ra,552(sp)
    80005cce:	22813023          	sd	s0,544(sp)
    80005cd2:	20913c23          	sd	s1,536(sp)
    80005cd6:	21213823          	sd	s2,528(sp)
    80005cda:	21313423          	sd	s3,520(sp)
    80005cde:	21413023          	sd	s4,512(sp)
    80005ce2:	ffd6                	sd	s5,504(sp)
    80005ce4:	fbda                	sd	s6,496(sp)
    80005ce6:	f7de                	sd	s7,488(sp)
    80005ce8:	f3e2                	sd	s8,480(sp)
    80005cea:	efe6                	sd	s9,472(sp)
    80005cec:	ebea                	sd	s10,464(sp)
    80005cee:	e7ee                	sd	s11,456(sp)
    80005cf0:	1c00                	addi	s0,sp,560
    80005cf2:	892a                	mv	s2,a0
    80005cf4:	dea43423          	sd	a0,-536(s0)
    80005cf8:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005cfc:	ffffc097          	auipc	ra,0xffffc
    80005d00:	d6a080e7          	jalr	-662(ra) # 80001a66 <myproc>
    80005d04:	84aa                	mv	s1,a0
  struct thread *t = mythread();
    80005d06:	ffffc097          	auipc	ra,0xffffc
    80005d0a:	da0080e7          	jalr	-608(ra) # 80001aa6 <mythread>
    80005d0e:	dea43023          	sd	a0,-544(s0)
  begin_op();
    80005d12:	fffff097          	auipc	ra,0xfffff
    80005d16:	482080e7          	jalr	1154(ra) # 80005194 <begin_op>
  if((ip = namei(path)) == 0){
    80005d1a:	854a                	mv	a0,s2
    80005d1c:	fffff097          	auipc	ra,0xfffff
    80005d20:	258080e7          	jalr	600(ra) # 80004f74 <namei>
    80005d24:	cd2d                	beqz	a0,80005d9e <exec+0xd8>
    80005d26:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005d28:	fffff097          	auipc	ra,0xfffff
    80005d2c:	a92080e7          	jalr	-1390(ra) # 800047ba <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005d30:	04000713          	li	a4,64
    80005d34:	4681                	li	a3,0
    80005d36:	e4840613          	addi	a2,s0,-440
    80005d3a:	4581                	li	a1,0
    80005d3c:	8556                	mv	a0,s5
    80005d3e:	fffff097          	auipc	ra,0xfffff
    80005d42:	d30080e7          	jalr	-720(ra) # 80004a6e <readi>
    80005d46:	04000793          	li	a5,64
    80005d4a:	00f51a63          	bne	a0,a5,80005d5e <exec+0x98>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80005d4e:	e4842703          	lw	a4,-440(s0)
    80005d52:	464c47b7          	lui	a5,0x464c4
    80005d56:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005d5a:	04f70863          	beq	a4,a5,80005daa <exec+0xe4>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005d5e:	8556                	mv	a0,s5
    80005d60:	fffff097          	auipc	ra,0xfffff
    80005d64:	cbc080e7          	jalr	-836(ra) # 80004a1c <iunlockput>
    end_op();
    80005d68:	fffff097          	auipc	ra,0xfffff
    80005d6c:	4ac080e7          	jalr	1196(ra) # 80005214 <end_op>
  }
  return -1;
    80005d70:	557d                	li	a0,-1
}
    80005d72:	22813083          	ld	ra,552(sp)
    80005d76:	22013403          	ld	s0,544(sp)
    80005d7a:	21813483          	ld	s1,536(sp)
    80005d7e:	21013903          	ld	s2,528(sp)
    80005d82:	20813983          	ld	s3,520(sp)
    80005d86:	20013a03          	ld	s4,512(sp)
    80005d8a:	7afe                	ld	s5,504(sp)
    80005d8c:	7b5e                	ld	s6,496(sp)
    80005d8e:	7bbe                	ld	s7,488(sp)
    80005d90:	7c1e                	ld	s8,480(sp)
    80005d92:	6cfe                	ld	s9,472(sp)
    80005d94:	6d5e                	ld	s10,464(sp)
    80005d96:	6dbe                	ld	s11,456(sp)
    80005d98:	23010113          	addi	sp,sp,560
    80005d9c:	8082                	ret
    end_op();
    80005d9e:	fffff097          	auipc	ra,0xfffff
    80005da2:	476080e7          	jalr	1142(ra) # 80005214 <end_op>
    return -1;
    80005da6:	557d                	li	a0,-1
    80005da8:	b7e9                	j	80005d72 <exec+0xac>
  if((pagetable = proc_pagetable(p)) == 0)
    80005daa:	8526                	mv	a0,s1
    80005dac:	ffffc097          	auipc	ra,0xffffc
    80005db0:	f00080e7          	jalr	-256(ra) # 80001cac <proc_pagetable>
    80005db4:	8b2a                	mv	s6,a0
    80005db6:	d545                	beqz	a0,80005d5e <exec+0x98>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005db8:	e6842783          	lw	a5,-408(s0)
    80005dbc:	e8045703          	lhu	a4,-384(s0)
    80005dc0:	c735                	beqz	a4,80005e2c <exec+0x166>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80005dc2:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005dc4:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80005dc8:	6a05                	lui	s4,0x1
    80005dca:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80005dce:	dce43c23          	sd	a4,-552(s0)
  uint64 pa;

  if((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    80005dd2:	6d85                	lui	s11,0x1
    80005dd4:	7d7d                	lui	s10,0xfffff
    80005dd6:	ac9d                	j	8000604c <exec+0x386>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80005dd8:	00004517          	auipc	a0,0x4
    80005ddc:	92850513          	addi	a0,a0,-1752 # 80009700 <syscalls+0x2d8>
    80005de0:	ffffa097          	auipc	ra,0xffffa
    80005de4:	74a080e7          	jalr	1866(ra) # 8000052a <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005de8:	874a                	mv	a4,s2
    80005dea:	009c86bb          	addw	a3,s9,s1
    80005dee:	4581                	li	a1,0
    80005df0:	8556                	mv	a0,s5
    80005df2:	fffff097          	auipc	ra,0xfffff
    80005df6:	c7c080e7          	jalr	-900(ra) # 80004a6e <readi>
    80005dfa:	2501                	sext.w	a0,a0
    80005dfc:	1ea91863          	bne	s2,a0,80005fec <exec+0x326>
  for(i = 0; i < sz; i += PGSIZE){
    80005e00:	009d84bb          	addw	s1,s11,s1
    80005e04:	013d09bb          	addw	s3,s10,s3
    80005e08:	2374f263          	bgeu	s1,s7,8000602c <exec+0x366>
    pa = walkaddr(pagetable, va + i);
    80005e0c:	02049593          	slli	a1,s1,0x20
    80005e10:	9181                	srli	a1,a1,0x20
    80005e12:	95e2                	add	a1,a1,s8
    80005e14:	855a                	mv	a0,s6
    80005e16:	ffffb097          	auipc	ra,0xffffb
    80005e1a:	244080e7          	jalr	580(ra) # 8000105a <walkaddr>
    80005e1e:	862a                	mv	a2,a0
    if(pa == 0)
    80005e20:	dd45                	beqz	a0,80005dd8 <exec+0x112>
      n = PGSIZE;
    80005e22:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80005e24:	fd49f2e3          	bgeu	s3,s4,80005de8 <exec+0x122>
      n = sz - i;
    80005e28:	894e                	mv	s2,s3
    80005e2a:	bf7d                	j	80005de8 <exec+0x122>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80005e2c:	4481                	li	s1,0
  iunlockput(ip);
    80005e2e:	8556                	mv	a0,s5
    80005e30:	fffff097          	auipc	ra,0xfffff
    80005e34:	bec080e7          	jalr	-1044(ra) # 80004a1c <iunlockput>
  end_op();
    80005e38:	fffff097          	auipc	ra,0xfffff
    80005e3c:	3dc080e7          	jalr	988(ra) # 80005214 <end_op>
  p = myproc();
    80005e40:	ffffc097          	auipc	ra,0xffffc
    80005e44:	c26080e7          	jalr	-986(ra) # 80001a66 <myproc>
    80005e48:	8caa                	mv	s9,a0
  uint64 oldsz = p->sz;
    80005e4a:	6785                	lui	a5,0x1
    80005e4c:	00f50733          	add	a4,a0,a5
    80005e50:	81073d03          	ld	s10,-2032(a4)
  sz = PGROUNDUP(sz);
    80005e54:	17fd                	addi	a5,a5,-1
    80005e56:	94be                	add	s1,s1,a5
    80005e58:	77fd                	lui	a5,0xfffff
    80005e5a:	8fe5                	and	a5,a5,s1
    80005e5c:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80005e60:	6609                	lui	a2,0x2
    80005e62:	963e                	add	a2,a2,a5
    80005e64:	85be                	mv	a1,a5
    80005e66:	855a                	mv	a0,s6
    80005e68:	ffffb097          	auipc	ra,0xffffb
    80005e6c:	594080e7          	jalr	1428(ra) # 800013fc <uvmalloc>
    80005e70:	8baa                	mv	s7,a0
  ip = 0;
    80005e72:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80005e74:	16050c63          	beqz	a0,80005fec <exec+0x326>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005e78:	75f9                	lui	a1,0xffffe
    80005e7a:	95aa                	add	a1,a1,a0
    80005e7c:	855a                	mv	a0,s6
    80005e7e:	ffffb097          	auipc	ra,0xffffb
    80005e82:	79c080e7          	jalr	1948(ra) # 8000161a <uvmclear>
  stackbase = sp - PGSIZE;
    80005e86:	7afd                	lui	s5,0xfffff
    80005e88:	9ade                	add	s5,s5,s7
  for(argc = 0; argv[argc]; argc++) {
    80005e8a:	df043783          	ld	a5,-528(s0)
    80005e8e:	6388                	ld	a0,0(a5)
    80005e90:	c925                	beqz	a0,80005f00 <exec+0x23a>
    80005e92:	e8840993          	addi	s3,s0,-376
    80005e96:	f8840c13          	addi	s8,s0,-120
  sp = sz;
    80005e9a:	895e                	mv	s2,s7
  for(argc = 0; argv[argc]; argc++) {
    80005e9c:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005e9e:	ffffb097          	auipc	ra,0xffffb
    80005ea2:	fb2080e7          	jalr	-78(ra) # 80000e50 <strlen>
    80005ea6:	0015079b          	addiw	a5,a0,1
    80005eaa:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005eae:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80005eb2:	17596163          	bltu	s2,s5,80006014 <exec+0x34e>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005eb6:	df043d83          	ld	s11,-528(s0)
    80005eba:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80005ebe:	8552                	mv	a0,s4
    80005ec0:	ffffb097          	auipc	ra,0xffffb
    80005ec4:	f90080e7          	jalr	-112(ra) # 80000e50 <strlen>
    80005ec8:	0015069b          	addiw	a3,a0,1
    80005ecc:	8652                	mv	a2,s4
    80005ece:	85ca                	mv	a1,s2
    80005ed0:	855a                	mv	a0,s6
    80005ed2:	ffffb097          	auipc	ra,0xffffb
    80005ed6:	77a080e7          	jalr	1914(ra) # 8000164c <copyout>
    80005eda:	14054163          	bltz	a0,8000601c <exec+0x356>
    ustack[argc] = sp;
    80005ede:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005ee2:	0485                	addi	s1,s1,1
    80005ee4:	008d8793          	addi	a5,s11,8
    80005ee8:	def43823          	sd	a5,-528(s0)
    80005eec:	008db503          	ld	a0,8(s11)
    80005ef0:	c911                	beqz	a0,80005f04 <exec+0x23e>
    if(argc >= MAXARG)
    80005ef2:	09a1                	addi	s3,s3,8
    80005ef4:	fb8995e3          	bne	s3,s8,80005e9e <exec+0x1d8>
  sz = sz1;
    80005ef8:	df743c23          	sd	s7,-520(s0)
  ip = 0;
    80005efc:	4a81                	li	s5,0
    80005efe:	a0fd                	j	80005fec <exec+0x326>
  sp = sz;
    80005f00:	895e                	mv	s2,s7
  for(argc = 0; argv[argc]; argc++) {
    80005f02:	4481                	li	s1,0
  ustack[argc] = 0;
    80005f04:	00349793          	slli	a5,s1,0x3
    80005f08:	f9040713          	addi	a4,s0,-112
    80005f0c:	97ba                	add	a5,a5,a4
    80005f0e:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffb9ef8>
  sp -= (argc+1) * sizeof(uint64);
    80005f12:	00148693          	addi	a3,s1,1
    80005f16:	068e                	slli	a3,a3,0x3
    80005f18:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005f1c:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80005f20:	01597663          	bgeu	s2,s5,80005f2c <exec+0x266>
  sz = sz1;
    80005f24:	df743c23          	sd	s7,-520(s0)
  ip = 0;
    80005f28:	4a81                	li	s5,0
    80005f2a:	a0c9                	j	80005fec <exec+0x326>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005f2c:	e8840613          	addi	a2,s0,-376
    80005f30:	85ca                	mv	a1,s2
    80005f32:	855a                	mv	a0,s6
    80005f34:	ffffb097          	auipc	ra,0xffffb
    80005f38:	718080e7          	jalr	1816(ra) # 8000164c <copyout>
    80005f3c:	0e054463          	bltz	a0,80006024 <exec+0x35e>
  t->trapframe->a1 = sp;
    80005f40:	de043783          	ld	a5,-544(s0)
    80005f44:	63dc                	ld	a5,128(a5)
    80005f46:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005f4a:	de843783          	ld	a5,-536(s0)
    80005f4e:	0007c703          	lbu	a4,0(a5)
    80005f52:	cf11                	beqz	a4,80005f6e <exec+0x2a8>
    80005f54:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005f56:	02f00693          	li	a3,47
    80005f5a:	a039                	j	80005f68 <exec+0x2a2>
      last = s+1;
    80005f5c:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80005f60:	0785                	addi	a5,a5,1
    80005f62:	fff7c703          	lbu	a4,-1(a5)
    80005f66:	c701                	beqz	a4,80005f6e <exec+0x2a8>
    if(*s == '/')
    80005f68:	fed71ce3          	bne	a4,a3,80005f60 <exec+0x29a>
    80005f6c:	bfc5                	j	80005f5c <exec+0x296>
  safestrcpy(p->name, last, sizeof(p->name));
    80005f6e:	6985                	lui	s3,0x1
    80005f70:	8a898513          	addi	a0,s3,-1880 # 8a8 <_entry-0x7ffff758>
    80005f74:	4641                	li	a2,16
    80005f76:	de843583          	ld	a1,-536(s0)
    80005f7a:	9566                	add	a0,a0,s9
    80005f7c:	ffffb097          	auipc	ra,0xffffb
    80005f80:	ea2080e7          	jalr	-350(ra) # 80000e1e <safestrcpy>
  oldpagetable = p->pagetable;
    80005f84:	013c87b3          	add	a5,s9,s3
    80005f88:	8187b503          	ld	a0,-2024(a5)
  p->pagetable = pagetable;
    80005f8c:	8167bc23          	sd	s6,-2024(a5)
  p->sz = sz;
    80005f90:	8177b823          	sd	s7,-2032(a5)
  t->trapframe->epc = elf.entry;  // initial program counter = main
    80005f94:	de043683          	ld	a3,-544(s0)
    80005f98:	62dc                	ld	a5,128(a3)
    80005f9a:	e6043703          	ld	a4,-416(s0)
    80005f9e:	ef98                	sd	a4,24(a5)
  t->trapframe->sp = sp; // initial stack pointer
    80005fa0:	62dc                	ld	a5,128(a3)
    80005fa2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005fa6:	85ea                	mv	a1,s10
    80005fa8:	ffffc097          	auipc	ra,0xffffc
    80005fac:	da0080e7          	jalr	-608(ra) # 80001d48 <proc_freepagetable>
  for(int i = 0; i < 32; i++){
    80005fb0:	030c8793          	addi	a5,s9,48
    80005fb4:	130c8c93          	addi	s9,s9,304
    80005fb8:	85e6                	mv	a1,s9
    if(p->signalHandlers[i] != (void*) SIG_DFL && p->signalHandlers[i] != (void*) SIG_IGN){
    80005fba:	468d                	li	a3,3
    80005fbc:	4505                	li	a0,1
    80005fbe:	a029                	j	80005fc8 <exec+0x302>
  for(int i = 0; i < 32; i++){
    80005fc0:	07a1                	addi	a5,a5,8
    80005fc2:	0c91                	addi	s9,s9,4
    80005fc4:	00b78b63          	beq	a5,a1,80005fda <exec+0x314>
    if(p->signalHandlers[i] != (void*) SIG_DFL && p->signalHandlers[i] != (void*) SIG_IGN){
    80005fc8:	6398                	ld	a4,0(a5)
    80005fca:	fed70be3          	beq	a4,a3,80005fc0 <exec+0x2fa>
    80005fce:	fea709e3          	beq	a4,a0,80005fc0 <exec+0x2fa>
      p->signalHandlers[i] = (void *) SIG_DFL;
    80005fd2:	e394                	sd	a3,0(a5)
      p->signalHandlersMasks[i] = 0;
    80005fd4:	000ca023          	sw	zero,0(s9)
    80005fd8:	b7e5                	j	80005fc0 <exec+0x2fa>
  killOtherThreads();
    80005fda:	ffffd097          	auipc	ra,0xffffd
    80005fde:	cfc080e7          	jalr	-772(ra) # 80002cd6 <killOtherThreads>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005fe2:	0004851b          	sext.w	a0,s1
    80005fe6:	b371                	j	80005d72 <exec+0xac>
    80005fe8:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005fec:	df843583          	ld	a1,-520(s0)
    80005ff0:	855a                	mv	a0,s6
    80005ff2:	ffffc097          	auipc	ra,0xffffc
    80005ff6:	d56080e7          	jalr	-682(ra) # 80001d48 <proc_freepagetable>
  if(ip){
    80005ffa:	d60a92e3          	bnez	s5,80005d5e <exec+0x98>
  return -1;
    80005ffe:	557d                	li	a0,-1
    80006000:	bb8d                	j	80005d72 <exec+0xac>
    80006002:	de943c23          	sd	s1,-520(s0)
    80006006:	b7dd                	j	80005fec <exec+0x326>
    80006008:	de943c23          	sd	s1,-520(s0)
    8000600c:	b7c5                	j	80005fec <exec+0x326>
    8000600e:	de943c23          	sd	s1,-520(s0)
    80006012:	bfe9                	j	80005fec <exec+0x326>
  sz = sz1;
    80006014:	df743c23          	sd	s7,-520(s0)
  ip = 0;
    80006018:	4a81                	li	s5,0
    8000601a:	bfc9                	j	80005fec <exec+0x326>
  sz = sz1;
    8000601c:	df743c23          	sd	s7,-520(s0)
  ip = 0;
    80006020:	4a81                	li	s5,0
    80006022:	b7e9                	j	80005fec <exec+0x326>
  sz = sz1;
    80006024:	df743c23          	sd	s7,-520(s0)
  ip = 0;
    80006028:	4a81                	li	s5,0
    8000602a:	b7c9                	j	80005fec <exec+0x326>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000602c:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80006030:	e0843783          	ld	a5,-504(s0)
    80006034:	0017869b          	addiw	a3,a5,1
    80006038:	e0d43423          	sd	a3,-504(s0)
    8000603c:	e0043783          	ld	a5,-512(s0)
    80006040:	0387879b          	addiw	a5,a5,56
    80006044:	e8045703          	lhu	a4,-384(s0)
    80006048:	dee6d3e3          	bge	a3,a4,80005e2e <exec+0x168>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000604c:	2781                	sext.w	a5,a5
    8000604e:	e0f43023          	sd	a5,-512(s0)
    80006052:	03800713          	li	a4,56
    80006056:	86be                	mv	a3,a5
    80006058:	e1040613          	addi	a2,s0,-496
    8000605c:	4581                	li	a1,0
    8000605e:	8556                	mv	a0,s5
    80006060:	fffff097          	auipc	ra,0xfffff
    80006064:	a0e080e7          	jalr	-1522(ra) # 80004a6e <readi>
    80006068:	03800793          	li	a5,56
    8000606c:	f6f51ee3          	bne	a0,a5,80005fe8 <exec+0x322>
    if(ph.type != ELF_PROG_LOAD)
    80006070:	e1042783          	lw	a5,-496(s0)
    80006074:	4705                	li	a4,1
    80006076:	fae79de3          	bne	a5,a4,80006030 <exec+0x36a>
    if(ph.memsz < ph.filesz)
    8000607a:	e3843603          	ld	a2,-456(s0)
    8000607e:	e3043783          	ld	a5,-464(s0)
    80006082:	f8f660e3          	bltu	a2,a5,80006002 <exec+0x33c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80006086:	e2043783          	ld	a5,-480(s0)
    8000608a:	963e                	add	a2,a2,a5
    8000608c:	f6f66ee3          	bltu	a2,a5,80006008 <exec+0x342>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80006090:	85a6                	mv	a1,s1
    80006092:	855a                	mv	a0,s6
    80006094:	ffffb097          	auipc	ra,0xffffb
    80006098:	368080e7          	jalr	872(ra) # 800013fc <uvmalloc>
    8000609c:	dea43c23          	sd	a0,-520(s0)
    800060a0:	d53d                	beqz	a0,8000600e <exec+0x348>
    if(ph.vaddr % PGSIZE != 0)
    800060a2:	e2043c03          	ld	s8,-480(s0)
    800060a6:	dd843783          	ld	a5,-552(s0)
    800060aa:	00fc77b3          	and	a5,s8,a5
    800060ae:	ff9d                	bnez	a5,80005fec <exec+0x326>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800060b0:	e1842c83          	lw	s9,-488(s0)
    800060b4:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800060b8:	f60b8ae3          	beqz	s7,8000602c <exec+0x366>
    800060bc:	89de                	mv	s3,s7
    800060be:	4481                	li	s1,0
    800060c0:	b3b1                	j	80005e0c <exec+0x146>

00000000800060c2 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800060c2:	7179                	addi	sp,sp,-48
    800060c4:	f406                	sd	ra,40(sp)
    800060c6:	f022                	sd	s0,32(sp)
    800060c8:	ec26                	sd	s1,24(sp)
    800060ca:	e84a                	sd	s2,16(sp)
    800060cc:	1800                	addi	s0,sp,48
    800060ce:	892e                	mv	s2,a1
    800060d0:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800060d2:	fdc40593          	addi	a1,s0,-36
    800060d6:	ffffe097          	auipc	ra,0xffffe
    800060da:	90a080e7          	jalr	-1782(ra) # 800039e0 <argint>
    800060de:	04054063          	bltz	a0,8000611e <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800060e2:	fdc42703          	lw	a4,-36(s0)
    800060e6:	47bd                	li	a5,15
    800060e8:	02e7ed63          	bltu	a5,a4,80006122 <argfd+0x60>
    800060ec:	ffffc097          	auipc	ra,0xffffc
    800060f0:	97a080e7          	jalr	-1670(ra) # 80001a66 <myproc>
    800060f4:	fdc42703          	lw	a4,-36(s0)
    800060f8:	10470793          	addi	a5,a4,260
    800060fc:	078e                	slli	a5,a5,0x3
    800060fe:	953e                	add	a0,a0,a5
    80006100:	611c                	ld	a5,0(a0)
    80006102:	c395                	beqz	a5,80006126 <argfd+0x64>
    return -1;
  if(pfd)
    80006104:	00090463          	beqz	s2,8000610c <argfd+0x4a>
    *pfd = fd;
    80006108:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000610c:	4501                	li	a0,0
  if(pf)
    8000610e:	c091                	beqz	s1,80006112 <argfd+0x50>
    *pf = f;
    80006110:	e09c                	sd	a5,0(s1)
}
    80006112:	70a2                	ld	ra,40(sp)
    80006114:	7402                	ld	s0,32(sp)
    80006116:	64e2                	ld	s1,24(sp)
    80006118:	6942                	ld	s2,16(sp)
    8000611a:	6145                	addi	sp,sp,48
    8000611c:	8082                	ret
    return -1;
    8000611e:	557d                	li	a0,-1
    80006120:	bfcd                	j	80006112 <argfd+0x50>
    return -1;
    80006122:	557d                	li	a0,-1
    80006124:	b7fd                	j	80006112 <argfd+0x50>
    80006126:	557d                	li	a0,-1
    80006128:	b7ed                	j	80006112 <argfd+0x50>

000000008000612a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000612a:	1101                	addi	sp,sp,-32
    8000612c:	ec06                	sd	ra,24(sp)
    8000612e:	e822                	sd	s0,16(sp)
    80006130:	e426                	sd	s1,8(sp)
    80006132:	1000                	addi	s0,sp,32
    80006134:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80006136:	ffffc097          	auipc	ra,0xffffc
    8000613a:	930080e7          	jalr	-1744(ra) # 80001a66 <myproc>
    8000613e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80006140:	6785                	lui	a5,0x1
    80006142:	82078793          	addi	a5,a5,-2016 # 820 <_entry-0x7ffff7e0>
    80006146:	97aa                	add	a5,a5,a0
    80006148:	4501                	li	a0,0
    8000614a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000614c:	6398                	ld	a4,0(a5)
    8000614e:	cb19                	beqz	a4,80006164 <fdalloc+0x3a>
  for(fd = 0; fd < NOFILE; fd++){
    80006150:	2505                	addiw	a0,a0,1
    80006152:	07a1                	addi	a5,a5,8
    80006154:	fed51ce3          	bne	a0,a3,8000614c <fdalloc+0x22>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80006158:	557d                	li	a0,-1
}
    8000615a:	60e2                	ld	ra,24(sp)
    8000615c:	6442                	ld	s0,16(sp)
    8000615e:	64a2                	ld	s1,8(sp)
    80006160:	6105                	addi	sp,sp,32
    80006162:	8082                	ret
      p->ofile[fd] = f;
    80006164:	10450793          	addi	a5,a0,260
    80006168:	078e                	slli	a5,a5,0x3
    8000616a:	963e                	add	a2,a2,a5
    8000616c:	e204                	sd	s1,0(a2)
      return fd;
    8000616e:	b7f5                	j	8000615a <fdalloc+0x30>

0000000080006170 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80006170:	715d                	addi	sp,sp,-80
    80006172:	e486                	sd	ra,72(sp)
    80006174:	e0a2                	sd	s0,64(sp)
    80006176:	fc26                	sd	s1,56(sp)
    80006178:	f84a                	sd	s2,48(sp)
    8000617a:	f44e                	sd	s3,40(sp)
    8000617c:	f052                	sd	s4,32(sp)
    8000617e:	ec56                	sd	s5,24(sp)
    80006180:	0880                	addi	s0,sp,80
    80006182:	89ae                	mv	s3,a1
    80006184:	8ab2                	mv	s5,a2
    80006186:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80006188:	fb040593          	addi	a1,s0,-80
    8000618c:	fffff097          	auipc	ra,0xfffff
    80006190:	e06080e7          	jalr	-506(ra) # 80004f92 <nameiparent>
    80006194:	892a                	mv	s2,a0
    80006196:	12050e63          	beqz	a0,800062d2 <create+0x162>
    return 0;

  ilock(dp);
    8000619a:	ffffe097          	auipc	ra,0xffffe
    8000619e:	620080e7          	jalr	1568(ra) # 800047ba <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800061a2:	4601                	li	a2,0
    800061a4:	fb040593          	addi	a1,s0,-80
    800061a8:	854a                	mv	a0,s2
    800061aa:	fffff097          	auipc	ra,0xfffff
    800061ae:	af4080e7          	jalr	-1292(ra) # 80004c9e <dirlookup>
    800061b2:	84aa                	mv	s1,a0
    800061b4:	c921                	beqz	a0,80006204 <create+0x94>
    iunlockput(dp);
    800061b6:	854a                	mv	a0,s2
    800061b8:	fffff097          	auipc	ra,0xfffff
    800061bc:	864080e7          	jalr	-1948(ra) # 80004a1c <iunlockput>
    ilock(ip);
    800061c0:	8526                	mv	a0,s1
    800061c2:	ffffe097          	auipc	ra,0xffffe
    800061c6:	5f8080e7          	jalr	1528(ra) # 800047ba <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800061ca:	2981                	sext.w	s3,s3
    800061cc:	4789                	li	a5,2
    800061ce:	02f99463          	bne	s3,a5,800061f6 <create+0x86>
    800061d2:	0444d783          	lhu	a5,68(s1)
    800061d6:	37f9                	addiw	a5,a5,-2
    800061d8:	17c2                	slli	a5,a5,0x30
    800061da:	93c1                	srli	a5,a5,0x30
    800061dc:	4705                	li	a4,1
    800061de:	00f76c63          	bltu	a4,a5,800061f6 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800061e2:	8526                	mv	a0,s1
    800061e4:	60a6                	ld	ra,72(sp)
    800061e6:	6406                	ld	s0,64(sp)
    800061e8:	74e2                	ld	s1,56(sp)
    800061ea:	7942                	ld	s2,48(sp)
    800061ec:	79a2                	ld	s3,40(sp)
    800061ee:	7a02                	ld	s4,32(sp)
    800061f0:	6ae2                	ld	s5,24(sp)
    800061f2:	6161                	addi	sp,sp,80
    800061f4:	8082                	ret
    iunlockput(ip);
    800061f6:	8526                	mv	a0,s1
    800061f8:	fffff097          	auipc	ra,0xfffff
    800061fc:	824080e7          	jalr	-2012(ra) # 80004a1c <iunlockput>
    return 0;
    80006200:	4481                	li	s1,0
    80006202:	b7c5                	j	800061e2 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80006204:	85ce                	mv	a1,s3
    80006206:	00092503          	lw	a0,0(s2)
    8000620a:	ffffe097          	auipc	ra,0xffffe
    8000620e:	418080e7          	jalr	1048(ra) # 80004622 <ialloc>
    80006212:	84aa                	mv	s1,a0
    80006214:	c521                	beqz	a0,8000625c <create+0xec>
  ilock(ip);
    80006216:	ffffe097          	auipc	ra,0xffffe
    8000621a:	5a4080e7          	jalr	1444(ra) # 800047ba <ilock>
  ip->major = major;
    8000621e:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80006222:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80006226:	4a05                	li	s4,1
    80006228:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    8000622c:	8526                	mv	a0,s1
    8000622e:	ffffe097          	auipc	ra,0xffffe
    80006232:	4c2080e7          	jalr	1218(ra) # 800046f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80006236:	2981                	sext.w	s3,s3
    80006238:	03498a63          	beq	s3,s4,8000626c <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000623c:	40d0                	lw	a2,4(s1)
    8000623e:	fb040593          	addi	a1,s0,-80
    80006242:	854a                	mv	a0,s2
    80006244:	fffff097          	auipc	ra,0xfffff
    80006248:	c6e080e7          	jalr	-914(ra) # 80004eb2 <dirlink>
    8000624c:	06054b63          	bltz	a0,800062c2 <create+0x152>
  iunlockput(dp);
    80006250:	854a                	mv	a0,s2
    80006252:	ffffe097          	auipc	ra,0xffffe
    80006256:	7ca080e7          	jalr	1994(ra) # 80004a1c <iunlockput>
  return ip;
    8000625a:	b761                	j	800061e2 <create+0x72>
    panic("create: ialloc");
    8000625c:	00003517          	auipc	a0,0x3
    80006260:	4c450513          	addi	a0,a0,1220 # 80009720 <syscalls+0x2f8>
    80006264:	ffffa097          	auipc	ra,0xffffa
    80006268:	2c6080e7          	jalr	710(ra) # 8000052a <panic>
    dp->nlink++;  // for ".."
    8000626c:	04a95783          	lhu	a5,74(s2)
    80006270:	2785                	addiw	a5,a5,1
    80006272:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80006276:	854a                	mv	a0,s2
    80006278:	ffffe097          	auipc	ra,0xffffe
    8000627c:	478080e7          	jalr	1144(ra) # 800046f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80006280:	40d0                	lw	a2,4(s1)
    80006282:	00003597          	auipc	a1,0x3
    80006286:	4ae58593          	addi	a1,a1,1198 # 80009730 <syscalls+0x308>
    8000628a:	8526                	mv	a0,s1
    8000628c:	fffff097          	auipc	ra,0xfffff
    80006290:	c26080e7          	jalr	-986(ra) # 80004eb2 <dirlink>
    80006294:	00054f63          	bltz	a0,800062b2 <create+0x142>
    80006298:	00492603          	lw	a2,4(s2)
    8000629c:	00003597          	auipc	a1,0x3
    800062a0:	49c58593          	addi	a1,a1,1180 # 80009738 <syscalls+0x310>
    800062a4:	8526                	mv	a0,s1
    800062a6:	fffff097          	auipc	ra,0xfffff
    800062aa:	c0c080e7          	jalr	-1012(ra) # 80004eb2 <dirlink>
    800062ae:	f80557e3          	bgez	a0,8000623c <create+0xcc>
      panic("create dots");
    800062b2:	00003517          	auipc	a0,0x3
    800062b6:	48e50513          	addi	a0,a0,1166 # 80009740 <syscalls+0x318>
    800062ba:	ffffa097          	auipc	ra,0xffffa
    800062be:	270080e7          	jalr	624(ra) # 8000052a <panic>
    panic("create: dirlink");
    800062c2:	00003517          	auipc	a0,0x3
    800062c6:	48e50513          	addi	a0,a0,1166 # 80009750 <syscalls+0x328>
    800062ca:	ffffa097          	auipc	ra,0xffffa
    800062ce:	260080e7          	jalr	608(ra) # 8000052a <panic>
    return 0;
    800062d2:	84aa                	mv	s1,a0
    800062d4:	b739                	j	800061e2 <create+0x72>

00000000800062d6 <sys_dup>:
{
    800062d6:	7179                	addi	sp,sp,-48
    800062d8:	f406                	sd	ra,40(sp)
    800062da:	f022                	sd	s0,32(sp)
    800062dc:	ec26                	sd	s1,24(sp)
    800062de:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800062e0:	fd840613          	addi	a2,s0,-40
    800062e4:	4581                	li	a1,0
    800062e6:	4501                	li	a0,0
    800062e8:	00000097          	auipc	ra,0x0
    800062ec:	dda080e7          	jalr	-550(ra) # 800060c2 <argfd>
    return -1;
    800062f0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800062f2:	02054363          	bltz	a0,80006318 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800062f6:	fd843503          	ld	a0,-40(s0)
    800062fa:	00000097          	auipc	ra,0x0
    800062fe:	e30080e7          	jalr	-464(ra) # 8000612a <fdalloc>
    80006302:	84aa                	mv	s1,a0
    return -1;
    80006304:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80006306:	00054963          	bltz	a0,80006318 <sys_dup+0x42>
  filedup(f);
    8000630a:	fd843503          	ld	a0,-40(s0)
    8000630e:	fffff097          	auipc	ra,0xfffff
    80006312:	300080e7          	jalr	768(ra) # 8000560e <filedup>
  return fd;
    80006316:	87a6                	mv	a5,s1
}
    80006318:	853e                	mv	a0,a5
    8000631a:	70a2                	ld	ra,40(sp)
    8000631c:	7402                	ld	s0,32(sp)
    8000631e:	64e2                	ld	s1,24(sp)
    80006320:	6145                	addi	sp,sp,48
    80006322:	8082                	ret

0000000080006324 <sys_read>:
{
    80006324:	7179                	addi	sp,sp,-48
    80006326:	f406                	sd	ra,40(sp)
    80006328:	f022                	sd	s0,32(sp)
    8000632a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000632c:	fe840613          	addi	a2,s0,-24
    80006330:	4581                	li	a1,0
    80006332:	4501                	li	a0,0
    80006334:	00000097          	auipc	ra,0x0
    80006338:	d8e080e7          	jalr	-626(ra) # 800060c2 <argfd>
    return -1;
    8000633c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000633e:	04054163          	bltz	a0,80006380 <sys_read+0x5c>
    80006342:	fe440593          	addi	a1,s0,-28
    80006346:	4509                	li	a0,2
    80006348:	ffffd097          	auipc	ra,0xffffd
    8000634c:	698080e7          	jalr	1688(ra) # 800039e0 <argint>
    return -1;
    80006350:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80006352:	02054763          	bltz	a0,80006380 <sys_read+0x5c>
    80006356:	fd840593          	addi	a1,s0,-40
    8000635a:	4505                	li	a0,1
    8000635c:	ffffd097          	auipc	ra,0xffffd
    80006360:	6a6080e7          	jalr	1702(ra) # 80003a02 <argaddr>
    return -1;
    80006364:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80006366:	00054d63          	bltz	a0,80006380 <sys_read+0x5c>
  return fileread(f, p, n);
    8000636a:	fe442603          	lw	a2,-28(s0)
    8000636e:	fd843583          	ld	a1,-40(s0)
    80006372:	fe843503          	ld	a0,-24(s0)
    80006376:	fffff097          	auipc	ra,0xfffff
    8000637a:	428080e7          	jalr	1064(ra) # 8000579e <fileread>
    8000637e:	87aa                	mv	a5,a0
}
    80006380:	853e                	mv	a0,a5
    80006382:	70a2                	ld	ra,40(sp)
    80006384:	7402                	ld	s0,32(sp)
    80006386:	6145                	addi	sp,sp,48
    80006388:	8082                	ret

000000008000638a <sys_write>:
{
    8000638a:	7179                	addi	sp,sp,-48
    8000638c:	f406                	sd	ra,40(sp)
    8000638e:	f022                	sd	s0,32(sp)
    80006390:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80006392:	fe840613          	addi	a2,s0,-24
    80006396:	4581                	li	a1,0
    80006398:	4501                	li	a0,0
    8000639a:	00000097          	auipc	ra,0x0
    8000639e:	d28080e7          	jalr	-728(ra) # 800060c2 <argfd>
    return -1;
    800063a2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800063a4:	04054163          	bltz	a0,800063e6 <sys_write+0x5c>
    800063a8:	fe440593          	addi	a1,s0,-28
    800063ac:	4509                	li	a0,2
    800063ae:	ffffd097          	auipc	ra,0xffffd
    800063b2:	632080e7          	jalr	1586(ra) # 800039e0 <argint>
    return -1;
    800063b6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800063b8:	02054763          	bltz	a0,800063e6 <sys_write+0x5c>
    800063bc:	fd840593          	addi	a1,s0,-40
    800063c0:	4505                	li	a0,1
    800063c2:	ffffd097          	auipc	ra,0xffffd
    800063c6:	640080e7          	jalr	1600(ra) # 80003a02 <argaddr>
    return -1;
    800063ca:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800063cc:	00054d63          	bltz	a0,800063e6 <sys_write+0x5c>
  return filewrite(f, p, n);
    800063d0:	fe442603          	lw	a2,-28(s0)
    800063d4:	fd843583          	ld	a1,-40(s0)
    800063d8:	fe843503          	ld	a0,-24(s0)
    800063dc:	fffff097          	auipc	ra,0xfffff
    800063e0:	484080e7          	jalr	1156(ra) # 80005860 <filewrite>
    800063e4:	87aa                	mv	a5,a0
}
    800063e6:	853e                	mv	a0,a5
    800063e8:	70a2                	ld	ra,40(sp)
    800063ea:	7402                	ld	s0,32(sp)
    800063ec:	6145                	addi	sp,sp,48
    800063ee:	8082                	ret

00000000800063f0 <sys_close>:
{
    800063f0:	1101                	addi	sp,sp,-32
    800063f2:	ec06                	sd	ra,24(sp)
    800063f4:	e822                	sd	s0,16(sp)
    800063f6:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800063f8:	fe040613          	addi	a2,s0,-32
    800063fc:	fec40593          	addi	a1,s0,-20
    80006400:	4501                	li	a0,0
    80006402:	00000097          	auipc	ra,0x0
    80006406:	cc0080e7          	jalr	-832(ra) # 800060c2 <argfd>
    return -1;
    8000640a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000640c:	02054563          	bltz	a0,80006436 <sys_close+0x46>
  myproc()->ofile[fd] = 0;
    80006410:	ffffb097          	auipc	ra,0xffffb
    80006414:	656080e7          	jalr	1622(ra) # 80001a66 <myproc>
    80006418:	fec42783          	lw	a5,-20(s0)
    8000641c:	10478793          	addi	a5,a5,260
    80006420:	078e                	slli	a5,a5,0x3
    80006422:	97aa                	add	a5,a5,a0
    80006424:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80006428:	fe043503          	ld	a0,-32(s0)
    8000642c:	fffff097          	auipc	ra,0xfffff
    80006430:	234080e7          	jalr	564(ra) # 80005660 <fileclose>
  return 0;
    80006434:	4781                	li	a5,0
}
    80006436:	853e                	mv	a0,a5
    80006438:	60e2                	ld	ra,24(sp)
    8000643a:	6442                	ld	s0,16(sp)
    8000643c:	6105                	addi	sp,sp,32
    8000643e:	8082                	ret

0000000080006440 <sys_fstat>:
{
    80006440:	1101                	addi	sp,sp,-32
    80006442:	ec06                	sd	ra,24(sp)
    80006444:	e822                	sd	s0,16(sp)
    80006446:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80006448:	fe840613          	addi	a2,s0,-24
    8000644c:	4581                	li	a1,0
    8000644e:	4501                	li	a0,0
    80006450:	00000097          	auipc	ra,0x0
    80006454:	c72080e7          	jalr	-910(ra) # 800060c2 <argfd>
    return -1;
    80006458:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000645a:	02054563          	bltz	a0,80006484 <sys_fstat+0x44>
    8000645e:	fe040593          	addi	a1,s0,-32
    80006462:	4505                	li	a0,1
    80006464:	ffffd097          	auipc	ra,0xffffd
    80006468:	59e080e7          	jalr	1438(ra) # 80003a02 <argaddr>
    return -1;
    8000646c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000646e:	00054b63          	bltz	a0,80006484 <sys_fstat+0x44>
  return filestat(f, st);
    80006472:	fe043583          	ld	a1,-32(s0)
    80006476:	fe843503          	ld	a0,-24(s0)
    8000647a:	fffff097          	auipc	ra,0xfffff
    8000647e:	2ae080e7          	jalr	686(ra) # 80005728 <filestat>
    80006482:	87aa                	mv	a5,a0
}
    80006484:	853e                	mv	a0,a5
    80006486:	60e2                	ld	ra,24(sp)
    80006488:	6442                	ld	s0,16(sp)
    8000648a:	6105                	addi	sp,sp,32
    8000648c:	8082                	ret

000000008000648e <sys_link>:
{
    8000648e:	7169                	addi	sp,sp,-304
    80006490:	f606                	sd	ra,296(sp)
    80006492:	f222                	sd	s0,288(sp)
    80006494:	ee26                	sd	s1,280(sp)
    80006496:	ea4a                	sd	s2,272(sp)
    80006498:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000649a:	08000613          	li	a2,128
    8000649e:	ed040593          	addi	a1,s0,-304
    800064a2:	4501                	li	a0,0
    800064a4:	ffffd097          	auipc	ra,0xffffd
    800064a8:	580080e7          	jalr	1408(ra) # 80003a24 <argstr>
    return -1;
    800064ac:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800064ae:	10054e63          	bltz	a0,800065ca <sys_link+0x13c>
    800064b2:	08000613          	li	a2,128
    800064b6:	f5040593          	addi	a1,s0,-176
    800064ba:	4505                	li	a0,1
    800064bc:	ffffd097          	auipc	ra,0xffffd
    800064c0:	568080e7          	jalr	1384(ra) # 80003a24 <argstr>
    return -1;
    800064c4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800064c6:	10054263          	bltz	a0,800065ca <sys_link+0x13c>
  begin_op();
    800064ca:	fffff097          	auipc	ra,0xfffff
    800064ce:	cca080e7          	jalr	-822(ra) # 80005194 <begin_op>
  if((ip = namei(old)) == 0){
    800064d2:	ed040513          	addi	a0,s0,-304
    800064d6:	fffff097          	auipc	ra,0xfffff
    800064da:	a9e080e7          	jalr	-1378(ra) # 80004f74 <namei>
    800064de:	84aa                	mv	s1,a0
    800064e0:	c551                	beqz	a0,8000656c <sys_link+0xde>
  ilock(ip);
    800064e2:	ffffe097          	auipc	ra,0xffffe
    800064e6:	2d8080e7          	jalr	728(ra) # 800047ba <ilock>
  if(ip->type == T_DIR){
    800064ea:	04449703          	lh	a4,68(s1)
    800064ee:	4785                	li	a5,1
    800064f0:	08f70463          	beq	a4,a5,80006578 <sys_link+0xea>
  ip->nlink++;
    800064f4:	04a4d783          	lhu	a5,74(s1)
    800064f8:	2785                	addiw	a5,a5,1
    800064fa:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800064fe:	8526                	mv	a0,s1
    80006500:	ffffe097          	auipc	ra,0xffffe
    80006504:	1f0080e7          	jalr	496(ra) # 800046f0 <iupdate>
  iunlock(ip);
    80006508:	8526                	mv	a0,s1
    8000650a:	ffffe097          	auipc	ra,0xffffe
    8000650e:	372080e7          	jalr	882(ra) # 8000487c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80006512:	fd040593          	addi	a1,s0,-48
    80006516:	f5040513          	addi	a0,s0,-176
    8000651a:	fffff097          	auipc	ra,0xfffff
    8000651e:	a78080e7          	jalr	-1416(ra) # 80004f92 <nameiparent>
    80006522:	892a                	mv	s2,a0
    80006524:	c935                	beqz	a0,80006598 <sys_link+0x10a>
  ilock(dp);
    80006526:	ffffe097          	auipc	ra,0xffffe
    8000652a:	294080e7          	jalr	660(ra) # 800047ba <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000652e:	00092703          	lw	a4,0(s2)
    80006532:	409c                	lw	a5,0(s1)
    80006534:	04f71d63          	bne	a4,a5,8000658e <sys_link+0x100>
    80006538:	40d0                	lw	a2,4(s1)
    8000653a:	fd040593          	addi	a1,s0,-48
    8000653e:	854a                	mv	a0,s2
    80006540:	fffff097          	auipc	ra,0xfffff
    80006544:	972080e7          	jalr	-1678(ra) # 80004eb2 <dirlink>
    80006548:	04054363          	bltz	a0,8000658e <sys_link+0x100>
  iunlockput(dp);
    8000654c:	854a                	mv	a0,s2
    8000654e:	ffffe097          	auipc	ra,0xffffe
    80006552:	4ce080e7          	jalr	1230(ra) # 80004a1c <iunlockput>
  iput(ip);
    80006556:	8526                	mv	a0,s1
    80006558:	ffffe097          	auipc	ra,0xffffe
    8000655c:	41c080e7          	jalr	1052(ra) # 80004974 <iput>
  end_op();
    80006560:	fffff097          	auipc	ra,0xfffff
    80006564:	cb4080e7          	jalr	-844(ra) # 80005214 <end_op>
  return 0;
    80006568:	4781                	li	a5,0
    8000656a:	a085                	j	800065ca <sys_link+0x13c>
    end_op();
    8000656c:	fffff097          	auipc	ra,0xfffff
    80006570:	ca8080e7          	jalr	-856(ra) # 80005214 <end_op>
    return -1;
    80006574:	57fd                	li	a5,-1
    80006576:	a891                	j	800065ca <sys_link+0x13c>
    iunlockput(ip);
    80006578:	8526                	mv	a0,s1
    8000657a:	ffffe097          	auipc	ra,0xffffe
    8000657e:	4a2080e7          	jalr	1186(ra) # 80004a1c <iunlockput>
    end_op();
    80006582:	fffff097          	auipc	ra,0xfffff
    80006586:	c92080e7          	jalr	-878(ra) # 80005214 <end_op>
    return -1;
    8000658a:	57fd                	li	a5,-1
    8000658c:	a83d                	j	800065ca <sys_link+0x13c>
    iunlockput(dp);
    8000658e:	854a                	mv	a0,s2
    80006590:	ffffe097          	auipc	ra,0xffffe
    80006594:	48c080e7          	jalr	1164(ra) # 80004a1c <iunlockput>
  ilock(ip);
    80006598:	8526                	mv	a0,s1
    8000659a:	ffffe097          	auipc	ra,0xffffe
    8000659e:	220080e7          	jalr	544(ra) # 800047ba <ilock>
  ip->nlink--;
    800065a2:	04a4d783          	lhu	a5,74(s1)
    800065a6:	37fd                	addiw	a5,a5,-1
    800065a8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800065ac:	8526                	mv	a0,s1
    800065ae:	ffffe097          	auipc	ra,0xffffe
    800065b2:	142080e7          	jalr	322(ra) # 800046f0 <iupdate>
  iunlockput(ip);
    800065b6:	8526                	mv	a0,s1
    800065b8:	ffffe097          	auipc	ra,0xffffe
    800065bc:	464080e7          	jalr	1124(ra) # 80004a1c <iunlockput>
  end_op();
    800065c0:	fffff097          	auipc	ra,0xfffff
    800065c4:	c54080e7          	jalr	-940(ra) # 80005214 <end_op>
  return -1;
    800065c8:	57fd                	li	a5,-1
}
    800065ca:	853e                	mv	a0,a5
    800065cc:	70b2                	ld	ra,296(sp)
    800065ce:	7412                	ld	s0,288(sp)
    800065d0:	64f2                	ld	s1,280(sp)
    800065d2:	6952                	ld	s2,272(sp)
    800065d4:	6155                	addi	sp,sp,304
    800065d6:	8082                	ret

00000000800065d8 <sys_unlink>:
{
    800065d8:	7151                	addi	sp,sp,-240
    800065da:	f586                	sd	ra,232(sp)
    800065dc:	f1a2                	sd	s0,224(sp)
    800065de:	eda6                	sd	s1,216(sp)
    800065e0:	e9ca                	sd	s2,208(sp)
    800065e2:	e5ce                	sd	s3,200(sp)
    800065e4:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800065e6:	08000613          	li	a2,128
    800065ea:	f3040593          	addi	a1,s0,-208
    800065ee:	4501                	li	a0,0
    800065f0:	ffffd097          	auipc	ra,0xffffd
    800065f4:	434080e7          	jalr	1076(ra) # 80003a24 <argstr>
    800065f8:	18054163          	bltz	a0,8000677a <sys_unlink+0x1a2>
  begin_op();
    800065fc:	fffff097          	auipc	ra,0xfffff
    80006600:	b98080e7          	jalr	-1128(ra) # 80005194 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80006604:	fb040593          	addi	a1,s0,-80
    80006608:	f3040513          	addi	a0,s0,-208
    8000660c:	fffff097          	auipc	ra,0xfffff
    80006610:	986080e7          	jalr	-1658(ra) # 80004f92 <nameiparent>
    80006614:	84aa                	mv	s1,a0
    80006616:	c979                	beqz	a0,800066ec <sys_unlink+0x114>
  ilock(dp);
    80006618:	ffffe097          	auipc	ra,0xffffe
    8000661c:	1a2080e7          	jalr	418(ra) # 800047ba <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80006620:	00003597          	auipc	a1,0x3
    80006624:	11058593          	addi	a1,a1,272 # 80009730 <syscalls+0x308>
    80006628:	fb040513          	addi	a0,s0,-80
    8000662c:	ffffe097          	auipc	ra,0xffffe
    80006630:	658080e7          	jalr	1624(ra) # 80004c84 <namecmp>
    80006634:	14050a63          	beqz	a0,80006788 <sys_unlink+0x1b0>
    80006638:	00003597          	auipc	a1,0x3
    8000663c:	10058593          	addi	a1,a1,256 # 80009738 <syscalls+0x310>
    80006640:	fb040513          	addi	a0,s0,-80
    80006644:	ffffe097          	auipc	ra,0xffffe
    80006648:	640080e7          	jalr	1600(ra) # 80004c84 <namecmp>
    8000664c:	12050e63          	beqz	a0,80006788 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80006650:	f2c40613          	addi	a2,s0,-212
    80006654:	fb040593          	addi	a1,s0,-80
    80006658:	8526                	mv	a0,s1
    8000665a:	ffffe097          	auipc	ra,0xffffe
    8000665e:	644080e7          	jalr	1604(ra) # 80004c9e <dirlookup>
    80006662:	892a                	mv	s2,a0
    80006664:	12050263          	beqz	a0,80006788 <sys_unlink+0x1b0>
  ilock(ip);
    80006668:	ffffe097          	auipc	ra,0xffffe
    8000666c:	152080e7          	jalr	338(ra) # 800047ba <ilock>
  if(ip->nlink < 1)
    80006670:	04a91783          	lh	a5,74(s2)
    80006674:	08f05263          	blez	a5,800066f8 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80006678:	04491703          	lh	a4,68(s2)
    8000667c:	4785                	li	a5,1
    8000667e:	08f70563          	beq	a4,a5,80006708 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80006682:	4641                	li	a2,16
    80006684:	4581                	li	a1,0
    80006686:	fc040513          	addi	a0,s0,-64
    8000668a:	ffffa097          	auipc	ra,0xffffa
    8000668e:	642080e7          	jalr	1602(ra) # 80000ccc <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80006692:	4741                	li	a4,16
    80006694:	f2c42683          	lw	a3,-212(s0)
    80006698:	fc040613          	addi	a2,s0,-64
    8000669c:	4581                	li	a1,0
    8000669e:	8526                	mv	a0,s1
    800066a0:	ffffe097          	auipc	ra,0xffffe
    800066a4:	4c6080e7          	jalr	1222(ra) # 80004b66 <writei>
    800066a8:	47c1                	li	a5,16
    800066aa:	0af51563          	bne	a0,a5,80006754 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800066ae:	04491703          	lh	a4,68(s2)
    800066b2:	4785                	li	a5,1
    800066b4:	0af70863          	beq	a4,a5,80006764 <sys_unlink+0x18c>
  iunlockput(dp);
    800066b8:	8526                	mv	a0,s1
    800066ba:	ffffe097          	auipc	ra,0xffffe
    800066be:	362080e7          	jalr	866(ra) # 80004a1c <iunlockput>
  ip->nlink--;
    800066c2:	04a95783          	lhu	a5,74(s2)
    800066c6:	37fd                	addiw	a5,a5,-1
    800066c8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800066cc:	854a                	mv	a0,s2
    800066ce:	ffffe097          	auipc	ra,0xffffe
    800066d2:	022080e7          	jalr	34(ra) # 800046f0 <iupdate>
  iunlockput(ip);
    800066d6:	854a                	mv	a0,s2
    800066d8:	ffffe097          	auipc	ra,0xffffe
    800066dc:	344080e7          	jalr	836(ra) # 80004a1c <iunlockput>
  end_op();
    800066e0:	fffff097          	auipc	ra,0xfffff
    800066e4:	b34080e7          	jalr	-1228(ra) # 80005214 <end_op>
  return 0;
    800066e8:	4501                	li	a0,0
    800066ea:	a84d                	j	8000679c <sys_unlink+0x1c4>
    end_op();
    800066ec:	fffff097          	auipc	ra,0xfffff
    800066f0:	b28080e7          	jalr	-1240(ra) # 80005214 <end_op>
    return -1;
    800066f4:	557d                	li	a0,-1
    800066f6:	a05d                	j	8000679c <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800066f8:	00003517          	auipc	a0,0x3
    800066fc:	06850513          	addi	a0,a0,104 # 80009760 <syscalls+0x338>
    80006700:	ffffa097          	auipc	ra,0xffffa
    80006704:	e2a080e7          	jalr	-470(ra) # 8000052a <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80006708:	04c92703          	lw	a4,76(s2)
    8000670c:	02000793          	li	a5,32
    80006710:	f6e7f9e3          	bgeu	a5,a4,80006682 <sys_unlink+0xaa>
    80006714:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80006718:	4741                	li	a4,16
    8000671a:	86ce                	mv	a3,s3
    8000671c:	f1840613          	addi	a2,s0,-232
    80006720:	4581                	li	a1,0
    80006722:	854a                	mv	a0,s2
    80006724:	ffffe097          	auipc	ra,0xffffe
    80006728:	34a080e7          	jalr	842(ra) # 80004a6e <readi>
    8000672c:	47c1                	li	a5,16
    8000672e:	00f51b63          	bne	a0,a5,80006744 <sys_unlink+0x16c>
    if(de.inum != 0)
    80006732:	f1845783          	lhu	a5,-232(s0)
    80006736:	e7a1                	bnez	a5,8000677e <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80006738:	29c1                	addiw	s3,s3,16
    8000673a:	04c92783          	lw	a5,76(s2)
    8000673e:	fcf9ede3          	bltu	s3,a5,80006718 <sys_unlink+0x140>
    80006742:	b781                	j	80006682 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80006744:	00003517          	auipc	a0,0x3
    80006748:	03450513          	addi	a0,a0,52 # 80009778 <syscalls+0x350>
    8000674c:	ffffa097          	auipc	ra,0xffffa
    80006750:	dde080e7          	jalr	-546(ra) # 8000052a <panic>
    panic("unlink: writei");
    80006754:	00003517          	auipc	a0,0x3
    80006758:	03c50513          	addi	a0,a0,60 # 80009790 <syscalls+0x368>
    8000675c:	ffffa097          	auipc	ra,0xffffa
    80006760:	dce080e7          	jalr	-562(ra) # 8000052a <panic>
    dp->nlink--;
    80006764:	04a4d783          	lhu	a5,74(s1)
    80006768:	37fd                	addiw	a5,a5,-1
    8000676a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000676e:	8526                	mv	a0,s1
    80006770:	ffffe097          	auipc	ra,0xffffe
    80006774:	f80080e7          	jalr	-128(ra) # 800046f0 <iupdate>
    80006778:	b781                	j	800066b8 <sys_unlink+0xe0>
    return -1;
    8000677a:	557d                	li	a0,-1
    8000677c:	a005                	j	8000679c <sys_unlink+0x1c4>
    iunlockput(ip);
    8000677e:	854a                	mv	a0,s2
    80006780:	ffffe097          	auipc	ra,0xffffe
    80006784:	29c080e7          	jalr	668(ra) # 80004a1c <iunlockput>
  iunlockput(dp);
    80006788:	8526                	mv	a0,s1
    8000678a:	ffffe097          	auipc	ra,0xffffe
    8000678e:	292080e7          	jalr	658(ra) # 80004a1c <iunlockput>
  end_op();
    80006792:	fffff097          	auipc	ra,0xfffff
    80006796:	a82080e7          	jalr	-1406(ra) # 80005214 <end_op>
  return -1;
    8000679a:	557d                	li	a0,-1
}
    8000679c:	70ae                	ld	ra,232(sp)
    8000679e:	740e                	ld	s0,224(sp)
    800067a0:	64ee                	ld	s1,216(sp)
    800067a2:	694e                	ld	s2,208(sp)
    800067a4:	69ae                	ld	s3,200(sp)
    800067a6:	616d                	addi	sp,sp,240
    800067a8:	8082                	ret

00000000800067aa <sys_open>:

uint64
sys_open(void)
{
    800067aa:	7131                	addi	sp,sp,-192
    800067ac:	fd06                	sd	ra,184(sp)
    800067ae:	f922                	sd	s0,176(sp)
    800067b0:	f526                	sd	s1,168(sp)
    800067b2:	f14a                	sd	s2,160(sp)
    800067b4:	ed4e                	sd	s3,152(sp)
    800067b6:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800067b8:	08000613          	li	a2,128
    800067bc:	f5040593          	addi	a1,s0,-176
    800067c0:	4501                	li	a0,0
    800067c2:	ffffd097          	auipc	ra,0xffffd
    800067c6:	262080e7          	jalr	610(ra) # 80003a24 <argstr>
    return -1;
    800067ca:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800067cc:	0c054163          	bltz	a0,8000688e <sys_open+0xe4>
    800067d0:	f4c40593          	addi	a1,s0,-180
    800067d4:	4505                	li	a0,1
    800067d6:	ffffd097          	auipc	ra,0xffffd
    800067da:	20a080e7          	jalr	522(ra) # 800039e0 <argint>
    800067de:	0a054863          	bltz	a0,8000688e <sys_open+0xe4>

  begin_op();
    800067e2:	fffff097          	auipc	ra,0xfffff
    800067e6:	9b2080e7          	jalr	-1614(ra) # 80005194 <begin_op>

  if(omode & O_CREATE){
    800067ea:	f4c42783          	lw	a5,-180(s0)
    800067ee:	2007f793          	andi	a5,a5,512
    800067f2:	cbdd                	beqz	a5,800068a8 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    800067f4:	4681                	li	a3,0
    800067f6:	4601                	li	a2,0
    800067f8:	4589                	li	a1,2
    800067fa:	f5040513          	addi	a0,s0,-176
    800067fe:	00000097          	auipc	ra,0x0
    80006802:	972080e7          	jalr	-1678(ra) # 80006170 <create>
    80006806:	892a                	mv	s2,a0
    if(ip == 0){
    80006808:	c959                	beqz	a0,8000689e <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000680a:	04491703          	lh	a4,68(s2)
    8000680e:	478d                	li	a5,3
    80006810:	00f71763          	bne	a4,a5,8000681e <sys_open+0x74>
    80006814:	04695703          	lhu	a4,70(s2)
    80006818:	47a5                	li	a5,9
    8000681a:	0ce7ec63          	bltu	a5,a4,800068f2 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000681e:	fffff097          	auipc	ra,0xfffff
    80006822:	d86080e7          	jalr	-634(ra) # 800055a4 <filealloc>
    80006826:	89aa                	mv	s3,a0
    80006828:	10050263          	beqz	a0,8000692c <sys_open+0x182>
    8000682c:	00000097          	auipc	ra,0x0
    80006830:	8fe080e7          	jalr	-1794(ra) # 8000612a <fdalloc>
    80006834:	84aa                	mv	s1,a0
    80006836:	0e054663          	bltz	a0,80006922 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000683a:	04491703          	lh	a4,68(s2)
    8000683e:	478d                	li	a5,3
    80006840:	0cf70463          	beq	a4,a5,80006908 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80006844:	4789                	li	a5,2
    80006846:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    8000684a:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    8000684e:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80006852:	f4c42783          	lw	a5,-180(s0)
    80006856:	0017c713          	xori	a4,a5,1
    8000685a:	8b05                	andi	a4,a4,1
    8000685c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80006860:	0037f713          	andi	a4,a5,3
    80006864:	00e03733          	snez	a4,a4
    80006868:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000686c:	4007f793          	andi	a5,a5,1024
    80006870:	c791                	beqz	a5,8000687c <sys_open+0xd2>
    80006872:	04491703          	lh	a4,68(s2)
    80006876:	4789                	li	a5,2
    80006878:	08f70f63          	beq	a4,a5,80006916 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    8000687c:	854a                	mv	a0,s2
    8000687e:	ffffe097          	auipc	ra,0xffffe
    80006882:	ffe080e7          	jalr	-2(ra) # 8000487c <iunlock>
  end_op();
    80006886:	fffff097          	auipc	ra,0xfffff
    8000688a:	98e080e7          	jalr	-1650(ra) # 80005214 <end_op>

  return fd;
}
    8000688e:	8526                	mv	a0,s1
    80006890:	70ea                	ld	ra,184(sp)
    80006892:	744a                	ld	s0,176(sp)
    80006894:	74aa                	ld	s1,168(sp)
    80006896:	790a                	ld	s2,160(sp)
    80006898:	69ea                	ld	s3,152(sp)
    8000689a:	6129                	addi	sp,sp,192
    8000689c:	8082                	ret
      end_op();
    8000689e:	fffff097          	auipc	ra,0xfffff
    800068a2:	976080e7          	jalr	-1674(ra) # 80005214 <end_op>
      return -1;
    800068a6:	b7e5                	j	8000688e <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    800068a8:	f5040513          	addi	a0,s0,-176
    800068ac:	ffffe097          	auipc	ra,0xffffe
    800068b0:	6c8080e7          	jalr	1736(ra) # 80004f74 <namei>
    800068b4:	892a                	mv	s2,a0
    800068b6:	c905                	beqz	a0,800068e6 <sys_open+0x13c>
    ilock(ip);
    800068b8:	ffffe097          	auipc	ra,0xffffe
    800068bc:	f02080e7          	jalr	-254(ra) # 800047ba <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800068c0:	04491703          	lh	a4,68(s2)
    800068c4:	4785                	li	a5,1
    800068c6:	f4f712e3          	bne	a4,a5,8000680a <sys_open+0x60>
    800068ca:	f4c42783          	lw	a5,-180(s0)
    800068ce:	dba1                	beqz	a5,8000681e <sys_open+0x74>
      iunlockput(ip);
    800068d0:	854a                	mv	a0,s2
    800068d2:	ffffe097          	auipc	ra,0xffffe
    800068d6:	14a080e7          	jalr	330(ra) # 80004a1c <iunlockput>
      end_op();
    800068da:	fffff097          	auipc	ra,0xfffff
    800068de:	93a080e7          	jalr	-1734(ra) # 80005214 <end_op>
      return -1;
    800068e2:	54fd                	li	s1,-1
    800068e4:	b76d                	j	8000688e <sys_open+0xe4>
      end_op();
    800068e6:	fffff097          	auipc	ra,0xfffff
    800068ea:	92e080e7          	jalr	-1746(ra) # 80005214 <end_op>
      return -1;
    800068ee:	54fd                	li	s1,-1
    800068f0:	bf79                	j	8000688e <sys_open+0xe4>
    iunlockput(ip);
    800068f2:	854a                	mv	a0,s2
    800068f4:	ffffe097          	auipc	ra,0xffffe
    800068f8:	128080e7          	jalr	296(ra) # 80004a1c <iunlockput>
    end_op();
    800068fc:	fffff097          	auipc	ra,0xfffff
    80006900:	918080e7          	jalr	-1768(ra) # 80005214 <end_op>
    return -1;
    80006904:	54fd                	li	s1,-1
    80006906:	b761                	j	8000688e <sys_open+0xe4>
    f->type = FD_DEVICE;
    80006908:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    8000690c:	04691783          	lh	a5,70(s2)
    80006910:	02f99223          	sh	a5,36(s3)
    80006914:	bf2d                	j	8000684e <sys_open+0xa4>
    itrunc(ip);
    80006916:	854a                	mv	a0,s2
    80006918:	ffffe097          	auipc	ra,0xffffe
    8000691c:	fb0080e7          	jalr	-80(ra) # 800048c8 <itrunc>
    80006920:	bfb1                	j	8000687c <sys_open+0xd2>
      fileclose(f);
    80006922:	854e                	mv	a0,s3
    80006924:	fffff097          	auipc	ra,0xfffff
    80006928:	d3c080e7          	jalr	-708(ra) # 80005660 <fileclose>
    iunlockput(ip);
    8000692c:	854a                	mv	a0,s2
    8000692e:	ffffe097          	auipc	ra,0xffffe
    80006932:	0ee080e7          	jalr	238(ra) # 80004a1c <iunlockput>
    end_op();
    80006936:	fffff097          	auipc	ra,0xfffff
    8000693a:	8de080e7          	jalr	-1826(ra) # 80005214 <end_op>
    return -1;
    8000693e:	54fd                	li	s1,-1
    80006940:	b7b9                	j	8000688e <sys_open+0xe4>

0000000080006942 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80006942:	7175                	addi	sp,sp,-144
    80006944:	e506                	sd	ra,136(sp)
    80006946:	e122                	sd	s0,128(sp)
    80006948:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000694a:	fffff097          	auipc	ra,0xfffff
    8000694e:	84a080e7          	jalr	-1974(ra) # 80005194 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80006952:	08000613          	li	a2,128
    80006956:	f7040593          	addi	a1,s0,-144
    8000695a:	4501                	li	a0,0
    8000695c:	ffffd097          	auipc	ra,0xffffd
    80006960:	0c8080e7          	jalr	200(ra) # 80003a24 <argstr>
    80006964:	02054963          	bltz	a0,80006996 <sys_mkdir+0x54>
    80006968:	4681                	li	a3,0
    8000696a:	4601                	li	a2,0
    8000696c:	4585                	li	a1,1
    8000696e:	f7040513          	addi	a0,s0,-144
    80006972:	fffff097          	auipc	ra,0xfffff
    80006976:	7fe080e7          	jalr	2046(ra) # 80006170 <create>
    8000697a:	cd11                	beqz	a0,80006996 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000697c:	ffffe097          	auipc	ra,0xffffe
    80006980:	0a0080e7          	jalr	160(ra) # 80004a1c <iunlockput>
  end_op();
    80006984:	fffff097          	auipc	ra,0xfffff
    80006988:	890080e7          	jalr	-1904(ra) # 80005214 <end_op>
  return 0;
    8000698c:	4501                	li	a0,0
}
    8000698e:	60aa                	ld	ra,136(sp)
    80006990:	640a                	ld	s0,128(sp)
    80006992:	6149                	addi	sp,sp,144
    80006994:	8082                	ret
    end_op();
    80006996:	fffff097          	auipc	ra,0xfffff
    8000699a:	87e080e7          	jalr	-1922(ra) # 80005214 <end_op>
    return -1;
    8000699e:	557d                	li	a0,-1
    800069a0:	b7fd                	j	8000698e <sys_mkdir+0x4c>

00000000800069a2 <sys_mknod>:

uint64
sys_mknod(void)
{
    800069a2:	7135                	addi	sp,sp,-160
    800069a4:	ed06                	sd	ra,152(sp)
    800069a6:	e922                	sd	s0,144(sp)
    800069a8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800069aa:	ffffe097          	auipc	ra,0xffffe
    800069ae:	7ea080e7          	jalr	2026(ra) # 80005194 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800069b2:	08000613          	li	a2,128
    800069b6:	f7040593          	addi	a1,s0,-144
    800069ba:	4501                	li	a0,0
    800069bc:	ffffd097          	auipc	ra,0xffffd
    800069c0:	068080e7          	jalr	104(ra) # 80003a24 <argstr>
    800069c4:	04054a63          	bltz	a0,80006a18 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    800069c8:	f6c40593          	addi	a1,s0,-148
    800069cc:	4505                	li	a0,1
    800069ce:	ffffd097          	auipc	ra,0xffffd
    800069d2:	012080e7          	jalr	18(ra) # 800039e0 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800069d6:	04054163          	bltz	a0,80006a18 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    800069da:	f6840593          	addi	a1,s0,-152
    800069de:	4509                	li	a0,2
    800069e0:	ffffd097          	auipc	ra,0xffffd
    800069e4:	000080e7          	jalr	ra # 800039e0 <argint>
     argint(1, &major) < 0 ||
    800069e8:	02054863          	bltz	a0,80006a18 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800069ec:	f6841683          	lh	a3,-152(s0)
    800069f0:	f6c41603          	lh	a2,-148(s0)
    800069f4:	458d                	li	a1,3
    800069f6:	f7040513          	addi	a0,s0,-144
    800069fa:	fffff097          	auipc	ra,0xfffff
    800069fe:	776080e7          	jalr	1910(ra) # 80006170 <create>
     argint(2, &minor) < 0 ||
    80006a02:	c919                	beqz	a0,80006a18 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006a04:	ffffe097          	auipc	ra,0xffffe
    80006a08:	018080e7          	jalr	24(ra) # 80004a1c <iunlockput>
  end_op();
    80006a0c:	fffff097          	auipc	ra,0xfffff
    80006a10:	808080e7          	jalr	-2040(ra) # 80005214 <end_op>
  return 0;
    80006a14:	4501                	li	a0,0
    80006a16:	a031                	j	80006a22 <sys_mknod+0x80>
    end_op();
    80006a18:	ffffe097          	auipc	ra,0xffffe
    80006a1c:	7fc080e7          	jalr	2044(ra) # 80005214 <end_op>
    return -1;
    80006a20:	557d                	li	a0,-1
}
    80006a22:	60ea                	ld	ra,152(sp)
    80006a24:	644a                	ld	s0,144(sp)
    80006a26:	610d                	addi	sp,sp,160
    80006a28:	8082                	ret

0000000080006a2a <sys_chdir>:

uint64
sys_chdir(void)
{
    80006a2a:	7135                	addi	sp,sp,-160
    80006a2c:	ed06                	sd	ra,152(sp)
    80006a2e:	e922                	sd	s0,144(sp)
    80006a30:	e526                	sd	s1,136(sp)
    80006a32:	e14a                	sd	s2,128(sp)
    80006a34:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80006a36:	ffffb097          	auipc	ra,0xffffb
    80006a3a:	030080e7          	jalr	48(ra) # 80001a66 <myproc>
    80006a3e:	892a                	mv	s2,a0
  
  begin_op();
    80006a40:	ffffe097          	auipc	ra,0xffffe
    80006a44:	754080e7          	jalr	1876(ra) # 80005194 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80006a48:	08000613          	li	a2,128
    80006a4c:	f6040593          	addi	a1,s0,-160
    80006a50:	4501                	li	a0,0
    80006a52:	ffffd097          	auipc	ra,0xffffd
    80006a56:	fd2080e7          	jalr	-46(ra) # 80003a24 <argstr>
    80006a5a:	04054d63          	bltz	a0,80006ab4 <sys_chdir+0x8a>
    80006a5e:	f6040513          	addi	a0,s0,-160
    80006a62:	ffffe097          	auipc	ra,0xffffe
    80006a66:	512080e7          	jalr	1298(ra) # 80004f74 <namei>
    80006a6a:	84aa                	mv	s1,a0
    80006a6c:	c521                	beqz	a0,80006ab4 <sys_chdir+0x8a>
    end_op();
    return -1;
  }
  ilock(ip);
    80006a6e:	ffffe097          	auipc	ra,0xffffe
    80006a72:	d4c080e7          	jalr	-692(ra) # 800047ba <ilock>
  if(ip->type != T_DIR){
    80006a76:	04449703          	lh	a4,68(s1)
    80006a7a:	4785                	li	a5,1
    80006a7c:	04f71263          	bne	a4,a5,80006ac0 <sys_chdir+0x96>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80006a80:	8526                	mv	a0,s1
    80006a82:	ffffe097          	auipc	ra,0xffffe
    80006a86:	dfa080e7          	jalr	-518(ra) # 8000487c <iunlock>
  iput(p->cwd);
    80006a8a:	6505                	lui	a0,0x1
    80006a8c:	992a                	add	s2,s2,a0
    80006a8e:	8a093503          	ld	a0,-1888(s2)
    80006a92:	ffffe097          	auipc	ra,0xffffe
    80006a96:	ee2080e7          	jalr	-286(ra) # 80004974 <iput>
  end_op();
    80006a9a:	ffffe097          	auipc	ra,0xffffe
    80006a9e:	77a080e7          	jalr	1914(ra) # 80005214 <end_op>
  p->cwd = ip;
    80006aa2:	8a993023          	sd	s1,-1888(s2)
  return 0;
    80006aa6:	4501                	li	a0,0
}
    80006aa8:	60ea                	ld	ra,152(sp)
    80006aaa:	644a                	ld	s0,144(sp)
    80006aac:	64aa                	ld	s1,136(sp)
    80006aae:	690a                	ld	s2,128(sp)
    80006ab0:	610d                	addi	sp,sp,160
    80006ab2:	8082                	ret
    end_op();
    80006ab4:	ffffe097          	auipc	ra,0xffffe
    80006ab8:	760080e7          	jalr	1888(ra) # 80005214 <end_op>
    return -1;
    80006abc:	557d                	li	a0,-1
    80006abe:	b7ed                	j	80006aa8 <sys_chdir+0x7e>
    iunlockput(ip);
    80006ac0:	8526                	mv	a0,s1
    80006ac2:	ffffe097          	auipc	ra,0xffffe
    80006ac6:	f5a080e7          	jalr	-166(ra) # 80004a1c <iunlockput>
    end_op();
    80006aca:	ffffe097          	auipc	ra,0xffffe
    80006ace:	74a080e7          	jalr	1866(ra) # 80005214 <end_op>
    return -1;
    80006ad2:	557d                	li	a0,-1
    80006ad4:	bfd1                	j	80006aa8 <sys_chdir+0x7e>

0000000080006ad6 <sys_exec>:

uint64
sys_exec(void)
{
    80006ad6:	7145                	addi	sp,sp,-464
    80006ad8:	e786                	sd	ra,456(sp)
    80006ada:	e3a2                	sd	s0,448(sp)
    80006adc:	ff26                	sd	s1,440(sp)
    80006ade:	fb4a                	sd	s2,432(sp)
    80006ae0:	f74e                	sd	s3,424(sp)
    80006ae2:	f352                	sd	s4,416(sp)
    80006ae4:	ef56                	sd	s5,408(sp)
    80006ae6:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80006ae8:	08000613          	li	a2,128
    80006aec:	f4040593          	addi	a1,s0,-192
    80006af0:	4501                	li	a0,0
    80006af2:	ffffd097          	auipc	ra,0xffffd
    80006af6:	f32080e7          	jalr	-206(ra) # 80003a24 <argstr>
    return -1;
    80006afa:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80006afc:	0c054a63          	bltz	a0,80006bd0 <sys_exec+0xfa>
    80006b00:	e3840593          	addi	a1,s0,-456
    80006b04:	4505                	li	a0,1
    80006b06:	ffffd097          	auipc	ra,0xffffd
    80006b0a:	efc080e7          	jalr	-260(ra) # 80003a02 <argaddr>
    80006b0e:	0c054163          	bltz	a0,80006bd0 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80006b12:	10000613          	li	a2,256
    80006b16:	4581                	li	a1,0
    80006b18:	e4040513          	addi	a0,s0,-448
    80006b1c:	ffffa097          	auipc	ra,0xffffa
    80006b20:	1b0080e7          	jalr	432(ra) # 80000ccc <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80006b24:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80006b28:	89a6                	mv	s3,s1
    80006b2a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80006b2c:	02000a13          	li	s4,32
    80006b30:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006b34:	00391793          	slli	a5,s2,0x3
    80006b38:	e3040593          	addi	a1,s0,-464
    80006b3c:	e3843503          	ld	a0,-456(s0)
    80006b40:	953e                	add	a0,a0,a5
    80006b42:	ffffd097          	auipc	ra,0xffffd
    80006b46:	df2080e7          	jalr	-526(ra) # 80003934 <fetchaddr>
    80006b4a:	02054a63          	bltz	a0,80006b7e <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80006b4e:	e3043783          	ld	a5,-464(s0)
    80006b52:	c3b9                	beqz	a5,80006b98 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80006b54:	ffffa097          	auipc	ra,0xffffa
    80006b58:	f7e080e7          	jalr	-130(ra) # 80000ad2 <kalloc>
    80006b5c:	85aa                	mv	a1,a0
    80006b5e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80006b62:	cd11                	beqz	a0,80006b7e <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006b64:	6605                	lui	a2,0x1
    80006b66:	e3043503          	ld	a0,-464(s0)
    80006b6a:	ffffd097          	auipc	ra,0xffffd
    80006b6e:	e28080e7          	jalr	-472(ra) # 80003992 <fetchstr>
    80006b72:	00054663          	bltz	a0,80006b7e <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80006b76:	0905                	addi	s2,s2,1
    80006b78:	09a1                	addi	s3,s3,8
    80006b7a:	fb491be3          	bne	s2,s4,80006b30 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006b7e:	10048913          	addi	s2,s1,256
    80006b82:	6088                	ld	a0,0(s1)
    80006b84:	c529                	beqz	a0,80006bce <sys_exec+0xf8>
    kfree(argv[i]);
    80006b86:	ffffa097          	auipc	ra,0xffffa
    80006b8a:	e50080e7          	jalr	-432(ra) # 800009d6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006b8e:	04a1                	addi	s1,s1,8
    80006b90:	ff2499e3          	bne	s1,s2,80006b82 <sys_exec+0xac>
  return -1;
    80006b94:	597d                	li	s2,-1
    80006b96:	a82d                	j	80006bd0 <sys_exec+0xfa>
      argv[i] = 0;
    80006b98:	0a8e                	slli	s5,s5,0x3
    80006b9a:	fc040793          	addi	a5,s0,-64
    80006b9e:	9abe                	add	s5,s5,a5
    80006ba0:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffb9e80>
  int ret = exec(path, argv);
    80006ba4:	e4040593          	addi	a1,s0,-448
    80006ba8:	f4040513          	addi	a0,s0,-192
    80006bac:	fffff097          	auipc	ra,0xfffff
    80006bb0:	11a080e7          	jalr	282(ra) # 80005cc6 <exec>
    80006bb4:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006bb6:	10048993          	addi	s3,s1,256
    80006bba:	6088                	ld	a0,0(s1)
    80006bbc:	c911                	beqz	a0,80006bd0 <sys_exec+0xfa>
    kfree(argv[i]);
    80006bbe:	ffffa097          	auipc	ra,0xffffa
    80006bc2:	e18080e7          	jalr	-488(ra) # 800009d6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006bc6:	04a1                	addi	s1,s1,8
    80006bc8:	ff3499e3          	bne	s1,s3,80006bba <sys_exec+0xe4>
    80006bcc:	a011                	j	80006bd0 <sys_exec+0xfa>
  return -1;
    80006bce:	597d                	li	s2,-1
}
    80006bd0:	854a                	mv	a0,s2
    80006bd2:	60be                	ld	ra,456(sp)
    80006bd4:	641e                	ld	s0,448(sp)
    80006bd6:	74fa                	ld	s1,440(sp)
    80006bd8:	795a                	ld	s2,432(sp)
    80006bda:	79ba                	ld	s3,424(sp)
    80006bdc:	7a1a                	ld	s4,416(sp)
    80006bde:	6afa                	ld	s5,408(sp)
    80006be0:	6179                	addi	sp,sp,464
    80006be2:	8082                	ret

0000000080006be4 <sys_pipe>:

uint64
sys_pipe(void)
{
    80006be4:	7139                	addi	sp,sp,-64
    80006be6:	fc06                	sd	ra,56(sp)
    80006be8:	f822                	sd	s0,48(sp)
    80006bea:	f426                	sd	s1,40(sp)
    80006bec:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006bee:	ffffb097          	auipc	ra,0xffffb
    80006bf2:	e78080e7          	jalr	-392(ra) # 80001a66 <myproc>
    80006bf6:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80006bf8:	fd840593          	addi	a1,s0,-40
    80006bfc:	4501                	li	a0,0
    80006bfe:	ffffd097          	auipc	ra,0xffffd
    80006c02:	e04080e7          	jalr	-508(ra) # 80003a02 <argaddr>
    return -1;
    80006c06:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80006c08:	0e054863          	bltz	a0,80006cf8 <sys_pipe+0x114>
  if(pipealloc(&rf, &wf) < 0)
    80006c0c:	fc840593          	addi	a1,s0,-56
    80006c10:	fd040513          	addi	a0,s0,-48
    80006c14:	fffff097          	auipc	ra,0xfffff
    80006c18:	d80080e7          	jalr	-640(ra) # 80005994 <pipealloc>
    return -1;
    80006c1c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006c1e:	0c054d63          	bltz	a0,80006cf8 <sys_pipe+0x114>
  fd0 = -1;
    80006c22:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80006c26:	fd043503          	ld	a0,-48(s0)
    80006c2a:	fffff097          	auipc	ra,0xfffff
    80006c2e:	500080e7          	jalr	1280(ra) # 8000612a <fdalloc>
    80006c32:	fca42223          	sw	a0,-60(s0)
    80006c36:	0a054463          	bltz	a0,80006cde <sys_pipe+0xfa>
    80006c3a:	fc843503          	ld	a0,-56(s0)
    80006c3e:	fffff097          	auipc	ra,0xfffff
    80006c42:	4ec080e7          	jalr	1260(ra) # 8000612a <fdalloc>
    80006c46:	fca42023          	sw	a0,-64(s0)
    80006c4a:	08054063          	bltz	a0,80006cca <sys_pipe+0xe6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006c4e:	6785                	lui	a5,0x1
    80006c50:	97a6                	add	a5,a5,s1
    80006c52:	4691                	li	a3,4
    80006c54:	fc440613          	addi	a2,s0,-60
    80006c58:	fd843583          	ld	a1,-40(s0)
    80006c5c:	8187b503          	ld	a0,-2024(a5) # 818 <_entry-0x7ffff7e8>
    80006c60:	ffffb097          	auipc	ra,0xffffb
    80006c64:	9ec080e7          	jalr	-1556(ra) # 8000164c <copyout>
    80006c68:	02054363          	bltz	a0,80006c8e <sys_pipe+0xaa>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80006c6c:	6785                	lui	a5,0x1
    80006c6e:	97a6                	add	a5,a5,s1
    80006c70:	4691                	li	a3,4
    80006c72:	fc040613          	addi	a2,s0,-64
    80006c76:	fd843583          	ld	a1,-40(s0)
    80006c7a:	0591                	addi	a1,a1,4
    80006c7c:	8187b503          	ld	a0,-2024(a5) # 818 <_entry-0x7ffff7e8>
    80006c80:	ffffb097          	auipc	ra,0xffffb
    80006c84:	9cc080e7          	jalr	-1588(ra) # 8000164c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006c88:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006c8a:	06055763          	bgez	a0,80006cf8 <sys_pipe+0x114>
    p->ofile[fd0] = 0;
    80006c8e:	fc442783          	lw	a5,-60(s0)
    80006c92:	10478793          	addi	a5,a5,260
    80006c96:	078e                	slli	a5,a5,0x3
    80006c98:	97a6                	add	a5,a5,s1
    80006c9a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80006c9e:	fc042503          	lw	a0,-64(s0)
    80006ca2:	10450513          	addi	a0,a0,260 # 1104 <_entry-0x7fffeefc>
    80006ca6:	050e                	slli	a0,a0,0x3
    80006ca8:	9526                	add	a0,a0,s1
    80006caa:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80006cae:	fd043503          	ld	a0,-48(s0)
    80006cb2:	fffff097          	auipc	ra,0xfffff
    80006cb6:	9ae080e7          	jalr	-1618(ra) # 80005660 <fileclose>
    fileclose(wf);
    80006cba:	fc843503          	ld	a0,-56(s0)
    80006cbe:	fffff097          	auipc	ra,0xfffff
    80006cc2:	9a2080e7          	jalr	-1630(ra) # 80005660 <fileclose>
    return -1;
    80006cc6:	57fd                	li	a5,-1
    80006cc8:	a805                	j	80006cf8 <sys_pipe+0x114>
    if(fd0 >= 0)
    80006cca:	fc442783          	lw	a5,-60(s0)
    80006cce:	0007c863          	bltz	a5,80006cde <sys_pipe+0xfa>
      p->ofile[fd0] = 0;
    80006cd2:	10478513          	addi	a0,a5,260
    80006cd6:	050e                	slli	a0,a0,0x3
    80006cd8:	9526                	add	a0,a0,s1
    80006cda:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80006cde:	fd043503          	ld	a0,-48(s0)
    80006ce2:	fffff097          	auipc	ra,0xfffff
    80006ce6:	97e080e7          	jalr	-1666(ra) # 80005660 <fileclose>
    fileclose(wf);
    80006cea:	fc843503          	ld	a0,-56(s0)
    80006cee:	fffff097          	auipc	ra,0xfffff
    80006cf2:	972080e7          	jalr	-1678(ra) # 80005660 <fileclose>
    return -1;
    80006cf6:	57fd                	li	a5,-1
}
    80006cf8:	853e                	mv	a0,a5
    80006cfa:	70e2                	ld	ra,56(sp)
    80006cfc:	7442                	ld	s0,48(sp)
    80006cfe:	74a2                	ld	s1,40(sp)
    80006d00:	6121                	addi	sp,sp,64
    80006d02:	8082                	ret
	...

0000000080006d10 <kernelvec>:
    80006d10:	7111                	addi	sp,sp,-256
    80006d12:	e006                	sd	ra,0(sp)
    80006d14:	e40a                	sd	sp,8(sp)
    80006d16:	e80e                	sd	gp,16(sp)
    80006d18:	ec12                	sd	tp,24(sp)
    80006d1a:	f016                	sd	t0,32(sp)
    80006d1c:	f41a                	sd	t1,40(sp)
    80006d1e:	f81e                	sd	t2,48(sp)
    80006d20:	fc22                	sd	s0,56(sp)
    80006d22:	e0a6                	sd	s1,64(sp)
    80006d24:	e4aa                	sd	a0,72(sp)
    80006d26:	e8ae                	sd	a1,80(sp)
    80006d28:	ecb2                	sd	a2,88(sp)
    80006d2a:	f0b6                	sd	a3,96(sp)
    80006d2c:	f4ba                	sd	a4,104(sp)
    80006d2e:	f8be                	sd	a5,112(sp)
    80006d30:	fcc2                	sd	a6,120(sp)
    80006d32:	e146                	sd	a7,128(sp)
    80006d34:	e54a                	sd	s2,136(sp)
    80006d36:	e94e                	sd	s3,144(sp)
    80006d38:	ed52                	sd	s4,152(sp)
    80006d3a:	f156                	sd	s5,160(sp)
    80006d3c:	f55a                	sd	s6,168(sp)
    80006d3e:	f95e                	sd	s7,176(sp)
    80006d40:	fd62                	sd	s8,184(sp)
    80006d42:	e1e6                	sd	s9,192(sp)
    80006d44:	e5ea                	sd	s10,200(sp)
    80006d46:	e9ee                	sd	s11,208(sp)
    80006d48:	edf2                	sd	t3,216(sp)
    80006d4a:	f1f6                	sd	t4,224(sp)
    80006d4c:	f5fa                	sd	t5,232(sp)
    80006d4e:	f9fe                	sd	t6,240(sp)
    80006d50:	ab1fc0ef          	jal	ra,80003800 <kerneltrap>
    80006d54:	6082                	ld	ra,0(sp)
    80006d56:	6122                	ld	sp,8(sp)
    80006d58:	61c2                	ld	gp,16(sp)
    80006d5a:	7282                	ld	t0,32(sp)
    80006d5c:	7322                	ld	t1,40(sp)
    80006d5e:	73c2                	ld	t2,48(sp)
    80006d60:	7462                	ld	s0,56(sp)
    80006d62:	6486                	ld	s1,64(sp)
    80006d64:	6526                	ld	a0,72(sp)
    80006d66:	65c6                	ld	a1,80(sp)
    80006d68:	6666                	ld	a2,88(sp)
    80006d6a:	7686                	ld	a3,96(sp)
    80006d6c:	7726                	ld	a4,104(sp)
    80006d6e:	77c6                	ld	a5,112(sp)
    80006d70:	7866                	ld	a6,120(sp)
    80006d72:	688a                	ld	a7,128(sp)
    80006d74:	692a                	ld	s2,136(sp)
    80006d76:	69ca                	ld	s3,144(sp)
    80006d78:	6a6a                	ld	s4,152(sp)
    80006d7a:	7a8a                	ld	s5,160(sp)
    80006d7c:	7b2a                	ld	s6,168(sp)
    80006d7e:	7bca                	ld	s7,176(sp)
    80006d80:	7c6a                	ld	s8,184(sp)
    80006d82:	6c8e                	ld	s9,192(sp)
    80006d84:	6d2e                	ld	s10,200(sp)
    80006d86:	6dce                	ld	s11,208(sp)
    80006d88:	6e6e                	ld	t3,216(sp)
    80006d8a:	7e8e                	ld	t4,224(sp)
    80006d8c:	7f2e                	ld	t5,232(sp)
    80006d8e:	7fce                	ld	t6,240(sp)
    80006d90:	6111                	addi	sp,sp,256
    80006d92:	10200073          	sret
    80006d96:	00000013          	nop
    80006d9a:	00000013          	nop
    80006d9e:	0001                	nop

0000000080006da0 <timervec>:
    80006da0:	34051573          	csrrw	a0,mscratch,a0
    80006da4:	e10c                	sd	a1,0(a0)
    80006da6:	e510                	sd	a2,8(a0)
    80006da8:	e914                	sd	a3,16(a0)
    80006daa:	6d0c                	ld	a1,24(a0)
    80006dac:	7110                	ld	a2,32(a0)
    80006dae:	6194                	ld	a3,0(a1)
    80006db0:	96b2                	add	a3,a3,a2
    80006db2:	e194                	sd	a3,0(a1)
    80006db4:	4589                	li	a1,2
    80006db6:	14459073          	csrw	sip,a1
    80006dba:	6914                	ld	a3,16(a0)
    80006dbc:	6510                	ld	a2,8(a0)
    80006dbe:	610c                	ld	a1,0(a0)
    80006dc0:	34051573          	csrrw	a0,mscratch,a0
    80006dc4:	30200073          	mret
	...

0000000080006dca <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80006dca:	1141                	addi	sp,sp,-16
    80006dcc:	e422                	sd	s0,8(sp)
    80006dce:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006dd0:	0c0007b7          	lui	a5,0xc000
    80006dd4:	4705                	li	a4,1
    80006dd6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006dd8:	c3d8                	sw	a4,4(a5)
}
    80006dda:	6422                	ld	s0,8(sp)
    80006ddc:	0141                	addi	sp,sp,16
    80006dde:	8082                	ret

0000000080006de0 <plicinithart>:

void
plicinithart(void)
{
    80006de0:	1141                	addi	sp,sp,-16
    80006de2:	e406                	sd	ra,8(sp)
    80006de4:	e022                	sd	s0,0(sp)
    80006de6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006de8:	ffffb097          	auipc	ra,0xffffb
    80006dec:	c4a080e7          	jalr	-950(ra) # 80001a32 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006df0:	0085171b          	slliw	a4,a0,0x8
    80006df4:	0c0027b7          	lui	a5,0xc002
    80006df8:	97ba                	add	a5,a5,a4
    80006dfa:	40200713          	li	a4,1026
    80006dfe:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006e02:	00d5151b          	slliw	a0,a0,0xd
    80006e06:	0c2017b7          	lui	a5,0xc201
    80006e0a:	953e                	add	a0,a0,a5
    80006e0c:	00052023          	sw	zero,0(a0)
}
    80006e10:	60a2                	ld	ra,8(sp)
    80006e12:	6402                	ld	s0,0(sp)
    80006e14:	0141                	addi	sp,sp,16
    80006e16:	8082                	ret

0000000080006e18 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006e18:	1141                	addi	sp,sp,-16
    80006e1a:	e406                	sd	ra,8(sp)
    80006e1c:	e022                	sd	s0,0(sp)
    80006e1e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006e20:	ffffb097          	auipc	ra,0xffffb
    80006e24:	c12080e7          	jalr	-1006(ra) # 80001a32 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006e28:	00d5179b          	slliw	a5,a0,0xd
    80006e2c:	0c201537          	lui	a0,0xc201
    80006e30:	953e                	add	a0,a0,a5
  return irq;
}
    80006e32:	4148                	lw	a0,4(a0)
    80006e34:	60a2                	ld	ra,8(sp)
    80006e36:	6402                	ld	s0,0(sp)
    80006e38:	0141                	addi	sp,sp,16
    80006e3a:	8082                	ret

0000000080006e3c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006e3c:	1101                	addi	sp,sp,-32
    80006e3e:	ec06                	sd	ra,24(sp)
    80006e40:	e822                	sd	s0,16(sp)
    80006e42:	e426                	sd	s1,8(sp)
    80006e44:	1000                	addi	s0,sp,32
    80006e46:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006e48:	ffffb097          	auipc	ra,0xffffb
    80006e4c:	bea080e7          	jalr	-1046(ra) # 80001a32 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006e50:	00d5151b          	slliw	a0,a0,0xd
    80006e54:	0c2017b7          	lui	a5,0xc201
    80006e58:	97aa                	add	a5,a5,a0
    80006e5a:	c3c4                	sw	s1,4(a5)
}
    80006e5c:	60e2                	ld	ra,24(sp)
    80006e5e:	6442                	ld	s0,16(sp)
    80006e60:	64a2                	ld	s1,8(sp)
    80006e62:	6105                	addi	sp,sp,32
    80006e64:	8082                	ret

0000000080006e66 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006e66:	1141                	addi	sp,sp,-16
    80006e68:	e406                	sd	ra,8(sp)
    80006e6a:	e022                	sd	s0,0(sp)
    80006e6c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006e6e:	479d                	li	a5,7
    80006e70:	06a7c963          	blt	a5,a0,80006ee2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80006e74:	0003b797          	auipc	a5,0x3b
    80006e78:	18c78793          	addi	a5,a5,396 # 80042000 <disk>
    80006e7c:	00a78733          	add	a4,a5,a0
    80006e80:	6789                	lui	a5,0x2
    80006e82:	97ba                	add	a5,a5,a4
    80006e84:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80006e88:	e7ad                	bnez	a5,80006ef2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006e8a:	00451793          	slli	a5,a0,0x4
    80006e8e:	0003d717          	auipc	a4,0x3d
    80006e92:	17270713          	addi	a4,a4,370 # 80044000 <disk+0x2000>
    80006e96:	6314                	ld	a3,0(a4)
    80006e98:	96be                	add	a3,a3,a5
    80006e9a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80006e9e:	6314                	ld	a3,0(a4)
    80006ea0:	96be                	add	a3,a3,a5
    80006ea2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80006ea6:	6314                	ld	a3,0(a4)
    80006ea8:	96be                	add	a3,a3,a5
    80006eaa:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80006eae:	6318                	ld	a4,0(a4)
    80006eb0:	97ba                	add	a5,a5,a4
    80006eb2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80006eb6:	0003b797          	auipc	a5,0x3b
    80006eba:	14a78793          	addi	a5,a5,330 # 80042000 <disk>
    80006ebe:	97aa                	add	a5,a5,a0
    80006ec0:	6509                	lui	a0,0x2
    80006ec2:	953e                	add	a0,a0,a5
    80006ec4:	4785                	li	a5,1
    80006ec6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80006eca:	0003d517          	auipc	a0,0x3d
    80006ece:	14e50513          	addi	a0,a0,334 # 80044018 <disk+0x2018>
    80006ed2:	ffffc097          	auipc	ra,0xffffc
    80006ed6:	cf0080e7          	jalr	-784(ra) # 80002bc2 <wakeup>
}
    80006eda:	60a2                	ld	ra,8(sp)
    80006edc:	6402                	ld	s0,0(sp)
    80006ede:	0141                	addi	sp,sp,16
    80006ee0:	8082                	ret
    panic("free_desc 1");
    80006ee2:	00003517          	auipc	a0,0x3
    80006ee6:	8be50513          	addi	a0,a0,-1858 # 800097a0 <syscalls+0x378>
    80006eea:	ffff9097          	auipc	ra,0xffff9
    80006eee:	640080e7          	jalr	1600(ra) # 8000052a <panic>
    panic("free_desc 2");
    80006ef2:	00003517          	auipc	a0,0x3
    80006ef6:	8be50513          	addi	a0,a0,-1858 # 800097b0 <syscalls+0x388>
    80006efa:	ffff9097          	auipc	ra,0xffff9
    80006efe:	630080e7          	jalr	1584(ra) # 8000052a <panic>

0000000080006f02 <virtio_disk_init>:
{
    80006f02:	1101                	addi	sp,sp,-32
    80006f04:	ec06                	sd	ra,24(sp)
    80006f06:	e822                	sd	s0,16(sp)
    80006f08:	e426                	sd	s1,8(sp)
    80006f0a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006f0c:	00003597          	auipc	a1,0x3
    80006f10:	8b458593          	addi	a1,a1,-1868 # 800097c0 <syscalls+0x398>
    80006f14:	0003d517          	auipc	a0,0x3d
    80006f18:	21450513          	addi	a0,a0,532 # 80044128 <disk+0x2128>
    80006f1c:	ffffa097          	auipc	ra,0xffffa
    80006f20:	c16080e7          	jalr	-1002(ra) # 80000b32 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006f24:	100017b7          	lui	a5,0x10001
    80006f28:	4398                	lw	a4,0(a5)
    80006f2a:	2701                	sext.w	a4,a4
    80006f2c:	747277b7          	lui	a5,0x74727
    80006f30:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006f34:	0ef71163          	bne	a4,a5,80007016 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80006f38:	100017b7          	lui	a5,0x10001
    80006f3c:	43dc                	lw	a5,4(a5)
    80006f3e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006f40:	4705                	li	a4,1
    80006f42:	0ce79a63          	bne	a5,a4,80007016 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006f46:	100017b7          	lui	a5,0x10001
    80006f4a:	479c                	lw	a5,8(a5)
    80006f4c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80006f4e:	4709                	li	a4,2
    80006f50:	0ce79363          	bne	a5,a4,80007016 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006f54:	100017b7          	lui	a5,0x10001
    80006f58:	47d8                	lw	a4,12(a5)
    80006f5a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006f5c:	554d47b7          	lui	a5,0x554d4
    80006f60:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006f64:	0af71963          	bne	a4,a5,80007016 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006f68:	100017b7          	lui	a5,0x10001
    80006f6c:	4705                	li	a4,1
    80006f6e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006f70:	470d                	li	a4,3
    80006f72:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006f74:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006f76:	c7ffe737          	lui	a4,0xc7ffe
    80006f7a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fb975f>
    80006f7e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006f80:	2701                	sext.w	a4,a4
    80006f82:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006f84:	472d                	li	a4,11
    80006f86:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006f88:	473d                	li	a4,15
    80006f8a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80006f8c:	6705                	lui	a4,0x1
    80006f8e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006f90:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006f94:	5bdc                	lw	a5,52(a5)
    80006f96:	2781                	sext.w	a5,a5
  if(max == 0)
    80006f98:	c7d9                	beqz	a5,80007026 <virtio_disk_init+0x124>
  if(max < NUM)
    80006f9a:	471d                	li	a4,7
    80006f9c:	08f77d63          	bgeu	a4,a5,80007036 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006fa0:	100014b7          	lui	s1,0x10001
    80006fa4:	47a1                	li	a5,8
    80006fa6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80006fa8:	6609                	lui	a2,0x2
    80006faa:	4581                	li	a1,0
    80006fac:	0003b517          	auipc	a0,0x3b
    80006fb0:	05450513          	addi	a0,a0,84 # 80042000 <disk>
    80006fb4:	ffffa097          	auipc	ra,0xffffa
    80006fb8:	d18080e7          	jalr	-744(ra) # 80000ccc <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80006fbc:	0003b717          	auipc	a4,0x3b
    80006fc0:	04470713          	addi	a4,a4,68 # 80042000 <disk>
    80006fc4:	00c75793          	srli	a5,a4,0xc
    80006fc8:	2781                	sext.w	a5,a5
    80006fca:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80006fcc:	0003d797          	auipc	a5,0x3d
    80006fd0:	03478793          	addi	a5,a5,52 # 80044000 <disk+0x2000>
    80006fd4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80006fd6:	0003b717          	auipc	a4,0x3b
    80006fda:	0aa70713          	addi	a4,a4,170 # 80042080 <disk+0x80>
    80006fde:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80006fe0:	0003c717          	auipc	a4,0x3c
    80006fe4:	02070713          	addi	a4,a4,32 # 80043000 <disk+0x1000>
    80006fe8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80006fea:	4705                	li	a4,1
    80006fec:	00e78c23          	sb	a4,24(a5)
    80006ff0:	00e78ca3          	sb	a4,25(a5)
    80006ff4:	00e78d23          	sb	a4,26(a5)
    80006ff8:	00e78da3          	sb	a4,27(a5)
    80006ffc:	00e78e23          	sb	a4,28(a5)
    80007000:	00e78ea3          	sb	a4,29(a5)
    80007004:	00e78f23          	sb	a4,30(a5)
    80007008:	00e78fa3          	sb	a4,31(a5)
}
    8000700c:	60e2                	ld	ra,24(sp)
    8000700e:	6442                	ld	s0,16(sp)
    80007010:	64a2                	ld	s1,8(sp)
    80007012:	6105                	addi	sp,sp,32
    80007014:	8082                	ret
    panic("could not find virtio disk");
    80007016:	00002517          	auipc	a0,0x2
    8000701a:	7ba50513          	addi	a0,a0,1978 # 800097d0 <syscalls+0x3a8>
    8000701e:	ffff9097          	auipc	ra,0xffff9
    80007022:	50c080e7          	jalr	1292(ra) # 8000052a <panic>
    panic("virtio disk has no queue 0");
    80007026:	00002517          	auipc	a0,0x2
    8000702a:	7ca50513          	addi	a0,a0,1994 # 800097f0 <syscalls+0x3c8>
    8000702e:	ffff9097          	auipc	ra,0xffff9
    80007032:	4fc080e7          	jalr	1276(ra) # 8000052a <panic>
    panic("virtio disk max queue too short");
    80007036:	00002517          	auipc	a0,0x2
    8000703a:	7da50513          	addi	a0,a0,2010 # 80009810 <syscalls+0x3e8>
    8000703e:	ffff9097          	auipc	ra,0xffff9
    80007042:	4ec080e7          	jalr	1260(ra) # 8000052a <panic>

0000000080007046 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80007046:	7119                	addi	sp,sp,-128
    80007048:	fc86                	sd	ra,120(sp)
    8000704a:	f8a2                	sd	s0,112(sp)
    8000704c:	f4a6                	sd	s1,104(sp)
    8000704e:	f0ca                	sd	s2,96(sp)
    80007050:	ecce                	sd	s3,88(sp)
    80007052:	e8d2                	sd	s4,80(sp)
    80007054:	e4d6                	sd	s5,72(sp)
    80007056:	e0da                	sd	s6,64(sp)
    80007058:	fc5e                	sd	s7,56(sp)
    8000705a:	f862                	sd	s8,48(sp)
    8000705c:	f466                	sd	s9,40(sp)
    8000705e:	f06a                	sd	s10,32(sp)
    80007060:	ec6e                	sd	s11,24(sp)
    80007062:	0100                	addi	s0,sp,128
    80007064:	8aaa                	mv	s5,a0
    80007066:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80007068:	00c52c83          	lw	s9,12(a0)
    8000706c:	001c9c9b          	slliw	s9,s9,0x1
    80007070:	1c82                	slli	s9,s9,0x20
    80007072:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80007076:	0003d517          	auipc	a0,0x3d
    8000707a:	0b250513          	addi	a0,a0,178 # 80044128 <disk+0x2128>
    8000707e:	ffffa097          	auipc	ra,0xffffa
    80007082:	b4c080e7          	jalr	-1204(ra) # 80000bca <acquire>
  for(int i = 0; i < 3; i++){
    80007086:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80007088:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000708a:	0003bc17          	auipc	s8,0x3b
    8000708e:	f76c0c13          	addi	s8,s8,-138 # 80042000 <disk>
    80007092:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80007094:	4b0d                	li	s6,3
    80007096:	a0ad                	j	80007100 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80007098:	00fc0733          	add	a4,s8,a5
    8000709c:	975e                	add	a4,a4,s7
    8000709e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800070a2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800070a4:	0207c563          	bltz	a5,800070ce <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800070a8:	2905                	addiw	s2,s2,1
    800070aa:	0611                	addi	a2,a2,4
    800070ac:	19690d63          	beq	s2,s6,80007246 <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    800070b0:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800070b2:	0003d717          	auipc	a4,0x3d
    800070b6:	f6670713          	addi	a4,a4,-154 # 80044018 <disk+0x2018>
    800070ba:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800070bc:	00074683          	lbu	a3,0(a4)
    800070c0:	fee1                	bnez	a3,80007098 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800070c2:	2785                	addiw	a5,a5,1
    800070c4:	0705                	addi	a4,a4,1
    800070c6:	fe979be3          	bne	a5,s1,800070bc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800070ca:	57fd                	li	a5,-1
    800070cc:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800070ce:	01205d63          	blez	s2,800070e8 <virtio_disk_rw+0xa2>
    800070d2:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800070d4:	000a2503          	lw	a0,0(s4)
    800070d8:	00000097          	auipc	ra,0x0
    800070dc:	d8e080e7          	jalr	-626(ra) # 80006e66 <free_desc>
      for(int j = 0; j < i; j++)
    800070e0:	2d85                	addiw	s11,s11,1
    800070e2:	0a11                	addi	s4,s4,4
    800070e4:	ffb918e3          	bne	s2,s11,800070d4 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800070e8:	0003d597          	auipc	a1,0x3d
    800070ec:	04058593          	addi	a1,a1,64 # 80044128 <disk+0x2128>
    800070f0:	0003d517          	auipc	a0,0x3d
    800070f4:	f2850513          	addi	a0,a0,-216 # 80044018 <disk+0x2018>
    800070f8:	ffffb097          	auipc	ra,0xffffb
    800070fc:	75c080e7          	jalr	1884(ra) # 80002854 <sleep>
  for(int i = 0; i < 3; i++){
    80007100:	f8040a13          	addi	s4,s0,-128
{
    80007104:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80007106:	894e                	mv	s2,s3
    80007108:	b765                	j	800070b0 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000710a:	0003d697          	auipc	a3,0x3d
    8000710e:	ef66b683          	ld	a3,-266(a3) # 80044000 <disk+0x2000>
    80007112:	96ba                	add	a3,a3,a4
    80007114:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80007118:	0003b817          	auipc	a6,0x3b
    8000711c:	ee880813          	addi	a6,a6,-280 # 80042000 <disk>
    80007120:	0003d697          	auipc	a3,0x3d
    80007124:	ee068693          	addi	a3,a3,-288 # 80044000 <disk+0x2000>
    80007128:	6290                	ld	a2,0(a3)
    8000712a:	963a                	add	a2,a2,a4
    8000712c:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80007130:	0015e593          	ori	a1,a1,1
    80007134:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80007138:	f8842603          	lw	a2,-120(s0)
    8000713c:	628c                	ld	a1,0(a3)
    8000713e:	972e                	add	a4,a4,a1
    80007140:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80007144:	20050593          	addi	a1,a0,512
    80007148:	0592                	slli	a1,a1,0x4
    8000714a:	95c2                	add	a1,a1,a6
    8000714c:	577d                	li	a4,-1
    8000714e:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80007152:	00461713          	slli	a4,a2,0x4
    80007156:	6290                	ld	a2,0(a3)
    80007158:	963a                	add	a2,a2,a4
    8000715a:	03078793          	addi	a5,a5,48
    8000715e:	97c2                	add	a5,a5,a6
    80007160:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    80007162:	629c                	ld	a5,0(a3)
    80007164:	97ba                	add	a5,a5,a4
    80007166:	4605                	li	a2,1
    80007168:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000716a:	629c                	ld	a5,0(a3)
    8000716c:	97ba                	add	a5,a5,a4
    8000716e:	4809                	li	a6,2
    80007170:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80007174:	629c                	ld	a5,0(a3)
    80007176:	973e                	add	a4,a4,a5
    80007178:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000717c:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80007180:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80007184:	6698                	ld	a4,8(a3)
    80007186:	00275783          	lhu	a5,2(a4)
    8000718a:	8b9d                	andi	a5,a5,7
    8000718c:	0786                	slli	a5,a5,0x1
    8000718e:	97ba                	add	a5,a5,a4
    80007190:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    80007194:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80007198:	6698                	ld	a4,8(a3)
    8000719a:	00275783          	lhu	a5,2(a4)
    8000719e:	2785                	addiw	a5,a5,1
    800071a0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800071a4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800071a8:	100017b7          	lui	a5,0x10001
    800071ac:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800071b0:	004aa783          	lw	a5,4(s5)
    800071b4:	02c79163          	bne	a5,a2,800071d6 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    800071b8:	0003d917          	auipc	s2,0x3d
    800071bc:	f7090913          	addi	s2,s2,-144 # 80044128 <disk+0x2128>
  while(b->disk == 1) {
    800071c0:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800071c2:	85ca                	mv	a1,s2
    800071c4:	8556                	mv	a0,s5
    800071c6:	ffffb097          	auipc	ra,0xffffb
    800071ca:	68e080e7          	jalr	1678(ra) # 80002854 <sleep>
  while(b->disk == 1) {
    800071ce:	004aa783          	lw	a5,4(s5)
    800071d2:	fe9788e3          	beq	a5,s1,800071c2 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    800071d6:	f8042903          	lw	s2,-128(s0)
    800071da:	20090793          	addi	a5,s2,512
    800071de:	00479713          	slli	a4,a5,0x4
    800071e2:	0003b797          	auipc	a5,0x3b
    800071e6:	e1e78793          	addi	a5,a5,-482 # 80042000 <disk>
    800071ea:	97ba                	add	a5,a5,a4
    800071ec:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800071f0:	0003d997          	auipc	s3,0x3d
    800071f4:	e1098993          	addi	s3,s3,-496 # 80044000 <disk+0x2000>
    800071f8:	00491713          	slli	a4,s2,0x4
    800071fc:	0009b783          	ld	a5,0(s3)
    80007200:	97ba                	add	a5,a5,a4
    80007202:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80007206:	854a                	mv	a0,s2
    80007208:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000720c:	00000097          	auipc	ra,0x0
    80007210:	c5a080e7          	jalr	-934(ra) # 80006e66 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80007214:	8885                	andi	s1,s1,1
    80007216:	f0ed                	bnez	s1,800071f8 <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80007218:	0003d517          	auipc	a0,0x3d
    8000721c:	f1050513          	addi	a0,a0,-240 # 80044128 <disk+0x2128>
    80007220:	ffffa097          	auipc	ra,0xffffa
    80007224:	a64080e7          	jalr	-1436(ra) # 80000c84 <release>
}
    80007228:	70e6                	ld	ra,120(sp)
    8000722a:	7446                	ld	s0,112(sp)
    8000722c:	74a6                	ld	s1,104(sp)
    8000722e:	7906                	ld	s2,96(sp)
    80007230:	69e6                	ld	s3,88(sp)
    80007232:	6a46                	ld	s4,80(sp)
    80007234:	6aa6                	ld	s5,72(sp)
    80007236:	6b06                	ld	s6,64(sp)
    80007238:	7be2                	ld	s7,56(sp)
    8000723a:	7c42                	ld	s8,48(sp)
    8000723c:	7ca2                	ld	s9,40(sp)
    8000723e:	7d02                	ld	s10,32(sp)
    80007240:	6de2                	ld	s11,24(sp)
    80007242:	6109                	addi	sp,sp,128
    80007244:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80007246:	f8042503          	lw	a0,-128(s0)
    8000724a:	20050793          	addi	a5,a0,512
    8000724e:	0792                	slli	a5,a5,0x4
  if(write)
    80007250:	0003b817          	auipc	a6,0x3b
    80007254:	db080813          	addi	a6,a6,-592 # 80042000 <disk>
    80007258:	00f80733          	add	a4,a6,a5
    8000725c:	01a036b3          	snez	a3,s10
    80007260:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    80007264:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80007268:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000726c:	7679                	lui	a2,0xffffe
    8000726e:	963e                	add	a2,a2,a5
    80007270:	0003d697          	auipc	a3,0x3d
    80007274:	d9068693          	addi	a3,a3,-624 # 80044000 <disk+0x2000>
    80007278:	6298                	ld	a4,0(a3)
    8000727a:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000727c:	0a878593          	addi	a1,a5,168
    80007280:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    80007282:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80007284:	6298                	ld	a4,0(a3)
    80007286:	9732                	add	a4,a4,a2
    80007288:	45c1                	li	a1,16
    8000728a:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000728c:	6298                	ld	a4,0(a3)
    8000728e:	9732                	add	a4,a4,a2
    80007290:	4585                	li	a1,1
    80007292:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80007296:	f8442703          	lw	a4,-124(s0)
    8000729a:	628c                	ld	a1,0(a3)
    8000729c:	962e                	add	a2,a2,a1
    8000729e:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffb900e>
  disk.desc[idx[1]].addr = (uint64) b->data;
    800072a2:	0712                	slli	a4,a4,0x4
    800072a4:	6290                	ld	a2,0(a3)
    800072a6:	963a                	add	a2,a2,a4
    800072a8:	058a8593          	addi	a1,s5,88
    800072ac:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800072ae:	6294                	ld	a3,0(a3)
    800072b0:	96ba                	add	a3,a3,a4
    800072b2:	40000613          	li	a2,1024
    800072b6:	c690                	sw	a2,8(a3)
  if(write)
    800072b8:	e40d19e3          	bnez	s10,8000710a <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800072bc:	0003d697          	auipc	a3,0x3d
    800072c0:	d446b683          	ld	a3,-700(a3) # 80044000 <disk+0x2000>
    800072c4:	96ba                	add	a3,a3,a4
    800072c6:	4609                	li	a2,2
    800072c8:	00c69623          	sh	a2,12(a3)
    800072cc:	b5b1                	j	80007118 <virtio_disk_rw+0xd2>

00000000800072ce <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800072ce:	1101                	addi	sp,sp,-32
    800072d0:	ec06                	sd	ra,24(sp)
    800072d2:	e822                	sd	s0,16(sp)
    800072d4:	e426                	sd	s1,8(sp)
    800072d6:	e04a                	sd	s2,0(sp)
    800072d8:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800072da:	0003d517          	auipc	a0,0x3d
    800072de:	e4e50513          	addi	a0,a0,-434 # 80044128 <disk+0x2128>
    800072e2:	ffffa097          	auipc	ra,0xffffa
    800072e6:	8e8080e7          	jalr	-1816(ra) # 80000bca <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800072ea:	10001737          	lui	a4,0x10001
    800072ee:	533c                	lw	a5,96(a4)
    800072f0:	8b8d                	andi	a5,a5,3
    800072f2:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800072f4:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800072f8:	0003d797          	auipc	a5,0x3d
    800072fc:	d0878793          	addi	a5,a5,-760 # 80044000 <disk+0x2000>
    80007300:	6b94                	ld	a3,16(a5)
    80007302:	0207d703          	lhu	a4,32(a5)
    80007306:	0026d783          	lhu	a5,2(a3)
    8000730a:	06f70163          	beq	a4,a5,8000736c <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000730e:	0003b917          	auipc	s2,0x3b
    80007312:	cf290913          	addi	s2,s2,-782 # 80042000 <disk>
    80007316:	0003d497          	auipc	s1,0x3d
    8000731a:	cea48493          	addi	s1,s1,-790 # 80044000 <disk+0x2000>
    __sync_synchronize();
    8000731e:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80007322:	6898                	ld	a4,16(s1)
    80007324:	0204d783          	lhu	a5,32(s1)
    80007328:	8b9d                	andi	a5,a5,7
    8000732a:	078e                	slli	a5,a5,0x3
    8000732c:	97ba                	add	a5,a5,a4
    8000732e:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80007330:	20078713          	addi	a4,a5,512
    80007334:	0712                	slli	a4,a4,0x4
    80007336:	974a                	add	a4,a4,s2
    80007338:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000733c:	e731                	bnez	a4,80007388 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000733e:	20078793          	addi	a5,a5,512
    80007342:	0792                	slli	a5,a5,0x4
    80007344:	97ca                	add	a5,a5,s2
    80007346:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80007348:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000734c:	ffffc097          	auipc	ra,0xffffc
    80007350:	876080e7          	jalr	-1930(ra) # 80002bc2 <wakeup>

    disk.used_idx += 1;
    80007354:	0204d783          	lhu	a5,32(s1)
    80007358:	2785                	addiw	a5,a5,1
    8000735a:	17c2                	slli	a5,a5,0x30
    8000735c:	93c1                	srli	a5,a5,0x30
    8000735e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80007362:	6898                	ld	a4,16(s1)
    80007364:	00275703          	lhu	a4,2(a4)
    80007368:	faf71be3          	bne	a4,a5,8000731e <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000736c:	0003d517          	auipc	a0,0x3d
    80007370:	dbc50513          	addi	a0,a0,-580 # 80044128 <disk+0x2128>
    80007374:	ffffa097          	auipc	ra,0xffffa
    80007378:	910080e7          	jalr	-1776(ra) # 80000c84 <release>
}
    8000737c:	60e2                	ld	ra,24(sp)
    8000737e:	6442                	ld	s0,16(sp)
    80007380:	64a2                	ld	s1,8(sp)
    80007382:	6902                	ld	s2,0(sp)
    80007384:	6105                	addi	sp,sp,32
    80007386:	8082                	ret
      panic("virtio_disk_intr status");
    80007388:	00002517          	auipc	a0,0x2
    8000738c:	4a850513          	addi	a0,a0,1192 # 80009830 <syscalls+0x408>
    80007390:	ffff9097          	auipc	ra,0xffff9
    80007394:	19a080e7          	jalr	410(ra) # 8000052a <panic>
	...

0000000080008000 <_trampoline>:
    80008000:	14051573          	csrrw	a0,sscratch,a0
    80008004:	02153423          	sd	ra,40(a0)
    80008008:	02253823          	sd	sp,48(a0)
    8000800c:	02353c23          	sd	gp,56(a0)
    80008010:	04453023          	sd	tp,64(a0)
    80008014:	04553423          	sd	t0,72(a0)
    80008018:	04653823          	sd	t1,80(a0)
    8000801c:	04753c23          	sd	t2,88(a0)
    80008020:	f120                	sd	s0,96(a0)
    80008022:	f524                	sd	s1,104(a0)
    80008024:	fd2c                	sd	a1,120(a0)
    80008026:	e150                	sd	a2,128(a0)
    80008028:	e554                	sd	a3,136(a0)
    8000802a:	e958                	sd	a4,144(a0)
    8000802c:	ed5c                	sd	a5,152(a0)
    8000802e:	0b053023          	sd	a6,160(a0)
    80008032:	0b153423          	sd	a7,168(a0)
    80008036:	0b253823          	sd	s2,176(a0)
    8000803a:	0b353c23          	sd	s3,184(a0)
    8000803e:	0d453023          	sd	s4,192(a0)
    80008042:	0d553423          	sd	s5,200(a0)
    80008046:	0d653823          	sd	s6,208(a0)
    8000804a:	0d753c23          	sd	s7,216(a0)
    8000804e:	0f853023          	sd	s8,224(a0)
    80008052:	0f953423          	sd	s9,232(a0)
    80008056:	0fa53823          	sd	s10,240(a0)
    8000805a:	0fb53c23          	sd	s11,248(a0)
    8000805e:	11c53023          	sd	t3,256(a0)
    80008062:	11d53423          	sd	t4,264(a0)
    80008066:	11e53823          	sd	t5,272(a0)
    8000806a:	11f53c23          	sd	t6,280(a0)
    8000806e:	140022f3          	csrr	t0,sscratch
    80008072:	06553823          	sd	t0,112(a0)
    80008076:	00853103          	ld	sp,8(a0)
    8000807a:	02053203          	ld	tp,32(a0)
    8000807e:	01053283          	ld	t0,16(a0)
    80008082:	00053303          	ld	t1,0(a0)
    80008086:	18031073          	csrw	satp,t1
    8000808a:	12000073          	sfence.vma
    8000808e:	8282                	jr	t0

0000000080008090 <userret>:
    80008090:	18059073          	csrw	satp,a1
    80008094:	12000073          	sfence.vma
    80008098:	07053283          	ld	t0,112(a0)
    8000809c:	14029073          	csrw	sscratch,t0
    800080a0:	02853083          	ld	ra,40(a0)
    800080a4:	03053103          	ld	sp,48(a0)
    800080a8:	03853183          	ld	gp,56(a0)
    800080ac:	04053203          	ld	tp,64(a0)
    800080b0:	04853283          	ld	t0,72(a0)
    800080b4:	05053303          	ld	t1,80(a0)
    800080b8:	05853383          	ld	t2,88(a0)
    800080bc:	7120                	ld	s0,96(a0)
    800080be:	7524                	ld	s1,104(a0)
    800080c0:	7d2c                	ld	a1,120(a0)
    800080c2:	6150                	ld	a2,128(a0)
    800080c4:	6554                	ld	a3,136(a0)
    800080c6:	6958                	ld	a4,144(a0)
    800080c8:	6d5c                	ld	a5,152(a0)
    800080ca:	0a053803          	ld	a6,160(a0)
    800080ce:	0a853883          	ld	a7,168(a0)
    800080d2:	0b053903          	ld	s2,176(a0)
    800080d6:	0b853983          	ld	s3,184(a0)
    800080da:	0c053a03          	ld	s4,192(a0)
    800080de:	0c853a83          	ld	s5,200(a0)
    800080e2:	0d053b03          	ld	s6,208(a0)
    800080e6:	0d853b83          	ld	s7,216(a0)
    800080ea:	0e053c03          	ld	s8,224(a0)
    800080ee:	0e853c83          	ld	s9,232(a0)
    800080f2:	0f053d03          	ld	s10,240(a0)
    800080f6:	0f853d83          	ld	s11,248(a0)
    800080fa:	10053e03          	ld	t3,256(a0)
    800080fe:	10853e83          	ld	t4,264(a0)
    80008102:	11053f03          	ld	t5,272(a0)
    80008106:	11853f83          	ld	t6,280(a0)
    8000810a:	14051573          	csrrw	a0,sscratch,a0
    8000810e:	10200073          	sret
	...
