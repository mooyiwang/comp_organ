.data
	num: .word 200210231

.text

.macro push %a
	addi	sp, sp, -4
	sw	%a, 0(sp)
.end_macro

.macro pop %a
	lw	%a, 0(sp)
	addi	sp, sp, 4
.end_macro

Main: 

	lui	t0, 0x00002	#load the address of num
	lw	a6,0(t0)		#load num to reg(a6)
	add 	s3,zero,zero	#initial s3
	add	a0,a6,zero	#mv a0,a6
	jal 	ra,toHex		#subroutine
	
	# END 
	jal    zero, Done

#####
#function: Dec to Hex
#param : a0
#return : s3
#####
toHex:
	#push
	push ra
	push a5
	push a4
	push a1
	push a2
	push a3
	
	
	addi a5, zero, 16
	addi a4, zero, 0
	
	Loop:
		# div & rem
		divu	a1, a0, a5
		remu a2, a0, a5 
		slli	a3, a4, 2
		sll	a2, a2, a3
		# add digit
		add	s3, s3, a2
		addi	a4, a4, 1
		add	a0, a1, zero
		beq 	a0, zero, Ret	
		jal	zero, Loop
	Ret:
		# pop
		pop a3
		pop a2
		pop a1
		pop a4
		pop a5
		pop ra
		jalr zero,ra,0

Done:
	
