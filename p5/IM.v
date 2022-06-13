`timescale 1ns / 1ps
`include "macro.v"
module IM(
    input [31:0] A,
	output [31:0] RD
    );
    
	reg [31:0] IM_Reg[0:4095];
	wire [31:0] Addr;
	
	initial begin	
	  $readmemh("code.txt" ,IM_Reg);
	end
    
	 assign Addr = A - `BeginAddr;
    assign RD = IM_Reg[Addr[13:2]];
endmodule
