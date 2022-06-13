`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:00:06 11/15/2021 
// Design Name: 
// Module Name:    macro 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`define AND 3'b000
`define OR 3'b001
`define ADD 3'b010
`define SUB 3'b110
`define SLT 3'b111
`define Sign_EXT 1'b1
`define Zero_EXT 1'b0
`define two_bits_shift 2'b01
`define sixteen_bits_shift 2'b10
`define addu_func 6'b100001
`define subu_func 6'b100011
`define and_func 6'b100100
`define or_func 6'b100101
`define slt_func 6'b101010
`define jr_func 6'b001000
`define lw 6'b100011
`define sw 6'b101011
`define beq 6'b000100
`define Rtype 6'b000000
`define ori 6'b001101
`define lui 6'b001111
`define addi 6'b001000
`define j 6'b000010
`define jal 6'b000011
`define BeginAddr 32'h00003000