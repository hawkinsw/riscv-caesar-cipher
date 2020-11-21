make clean

# Assemble to an object file.
/home/hawkinsw/code/riscv-gnu/bin/riscv64-unknown-elf-as -v --traditional-format -fpic -march=rv64gcv -mabi=lp64d -o caesar.o caesar.S

# Compile
/home/hawkinsw/code/riscv-gnu/bin/riscv64-unknown-elf-gcc -o caesar.out caesar.o  

# Emulate
/home/hawkinsw/code/risc-spike/bin/spike --isa=RV64gcV /home/hawkinsw/code/risc/risk-pk/riscv64-unknown-elf/bin/pk caesar.out
/home/hawkinsw/code/risc-spike/bin/spike -d --isa=RV64gcV /home/hawkinsw/code/risc/risk-pk/riscv64-unknown-elf/bin/pk caesar.out

#./vector.out
