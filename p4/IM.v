`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:02:39 11/15/2021 
// Design Name: 
// Module Name:    IM 
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
module IM(
    input [31:0] A,
	 output [31:0] RD
    );
    
	 reg [31:0] IM_Reg[0:1023];
	 
	 initial begin
	   $readmemh("code.txt" ,IM_Reg);
	 end

    assign RD = IM_Reg[A[11:2]];
endmodule
