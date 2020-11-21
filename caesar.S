	.file	"caesar.c"
	.option pic
	.text
	.section	.rodata
.prompt_string:
	.string	"Enter string to encode: "
.echo_string:
	.string "'%s' encrypts to '%s'!\n"
.key:
	.byte 0x01, 0x01, 0x01, 0x01
	.text
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-40
	sd	ra,8(sp)
	sd	s0,0(sp)
	addi	s0,sp,40

	lla	a0, .prompt_string
	call puts@plt

	# allocate a space for 5 characters.
	li	a0, 5
	call malloc@plt
	# store a pointer to the allocated space at sp+32
	# encrypted = 32(sp)
	sd a0, 32(sp)

	# allocate space to store the string we read.
	li	a0, 80
	call	malloc@plt
	# store a pointer to the allocated space at sp+16
	# plaintext = 16(sp)
	sd a0, 16(sp)

	# read a string into that space.
	mv	a0, a0
	call	gets@plt

	# find out how long it is
	call	strlen@plt
	# plaintext_len = 24(sp)
	sd a0, 24(sp)

	# a2 = plaintext_len
	ld a2, 24(sp)
	# a3 = encrypted
	ld a3, 32(sp)
	# a4 = plaintext
	ld a4, 16(sp)
	# a5 = key
	lla a5, .key
.encrypt:

	# tell the vector system that we want to slurp up 4 bytes at a time
	li	a1, 4
	vsetvli	t0, a1, e8, m1


	# load t0 bytes of plaintext into v0
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

	# print out the encrypted text
	ld a2, 32(sp)
	ld a1, 16(sp)
	lla a0, .echo_string
	call printf@plt

	mv	a0,a1
	ld	ra,8(sp)
	ld	s0,0(sp)
	addi	sp,sp,40
	jr	ra
	.size	main, .-main
	.section	.note.GNU-stack,"",@progbits	#set a non-executable program stack.
