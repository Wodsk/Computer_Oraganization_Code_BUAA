`timescale 1ns / 1ps
module DM(
  input clk,
	input WE,
	input reset,
	input [31:0] PC,
	input [31:0] A,
	input [31:0] WD,
	output [31:0] RD);
    
	reg [31:0] DM_Reg [0:4095];
	integer i;
   
  initial begin
	  for(i = 0; i < 4096; i = i + 1) begin
		  DM_Reg[i] = 0;
    end
  end
	   
  always @(posedge clk) begin
    if(reset == 1)begin
      for(i = 0; i < 4096; i = i + 1)
      DM_Reg[i] = 0;
    end
    else begin
      if(WE == 1) begin
        DM_Reg [A[13:2]] <= WD;
			  $display("%d@%h: *%h <= %h", $time, PC, A, WD);
      end
    end
  end


  assign RD = DM_Reg[A[13:2]];
endmodule
