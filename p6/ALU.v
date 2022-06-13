`timescale 1ns / 1ps
`include "macro.v"
module ALU(
    input [31:0] A,
	input [31:0] B,
	input [4:0] s,
	input [4:0] ALUop,
    output [31:0] data);
	 
	reg [31:0] temp_data;
	reg [32:0] temp_A, temp_B, temp_result;


	function [32:0] High_Sign_One_EXT;
	input [31:0] data;
		begin
			High_Sign_One_EXT = {data[31], data};
		end
	endfunction

	always @(*) begin
       case (ALUop)
		    `AND: temp_data = A & B;
	        `OR: temp_data = A | B;
	        `XOR: temp_data = A ^ B;
	        `NOR: temp_data = ~(A | B);
	        `ADD: begin
		        temp_A = High_Sign_One_EXT(A);
		        temp_B = High_Sign_One_EXT(B);
                temp_result = temp_A + temp_B;
		        temp_data = temp_result[31:0];
	        end
	        `ADDU: temp_data = A + B;
	        `SUB: begin
		        temp_A = High_Sign_One_EXT(A);
		        temp_B = High_Sign_One_EXT(B);
                temp_result = temp_A - temp_B;
		        temp_data = temp_result[31:0];
	        end
	        `SUBU: temp_data = A - B;
	        `SLT: begin
		        if($signed(A) < $signed(B)) temp_data = 1;
		        else temp_data = 0;
	        end
	        `SLTU: begin
		        if(A < B) temp_data = 1;
		        else temp_data = 0;
	        end
	        `SLL: temp_data = B << s;
	        `SRL: temp_data = B >> s;
	        `SRA: temp_data = $signed(B) >>> s;
	        `SLLV: temp_data = B << A[4:0];
	        `SRLV: temp_data = B >> A[4:0];
	        `SRAV: temp_data = $signed(B) >>> A[4:0];
	        default: temp_data = 0; 
	   endcase
	  
	end

    assign data = temp_data;
endmodule
