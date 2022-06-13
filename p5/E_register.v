`timescale 1ns / 1ps
module E_register (
    input [31:0] D_Instr,
    input [31:0] D_PC,
    input [31:0] D_PC8,
    input [31:0] GRF_RD1,
    input [31:0] GRF_RD2,
    input [31:0] EXT_Imm,
    input [4:0] RegAddr,
    input RegWrite,
    input clk,
    input reset,
    output [31:0] E_Instr,//这些才是在E级需要用到的真正数据
    output [31:0] E_PC,
    output [31:0] E_PC8,
    output [31:0] E_GRF_RD1,
    output [31:0] E_GRF_RD2,
    output [31:0] E_EXT_Imm,
    output E_RegWrite,
    output [4:0] E_RegAddr
);
   
   reg [31:0] instr, pc, pc8, rd1, rd2, ext_imm;
   reg [4:0] regaddr;
   reg regwrite;

   initial begin
       instr = 0;
       pc = 0;
       pc8 = 0;
       rd1 = 0;
       rd2 = 0;
       regaddr = 0;
       regwrite = 0;
       ext_imm = 0;
   end

   always @(posedge clk) begin
       if(reset == 1)begin
           instr <= 0;
           pc <= 0;
           pc8 <= 0;
           rd1 <= 0;
           rd2 <= 0;
           regaddr <= 0;
           regwrite <= 0;
           ext_imm <= 0;
       end
       else begin
           instr <= D_Instr;
           pc <= D_PC;
           pc8 <= D_PC8;
           rd1 = GRF_RD1;
           rd2 <= GRF_RD2;
           regaddr <= RegAddr;
           regwrite <= RegWrite;
           ext_imm <= EXT_Imm;
       end
   end

   assign E_Instr = instr;
   assign E_PC = pc;
   assign E_PC8 = pc8;
   assign E_GRF_RD1 = rd1;
   assign E_GRF_RD2 = rd2;
   assign E_EXT_Imm = ext_imm;
   assign E_RegAddr = regaddr;
   assign E_RegWrite = regwrite; 
endmodule