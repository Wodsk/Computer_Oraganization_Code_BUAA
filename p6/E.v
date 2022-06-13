`timescale 1ns / 1ps
`include "macro.v"
module E (
    input clk,
    input reset,
    input Stall,
    //回写控制信息
    input [2:0] EAFMUXSrc,
    input [2:0] EBFMUXSrc,
    //D级信�
    input [31:0] D_Instr,
    input [31:0] D_PC,
    input [31:0] D_RegData,
    input [31:0] GRF_RD1,//经过D级的转发但未经过E级转�
    input [31:0] GRF_RD2,//经过D级的转发但未经过E级转�
    input [31:0] EXT_Imm,
    input [4:0] D_RegAddr,
    input D_RegWrite,
    //M级信�
    input [31:0] M_FRegData,
    //W级信�
    input [31:0] W_FRegData,
    //输出信息
    output [31:0] E_Instr,
    output [31:0] E_PC,
    output [31:0] E_RegData,
    output [31:0] E_FRegData,//专门进行转发的数�
    output [31:0] ALUResult,
    output [31:0] E_RD2,//经过了E级的转发
    output [4:0] E_RegAddr,
	 output [4:0] E_rs,
	 output [4:0] E_rt,
    output E_RegWrite,
    output [2:0] E_Tnew,
    output E_Busy);
    
    //声明部分
    wire [31:0] E_RD1/*只有转发*/, ALUB/*既有转发还有与立即数的选择*/, E_EXT_Imm, E_GRF_RD1, E_GRF_RD2, HI, LO;
    wire [4:0] ALUop, s;
    wire [3:0] E_RDMUXSrc;
    wire [2:0] MADop;
    wire [1:0] AMFSrc, BMFSrc;
    wire ALUSrc, Start, Busy;
    parameter [2:0] level = `E_level;

    //数据通路部分(寄存器读出的才是本级可以使用的信�
    E_register e_register(.clk(clk),
                        .reset(reset || Stall),
                        .D_Instr(D_Instr),
                        .D_PC(D_PC),
                        .D_RegData(D_RegData),
                        .GRF_RD1(GRF_RD1),
                        .GRF_RD2(GRF_RD2),
                        .EXT_Imm(EXT_Imm),
                        .RegAddr(D_RegAddr), 
                        .RegWrite(D_RegWrite),
                        .E_Instr(E_Instr),
                        .E_PC(E_PC),
                        .E_FRegData(E_FRegData),
                        .E_GRF_RD1(E_GRF_RD1),
                        .E_GRF_RD2(E_GRF_RD2),
                        .E_EXT_Imm(E_EXT_Imm),
                        .E_RegWrite(E_RegWrite),
                        .E_RegAddr(E_RegAddr));
    
    ALU alu(.A(E_RD1),
            .B(ALUB),
	    .s(s),
            .ALUop(ALUop),
            .data(ALUResult));

    ALUMUX alumux(.RD2(E_RD2),
                  .EXT_Imm(E_EXT_Imm),
                  .ALUSrc(ALUSrc),
                  .ALUB(ALUB));
    
    MAD mad(.clk(clk),
            .reset(reset),
            .A(E_RD1),
            .B(E_RD2),
            .MADop(MADop),
            .HI(HI),
            .LO(LO),
            .Busy(Busy));
    
    assign E_Busy = Busy | Start;
    
    FMUX EAFMUX(.Origin(E_GRF_RD1),
                  .M_FRegData(M_FRegData),
                  .W_FRegData(W_FRegData),
                  .FMUXSrc(EAFMUXSrc),
                  .RD(E_RD1));
    
    FMUX EBFMUX(.Origin(E_GRF_RD2),
                  .M_FRegData(M_FRegData),
                  .W_FRegData(W_FRegData),
                  .FMUXSrc(EBFMUXSrc),
                  .RD(E_RD2));
    
    RDMUX E_RDMUX(.ALUResult(ALUResult),
                  .HI(HI),
                  .LO(LO),
                  .Front_RegData(E_FRegData),
                  .RDMUXSrc(E_RDMUXSrc),
                  .RegData(E_RegData));

    //控制信号部分
    Control_Unit E_control_unit(.Instr(E_Instr),
                                .State(level),
                                .rs(E_rs),
                                .rt(E_rt),
	                        .s(s),
                                .ALUSrc(ALUSrc),
                                .ALUop(ALUop),
                                .Start(Start),
                                .MADop(MADop),
				.E_RDMUXSrc(E_RDMUXSrc),
                                .Tnew(E_Tnew));
endmodule
