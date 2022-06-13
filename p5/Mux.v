`timescale 1ns / 1ps
`include "macro.v"
module Mux(
    );
endmodule

module RAMUX(
    input [4:0] rt,
    input [4:0] rd,
    input [1:0] RegDst,
    output [4:0] RegAddr	 
	 );
	  
    reg [4:0] temp_result;
	 
    always @(*) begin
	    case(RegDst)
		  2'b00: temp_result = rt;
		  2'b01: temp_result = rd;
		  2'b10: temp_result = 5'd31;//jal将PC+8写入ra
		endcase
    end
   assign RegAddr = temp_result;	 
endmodule

module ALUMUX(
    input [31:0] RD2,
    input [31:0] EXT_Imm,
	input ALUSrc,
    output [31:0] ALUB	 
    );
	 
	reg [31:0] temp_result;
	 
	always @(*) begin
	  case(ALUSrc)
		1'b0: temp_result = RD2;
		1'b1: temp_result = EXT_Imm;
      endcase
	end

    assign ALUB = temp_result;	 
endmodule

module RDMUX(
    input [31:0] ALUResult,
	input [31:0] DMResult,
	input [31:0] PC8,
	input [1:0] WBDst,
	output [31:0] RegData
	 );
	 
	reg [31:0] temp_result;
 
    always @(*) begin
	   case(WBDst)
		  2'b00: temp_result = ALUResult;
		  2'b01: temp_result = DMResult;
		  2'b10: temp_result = PC8;//jal将PC+8写入ra
		endcase
    end		
 
    assign RegData = temp_result;
endmodule

module FMUX (
	input [31:0] Origin,
	input [31:0] M_RegData,
	input [31:0] W_RegData,
	input [1:0] FMUXSrc,
	output [31:0] RD
);
    
	reg [31:0] rd;

	always @(*) begin
		case(FMUXSrc)
		  `origin: rd = Origin;
		  `M_Forward: rd = M_RegData;
		  `W_Forward: rd = W_RegData;
		endcase  
	end
	
	assign RD = rd;
endmodule
    	 