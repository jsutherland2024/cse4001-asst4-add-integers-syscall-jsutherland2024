#include <types.h>
#include <lib.h>
#include <syscall.h>

int
sys_print_int(const char *msg, int x)
{
    kprintf("%s%d\n", msg, x);
    return 0;
}
