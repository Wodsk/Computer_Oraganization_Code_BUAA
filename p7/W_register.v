`timescale 1ns / 1ps
module W_register (
    input [31:0] M_Instr,
    input [31:0] M_PC,
    input [31:0] M_RegData,
    input [4:0] M_RegAddr,
    input M_RegWrite,
    input clk,
    input reset,
    output [31:0] W_Instr,
    output [31:0] W_PC,
    output [31:0] W_FRegData,
    output [4:0] W_RegAddr,
    output W_RegWrite);

   reg [31:0] instr, pc, regdata;
   reg [4:0] regaddr;
   reg regwrite;

   initial begin
       instr = 0;
       pc = 0;
       regdata = 0;
       regaddr = 0;
       regwrite = 0;
   end
    
   always @(posedge clk) begin
       if(reset == 1) begin
           instr <= 0;
           pc <= 0;
           regdata <= 0;
           regaddr <= 0;
           regwrite <= 0;
       end
       else begin
           instr <= M_Instr;
           pc <= M_PC;
           regdata <= M_RegData;
           regaddr <= M_RegAddr;
           regwrite <= M_RegWrite;
       end
   end

   assign W_Instr = instr;
   assign W_PC = pc;
   assign W_FRegData = regdata;
   assign W_RegAddr = regaddr;
   assign W_RegWrite = regwrite;
endmodule