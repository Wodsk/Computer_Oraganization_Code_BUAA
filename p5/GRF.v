`timescale 1ns / 1ps
module GRF (
  input clk,
	input reset,
	input WE,
	input [4:0] A1,
	input [4:0] A2,
	input [4:0] A3,
	input [31:0] WD,
	input [31:0] PC,
	output [31:0] RD1,
	output [31:0] RD2
);
  
  reg [31:0] GRF_Reg [31:0];
	integer i;
	 
	initial begin
    for(i = 0; i < 32; i = i + 1)
      begin
        GRF_Reg[i] = 0;
      end
  end

  always @(posedge clk) begin
    if(reset == 1) begin
      for(i = 0; i < 32; i = i + 1)
        GRF_Reg[i] = 0;
    end
    else if(WE == 1 && A3 != 0)begin
      GRF_Reg[A3] <= WD;//写入寄存器操作
		  $display("%d@%h: $%d <= %h", $time, PC, A3, WD);
    end
  end

  assign RD1 =( (A3 == A1) && A3 && WE) ? WD : GRF_Reg[A1];
  assign RD2 =( (A3 == A2) && A3 && WE) ? WD : GRF_Reg[A2];
endmodule
	 