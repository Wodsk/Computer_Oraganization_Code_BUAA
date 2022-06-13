`timescale 1ns / 1ps
`include "macro.v"
module M (
    input clk,
    input reset,
    //E级信�
    input [31:0] E_Instr,
    input [31:0] E_PC,
    input [31:0] E_PC8,
    input [31:0] ALUResult,
    input [31:0] E_RD2,
    input [4:0] E_RegAddr,
    input E_RegWrite,
    //W级信�
    input [31:0] W_RegData,
    input [4:0] W_RegAddr,
    input W_RegWrite,
    //输出信息
    output [31:0] M_Instr,
    output [31:0] M_PC,
    output [31:0] M_PC8,
    output [31:0] M_RegData,
    output [4:0] M_RegAddr,
    output M_RegWrite,
    output [2:0] M_Tnew);

   //声明部分
   wire [31:0] M_ALUResult, M_RD2 ,DMResult, DMWD/*经过转发*/;
   wire [4:0] M_rt;
   wire [1:0] WBDst,DWFMSrc;
   wire MemWrite;
   parameter [2:0] level = `M_level;

   //数据通路部分
   M_register m_register(.clk(clk),
                       .reset(reset), 
                       .E_Instr(E_Instr), 
                       .E_PC(E_PC), 
                       .E_PC8(E_PC8), 
                       .ALUResult(ALUResult), 
                       .E_RD2(E_RD2), 
                       .E_RegAddr(E_RegAddr), 
                       .E_RegWrite(E_RegWrite), 
                       .M_Instr(M_Instr), 
                       .M_PC(M_PC), 
                       .M_PC8(M_PC8), 
                       .M_ALUResult(M_ALUResult), 
                       .M_RD2(M_RD2),
                       .M_RegAddr(M_RegAddr),
                       .M_RegWrite(M_RegWrite));

    DM dm(.clk(clk),
          .WE(MemWrite),
          .reset(reset),
          .PC(M_PC),
          .A(M_ALUResult),
          .WD(DMWD),
          .RD(DMResult));
    
    RDMUX rdmux(.ALUResult(M_ALUResult),
                .DMResult(DMResult),
                .PC8(M_PC8),
                .WBDst(WBDst),
                .RegData(M_RegData));

    FMUX DMWDFMUX(.Origin(M_RD2),
                  .W_RegData(W_RegData),
                  .FMUXSrc(DWFMSrc),
                  .RD(DMWD));//只需要W级的回写            

   //控制信号部分
   Control_Unit M_control_unit(.Instr(M_Instr),
                               .State(level),
                               .rt(M_rt),
                               .MemWrite(MemWrite),
                               .WBDst(WBDst),
                               .Tnew(M_Tnew));

   Forward DMWDFMUXSrc(.ReadAddr(M_rt),
                   .W_RegAddr(W_RegAddr),
                   .W_RegWrite(W_RegWrite),
                   .ForwardSrc(DWFMSrc));

    
endmodule