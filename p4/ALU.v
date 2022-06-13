`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:00:26 11/15/2021 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [31:0] A,
	 input [31:0] B,
	 input [2:0] Control,
    output [31:0] data,
    output [2:0] compare	 
    );
	 
	 reg [31:0] temp_data = 0;
	 reg [2:0] temp_compare = 0;
	 
	 always @(*)
	   begin
		  if(Control == `AND) temp_data = A & B;
		  else if(Control == `OR) temp_data = A | B;
		  else if(Control == `ADD) temp_data = A + B;
		  else if(Control == `SUB) temp_data = A - B;
		  else if(Control == `SLT)
		    begin
			   if(A < B) temp_data = 32'hffffffff;
				else temp_data = 0;
			 end
        temp_compare[0] = A > B;
        temp_compare[1] = A == B;
        temp_compare[2] = A < B;		  
      end

     assign data = temp_data;
	  assign compare = temp_compare;
endmodule
