#include <types.h>
#include <kern/errno.h>
#include <lib.h>
#include <kern/syscall.h>
#include <syscall.h>

int
sys_add_two_integers(int a, int b, int *retval)
{
    *retval = a + b;
    return 0;
}
