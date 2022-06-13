.data
string: .space 2000
.text
li $v0, 5
syscall
move $s0, $v0 # s0 = n
li $s1, 1 # s1 = len = 1
li $t0, 1
sw $t0, string($0) # string[0] = 1

li $t0, 2 # t0 = i
cacu_begin:
sub $t1, $t0, $s0 # t1 = i - n
bgtz $t1, cacu_end # if i > n, then move to end

li $t1, 0 # t1 = j
mult_begin:
slt $t2, $t1, $s1 # if j < len, t2 = 1, else t2 = 0
beq $t2, $0, mult_end
sll $t2, $t1, 2 # t2 = j * 4
lw $t3, string($t2) # t3 = string[j]
mult $t3, $t0
mflo $t3 # t3 = string[j] * i
sw $t3, string($t2) # string[i] = string[i] * i
addi $t1, $t1, 1 # j = j + 1
j mult_begin

mult_end:
li $t1, 0 # t1 = j
cin_begin:
slt $t2, $t1, $s1 # if j < len, t2 = 1, else t2 = 0
beq $t2, $0, cin_end
li $t2, 100
sll $t3, $t1, 2 # t3 = j * 4
lw $t4, string($t3) # t4 = string[j]
slt $t3, $t4, $t2 # if string[j] < 100 ,then t3 = 1,else t3 = 0
bne $t3, $0, else # if string[j] < 100, then move to else
subi $t2, $s1, 1 # t2 = len - 1
bne $t2, $t1, else_1 # if j != len - 1, then move to else_1
addi $s1, $s1, 1 # len = len + 1
else_1:
li $t2, 100
div $t4,$t2
mflo $t3 # t3 = string[j] / 100
mfhi $t4 # t4 = string[j] % 100
sll $t5, $t1, 2 # t5 = j * 4
addi $t6, $t5, 4 # t6 = (j + 1) * 4
sw $t4, string($t5) # string[j] = string[j] % 100
lw $t4, string($t6) # t4 = string[j+1]
add $t4, $t4, $t3 # t4 = string[j+1] = string[j+1] + string[j] / 100
sw $t4, string($t6)
else:
addi $t1, $t1, 1 # j = j + 1
j cin_begin

cin_end:
addi $t0, $t0, 1 # i = i + 1
j cacu_begin

cacu_end:
subi $t0, $s1, 1 # t0 = i = len - 1
out_begin:
bltz $t0, out_end # if i < 0 ,then move to out_end
subi $t1, $s1, 1 # t1 = len - 1
beq $t0, $t1, out_else # if i = len - 1, then move to out_else
li $t1, 10
sll $t2, $t0, 2 # t2 = i * 4
lw $t3, string($t2) # t3 = string[i]
slt $t2, $t3, $t1 # if string[i] < 10,then t2 = 1, else t2 = 0
beq $t2, $0, out_else # if string[i] >= 10, then move to out_else
li $a0, 0
li $v0, 1
syscall
out_else:
sll $t2, $t0, 2 # t2 = i * 4
lw $t3, string($t2) # t3 = string[i]
move $a0, $t3
li $v0, 1
syscall
subi $t0, $t0, 1 # i = i - 1
j out_begin

out_end:
li $v0, 10
syscall



  