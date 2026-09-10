# Sample solution (Add a new system call to OS/161)


## Add a new system call

Let's now add a new system call. Adding a new system call requires two major steps:

1. The first step is to add the *kernel-level implementation*. 
2. The second is to add the *user-level implementatio*n. 

## Kernel-level implementation steps

### The system-call implementation file
In the example that follows, we will add the `hello` system call. The kernel-level implementation of the system call goes in `kern/syscall`. In this example, the implementation is:

```shell
#include<types.h>
#include<lib.h>
#include<syscall.h>
int sys_hello(void){
    kprintf("Hello CSE4001!\n");    
    return 0; 
}
```

We need to include `<lib.h>` because of `kprintf`. The `#include  <syscall.h>` is also needed. 

### The system-call prototype 
Add the prototype of the system call to `kern/include/syscall.h`. In this example, the prototype is:

```shell
int sys_hello(void);
```

### Assign an ID to the system call

Now that we have the prototype and the implementation in place, we need to add an ID for the call. OS/161 keeps the list of system calls and their corresponding IDs in `kern/include/kern/syscall.h` 

```shell
#define SYS_hello       41
```

### Add the system call handler code

When a user-level program calls a function that is handled by a system call, an interruption is triggered. This interruption is "trapped" and information about it is stored in a data structure called `trapframe`. The trap ID is processed by a switch-case in `kern/arch/mips/syscall/syscall.c`. When we add a new system call, we need to add a new case statement.

```shell
case SYS_hello:
      err = sys_hello();
break; 
```

### Update the kernel configuration file

We have now completed the implementation of the new system call. We need to update the OS/161 configuration file so, when the kernel is rebuilt, the compiler knows where to find the new files. Add a new file-entry definition to `kern/conf/conf.kern` 

```shell
file    syscall/hello.c
```

### Compile the kernel 

Before proceeding, we can rebuild the kernel to see if everything is okay until now. For this, just run the script `build_os161` from the top-level of the assignment repository directory: 
```shell
cd <assignment_repository_url>
./build_os161 <assignment_number>
```



But, we cannot test our new system call yet because we have not completed its *user-level* implementation yet. We will do that next. 


## User-level implementation

### Add the user-level prototype for the system call
Let’s add the user-level prototype of the system call to `userland/include/unistd.h` 

```shell
int hello(void);
```

### Create the sub-directory of the test program
Create a new subdirectory where you will place the implementation of the test function for the new system call.

```shell
cd userland/testbin
mkdir hellotest
```

### Create the implementation file of the new test program

Add the implementation file (e.g., `hello.c`) to this directory.

```shell
#include <unistd.h> 
int main(){
   hello(); 
   return 0; 
}
```
### Update the makefile files related to the new test program

You need to write a makefile for the test program. This makefile will be place in the same subdirectory of the test program. You do not need to write a makefile from scratch. Instead, copy a makefile from another test directory, e.g., from `forkbomb`, and modify it.

 Then, also modify the top-level makefile in `userland/testbin` by adding an entry for new test directory (i.e., `hellotest`). Rebuild userland and test the system call by calling it from the `p function` in the OS161 menu. 

 Now, run the script `build_os161` again to build both the kernel and userland. Make sure there are no errors. 


### Testing the system call
Test the new system call by calling the test program using the operations-menu option `p`. This menu option executes a program written by the user of OS/161. When prompted by the `p` option, type: 

```shell
p testbin/hello
```

You should see the message *Hello CSE4001!*. But you might also see an error message because the OS cannot find `syscall 3`... This error occurs when the current version of the kernel does not have  the implementation of the `_exit` function, which is system call #3.

