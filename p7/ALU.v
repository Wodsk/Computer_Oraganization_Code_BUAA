`timescale 1ns / 1ps
`include "macro.v"
module ALU(
    input [31:0] A,
	input [31:0] B,
	input [4:0] s,
	input [4:0] ALUop,
    output [31:0] data,
	output Ov);
	 
	reg [31:0] temp_data;
	reg [32:0] temp_A, temp_B, temp_result;
    reg temp_Ov;

	function [32:0] High_Sign_One_EXT;
	input [31:0] data;
		begin
			High_Sign_One_EXT = {data[31], data};
		end
	endfunction

	always @(*) begin
       case (ALUop)
		    `AND: begin
				temp_data = A & B;
                temp_Ov = 0;
			end 
	        `OR: begin
				temp_data = A | B;
				temp_Ov = 0;
			end 
	        `XOR: begin
				temp_data = A ^ B;
				temp_Ov = 0;
			end 
	        `NOR: begin
				temp_data = ~(A | B);
				temp_Ov = 0;
			end 
	        `ADD: begin
		        temp_A = High_Sign_One_EXT(A);
		        temp_B = High_Sign_One_EXT(B);
                temp_result = temp_A + temp_B;
				if(temp_result[32] == temp_result[31]) begin
					temp_data = temp_result[31:0];
					temp_Ov = 0;
				end
				else begin
					temp_data = 0;
					temp_Ov = 1;
				end   
	        end
	        `ADDU: begin
				temp_data = A + B;
				temp_Ov = 0;
			end 
	        `SUB: begin
		        temp_A = High_Sign_One_EXT(A);
		        temp_B = High_Sign_One_EXT(B);
                temp_result = temp_A - temp_B;
				if(temp_result[32] == temp_result[31]) begin
					temp_data = temp_result[31:0];
					temp_Ov = 0;
				end
				else begin
					temp_data = 0;
					temp_Ov = 1;
				end
	        end
	        `SUBU: begin
				temp_data = A - B;
				temp_Ov = 0;
			end 
	        `SLT: begin
		        if($signed(A) < $signed(B)) temp_data = 1;
		        else temp_data = 0;
				temp_Ov = 0;
	        end
	        `SLTU: begin
		        if(A < B) temp_data = 1;
		        else temp_data = 0;
				temp_Ov = 0;
	        end
	        `SLL: begin
				temp_data = B << s;
				temp_Ov = 0;
			end 
	        `SRL: begin
				temp_data = B >> s;
				temp_Ov = 0;
			end 
	        `SRA: begin
				temp_data = $signed(B) >>> s;
				temp_Ov = 0;
			end 
	        `SLLV: begin
				temp_data = B << A[4:0];
				temp_Ov = 0;
			end 
	        `SRLV: begin
				temp_data = B >> A[4:0];
				temp_Ov = 0;
			end 
	        `SRAV: begin
				temp_data = $signed(B) >>> A[4:0];
				temp_Ov = 0;
			end 
	        default: begin
				temp_data = 0;
				temp_Ov = 0; 
			end  
	   endcase
	  
	end

    assign data = temp_data;
	assign Ov = temp_Ov;
endmodule
