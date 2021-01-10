# The Ides of RISC-V

This is a RISC-V implementation of a simple Ceasar Cipher. The implementation
uses the RISC-V ISA Vector extension to do encryption in parallel. This is a
learning exercise, nothing more.

If you are an expert on the RISC-V ISA Vector extension and have comments
about the comments in the source code, please alert me. Because this is for
learning, I want the source code commentary to be as educational as possible.

## Running

As of this writing, the Vector ISA is not standardized so you will need an
emulator to run it. The installation and execution instructions (below) will
install one for you.

## Prerequisites

Modify the directories.sh file with appropriate source and installation paths
for
1. the cross compiler,
1. the RISC-V binutils and
1. the emulator.

## Installation

Execute the `install.sh` script.

## Building

Execute the `build-caesar.sh` script.

## Executing

Execute the `run-caesar.sh` script.

## Comments/Issues

Please submit comments and bug reports using Github Issues. Remember, this
is a learning exercise. So, if you have comments about misleading/incorrect
commentary about in the source code, please submit them!! 
