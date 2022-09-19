	.file	"lab1.c"
	.option nopic
	.attribute arch, "rv64i2p0_m2p0_a2p0_f2p0_d2p0_c2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata
	.align	3
.LC1:
	.string	"%d\n"
	.align	3
.LC0:
	.word	0
	.word	0
	.word	0
	.word	1
	.word	1
	.word	1
	.word	1
	.word	1
	.text
	.align	1
	.globl	cube
	.type	cube, @function
cube:
	addi	sp,sp,-80		# 设置栈指针：sp = sp + (-80),设置栈指针sp，将栈指针寄存器sp与立即数-80相加，再写入sp
	sd	ra,72(sp)		# 入栈：将返回地址ra寄存器中的值存入存入地址为R[sp]+72的内存中
	sd	s0,64(sp)		# 入栈：将s0寄存器中的值存入存入地址为R[sp]+64的内存中
	addi	s0,sp,80		# s0 = sp + 80,栈指针寄存器sp与立即数80相加，再存入s0,即s0的值为起始sp的值
	lui	a5,%hi(.LC0)		# 加载数组地址：a5 = 0 + %hi(.LC0),将.LC0标志高20位地址加到a5，
	addi	a5,a5,%lo(.LC0)		# 加载数组地址：a5 = a5 + %lo(.LC0),.LC0标低12位地址加到a5，写入a5
	ld	a2,0(a5)		# 取double数：将数组第0,1个数写入a2
	ld	a3,8(a5)		# 取double数：将数组第2,3个数写入a3
	ld	a4,16(a5)		# 取double数：将数组第4,5个数写入a4
	ld	a5,24(a5)		# 取double数：将数组第6,7个数写入a5
	sd	a2,-72(s0)		# 存double数：将a2寄存器中的数存入地址为R[s0]-72的内存中
	sd	a3,-64(s0)		# 存double数：将a3寄存器中的数存入地址为R[s0]-64的内存中
	sd	a4,-56(s0)		# 存double数：将a4寄存器中的数存入地址为R[s0]-56的内存中
	sd	a5,-48(s0)		# 存double数：将a5寄存器中的数存入地址为R[s0]-48的内存中
	sw	zero,-20(s0)		# 存word数：将数0存入地址为R[s0]-20的内存中
	sw	zero,-24(s0)		# 存word数：将数0存入地址为R[s0]-24的内存中
	li	a5,8192			# 加载立即数：a5 = 8192，将立即数8192写入a5
	addi	a5,a5,-256		# 加立即数：a5 = a5 + (-256), 将a5与立即数-256相加（得0b0001111100000000），再写入a5
	sw	a5,-36(s0)		# 存word数：将a5寄存器的值（8192-256）存入地址为R[s0]-36的内存中
	li	a5,7			# 加载立即数：a5 = 7，将7写入a5
	sw	a5,-28(s0)		# 存word数：将a5寄存器的值（7）存入地址为R[s0]-28的内存中
	j	.L2			# 无条件跳转：直接跳转到.L2标志，未存返回地址
.L4:
	lw	a5,-28(s0)		# 取word数：将存储在地址R[s0]-28的内存中数取出，写入a5
	slli	a5,a5,2			# 立即数逻辑左移：a5 = a5 << 2,将a5中的数逻辑左移2位，写入a5
	addi	a4,s0,-16		# 加立即数：a4 = s0 + (-16),将s0中的值与立即数-16相加，写入a4
	add	a5,a4,a5		# 加：a5 = a4 + a5,将a4中的值与a5中的值相加，写入a5
	lw	a5,-56(a5)		# 取word数，将存储在地址R[a5]-56的内存中数取出，存入a5
	beq	a5,zero,.L3		# 分支：若a5中的数等于0，就跳转到.L3
	lw	a4,-24(s0)		# 取word数：将存储在地址R[s0]-24的内存中数取出，写入a4
	lw	a5,-36(s0)		# 取word数：将存储在地址R[s0]-36的内存中数取出，写入a5
	addw	a5,a4,a5		# word加：a5 = a4 + a5,将a4中的值与a5中的值相加，结果截断为32位，写入a5 （原码一位乘的相加）
	sw	a5,-24(s0)		# 存word数：将a5寄存器的值存入地址为R[s0]-24的内存中
.L3:
	lw	a5,-24(s0)		# 取word数：将存储在地址R[s0]-24的内存中数取出，写入a5
	sraiw	a5,a5,1			# 立即数算术右移word：将a5中的值算术右移1位，结果截断32位，写入a5（原码一位乘的右移）
	sw	a5,-24(s0)		# 存word数：将a5寄存器的值存入地址为R[s0]-24的内存中
	lw	a5,-28(s0)		# 取word数：将存储在地址R[s0]-28的内存中数取出，写入a5
	addiw	a5,a5,-1		# 加立即数word：a5 = a5 + （-1），将a5与立即数-1相加，结果截断32位，再写入a5（for循环i的更新）
	sw	a5,-28(s0)		# 存word数：将a5寄存器的值存入地址为R[s0]-28的内存中
.L2:
	lw	a5,-28(s0)		# 取word数：将存储在R[s0]-28的内存中数取出，写入a5
	sext.w	a5,a5			# word数符号扩展：将a5中的数符号扩展到64位.写入a5
	bge	a5,zero,.L4		# 分支：若a5中的数大于等于0，就跳转到.L4
	lw	a5,-24(s0)		# 取word数：将存储在地址R[s0]-24的内存中数取出，写入a5
	slliw	a5,a5,8			# 立即数逻辑左移word：将a5中的值算术左移8位，结果截断32位，写入a5
	sw	a5,-24(s0)		# 存word数：将a5寄存器的值存入地址为R[s0]-24的内存中
	li	a5,7			# 加载立即数：a5 = 7，将立即数7写入a5
	sw	a5,-32(s0)		# 存word数：将a5寄存器的值存入地址为R[s0]-32的内存中
	j	.L5			# 无条件跳转：直接跳转到.L5标志，未存返回地址
.L7:
	lw	a5,-32(s0)		# 取word数：将存储在地址R[s0]-32的内存中数取出，写入a5	
	slli	a5,a5,2			# 立即数逻辑左移：a5 = a5 << 2,将a5中的数逻辑左移2位，写入a5
	addi	a4,s0,-16		# 加立即数：a4 = s0 + （-16），将s0与立即数-16相加，再写入a4
	add	a5,a4,a5		# 加：a5 = a4 + a5,将a4中的值与a5中的值相加，写入a5
	lw	a5,-56(a5)		# 取word数，将存储在地址R[a5]-56的内存中数取出，存入a5
	beq	a5,zero,.L6		# 分支：若a5中的数等于0，就跳转到.L6
	lw	a4,-20(s0)		# 取word数：将存储在地址R[s0]-20的内存中数取出，写入a4
	lw	a5,-24(s0)		# 取word数：将存储在地址R[s0]-24的内存中数取出，写入a5
	addw	a5,a4,a5		# word加：a5 = a4 + a5,将a4中的值与a5中的值相加，结果截断为32位，写入a5（原码一位乘的相加）
	sw	a5,-20(s0)		# 存word数：将a5寄存器的值存入地址为R[s0]-24的内存中
.L6:
	lw	a5,-20(s0)		# 取word数：将存储在地址R[s0]-20的内存中数取出，写入a5
	sraiw	a5,a5,1			# 立即数算术右移word：将a5中的值算术右移1位，写入a5（原码一位乘的右移）
	sw	a5,-20(s0)		# 存word数：将a5寄存器的值存入地址为R[s0]-20的内存中
	lw	a5,-32(s0)		# 取word数：将存储在地址R[s0]-32的内存中数取出，写入a5
	addiw	a5,a5,-1		# 加立即数word：a5 = a5 + （-1），将a5与立即数-1相加，结果截断32位，再写入a5（for循环i的更新）
	sw	a5,-32(s0)		# 存word数：将a5寄存器的值存入地址为R[s0]-32的内存中
.L5:
	lw	a5,-32(s0)		# 取word数：将存储在地址R[s0]-32的内存中数取出，写入a5		
	sext.w	a5,a5			# word数符号扩展：将a5中的数符号扩展到64位,写入a5
	bge	a5,zero,.L7		# 分支：若a5中的数大于等于0，就跳转到.L7
	lw	a5,-20(s0)		# 存word数：将a5寄存器的值存入地址为R[s0]-20的内存中
	mv	a1,a5			# 复制数：a1 = a5, 将a5的值写入a1
	lui	a5,%hi(.LC1)		# a5 = 0 + %hi(.LC1),将.LC1标志高20位地址加到a5
	addi	a0,a5,%lo(.LC1)		# a0 = a5 + %lo(.LC1),.LC1标低12位地址加到a5，写入a0
	call	printf			# 跳转执行printf函数，打印立方值
	nop				# 无操作
	ld	ra,72(sp)		# 出栈：取出原来的返回地址到ra
	ld	s0,64(sp)		# 出栈：取出原来的s0寄存器值到s0
	addi	sp,sp,80		# 恢复栈指针：sp = sp + 80,恢复栈指针sp
	jr	ra			# 无条件跳转：跳转到ra中存的地址
	.size	cube, .-cube
	.section	.rodata
	.align	3
.LC2:
	.string	"my ID:200210231"	
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-16		# 设置栈指针：sp = sp + (-16),将栈指针寄存器sp与立即数-16相加，再写入sp
	sd	ra,8(sp)	  	# 入栈：将返回地址，即ra中的值存入地址为R[sp]+8的内存中
	sd	s0,0(sp)	  	# 入栈：将s0寄存器中的值存入地址为R[sp]+0的内存中
	addi	s0,sp,16	 	# s0 = sp + 16,栈指针寄存器sp与立即数16相加，再写入s0,即s0的值为起始sp的值
	lui	a5,%hi(.LC2)	  	# a5 = 0 + %hi(.LC2),将.LC2标志高20位地址加到a5
	addi	a0,a5,%lo(.LC2)  	# a0 = a5 + %lo(.LC2),.LC2标低12位地址加到a5，写入a0
	call	puts		  	# 跳转执行puts函数，打印学号 
	call	cube		  	# 跳转执行cube函数，计算31的立方
	li	a5,0		  	# 加载立即数：a5 = 0,将0加载到a5寄存器 
	mv	a0,a5		  	# 复制数：a0 = a5, 将a5的值写入a0
	ld	ra,8(sp)	  	# 出栈：取出原来的返回地址到ra
	ld	s0,0(sp)	  	# 出栈：取出原来的s0寄存器值到s0
	addi	sp,sp,16	  	# 恢复栈指针：sp = sp + 16,恢复栈指针sp
	jr	ra		  	# 返回：跳转到ra寄存器指示的地址，即返回
	.size	main, .-main
	.ident	"GCC: (GNU) 9.2.0"
