`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:03:08 11/15/2021 
// Design Name: 
// Module Name:    Control_Unit 
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
module Control_Unit(
     input [5:0] op,
	  input [5:0] funct,
	  output [2:0] Move,
	  output [1:0] Shiftop,
	  output EXTop,
	  output [1:0] Memback,
	  output MemWrite,
	  output [2:0] ALUControl,
	  output ALUSrc,
	  output RegWrite,
	  output [1:0] RegDst
    ); 
    
	 wire [1:0] ALUop;

    Main_Decoder main_decoder(.op(op),.RegDst(RegDst),.RegWrite(RegWrite),.ALUSrc(ALUSrc),.MemWrite(MemWrite),.Memback(Memback),.EXTop(EXTop),.Shiftop(Shiftop),.Branch(Move[0]),.Jump(Move[1]),.ALUop(ALUop));
	 ALU_Decoder  alu_decoder(.funct(funct),.ALUop(ALUop),.ALUControl(ALUControl),.jr(Move[2]));
	 

endmodule
