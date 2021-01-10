#!/bin/bash

make clean

source directories.sh

# Assemble the source code to an object file.
$TOOLCHAIN_INSTALL_DIR/bin/riscv64-unknown-elf-as -v --traditional-format -fpic -march=rv64gcv -mabi=lp64d -o caesar.o caesar.S

# Compile
$TOOLCHAIN_INSTALL_DIR/bin/riscv64-unknown-elf-gcc -o caesar.out caesar.o
