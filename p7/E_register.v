`timescale 1ns / 1ps
`include "macro.v"
module E_register (
    input [31:0] D_Instr,
    input [31:0] D_PC,
    input [31:0] D_RegData,
    input [31:0] GRF_RD1,
    input [31:0] GRF_RD2,
    input [31:0] EXT_Imm,
    input [4:0] RegAddr,
    input RegWrite,
    input [4:0] D_ExcCode,
    input D_BD,
    input clk,
    input reset,
    input Stall,
    output [31:0] E_Instr,//这些才是在E级需要用到的真正数据
    output [31:0] E_PC,
    output [31:0] E_FRegData,
    output [31:0] E_GRF_RD1,
    output [31:0] E_GRF_RD2,
    output [31:0] E_EXT_Imm,
    output E_RegWrite,
    output [4:0] E_RegAddr,
    output [4:0] E_ExcCode,
    output E_BD
);
   
   reg [31:0] instr, pc, regdata, rd1, rd2, ext_imm;
   reg [4:0] regaddr, exccode;
   reg regwrite, bd;

   initial begin
       instr = 0;
       pc = 0;
       regdata = 0;
       rd1 = 0;
       rd2 = 0;
       regaddr = 0;
       regwrite = 0;
       ext_imm = 0;
       exccode = 0;
       bd = 0;
   end

   always @(posedge clk) begin
       if(reset == 1)begin
           instr <= 0;
           pc <= 0;
           regdata <= 0;
           rd1 <= 0;
           rd2 <= 0;
           regaddr <= 0;
           regwrite <= 0;
           ext_imm <= 0;
           exccode <= 0;
           bd <= 0;
       end
       else if(Stall == 1) begin
           instr <= 0;
           pc <= D_PC;
           regdata <= 0;
           rd1 <= 0;
           rd2 <= 0;
           regaddr <= 0;
           regwrite <= 0;
           ext_imm <= 0;
           exccode <= 0;
           bd <= D_BD;
       end
       else begin
		   if(D_ExcCode == `RI) begin
			  instr <= 0;
			end
			else begin
			  instr <= D_Instr;
			end
           pc <= D_PC;
           regdata <= D_RegData;
           rd1 = GRF_RD1;
           rd2 <= GRF_RD2;
           regaddr <= RegAddr;
           regwrite <= RegWrite;
           ext_imm <= EXT_Imm;
           exccode <= D_ExcCode;
           bd <= D_BD;
       end
   end

   assign E_Instr = instr;
   assign E_PC = pc;
   assign E_FRegData = regdata;
   assign E_GRF_RD1 = rd1;
   assign E_GRF_RD2 = rd2;
   assign E_EXT_Imm = ext_imm;
   assign E_RegAddr = regaddr;
   assign E_RegWrite = regwrite;
   assign E_ExcCode = exccode;
   assign E_BD = bd; 
endmodule