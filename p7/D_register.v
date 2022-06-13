`timescale 1ns / 1ps
`include "macro.v"
module D_register (
    input [31:0] F_Instr,
    input [31:0] F_PC,
    input [31:0] F_PC8,
    input [4:0] F_ExcCode,
    input F_BD,
    input clk,
    input reset,
    input Enable,
    output [31:0] D_Instr,
    output [31:0] D_PC,
    output [31:0] D_PC8,
    output [4:0] D_ExcCode,
    output D_BD
);

  reg [31:0] instr, pc, pc8;
  reg [4:0] exccode;
  reg bd;

  initial begin
      instr = 0;
      pc = 0;
      pc8 = 0;
      exccode = 0;
      bd = 0;
  end

  always @(posedge clk) begin
      if (reset == 1) begin
          instr <= 0;
          pc <= 0;
          pc8 <= 0;
          exccode <= 0;
          bd <= 0;
      end
      else if(Enable == 0) begin
          if(F_ExcCode == `AdEL) begin
			   instr <= 0;
			 end
			 else begin
			   instr <= F_Instr;
			 end
          pc <= F_PC;
          pc8 <= F_PC8;
          exccode <= F_ExcCode;
          bd = F_BD;
      end
      else begin
          instr <= instr;
          pc <= pc;
          pc8 <= pc8;
          exccode <= exccode;
          bd <= bd;
      end
  end

  assign D_Instr = instr;
  assign D_PC = pc;
  assign D_PC8 = pc8;
  assign D_ExcCode = exccode;
  assign D_BD = bd;  
endmodule