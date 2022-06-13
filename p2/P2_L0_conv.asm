.data
matrix: .space 400
matrix_in: .space 400
space: .asciiz " "
enter: .asciiz "\n"
.macro cacu_addr(%dst, %row, %column, %rank)
      mult %row, %rank
      mflo %dst
      add %dst, %dst, %column
      sll %dst, %dst, 2
.end_macro 
.text 
li $v0, 5
syscall
move $s0, $v0 # s0 = m1
li $v0, 5
syscall
move $s1, $v0 # s1 = n1
li $v0, 5
syscall
move $s2, $v0 # s2 = m2
li $v0, 5
syscall
move $s3, $v0 # s3 = n2

li $t0, 0 # t0 = i
input1_begin:
slt $t1, $t0, $s0 # if i < m1 , t1 = 1, else t1 = 0
beq $t1, $0, input1_end

li $t2, 0 # t2 = j
inner1_begin:
slt $t3, $t2, $s1 # if j < n1, t3 = 1, else t3 = 0
beq $t3, $0, inner1_end
li $v0, 5
syscall
cacu_addr($t4, $t0, $t2, $s1)
sw $v0, matrix($t4) # save the data in the matrix[i][j]
addi $t2, $t2, 1 # j = j + 1
j inner1_begin

inner1_end:
addi $t0, $t0, 1# i = i + 1
j input1_begin

input1_end:
li $t0, 0 # t0 = i
input2_begin:
slt $t1, $t0, $s2 # if i < m2 , t1 = 1, else t1 = 0
beq $t1, $0, input2_end

li $t2, 0 # t2 = j
inner2_begin:
slt $t3, $t2, $s3 # if j < n2, t3 = 1, else t3 = 0
beq $t3, $0, inner2_end
li $v0, 5
syscall
cacu_addr($t4, $t0, $t2, $s3)
sw $v0, matrix_in($t4) # save the data in the matrix_in[i][j]
addi $t2, $t2, 1 # j = j + 1
j inner2_begin

inner2_end:
addi $t0, $t0, 1# i = i + 1
j input2_begin

input2_end:
sub $s4, $s0, $s2
addi $s4, $s4, 1 # s4 = m1 - m2 + 1
sub $s5, $s1, $s3
addi $s5, $s5, 1 # s5 = n1 - n2 + 1
li $t1, 0 # t1 = i

cacu_0_begin:
slt $t0, $t1, $s4 # if i < m1 - m2 + 1 , t0 = 1, else t0 = 0
beq $t0, $0, cacu_0_end

li $t2, 0 # t2 = j
cacu_1_begin:
slt $t0, $t2, $s5 # if j < n1 - n2 + 1 , t0 = 1, else t0 = 0
beq $t0, $0, cacu_1_end

li $s6, 0 # s6 is the data to output

li $t3, 0 # t3 = k
cacu_2_begin:
slt $t0, $t3, $s2 # if k < m2 , t0 = 1, else t0 = 0
beq $t0, $0, cacu_2_end

li $t4 0 # t4 = l
cacu_3_begin:
slt $t0, $t4, $s3 # if l < n2, t0 = 1, else t0 = 0
beq $t0, $0, cacu_3_end
add $t5, $t1, $t3 # t5 = i + k
add $t6, $t2, $t4 # t6 = j + l
cacu_addr($t7, $t5, $t6, $s1)
lw $t5, matrix($t7) # t5 = f(i + k, j + l)
cacu_addr($t7, $t3, $t4, $s3)
lw $t6, matrix_in($t7) # t6 = h(k, l)
mult $t5, $t6
mflo $t5 # t5 = f(i + k, j + l) * h(k, l)
add $s6, $s6, $t5
addi $t4, $t4, 1 # l = l + 1
j cacu_3_begin

cacu_3_end:
addi $t3, $t3, 1 # k = k + 1
j cacu_2_begin

cacu_2_end:
move $a0, $s6
li $v0, 1 
syscall
la $a0, space
li $v0, 4
syscall
addi $t2, $t2, 1 # j = j + 1
j cacu_1_begin

cacu_1_end:
la $a0, enter
li $v0, 4
syscall
addi $t1, $t1, 1 # i = i + 1
j cacu_0_begin

cacu_0_end:
li $v0, 10
syscall



      