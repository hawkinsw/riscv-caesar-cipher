	.option pic
	.text
	.section	.rodata
.prompt_string:
	.string	"Enter string to encode: "
.result_string:
	.string "'%s' encrypts to '%s'!\n"
.key:
	.byte 0x01, 0x01, 0x01, 0x01
	.text
	.globl	main
	.type	main, @function
main:
	# Locals:
	# plaintext = 16(sp)
	# plaintext_len = 24(sp)
	# encrypted = 32(sp)

	# Make room on the stack to store the return address,
	# the old stack pointer and the local variables.
	addi	sp,sp,-40

	# Stash away the return address.
	sd	ra,8(sp)
	# Stash away the stack pointer
	sd	s0,0(sp)

	# Adjust the stack pointer
	addi	s0,sp,40

	# Call puts(prompt_string) to display
	# Enter string to encode:
	# on the screen.
	lla	a0, .prompt_string
	call puts@plt

	# Call malloc(80) to allocate a memory for the encrypted string
	li	a0, 80
	call malloc@plt
	# Store the pointer to the allocated space at sp+32
	# encrypted = 32(sp)
	sd a0, 32(sp)

	# Call malloc(80) to allocate a memory for the plaintext string
	li	a0, 80
	call	malloc@plt
	# store a pointer to the allocated space at sp+16
	# plaintext = 16(sp)
	sd a0, 16(sp)

	# Call gets() and store the user's text in the space that
	# we just allocated for the plaintext string.
	mv	a0, a0
	call	gets@plt

	# Call strlen(plaintext) to find out how long the plaintext is.
	call	strlen@plt
	# plaintext_len = 24(sp)
	sd a0, 24(sp)

	# Recall the locals into registers to make them easier to use
	# during the encryption loop.
	# a2 = plaintext_len
	ld a2, 24(sp)
	# a3 = encrypted
	ld a3, 32(sp)
	# a4 = plaintext
	ld a4, 16(sp)
	# a5 = key
	lla a5, .key

# The top of the encryption loop.
.encrypt:
	# tell the vector system that we want to slurp up as many as
	# 4 bytes at a time. However, if there are fewer than 4 bytes
	# (left) to encode, then only encode that many bytes.
	li	a1, 4
	bgt a2, a1, .slurp_count_of_4_ok
	mv	a1, a2
.slurp_count_of_4_ok:
	# Each vector register is VLEN bits long. Each element in each vector
	# register is SEW bits wide. Therefore, each vector contains VLEN/SEW
	# elements. However, because VLEN is platform-specific, we don't know
	# VLEN/SEW a priori, even if SEW is static (which it does not have 
	# to be). Vector registers can be grouped together and viewed as a
	# larger, single logical register by setting LMUL to something other
	# than 1. vsetvli is used to configure vector operations. 
	# The semantics of the following use of vsetvli are:
	# 1. Set SEW to 8 bits.
	# 2. Set the LMUL to 1.
	# 3. Find out how many 4 8 bit elements fit in a single vector register.
	vsetvli	t0, a1, e8, m1

	# t0 contains max(4, VLEN/SEW).

	# load t0 bytes (bytes are 8 bits) of plaintext into v0
	vlbu.v	v0, (a4)
	# load t0 bytes of key into 1th vector
	vlbu.v	v1, (a5)
	# encrypt t0 bytes
	vadd.vv	v0, v0, v1
	# store t0 bytes of encrypted text into memory
	vsb.v	v0, (a3)

	# plaintext -= slurped_amt
	sub a2, a2, t0
	# move the pointer forward in plaintext
	add a4, a4, t0
	# move the pointer forward in encrypted
	add a3, a3, t0

	# redo until plaintext_len is less than 0
	bgt a2, x0, .encrypt
# The bottom of the encryption loop.

	# print out the results of the encryption.
	ld a2, 32(sp)
	ld a1, 16(sp)
	lla a0, .result_string
	call printf@plt

	mv	a0,a1
	ld	ra,8(sp)
	ld	s0,0(sp)
	addi	sp,sp,40
	jr	ra
	.size	main, .-main
	.section	.note.GNU-stack,"",@progbits	#set a non-executable program stack.
