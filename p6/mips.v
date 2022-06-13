`timescale 1ns / 1ps
module mips (
	input clk,
	input reset,
	input [31:0] i_inst_rdata,//IM取得的指�
    input [31:0] m_data_rdata,//DM取得的数�
    output [31:0] i_inst_addr,//IM取指对应的PC
    output [31:0] m_data_addr,//DM待写入地址
    output [31:0] m_data_wdata,//DM待写入数�
    output [3:0] m_data_byteen,//字节使能信号
    output [31:0] m_inst_addr,//M级PC(用于输出信息)
    output w_grf_we,//grf写使能信�
    output [4:0] w_grf_addr,//grf待写入寄存器编号
    output [31:0] w_grf_wdata,//grf待写入数�
    output [31:0] w_inst_addr//W级PC(用于输出信息)
	);
	
    //声明部分
	
	//F级输出信�
	wire [31:0] F_Instr, F_PC, F_PC8;
	//D级输出信�
	wire [31:0] D_Instr, D_PC, D_RegData, D_RD1, D_RD2, EXT_Imm;
	wire [25:0] D_Instr_index;
	wire [4:0] D_RegAddr, D_rs, D_rt;
	wire [2:0] D_Move;
	wire D_RegWrite, Stall;
	//E级输出信�
	wire [31:0] E_Instr, E_PC, E_RegData, E_FRegData, ALUResult, E_RD2;
	wire [4:0] E_RegAddr, E_rs, E_rt;
	wire E_RegWrite;
	wire [2:0] E_Tnew;
	wire E_Busy;
	//M级输出信�
	wire [31:0] M_Instr, M_PC, M_FRegData, M_RegData;
	wire [4:0] M_RegAddr, M_rt;
	wire M_RegWrite;
	wire [2:0] M_Tnew;
	//W级输出信�
	wire [31:0] W_Instr, W_PC, W_RegData, W_FRegData;
	wire [4:0] W_RegAddr;
	wire W_RegWrite;
	//回写控制器输出信�
	wire [2:0] NPCFMUXSrc, CMP1FMUXSrc, CMP2FMUXSrc, EAFMUXSrc, EBFMUXSrc, DMWDFMUXSrc;

    //各级部分连接
	F f(.clk(clk),
	    .reset(reset),
		.D_Enable(Stall),
		.D_PC(D_PC),
		.D_offset(EXT_Imm),
		.D_Instr_index(D_Instr_index),
		.D_GRF_rs(D_RD1),//传入的是经过转发后的GRF[rs]
		.D_Move(D_Move),
		.F_PC(F_PC),
		.F_PC8(F_PC8));
	
	assign i_inst_addr = F_PC;//给外置IM传入PC
	assign F_Instr = i_inst_rdata;//从外置的IM中取出指�

	D d(.clk(clk),
	    .reset(reset),
		.F_Instr(F_Instr),
		.F_PC(F_PC),
		.F_PC8(F_PC8),
		.W_RegWrite(w_grf_we),
		.W_RegAddr(w_grf_addr),
		.W_RegData(w_grf_wdata),
		.W_PC(w_inst_addr),
		.E_Busy(E_Busy),
		.E_Tnew(E_Tnew),
		.E_RegAddr(E_RegAddr),
		.E_FRegData(E_FRegData),
		.M_Tnew(M_Tnew),
		.M_RegAddr(M_RegAddr),
		.M_FRegData(M_FRegData),
		.CMP1FMUXSrc(CMP1FMUXSrc),
		.CMP2FMUXSrc(CMP2FMUXSrc),
		.D_Instr(D_Instr),
		.D_PC(D_PC),
		.D_RD1(D_RD1),
		.D_RD2(D_RD2),
		.EXT_Imm(EXT_Imm),
		.Instr_index(D_Instr_index),
		.D_Move(D_Move),
		.D_RegData(D_RegData),
		.D_RegAddr(D_RegAddr),
		.D_rs(D_rs),
		.D_rt(D_rt),
		.D_RegWrite(D_RegWrite),
		.Stall(Stall));

	E e(.clk(clk),
	    .reset(reset),
		.Stall(Stall),
		.EAFMUXSrc(EAFMUXSrc),
		.EBFMUXSrc(EBFMUXSrc),
		.D_Instr(D_Instr),
		.D_PC(D_PC),
		.D_RegData(D_RegData),
		.GRF_RD1(D_RD1),
		.GRF_RD2(D_RD2),
		.EXT_Imm(EXT_Imm),
		.D_RegAddr(D_RegAddr),
		.D_RegWrite(D_RegWrite),
		.M_FRegData(M_FRegData),
		.W_FRegData(W_FRegData),
		.E_Instr(E_Instr),
		.E_PC(E_PC),
		.E_RegData(E_RegData),
		.E_FRegData(E_FRegData),
		.ALUResult(ALUResult),
		.E_RD2(E_RD2),
		.E_RegAddr(E_RegAddr),
		.E_rs(E_rs),
		.E_rt(E_rt),
		.E_RegWrite(E_RegWrite),
		.E_Tnew(E_Tnew),
		.E_Busy(E_Busy));

	M m(.clk(clk),
	    .reset(reset),
		.temp_DMResult(m_data_rdata),
		.DMWDFMUXSrc(DMWDFMUXSrc),
		.E_Instr(E_Instr),
		.E_PC(E_PC),
		.E_RegData(E_RegData),
		.ALUResult(ALUResult),
		.E_RD2(E_RD2),
		.E_RegAddr(E_RegAddr),
		.E_RegWrite(E_RegWrite),
		.W_FRegData(W_FRegData),
		.DMWD(m_data_wdata),
		.DMWA(m_data_addr),
		.DM_byteen(m_data_byteen),
		.M_Instr(M_Instr),
		.M_PC(M_PC),
		.M_FRegData(M_FRegData),
		.M_RegData(M_RegData),
		.M_RegAddr(M_RegAddr),
		.M_rt(M_rt),
		.M_RegWrite(M_RegWrite),
		.M_Tnew(M_Tnew));

	assign 	m_inst_addr = M_PC;

	W w(.clk(clk),
	    .reset(reset),
		.M_Instr(M_Instr),
		.M_PC(M_PC),
		.M_RegData(M_RegData),
		.M_RegAddr(M_RegAddr),
		.M_RegWrite(M_RegWrite),
		.W_Instr(W_Instr),
		.W_PC(w_inst_addr),
		.W_RegData(w_grf_wdata),
		.W_FRegData(W_FRegData),
		.W_RegAddr(w_grf_addr),
		.W_RegWrite(w_grf_we));

   	Forward forward(.CMP1_ReadAddr(D_rs),
					.CMP2_ReadAddr(D_rt),
					.EA_ReadAddr(E_rs),
					.EB_ReadAddr(E_rt),
					.DMWD_ReadAddr(M_rt),
					.E_RegAddr(E_RegAddr),
					.E_RegWrite(E_RegWrite),
					.M_RegAddr(M_RegAddr),
					.M_RegWrite(M_RegWrite),
					.W_RegAddr(w_grf_addr),
					.W_RegWrite(w_grf_we),
					.CMP1FMUXSrc(CMP1FMUXSrc),
					.CMP2FMUXSrc(CMP2FMUXSrc),
					.EAFMUXSrc(EAFMUXSrc),
					.EBFMUXSrc(EBFMUXSrc),
					.DMWDFMUXSrc(DMWDFMUXSrc));	

endmodule