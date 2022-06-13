`timescale 1ns / 1ps
`include "macro.v"
module E (
    input clk,
    input reset,
    input Stall,
    //D级信�
    input [31:0] D_Instr,
    input [31:0] D_PC,
    input [31:0] D_PC8,
    input [31:0] GRF_RD1,//经过D级的转发但未经过E级转�
    input [31:0] GRF_RD2,//经过D级的转发但未经过E级转�
    input [31:0] EXT_Imm,
    input [4:0] D_RegAddr,
    input D_RegWrite,
    //M级信�
    input [31:0] M_RegData,
    input [4:0] M_RegAddr,
    input M_RegWrite,
    //W级信�
    input [31:0] W_RegData,
    input [4:0] W_RegAddr,
    input W_RegWrite,
    //输出信息
    output [31:0] E_Instr,
    output [31:0] E_PC,
    output [31:0] E_PC8,
    output [31:0] ALUResult,
    output [31:0] E_RD2,//经过了E级的转发
    output [4:0] E_RegAddr,
    output E_RegWrite,
    output [2:0] E_Tnew);
    
    //声明部分
    wire [31:0] E_RD1/*只有转发*/, ALUB/*既有转发还有与立即数的选择*/, E_EXT_Imm, E_GRF_RD1, E_GRF_RD2;
    wire [4:0] E_rs, E_rt;
    wire [2:0] ALUop;
    wire [1:0] AMFSrc, BMFSrc;
    wire ALUSrc;
    parameter [2:0] level = `E_level;

    //数据通路部分(寄存器读出的才是本级可以使用的信�
    E_register e_register(.clk(clk),
                        .reset(reset || Stall),
                        .D_Instr(D_Instr),
                        .D_PC(D_PC),
                        .D_PC8(D_PC8),
                        .GRF_RD1(GRF_RD1),
                        .GRF_RD2(GRF_RD2),
                        .EXT_Imm(EXT_Imm),
                        .RegAddr(D_RegAddr), 
                        .RegWrite(D_RegWrite),
                        .E_Instr(E_Instr),
                        .E_PC(E_PC),
                        .E_PC8(E_PC8),
                        .E_GRF_RD1(E_GRF_RD1),
                        .E_GRF_RD2(E_GRF_RD2),
                        .E_EXT_Imm(E_EXT_Imm),
                        .E_RegWrite(E_RegWrite),
                        .E_RegAddr(E_RegAddr));
    
    ALU alu(.A(E_RD1),
            .B(ALUB),
            .ALUop(ALUop),
            .data(ALUResult));

    ALUMUX alumux(.RD2(E_RD2),
                  .EXT_Imm(E_EXT_Imm),
                  .ALUSrc(ALUSrc),
                  .ALUB(ALUB));
    
    FMUX ALUAFMUX(.Origin(E_GRF_RD1),
                  .M_RegData(M_RegData),
                  .W_RegData(W_RegData),
                  .FMUXSrc(AMFSrc),
                  .RD(E_RD1));
    
    FMUX ALUBFMUX(.Origin(E_GRF_RD2),
                  .M_RegData(M_RegData),
                  .W_RegData(W_RegData),
                  .FMUXSrc(BMFSrc),
                  .RD(E_RD2));

    //控制信号部分
    Control_Unit E_control_unit(.Instr(E_Instr),
                                .State(level),
                                .rs(E_rs),
                                .rt(E_rt),
                                .ALUSrc(ALUSrc),
                                .ALUop(ALUop),
                                .Tnew(E_Tnew));

    Forward ALUAFMUXSrc(.ReadAddr(E_rs),
                        .M_RegAddr(M_RegAddr),
                        .M_RegWrite(M_RegWrite),
                        .W_RegAddr(W_RegAddr),
                        .W_RegWrite(W_RegWrite),
                        .ForwardSrc(AMFSrc));

    Forward ALUBFMUXSrc(.ReadAddr(E_rt),
                        .M_RegAddr(M_RegAddr),
                        .M_RegWrite(M_RegWrite),
                        .W_RegAddr(W_RegAddr),
                        .W_RegWrite(W_RegWrite),
                        .ForwardSrc(BMFSrc));
    
endmodule
