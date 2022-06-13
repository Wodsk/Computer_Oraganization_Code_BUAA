`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:46:02 11/16/2021 
// Design Name: 
// Module Name:    NPC 
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
module NPC(
    input [31:0] PC,
	 input [31:0] offset,
	 input [25:0] instr_index,
	 input [31:0] GRF_rs,
	 input [2:0] Move,
	 input [2:0] Cmp,
	 output [31:0] NPC
    );
	 
	 reg [31:0] temp_NPC;
	 
	 always @(*) begin
	   temp_NPC = PC + 4;
		if(Move[0] && Cmp[1]) temp_NPC = PC + 4 + offset;//仅仅实现了beq
		if(Move[1])//仅仅实现了j和jal
		  begin
		    temp_NPC[1:0] = 0;
			 temp_NPC[27:2] = instr_index;
			 temp_NPC[31:28] = PC[31:28];
		  end
      if(Move[2]) temp_NPC = GRF_rs;//仅仅实现jr
      end		
      
	  assign NPC = temp_NPC;
endmodule
