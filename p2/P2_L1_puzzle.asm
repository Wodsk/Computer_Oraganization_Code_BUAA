.data
puzzle: .space 196
# s0 = n, s1 = m, s2 = x of begin, s3 = y of begin, s4 = x of end, s5 = y of end, s6 = count

.macro cacu_addr(%dst, %row, %column, %rank)
mult %row, %rank
mflo %dst
add %dst, %dst, %column
sll %dst, %dst, 2
.end_macro 
.text
li $v0, 5
syscall
move $s0, $v0 # s0 = n
li $v0, 5
syscall
move $s1, $v0 # s1 = m

li $t0, 0 # t0 = i
input_1_begin:
slt $t1, $t0, $s0 # if i < n, t1 = 1, else t1 = 0
beq $t1, $0, input_1_end

li $t1, 0 # t1 = j
input_2_begin:
slt $t2, $t1, $s1 # if j < m, t2 = 1, else t2 = 0
beq $t2, $0, input_2_end
li $v0, 5
syscall
cacu_addr($t2, $t0, $t1, $s1)
sw $v0, puzzle($t2) # input puzzle[i][j]
addi $t1, $t1, 1 # j = j + 1
j input_2_begin

input_2_end:
addi $t0, $t0, 1 # i = i + 1
j input_1_begin

input_1_end:
li $v0, 5
syscall
move $s2, $v0 # s2 = x begin
li $v0, 5
syscall
move $s3, $v0 # s3 = y begin
li $v0, 5
syscall
move $s4, $v0 # s4 = x end
li $v0, 5
syscall
move $s5, $v0 # s5 = y end
subi $a0, $s2, 1 # a0 = x - 1
subi $a1, $s3, 1 # a1 = y - 1
jal DFS
move $a0, $s6
li $v0, 1
syscall
li $v0, 10
syscall

DFS: # a0 = x, a1 = y
subi $t0, $s4, 1 # t0 = x end - 1
bne $a0, $t0, if_up
subi $t0, $s5, 1 # t0 = y end - 1
bne $a1, $t0, if_up
addi $s6, $s6, 1 # count = count + 1
jr $ra # return

if_up:
subi $t0, $a0, 1 # t0 = x - 1
bltz $t0, if_down # if x - 1 < 0, then move to if_down
cacu_addr($t1, $t0, $a1, $s1)
lw $t0, puzzle($t1) # t0 = puzzle[x-1][y]
bne $t0, $0, if_down # if puzzle[x-1][y] != 0 ,then move to the if_down
cacu_addr($t0, $a0, $a1, $s1)
li $t1, 2
sw $t1, puzzle($t0) # puzzle[x][y] = 2

sw $ra, 0($sp) # store ra
subi $sp, $sp, 4
sw $a0, 0($sp) # store x
subi $sp, $sp, 4
sw $a1, 0($sp) # store y
subi $sp, $sp, 4
subi $a0, $a0, 1 # x -> x - 1
jal DFS # dfs(x - 1, y)
addi $sp, $sp, 4
lw $a1, 0($sp) # restore y
addi $sp, $sp, 4
lw $a0, 0($sp) # restore x
addi $sp, $sp, 4
lw $ra, 0($sp) # restore ra

cacu_addr($t0, $a0, $a1, $s1)
sw $0, puzzle($t0) # puzzle[x][y] = 0

if_down:
addi $t0, $a0, 1 # t0 = x + 1
sub $t1, $s0, $t0 # t1 = n - x - 1
blez $t1, if_right # if x - 1 >= n, then move to if_right
cacu_addr($t1, $t0, $a1, $s1)
lw $t0, puzzle($t1) # t0 = puzzle[x+1][y]
bne $t0, $0, if_right # if puzzle[x+1][y] != 0 ,then move to the if_right
cacu_addr($t0, $a0, $a1, $s1)
li $t1, 2
sw $t1, puzzle($t0) # puzzle[x][y] = 2

sw $ra, 0($sp) # store ra
subi $sp, $sp, 4
sw $a0, 0($sp) # store x
subi $sp, $sp, 4
sw $a1, 0($sp) # store y
subi $sp, $sp, 4
addi $a0, $a0, 1 # x -> x + 1
jal DFS # dfs(x + 1, y)
addi $sp, $sp, 4
lw $a1, 0($sp) # restore y
addi $sp, $sp, 4
lw $a0, 0($sp) # restore x
addi $sp, $sp, 4
lw $ra, 0($sp) # restore ra

cacu_addr($t0, $a0, $a1, $s1)
sw $0, puzzle($t0) # puzzle[x][y] = 0

if_right:
addi $t0, $a1, 1 # t0 = y + 1
sub $t1, $s1, $t0 # t1 = m - y - 1
blez $t1, if_left # if y - 1 >= m, then move to if_left
cacu_addr($t1, $a0, $t0, $s1)
lw $t0, puzzle($t1) # t0 = puzzle[x][y+1]
bne $t0, $0, if_left # if puzzle[x][y+1] != 0 ,then move to the if_left
cacu_addr($t0, $a0, $a1, $s1)
li $t1, 2
sw $t1, puzzle($t0) # puzzle[x][y] = 2

sw $ra, 0($sp) # store ra
subi $sp, $sp, 4
sw $a0, 0($sp) # store x
subi $sp, $sp, 4
sw $a1, 0($sp) # store y
subi $sp, $sp, 4
addi $a1, $a1, 1 # y -> y + 1
jal DFS # dfs(x, y + 1)
addi $sp, $sp, 4
lw $a1, 0($sp) # restore y
addi $sp, $sp, 4
lw $a0, 0($sp) # restore x
addi $sp, $sp, 4
lw $ra, 0($sp) # restore ra

cacu_addr($t0, $a0, $a1, $s1)
sw $0, puzzle($t0) # puzzle[x][y] = 0

if_left:
subi $t0, $a1, 1 # t0 = y - 1
bltz $t0, if_end # if y - 1 < 0, then move to if_end
cacu_addr($t1, $a0, $t0, $s1)
lw $t0, puzzle($t1) # t0 = puzzle[x][y-1]
bne $t0, $0, if_end # if puzzle[x][y-1] != 0 ,then move to the if_end
cacu_addr($t0, $a0, $a1, $s1)
li $t1, 2
sw $t1, puzzle($t0) # puzzle[x][y] = 2

sw $ra, 0($sp) # store ra
subi $sp, $sp, 4
sw $a0, 0($sp) # store x
subi $sp, $sp, 4
sw $a1, 0($sp) # store y
subi $sp, $sp, 4
subi $a1, $a1, 1 # y -> y - 1
jal DFS # dfs(x, y - 1)
addi $sp, $sp, 4
lw $a1, 0($sp) # restore y
addi $sp, $sp, 4
lw $a0, 0($sp) # restore x
addi $sp, $sp, 4
lw $ra, 0($sp) # restore ra

cacu_addr($t0, $a0, $a1, $s1)
sw $0, puzzle($t0) # puzzle[x][y] = 0

if_end:
jr $ra