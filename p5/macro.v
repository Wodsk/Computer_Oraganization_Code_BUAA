`timescale 1ns / 1ps
//ALU内部选择信号的编码
`define AND 3'b000
`define OR 3'b001
`define ADD 3'b010
`define SUB 3'b110
`define SLT 3'b111
//EXT内部选择信号的编码
`define Sign_EXT 1'b1
`define Zero_EXT 1'b0
`define two_bits_shift 2'b01
`define sixteen_bits_shift 2'b10
//funct字段的编码
`define addu_func 6'b100001
`define subu_func 6'b100011
`define and_func 6'b100100
`define or_func 6'b100101
`define slt_func 6'b101010
`define jr_func 6'b001000
//op字段的编码
`define lw 6'b100011
`define sw 6'b101011
`define beq 6'b000100
`define Rtype 6'b000000
`define ori 6'b001101
`define lui 6'b001111
`define addi 6'b001000
`define j 6'b000010
`define jal 6'b000011
//PC初始地址的编码
`define BeginAddr 32'h00003000
//流水寄存器级数编码就是离D级的距离)
`define D_level 3'b000;
`define E_level 3'b001;
`define M_level 3'b010;
`define W_level 3'b011;
//三类指令在D级产生的Tnew
`define D_ALU_Tnew 3'b010
`define D_DM_Tnew 3'b011
//转发指令的优先级
`define origin 2'b00
`define M_Forward 2'b10
`define W_Forward 2'b01