`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:03:26 11/15/2021 
// Design Name: 
// Module Name:    Main_Decoder 
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
`include "macro.v"
module Main_Decoder(
    input [5:0] op,
    output [1:0] RegDst,
    output RegWrite,
    output ALUSrc,
    output Branch,
    output MemWrite,
    output [1:0] Memback,
	 output EXTop,
    output [1:0] ALUop,
	 output [1:0] Shiftop,
	 output Jump
    );
	 
	 assign RegDst[0] = (op == `Rtype) ? 1 : 0;
	 assign RegDst[1] = (op == `jal) ? 1 : 0;
	 assign RegWrite = (op == `ori)   ? 1 : 
	                   (op == `lw)    ? 1 :
							 (op == `lui)   ? 1 :
							 (op == `Rtype) ? 1 :
							 (op == `addi)  ? 1 :
							 (op == `jal)   ? 1 : 0;
	 assign ALUSrc	= (op == `lui)  ? 1 :
                    (op == `ori)  ? 1 :
                    (op == `sw)   ? 1 :
                    (op == `lw)   ? 1 :
                    (op == `addi) ? 1 : 0;
    assign Branch = (op == `beq) ? 1 : 0;
    assign MemWrite = (op == `sw) ? 1 : 0;
    assign Memback[0] = (op == `lw)  ? 1 : 0;
	 assign Memback[1] = (op == `jal) ? 1 : 0;
    assign EXTop = (op == `sw)   ? 1 : 
                   (op == `beq)  ? 1 :
                   (op == `lw)   ? 1 :
                   (op == `addi) ? 1 : 0;
    assign ALUop[1] = (op == `ori)   ? 1 :
                      (op == `Rtype) ? 1 : 0;
    assign ALUop[0] = (op == `beq)   ? 1 :
                      (op == `Rtype) ? 1 : 0;
	 assign Shiftop[0] = (op == `beq) ? 1 : 0;						 
    assign Shiftop[1] = (op == `lui) ? 1 : 0;
    assign Jump = (op == `j) ? 1 :
                  (op == `jal) ? 1 : 0;	 


endmodule
