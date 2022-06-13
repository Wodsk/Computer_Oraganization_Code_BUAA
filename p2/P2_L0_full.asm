.data
array: .space 28
symbol: .space 28
space: .asciiz " "
enter: .asciiz "\n"
.text
li $v0, 5
syscall
move $s0, $v0 # s0 = n
li $a1, 0 #a1 = index
jal FullArray # FullArray(0)
li $v0, 10
syscall

FullArray:
sub $t0, $a1, $s0 # t0 = index - n
bltz $t0, else # if index < n, then move to else

li $t0, 0 # t0 = i
out_loop_begin:
slt $t1, $t0, $s0 # if i < n, t1 = 1, else t1 = 0
beq $t1, $0, out_loop_end
sll $t2, $t0, 2 # t2 = i * 4
lw $a0, array($t2) # a0 = array[i]
li $v0, 1
syscall
la $a0, space
li $v0, 4
syscall
addi $t0, $t0, 1 # i = i + 1
j out_loop_begin

out_loop_end:
la $a0, enter
li $v0, 4
syscall
jr $ra

else:
li $t0, 0 # t0 = i
sort_begin:
slt $t1, $t0, $s0 # if i < n, t1 = 1, else t1 = 0
beq $t1, $0, sort_end
sll $t2, $t0, 2 # t2 = i * 4
lw $t1, symbol($t2) # t1 = symbol[i]
bne $t1, $0, else_1 # if symbol[i] != 0, jump the if
sll $t1, $a1, 2 # t1 = index * 4
addi $t2, $t0, 1 # t2 = i + 1
sw $t2, array($t1) # arrat[index] = i + 1
sll $t1, $t0, 2 # t1 = i * 4
li $t2, 1
sw $t2, symbol($t1) # symbol[i] = 1
sw $ra, 0($sp)
subi $sp, $sp, 4
sw $t0, 0($sp) # save i
subi $sp, $sp, 4
sw $a1, 0($sp) # save index
subi $sp, $sp, 4

addi $a1, $a1, 1 #index = index + 1
jal FullArray # FullArrray(index + 1)

addi $sp, $sp, 4
lw $a1, 0($sp) #load the index
addi $sp, $sp, 4
lw $t0, 0($sp) # load the i
addi $sp, $sp, 4
lw $ra, 0($sp) # load the ra
sll $t1, $t0, 2# t1 = i * 4
sw $0, symbol($t1) # symbol[i] = 0

else_1:
addi $t0, $t0, 1# i = i + 1
j sort_begin

sort_end:
jr $ra



