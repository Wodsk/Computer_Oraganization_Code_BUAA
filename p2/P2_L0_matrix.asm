.data 
matrix1: .space 256
matrix2: .space 256
space: .asciiz  " "
enter: .asciiz  "\n"

.macro calc_addr(%dst, %row, %column, %rank)
       # dst: the register to save the address
       # row: the row of the data
       # column: the column of the data
       # rank: the whole numbers of lines that the matrix has
       mult %row, %rank
       mflo %dst
       add %dst, %dst, %column
       sll %dst, %dst, 2
.end_macro

.text
li $v0, 5
syscall
move $a1, $v0 # a1 == n
li $t0 0 # t0 == i

input1_begin:
slt $t1, $t0, $a1 # if i < n ,t1 = 1, else t1 = 0
beq $t1, $0, input1_end # if t1 = 0, jump to input1_end

li $t2 0 # t2 == j
inner_loop1:
slt $t3, $t2, $a1 # if j < n, t3 = 1, else t3 = 0
beq $t3, $0, inner_loop1_end
li $v0, 5
syscall
move $t4, $v0 # t4 is the input data
calc_addr($t5, $t0, $t2, $a1) # t5 is the addr to save the data
sw $t4, matrix1($t5)
addi $t2, $t2, 1 # j = j + 1
j inner_loop1

inner_loop1_end:
addi $t0, $t0, 1 # i = i + 1
j input1_begin

input1_end:
li $t0 0 # t0 == i
input2_begin:
slt $t1, $t0, $a1 # if i < n ,t1 = 1, else t1 = 0
beq $t1, $0, input2_end # if t1 = 0, jump to input1_end

li $t2 0 # t2 == j
inner_loop2:
slt $t3, $t2, $a1 # if j < n, t3 = 1, else t3 = 0
beq $t3, $0, inner_loop2_end
li $v0, 5
syscall
move $t4, $v0 # t4 is the input data
calc_addr($t5, $t0, $t2, $a1) # t5 is the addr to save the data
sw $t4, matrix2($t5)
addi $t2, $t2, 1 # j = j + 1
j inner_loop2

inner_loop2_end:
addi $t0, $t0, 1 # i = i + 1
j input2_begin

input2_end:
li $t0 0 # t0 = i
output_begin:
slt $t1, $t0, $a1 # if i < n, t1 = 1, else t1 = 0
beq $t1, $0, output_end

li $t2 0 # t2 = j
in_loop_begin:
slt $t3, $t2, $a1 # if j < n, t3 = 1, else t3 = 0;
beq $t3, $0, in_loop_end

li $t4, 0 # t4 = k
li $a0 0 # a0 is the data to save
cacu_loop_begin:
slt $t5, $t4, $a1 # if k < n, t5 = 1, else t5 = 0
beq $t5, $0, cacu_loop_end
calc_addr($t6, $t0, $t4, $a1)
lw $t7, matrix1($t6) # t7 is element in first matrix
calc_addr($t6, $t4, $t2, $a1)
lw $t8, matrix2($t6) #t8 is the element in second matrix
mult $t7, $t8
mflo $t9 # t9 is element in result matrix
add $a0, $a0, $t9
addi $t4, $t4, 1 # k = k + 1
j cacu_loop_begin

cacu_loop_end:
li $v0, 1
syscall
la $a0, space
li $v0, 4
syscall
addi $t2, $t2, 1 # j = j + 1
j in_loop_begin

in_loop_end:
la $a0, enter
li $v0, 4
syscall
addi $t0, $t0, 1 # i = i + 1
j output_begin

output_end:
li $v0, 10
syscall 






