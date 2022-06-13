`timescale 1ns / 1ps
module mips (
	input clk,
	input reset);
	
    //声明部分
	
	//F级输出信�
	wire [31:0] F_Instr, F_PC, F_PC8;
	//D级输出信�
	wire [31:0] D_Instr, D_PC, D_PC8, CMP_RD1, CMP_RD2, EXT_Imm;
	wire [25:0] D_Instr_index;
	wire [4:0] D_RegAddr, D_rs;
	wire [2:0] D_Move, D_Cmp;
	wire D_RegWrite, Stall;
	//E级输出信�
	wire [31:0] E_Instr, E_PC, E_PC8, ALUResult, E_RD2;
	wire [4:0] E_RegAddr;
	wire E_RegWrite;
	wire [2:0] E_Tnew;
	//M级输出信�
	wire [31:0] M_Instr, M_PC, M_PC8, M_RegData;
	wire [4:0] M_RegAddr;
	wire M_RegWrite;
	wire [2:0] M_Tnew;
	//W级输出信�
	wire [31:0] W_Instr, W_PC, W_RegData;
	wire [4:0] W_RegAddr;
	wire W_RegWrite;

    //各级部分连接
	F f(.clk(clk),
	    .reset(reset),
		.D_Enable(Stall),
		.D_PC(D_PC),
		.D_offset(EXT_Imm),
		.D_Instr_index(D_Instr_index),
		.D_GRF_rs(CMP_RD1),//传入的是经过转发后的GRF[rs]
		.D_rs(D_rs),
		.D_Cmp(D_Cmp),
		.D_Move(D_Move),
		.M_RegData(M_RegData),
		.M_RegAddr(M_RegAddr),
		.M_RegWrite(M_RegWrite),
		.F_Instr(F_Instr),
		.F_PC(F_PC),
		.F_PC8(F_PC8));

	D d(.clk(clk),
	    .reset(reset),
		.F_Instr(F_Instr),
		.F_PC(F_PC),
		.F_PC8(F_PC8),
		.W_RegWrite(W_RegWrite),
		.W_RegAddr(W_RegAddr),
		.W_RegData(W_RegData),
		.W_PC(W_PC),
		.E_Tnew(E_Tnew),
		.E_RegAddr(E_RegAddr),
		.M_RegWrite(M_RegWrite),
		.M_Tnew(M_Tnew),
		.M_RegAddr(M_RegAddr),
		.M_RegData(M_RegData),
		.D_Instr(D_Instr),
		.D_PC(D_PC),
		.D_PC8(D_PC8),
		.CMP_RD1(CMP_RD1),
		.CMP_RD2(CMP_RD2),
		.EXT_Imm(EXT_Imm),
		.Instr_index(D_Instr_index),
		.Cmp(D_Cmp),
		.Move(D_Move),
		.D_RegAddr(D_RegAddr),
		.D_rs(D_rs),
		.D_RegWrite(D_RegWrite),
		.Stall(Stall));

	E e(.clk(clk),
	    .reset(reset),
		.Stall(Stall),
		.D_Instr(D_Instr),
		.D_PC(D_PC),
		.D_PC8(D_PC8),
		.GRF_RD1(CMP_RD1),
		.GRF_RD2(CMP_RD2),
		.EXT_Imm(EXT_Imm),
		.D_RegAddr(D_RegAddr),
		.D_RegWrite(D_RegWrite),
		.M_RegData(M_RegData),
		.M_RegAddr(M_RegAddr),
		.M_RegWrite(M_RegWrite),
		.W_RegData(W_RegData),
		.W_RegAddr(W_RegAddr),
		.W_RegWrite(W_RegWrite),
		.E_Instr(E_Instr),
		.E_PC(E_PC),
		.E_PC8(E_PC8),
		.ALUResult(ALUResult),
		.E_RD2(E_RD2),
		.E_RegAddr(E_RegAddr),
		.E_RegWrite(E_RegWrite),
		.E_Tnew(E_Tnew));

	M m(.clk(clk),
	    .reset(reset),
		.E_Instr(E_Instr),
		.E_PC(E_PC),
		.E_PC8(E_PC8),
		.ALUResult(ALUResult),
		.E_RD2(E_RD2),
		.E_RegAddr(E_RegAddr),
		.E_RegWrite(E_RegWrite),
		.W_RegData(W_RegData),
		.W_RegAddr(W_RegAddr),
		.W_RegWrite(W_RegWrite),
		.M_Instr(M_Instr),
		.M_PC(M_PC),
		.M_PC8(M_PC8),
		.M_RegData(M_RegData),
		.M_RegAddr(M_RegAddr),
		.M_RegWrite(M_RegWrite),
		.M_Tnew(M_Tnew));

	W w(.clk(clk),
	    .reset(reset),
		.M_Instr(M_Instr),
		.M_PC(M_PC),
		.M_RegData(M_RegData),
		.M_RegAddr(M_RegAddr),
		.M_RegWrite(M_RegWrite),
		.W_Instr(W_Instr),
		.W_PC(W_PC),
		.W_RegData(W_RegData),
		.W_RegAddr(W_RegAddr),
		.W_RegWrite(W_RegWrite));

endmodule