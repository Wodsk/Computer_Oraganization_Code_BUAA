.data
string: .space 80
.text
li $v0, 5
syscall
move $a1, $v0 # a1 = n

li $t0, 0 # t0 = i
input_begin:
slt $t1, $t0, $a1 # if i < n, t1 = 1, else t1 = 0
beq $t1, $0, input_end
li $v0, 12
syscall
move $t2, $v0 # t2 is the input character
sll $t3, $t0, 2 # t3 = i * 4
sw $t2, string($t3)
addi $t0, $t0, 1 # i = i + 1
j input_begin

input_end:
li $t0, 0 # t0 = i
li $t1, 2
div $a1, $t1
mflo $t1 # t1 = n/2
cacu_begin:
slt $t2, $t0, $t1 # if i < n/2, t2 = 1, else t2 = 0
beq $t2, $0, cacu_end
subi $t3, $a1, 1 # t3 = n - 1
sub $t4, $t3, $t0 # t4 = n - i - 1
sll $t5, $t0, 2 # t5 = i * 4
sll $t6, $t4, 2 # t4 = (n - i - 1) * 4
lw $t7, string($t5)
lw $t8, string($t6)
bne $t7, $t8, irr_end
addi $t0, $t0, 1 # i = i + 1
j cacu_begin

cacu_end:
li $a0, 1
li $v0, 1
syscall
li $v0, 10
syscall

irr_end:
li $a0, 0
li $v0, 1
syscall
li $v0, 10
syscall