#!/bin/bash

source directories.sh

# Emulate the Caesar Cipher application using Spike and PK
#$SPIKE_INSTALL_DIR/bin/spike --isa=RV64gcV $PK_INSTALL_DIR/riscv64-unknown-elf/bin/pk caesar.out

# Debug the Caesar Cipher application using Spike and PK
$SPIKE_INSTALL_DIR/bin/spike -d --isa=RV64gcV $PK_INSTALL_DIR/riscv64-unknown-elf/bin/pk caesar.out

# Debug Spike as it emulates PK running the Caesar Cipher application
#gdb --args $SPIKE_INSTALL_DIR/bin/spike -d --isa=RV64gcV $PK_INSTALL_DIR/riscv64-unknown-elf/bin/pk caesar.out
