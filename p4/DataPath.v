`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:03:18 11/19/2021 
// Design Name: 
// Module Name:    DataPath 
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
module DataPath(
    input reset,
	 input clk,
	 input EXTop,
	 input MemWrite,
	 input ALUSrc,
	 input RegWrite,
	 input [1:0] Shiftop,
	 input [1:0] Memback,
	 input [1:0] RegDst,
	 input [2:0] Move,
	 input [2:0] ALUControl,
	 output [31:0] instr
    );
	 
	 wire [31:0] PC,NPC,ext_imm, GRF_rs,Instr,RegData,MemData,RD1,RD2,ALUresult,RD,ALUB,MemAddr;
	 wire [25:0] instr_index;
	 wire [15:0] imm;
	 wire [4:0] rs,rt,rd,RegAddr;
	 wire [2:0] Cmp;
	 
	 assign instr_index = Instr[25:0];
	 assign rs = Instr[25:21];
	 assign rt = Instr[20:16];
	 assign rd = Instr[15:11];
	 assign imm = Instr[15:0];
	 assign GRF_rs = RD1;
	 assign MemData = RD2;
	 assign MemAddr = ALUresult;
	 
	 NPC npc(.PC(PC),.offset(ext_imm),.instr_index(instr_index),.GRF_rs(GRF_rs),.Move(Move),.Cmp(Cmp),.NPC(NPC));
	 IFU ifu(.clk(clk),.reset(reset),.NPC(NPC),.RD(Instr),.PC_out(PC));
	 
	 EXT ext(.imm(imm),.EXTop(EXTop),.Shiftop(Shiftop),.data(ext_imm));
	 
	 RAMUX ramux(.rt(rt),.rd(rd),.RegDst(RegDst),.RegAddr(RegAddr));
	 ALUMUX alumux(.RD2(RD2),.ext_imm(ext_imm),.ALUSrc(ALUSrc),.ALUB(ALUB));
	 RDMUX rdmux(.ALUresult(ALUresult),.DMresult(RD),.PC(PC),.Memback(Memback),.RegData(RegData));
    
	 GRF grf(.clk(clk),.reset(reset),.WE(RegWrite),.PC(PC),.A1(rs),.A2(rt),.A3(RegAddr),.WD(RegData),.RD1(RD1),.RD2(RD2));
	 ALU alu(.A(RD1),.B(ALUB),.Control(ALUControl),.data(ALUresult),.compare(Cmp));
	 DM dm(.clk(clk),.reset(reset),.PC(PC),.WE(MemWrite),.A(MemAddr),.WD(MemData),.data(RD));
	 
	 
    assign instr = Instr;
endmodule
