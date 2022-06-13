`timescale 1ns / 1ps
module W (
    input clk,
    input reset,
    //M级信息
    input [31:0] M_Instr,
    input [31:0] M_PC,
    input [31:0] M_RegData,
    input [4:0] M_RegAddr,
    input M_RegWrite,
    //输出信息
    output [31:0] W_Instr,
    output [31:0] W_PC,
    output [31:0] W_RegData,
    output [4:0] W_RegAddr,
    output W_RegWrite);
  
  //声明部分

  //数据通路
  W_register w_register(.clk(clk),
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

                      
  //控制部分
     
endmodule