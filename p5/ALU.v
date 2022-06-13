`timescale 1ns / 1ps
`include "macro.v"
module ALU(
    input [31:0] A,
	input [31:0] B,
	input [2:0] ALUop,
    output [31:0] data);
	 
	reg [31:0] temp_data = 0;
	 
	always @(*) begin
	  if(ALUop == `AND) temp_data = A & B;
	  else if(ALUop == `OR) temp_data = A | B;
	  else if(ALUop == `ADD) temp_data = A + B;
	  else if(ALUop == `SUB) temp_data = A - B;
	  else if(ALUop == `SLT)
		begin
			if(A < B) temp_data = 32'hffffffff;
			else temp_data = 0;
		end	   
	end

    assign data = temp_data;
endmodule
