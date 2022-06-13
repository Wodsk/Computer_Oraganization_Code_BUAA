`timescale 1ns / 1ps
`include "macro.v"
module D (
    input clk,
    input reset,
    //F级信�信息自然流�
    input [31:0] F_Instr,
    input [31:0] F_PC,
    input [31:0] F_PC8,
    //W级信�用于回写与写入寄存器�
    input W_RegWrite,
    input [4:0] W_RegAddr,
    input [31:0] W_RegData,
    input [31:0] W_PC,
    //E级信�用于暂�
    input [2:0] E_Tnew,
    input [4:0] E_RegAddr,
    //M级信�用于暂停与回�
    input M_RegWrite,
    input [2:0] M_Tnew,
    input [4:0] M_RegAddr,
    input [31:0] M_RegData,
    //输出信息
    output [31:0] D_Instr,
    output [31:0] D_PC,
    output [31:0] D_PC8,
    output [31:0] CMP_RD1,
    output [31:0] CMP_RD2,
    output [31:0] EXT_Imm,
    output [25:0] Instr_index,
    output [2:0] Cmp,
    output [2:0] Move,
    output [4:0] D_RegAddr,
    output [4:0] D_rs,
    output D_RegWrite,
    output Stall
);
    
  //声明部分
  wire [31:0] GRF_RD1, GRF_RD2;
  wire [15:0] imm;
  wire [4:0] D_rt, D_rd;
  wire [2:0] Tuse_rs, Tuse_rt;
  wire [1:0] CMPRD1FMUXSrc, CMPRD2FMUXSrc, D_RegDst, shiftop;
  wire extop;

  parameter [2:0] level = `D_level;
  

  //数据通路部分
  D_register d_register(.clk(clk), 
                        .reset(reset),
                        .Enable(Stall),
                        .F_Instr(F_Instr),
                        .F_PC(F_PC),
                        .F_PC8(F_PC8),
                        .D_Instr(D_Instr),
                        .D_PC(D_PC),
                        .D_PC8(D_PC8));

  GRF grf(.clk(clk),
          .reset(reset),
          .WE(W_RegWrite),
          .A1(D_rs), 
          .A2(D_rt),
          .A3(W_RegAddr),
          .WD(W_RegData),
          .PC(W_PC),//写寄存器的指令来自于W�
          .RD1(GRF_RD1),
          .RD2(GRF_RD2));

  EXT ext(.Imm(imm),
          .EXTop(extop),
          .Shiftop(shiftop),
          .EXT_Imm(EXT_Imm));

  RAMUX ramux(.rt(D_rt),
              .rd(D_rd),
              .RegDst(D_RegDst),
              .RegAddr(D_RegAddr));

  FMUX CMPRD1FMUX(.Origin(GRF_RD1),
                  .M_RegData(M_RegData),
                  .W_RegData(W_RegData),
                  .FMUXSrc(CMPRD1FMUXSrc), 
                  .RD(CMP_RD1));

  FMUX CMPRD2FMUX(.Origin(GRF_RD2),
                  .M_RegData(M_RegData),
                  .W_RegData(W_RegData),
                  .FMUXSrc(CMPRD2FMUXSrc),
                  .RD(CMP_RD2));

  CMP cmp(.RD1(CMP_RD1),
          .RD2(CMP_RD2),
          .Cmp(Cmp));

  //控制信号部分
  Control_Unit D_control_unit(.Instr(D_Instr),
                              .State(level), 
                              .Imm(imm),
                              .Instr_index(Instr_index),
                              .rs(D_rs),
                              .rt(D_rt),
                              .rd(D_rd),
                              .Move(Move),
                              .RegDst(D_RegDst),
                              .RegWrite(D_RegWrite),
                              .EXTop(extop),
                              .Shiftop(shiftop),
                              .Tuse_rs(Tuse_rs),
                              .Tuse_rt(Tuse_rt));

  Stall stall(.Tuse_rs(Tuse_rs),
              .Tuse_rt(Tuse_rt),
              .D_rs(D_rs),
              .D_rt(D_rt),
              .E_Tnew(E_Tnew),
              .E_RegAddr(E_RegAddr),
              .M_Tnew(M_Tnew),
              .M_RegAddr(M_RegAddr),
              .Stall(Stall));

  Forward CMPRD1Forward(.ReadAddr(D_rs),
                        .M_RegAddr(M_RegAddr),
                        .M_RegWrite(M_RegWrite),
                        .W_RegAddr(W_RegAddr),
                        .W_RegWrite(W_RegWrite),
                        .ForwardSrc(CMPRD1FMUXSrc));

  Forward CMPRD2Forward(.ReadAddr(D_rt),
                        .M_RegAddr(M_RegAddr),
                        .M_RegWrite(M_RegWrite),
                        .W_RegAddr(W_RegAddr),
                        .W_RegWrite(W_RegWrite),
                        .ForwardSrc(CMPRD2FMUXSrc));
endmodule