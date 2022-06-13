`timescale 1ns / 1ps
`include "macro.v"
module M (
    input clk,
    input reset,
    //从外置DM中获得的数据
    input [31:0] temp_DMResult,
    //输入回写控制信息
    input [2:0] DMWDFMUXSrc,
    //E级信�
    input [31:0] E_Instr,
    input [31:0] E_PC,
    input [31:0] E_RegData,
    input [31:0] ALUResult,
    input [31:0] E_RD2,
    input [4:0] E_RegAddr,
    input E_RegWrite,
    //W级信�
    input [31:0] W_FRegData,
    //输出至外置DM信息
    output [31:0] DMWD,/*经过转发,DM待写入数�*/
    output [31:0] DMWA,//DM待写地址
    output [3:0] DM_byteen,//字节写使能信�
    //流水信息
    output [31:0] M_Instr,
    output [31:0] M_PC,//既要输出到DM也要进行流水
    output [31:0] M_FRegData,
    output [31:0] M_RegData,
    output [4:0] M_RegAddr,
    output [4:0] M_rt,
    output M_RegWrite,
    output [2:0] M_Tnew);

   //声明部分
   wire [31:0] M_ALUResult, M_RD2, DMResult, temp_DMWD;
   //wire [4:0] M_rt;
   wire [3:0] M_RDMUXSrc;
   wire [2:0] BEop, DMEXTop;
   parameter [2:0] level = `M_level;

   //数据通路部分
   M_register m_register(.clk(clk),
                       .reset(reset), 
                       .E_Instr(E_Instr), 
                       .E_PC(E_PC), 
                       .E_RegData(E_RegData), 
                       .ALUResult(ALUResult), 
                       .E_RD2(E_RD2), 
                       .E_RegAddr(E_RegAddr), 
                       .E_RegWrite(E_RegWrite), 
                       .M_Instr(M_Instr), 
                       .M_PC(M_PC), 
                       .M_FRegData(M_FRegData), 
                       .M_ALUResult(M_ALUResult), 
                       .M_RD2(M_RD2),
                       .M_RegAddr(M_RegAddr),
                       .M_RegWrite(M_RegWrite));

    
      assign DMWA = M_ALUResult;//输出DM待写地址
      
      BE be(.Addr(M_ALUResult[1:0]),
            .BEop(BEop),
				.temp_DMWD(temp_DMWD),
				.DMWD(DMWD),
            .DM_byteen(DM_byteen));//输出字节使能信号
    
    /*DM dm(.clk(clk),
          .WE(DM_byteen),
          .reset(reset),
          .PC(M_PC),
          .A(M_ALUResult),
          .WD(DMWD),
          .RD(DMResult));*/

    DMEXT dmext(.A(M_ALUResult[1:0]),
                .Din(temp_DMResult),
                .DMEXTop(DMEXTop),
                .Dout(DMResult));      

    FMUX DMWDFMUX(.Origin(M_RD2),
                  .W_FRegData(W_FRegData),
                  .FMUXSrc(DMWDFMUXSrc),
                  .RD(temp_DMWD));//只需要W级的回写+输出经过转发后的写入DM数据
    
    RDMUX M_RDMUX(.Front_RegData(M_FRegData),
                  .DMResult(DMResult),
                  .RDMUXSrc(M_RDMUXSrc),
                  .RegData(M_RegData));                          

   //控制信号部分
   Control_Unit M_control_unit(.Instr(M_Instr),
                               .State(level),
                               .rt(M_rt),
                               .BEop(BEop),
                               .DMEXTop(DMEXTop),
                               .M_RDMUXSrc(M_RDMUXSrc),
                               .Tnew(M_Tnew));

    
endmodule