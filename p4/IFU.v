`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:02:10 11/15/2021 
// Design Name: 
// Module Name:    IFU 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "macro.v"
module IFU(
    input clk,
	 input reset,
	 input [31:0] NPC,
	 output [31:0] RD,
	 output [31:0] PC_out
    );
	 
	 reg [31:0] PC;
	 
	 initial begin
	   PC = `BeginAddr;
    end
	 
	 always @(posedge clk)// Reg of PC
	   begin
		  if(reset == 1) PC = `BeginAddr;
		  else
		    begin
			   PC <= NPC;
          end			  
      end
	  
	 IM  im(.A(PC),.RD(RD));
	 assign PC_out = PC;



endmodule
