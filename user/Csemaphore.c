
#include "Csemaphore.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int csem_alloc(struct counting_semaphore *sem, int initial_value){
    sem->binary_semaphore1 = bsem_alloc();
    sem->binary_semaphore2 = bsem_alloc();
    if(sem->binary_semaphore1 == -1 || sem->binary_semaphore2 == -1)
        return -1;
    if(initial_value == 0)
        bsem_down(sem->binary_semaphore2);
    sem->value = initial_value;
    return 0;
}

void csem_free(struct counting_semaphore *sem){
    bsem_free(sem->binary_semaphore1);
    bsem_free(sem->binary_semaphore2);
    sem->value = 0;
}

void csem_down(struct counting_semaphore *sem){
    bsem_down(sem->binary_semaphore2);
    bsem_down(sem->binary_semaphore1);
    sem->value--;
    if(sem->value > 0)
        bsem_up(sem->binary_semaphore2);
    bsem_up(sem->binary_semaphore1);
}

void csem_up(struct counting_semaphore *sem){
    bsem_down(sem->binary_semaphore1);
    sem->value++;
    if(sem->value == 1)
        bsem_up(sem->binary_semaphore2);
    bsem_up(sem->binary_semaphore1);
}