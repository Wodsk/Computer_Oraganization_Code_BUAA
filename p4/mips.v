`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:31:25 11/15/2021 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
	 input reset
    );


    wire [31:0] Instr;
	 wire [5:0] op, funct;
	 wire [2:0] Move,ALUControl;
	 wire [1:0] Shiftop,Memback,RegDst;
	 wire EXTop,MemWrite,ALUSrc,RegWrite;
	 
	 assign op = Instr[31:26];
	 assign funct = Instr[5:0];
	 Control_Unit control_unit(.op(op),.funct(funct),.Move(Move),.Shiftop(Shiftop),.EXTop(EXTop),.Memback(Memback),.MemWrite(MemWrite),.ALUControl(ALUControl),.ALUSrc(ALUSrc),.RegWrite(RegWrite),.RegDst(RegDst));	 
    
	 DataPath datapath(.clk(clk),.reset(reset),.instr(Instr),.EXTop(EXTop),.MemWrite(MemWrite),.ALUSrc(ALUSrc),.RegWrite(RegWrite),.Shiftop(Shiftop),.Memback(Memback),.RegDst(RegDst),.Move(Move),.ALUControl(ALUControl));

endmodule
