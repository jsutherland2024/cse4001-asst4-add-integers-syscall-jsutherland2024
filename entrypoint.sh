#!/bin/bash

echo "Install pip and expect in the container"
apt update
apt install python3-pip -y
apt install expect -y

ls ~/
cd /github/workspace
echo "Original PATH variable in the container"
echo $PATH

echo "Updated PATH variable in the container"
export PATH=$PATH:/root/os161/tools/bin
echo $PATH

# Set (or re-set) the HOME variable otherwise 
# GitHub will set it to HOME = "/github/home/"
export HOME="/root"


echo "Building OS/161"
# Build OS/161 for assignment ASST4
./build_os161 4

# Run the OS/161 kernel with the test program
./expect_run_test.exp 

# Test 
grep -q "s2=-1" /root/os161/root/output.txt && exit 0 || exit 1
# grep -q "Operation took" /root/os161/root/output.txt && exit 0 || exit 1







