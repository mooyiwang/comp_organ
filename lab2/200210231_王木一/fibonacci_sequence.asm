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
	
	addi	a7, zero, 20	# n = 20
	add	a0, zero, a7 	# mv a0, a7
	add	s3, zero, zero
	addi	a1, zero, 1
	addi	a2, zero, 2
	jal	ra, Fibo
	
	# END
	jal 	zero, Done 
	
#####
#function: calculate fibonacci sequence
#param: a0
#return: s3
#####
Fibo:

	# push
	push ra
	push a4
	push a5
	push a0
	
	# a0(n) == 1 or 2?
	beq	a0, a1, Bound
	beq	a0, a2, Bound
	
	addi 	a0, a0, -1		
	jal	ra, Fibo
	add	a4, s3, zero	#a4 = fib(n-1)
	addi	a0, a0, -1
	jal	ra, Fibo
	add	a5, s3, zero	#a5 = fib(n-2)
	add 	s3, a4, a5		#fib(n) = fib(n-1)+fib(n-2)
	
	jal 	zero, Ret
	
	###
	#function bounds
	# return 1
	###
	Bound:
		addi s3, zero, 1
	
	Ret:
		#pop
		pop a0
		pop a5
		pop a4
		pop ra
		jalr	zero, ra, 0 

Done:
