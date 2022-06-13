`timescale 1ns / 1ps
`include "macro.v"
module D (
    input clk,
    input reset,
    //F级信息信息自然流�
    input [31:0] F_Instr,
    input [31:0] F_PC,
    input [31:0] F_PC8,
    //W级信息用于写入寄存器
    input W_RegWrite,
    input [4:0] W_RegAddr,
    input [31:0] W_RegData,
    input [31:0] W_PC,
    //E级信息用于暂停与回写
    input E_Busy,
    input [2:0] E_Tnew,
    input [4:0] E_RegAddr,
    input [31:0] E_FRegData,
    //M级信息用于暂停与回写
    input [2:0] M_Tnew,
    input [4:0] M_RegAddr,
    input [31:0] M_FRegData,
    //输入回写信息选择信号
    input [2:0] CMP1FMUXSrc,
    input [2:0] CMP2FMUXSrc,
    //输出信息
    output [31:0] D_Instr,
    output [31:0] D_PC,
    output [31:0] D_RD1,
    output [31:0] D_RD2,
    output [31:0] EXT_Imm,
    output [25:0] Instr_index,
    output [2:0] D_Move,
    output [31:0] D_RegData,//将PC8与lui的信号进行选择，不需要同时流�
    output [4:0] D_RegAddr,
    output [4:0] D_rs,
    output [4:0] D_rt,
    output D_RegWrite,
    output Stall
);
    
  //声明部分
  wire [31:0] GRF_RD1, GRF_RD2, D_PC8;
  wire [15:0] imm;
  wire [4:0] D_rd;
  wire [3:0] Branch, D_RDMUXSrc;
  wire [2:0] Tuse_rs, Tuse_rt, Move;
  wire [1:0] D_RegDst, Shiftop;
  wire EXTop, BrWE;

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
          .EXTop(EXTop),
          .Shiftop(Shiftop),
          .EXT_Imm(EXT_Imm));

  RAMUX ramux(.rt(D_rt),
              .rd(D_rd),
              .RegDst(D_RegDst),
              .RegAddr(D_RegAddr));

  FMUX CMPRD1FMUX(.Origin(GRF_RD1),
                  .E_FRegData(E_FRegData),
                  .M_FRegData(M_FRegData),
                  .FMUXSrc(CMP1FMUXSrc), 
                  .RD(D_RD1));

  FMUX CMPRD2FMUX(.Origin(GRF_RD2),
                  .E_FRegData(E_FRegData),
                  .M_FRegData(M_FRegData),
                  .FMUXSrc(CMP2FMUXSrc),
                  .RD(D_RD2));

  CMP cmp(.RD1(D_RD1),
          .RD2(D_RD2),
          .Branch(Branch),
          .BrWE(BrWE));

 RDMUX D_RDMUX(.PC8(D_PC8),
               .LuiData(EXT_Imm),
               .RDMUXSrc(D_RDMUXSrc),
               .RegData(D_RegData));
 assign D_Move[0] = Move[0] && BrWE;
 assign D_Move[1] = Move[1];
 assign D_Move[2] = Move[2];
      

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
                              .Branch(Branch),
                              .EXTop(EXTop),
                              .Shiftop(Shiftop),
                              .D_RDMUXSrc(D_RDMUXSrc),
                              .Tuse_rs(Tuse_rs),
                              .Tuse_rt(Tuse_rt),
                              .HILO(HILO));

  Stall stall(.Tuse_rs(Tuse_rs),
              .Tuse_rt(Tuse_rt),
              .D_rs(D_rs),
              .D_rt(D_rt),
              .HILO(HILO),
              .E_Busy(E_Busy),
              .E_Tnew(E_Tnew),
              .E_RegAddr(E_RegAddr),
              .M_Tnew(M_Tnew),
              .M_RegAddr(M_RegAddr),
              .Stall(Stall));

endmodule