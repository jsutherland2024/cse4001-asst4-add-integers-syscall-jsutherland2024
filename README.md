# CSE4001 - Assignment 4: Add two more system calls to OS/161 💥



>  **Assignment number**: 4
>
> **Assignment name**: `asst4-add-integers-syscall`

---

This repository contains the code base of the OS/161 kernel that you will use to complete this assignment. In this assignment, you will implement the following:

- **Two new system calls** , i.e., 

  - `add_two_integers()`  
  - `print_int()`

  Here, **you will need to implement all the steps needed to add a system call to the OS**. These are the same steps you followed to implement the system call `hello` (i.e., kernel-level steps and user-lever steps). 

- **A user-level program to test both system calls**. This is a single test program for testing the two new system calls. 

## 🚨 Do this first!!🚨 Create your own private repository for the assignment

1. **Follow these instructions**: https://github.com/cse4001/cse4001_course_materials/blob/main/adm/submitting_assignments.md
2. **Learn how to clone repositories using the GitHub tool `gh`**: https://github.com/eribeiroClassroom/notes_github/blob/main/README.md 

## **Hints for completing the assignment**

- **You must `git clone` the assignment GitHub repository.** Any other option to obtain the kernel files is wrong (e.g., using the download option from GitHub, copying the files from another directory or any other place, forking the repository, invoking the files through an *ouija board*). By *git cloning* the repository, its files  will be under source control and you will be able to edit the source code and `commit/push` any changes into the correct assignment repository on the GitHub server. You should not work on any files from a previous assignment. Every `OS/161` assignment has its own specific source code that is provided with the assignment repository. Clone the assignment repository from inside `/root/workspace/` (which is inside the CSE4001 container), and using the shell (command-line interface).

- **Test your kernel to make sure it works and read any error messages, if any are printed.** Read the error messages as they usually tell you what the problem is, e.g., undeclared function, syntax error, linking error, unknown library, unknown function.

- **Automated testing.** This repository tests the kernel automatically whenever new changes are pushed to the repository. To see the details of the tests, open the GitHub Actions tab and select the workflow of the test. The code passes the tests if a green checkmark (✅) appears besides the label of the latest commit. Failed tests are indicated by a red X (❌). 

## 🚀 Now, start the actual assignment

At this point, you should have already created your own private repository which contains the assignment files (i.e., kernel source code, test scripts, and test workflow directory). 

If you followed the instructions in https://github.com/cse4001/cse4001_course_materials/blob/main/adm/submitting_assignments.md, then all the required files should be in your private directory. 

### **Clone your private repository for this assignment**

#### Start the CSE4001 container, and clone the assignment repo

 Start the `CSE4001` container: 

  ```bash
docker start -i cse4001
  ```

  If the container fails to start, make sure the container is running by calling the `docker run` command. For details see notes: https://github.com/eraldoribeiro/UsingCSE4001_OS161/blob/main/RunningOS161_DockerDesktop.md

Clone the assignment repository. Do this from inside `/root/workspace/` in the `CSE4001` container. Use `git clone` or `gh repo clone`. 
    

```bash
cd /root/workspace
gh repo clone <assignment_repository_url>
```

#### Build the `OS/161` kernel. 

Start by building the current version of the kernel that was just cloned. Go into the directory of the repository that was cloned for this assignment, and run the script `build_os161` that is provided in the assignment repository. 

The `build_os161` script implements the steps to build both the `kernel` and `userland`. If you want to see the building steps, just open the file of the script in a text editor or read the detailed instructions on how to build `OS/161` (https://github.com/eraldoribeiro/UsingCSE4001_OS161/blob/main/README.md). 

```bash
cd <assignment_repository_url>
./build_os161 <assignment_number>
```

The script’s mode is set to executable. If it does not execute, call `bash build_os161 <assignment number>` .  If the build is successful, the script will print the following: 

```bash
Building done.
  
Now, run sys161 kernel from inside ~/os161/root/
```

## **Syscall 1** (user-level prototype): `int add_two_integers(int a, int b)`

This system call will have number 43 as its ID. If this ID number is being used then just choose another one that is not being used. 

This system call receives two integers as input and returns their sum (i.e., `sum = a + b`). 
The implementation is a bit more involved than the implementation of the `hello()` system call. First, the function accepts two input arguments. Another difference is that the user-level version of `add_two_numbers()` returns an integer value (i.e., the sum of the two input arguments). 

The handling of the return value of the system call is important in this case. In the system-call handler (i.e., the file `syscall.c` that has the `switch/case` block), the call to the kernel-level implementation must return an integer value that is either 0 (i.e., success) or nonzero (i.e., an error code). Given this restriction, the return value of the kernel-level prototype cannot be the sum of the numbers. To be able to acquire the value of the sum from the kernel-level function, you will pass the return variable (i.e., `retval`) as an input argument by *reference* to the kernel-version of `add_three_integers`. Passing an argument by reference in C-language is done by passing the address of the variable. 

The prototype of the kernel-level function will then be `int sys_add_two_integers(int a, int b, int *retval)`. Note that, in this case, the prototype of the user-level function (i.e., the function that is called by the user-level test program) which is declared as `int add_two_integers(int a, int b)` differs from the kernel-level version by an extra input argument (i.e., the reference to the `retval` variable). This difference will not cause any problems, as long as the list of argument types are placed in the order matching the arguments of the user-level prototype.

The variable `retval` will be passed by reference to the function, which is C-language means that the address of `retval` will be passed as an argument to the function, i.e.: 

```c
err = sys_add_two_integers(..., ..., &retval);
```

The kernel-level implementation of `sys_add_three_integers` looks like:

```c
int sys_add_two_integers(int a, int b, int* retval_ptr)
{
    ...

    *retval_ptr = s1 + s2;

    return 0;
}
```

Note that, when calling the function, the address of `retval` is passed as an argument to the function. This argument address is stored in the pointer-to-an-integer variable declared as `int* retval_ptr`. When inside the `sys_add_three_integers` function, assigning a value to the memory location pointed by `retval_ptr` is done by using by dereferencing the pointer, i.e., `*retval_ptr = s1 + s2;`  

## **Syscall 2**(user-level prototype): `int print_int(const char *msg, int x)`

You will not be able to call `printf()` from the user-level test program to print the result of the sum produced by `add_two_integers()`. The reason is because `printf()` calls `write()`, which is not yet implemented in the current version of OS/161 that is being used in this assignment. As a result, calling `printf()` in the test program will cause an error (i.e., missing syscall). 

To print the result of the `add_two_integers()` from the test program, you will create another system call with a signature `int print_int(const char *msg, int x)`. Again, because this system call does not exist in OS/161, you will need to implement all its steps in the kernel code, except for the test program since you will be testing it from your user-level test program for `add_two_integers()`. 

The implementation of the kernel-level version of `print_int` is:  

```c
void sys_print_string(const char *msg, int x) {
	kprintf("%s%d\n", msg, x);
}
```

The executable file of the test program must be named `test_sum_integers`. The code to be implemented in the test program is given as follows.

## Test program (for both functions)  

This is the user-level test program (i.e., `test_sum_integers.c`) to test both functions: 

```c
#include <unistd.h> 
int main(){

  int s1 = add_two_integers(3, 5);
  int s2 = add_two_integers(-5, 4);

  print_int("s1=", s1);
  print_int("s2=", s2);

  return 0;
} 
```

### Testing the system call

To test the system call, just run the following command: 

```bash
sys161 kernel p testbin/test_add_integers
```

The expected output (considering the hardcoded input values given in these instructions) is:

```bash
s1=10
s2=-1
```

## Submitting the assignment

To submit the assignment, you will `git commit` and `git push` the changes you made to the code so the changes are sent to the assignment repository on `GitHub.com`.

### Only add source code to the repository 

#### Add files manually instead of using `git add .` for all files 

Try your best to only add source code to the repository. Avoid adding executable and object files. Do not call  `git add .` to add all files. Instead, add files manually calling `git add <filename>`.

#### Clean up before committing

In addition to adding only the necessary files, remove binary files. The script `cleanup_before_committing` does that for you. Just run it from inside the CSE4001 container before any commit is done, i.e.: 

```shell
./cleanup_before_committing <assignment_number>
```

This script will run `bmake clean` for the kernel directories and also for the `userland` directories.





