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
		  `rt: temp_result = rt;
		  `rd: temp_result = rd;
		  `ra: temp_result = 5'd31;//jal将PC+8写入ra
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


module FMUX (
	input [31:0] Origin,
	input [31:0] E_FRegData,
	input [31:0] M_FRegData,
	input [31:0] W_FRegData,
	input [2:0] FMUXSrc,
	output [31:0] RD
);
    
	reg [31:0] rd;

	always @(*) begin
		case(FMUXSrc)
		  `origin: rd = Origin;
		  `E_Forward: rd = E_FRegData;
		  `M_Forward: rd = M_FRegData;
		  `W_Forward: rd = W_FRegData;
		endcase  
	end
	
	assign RD = rd;
endmodule

module RDMUX (
	input [31:0] PC8,
	input [31:0] LuiData,
	input [31:0] ALUResult,
	input [31:0] HI,
	input [31:0] LO,
	input [31:0] DMResult,
	input [31:0] Front_RegData,
	input [3:0] RDMUXSrc,
	output [31:0] RegData
);

   reg [31:0] regdata;

   always @(*) begin
	   case (RDMUXSrc)
	       `PC8: regdata = PC8;
		   `LuiData: regdata = LuiData;
		   `ALUResult: regdata = ALUResult;
		   `HIResult: regdata = HI;
		   `LOResult: regdata = LO;
		   `DMResult: regdata = DMResult;
		   `Front_RegData: regdata = Front_RegData;
		   default: regdata = 32'hxxxxxxxx;
	   endcase
   end

   assign RegData = regdata; 
endmodule