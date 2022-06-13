`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:46:46 11/16/2021 
// Design Name: 
// Module Name:    EXT 
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
module EXT(
   input [15:0] imm,
	input EXTop,
	input [1:0] Shiftop,
	output [31:0] data
    );
   
    reg [31:0] temp_data;
	 
	 always @(*)
	   begin
		  if(EXTop == `Sign_EXT) temp_data = {{16{imm[15]}}, imm};
		  else if(EXTop == `Zero_EXT) temp_data = {{16{1'b0}}, imm};
		  else temp_data = 0;
		  
		  if(Shiftop == `two_bits_shift) temp_data = temp_data << 2;
		  else if(Shiftop == `sixteen_bits_shift) temp_data = temp_data << 16;
		end
    
	 assign data = temp_data;		
endmodule
