`timescale 1ns / 1ps
module D_register (
    input [31:0] F_Instr,
    input [31:0] F_PC,
    input [31:0] F_PC8,
    input clk,
    input reset,
    input Enable,
    output [31:0] D_Instr,
    output [31:0] D_PC,
    output [31:0] D_PC8
);

  reg [31:0] instr, pc, pc8;

  initial begin
      instr = 0;
      pc = 0;
      pc8 = 0;
  end

  always @(posedge clk) begin
      if (reset == 1) begin
          instr <= 0;
          pc <= 0;
          pc8 <= 0;
      end
      else if(Enable == 0) begin
          instr <= F_Instr;
          pc <= F_PC;
          pc8 <= F_PC8;
      end
      else begin
          instr <= instr;
          pc <= pc;
          pc8 <= pc8;
      end
  end

  assign D_Instr = instr;
  assign D_PC = pc;
  assign D_PC8 = pc8;  
endmodule