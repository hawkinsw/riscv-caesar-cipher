#!/bin/bash

CURRENT_DIR=`pwd`

# Install the prerequisites.
apt-get install device-tree-compiler
apt-get install libmpfr-dev
apt-get install libmpfc-dev
apt-get install makeinfo

# Installation directories

source directories.sh

mkdir -p $SPIKE_HOME_DIR || exit
mkdir -p $SPIKE_INSTALL_DIR || exit 
cd $SPIKE_HOME_DIR

git clone https://github.com/riscv/riscv-isa-sim.git --depth 1
cd riscv-isa-sim
mkdir build
cd build
../configure --prefix=$SPIKE_INSTALL_DIR
make
make install
cd $CURRENT_DIR


# Install GNU Toolchain
mkdir -p $TOOLCHAIN_HOME_DIR || exit
mkdir -p $TOOLCHAIN_INSTALL_DIR || exit 
cd $TOOLCHAIN_HOME_DIR

git clone https://github.com/riscv/riscv-gnu-toolchain.git --branch rvv-0.8.x --single-branch --depth 1 riscv-gnu-toolchain_rvv-0.8.x
cd riscv-gnu-toolchain_rvv-0.8.x
git submodule update --init --recursive --depth 1 riscv-binutils riscv-gcc riscv-glibc riscv-dejagnu riscv-newlib riscv-gdb
mkdir build
cd build
../configure --prefix=$TOOLCHAIN_INSTALL_DIR --enable-multilib
make
make install

cd $CURRENT_DIR


# Proxy kernel
mkdir -p $PK_HOME_DIR || exit
mkdir -p $PK_INSTALL_DIR || exit 
cd $PK_HOME_DIR

git clone --depth 1 https://github.com/riscv/riscv-pk.git
cd riscv-pk
mkdir build
cd build
PATH=$TOOLCHAIN_INSTALL_DIR/bin/:$PATH ../configure --prefix=$PK_INSTALL_DIR --host=riscv64-unknown-elf
PATH=$TOOLCHAIN_INSTALL_DIR/bin/:$PATH make
PATH=$TOOLCHAIN_INSTALL_DIR/bin/:$PATH make install

cd $CURRENT_DIR

# Binutils
mkdir -p $BINUTILS_HOME_DIR || exit
mkdir -p $BINUTILS_INSTALL_DIR || exit 
cd $BINUTILS_HOME_DIR || exit

git clone https://github.com/riscv/riscv-binutils-gdb.git --branch rvv-0.8.x --single-branch --depth 1 riscv-binutils-gdb_rvv-0.8.x
cd riscv-binutils-gdb_rvv-0.8.x
mkdir build
cd build
../configure --prefix=$BINUTILS_INSTALL_DIR --target riscv64-unknown-elf --enable-multilib
make
make install

cd $CURRENT_DIR
