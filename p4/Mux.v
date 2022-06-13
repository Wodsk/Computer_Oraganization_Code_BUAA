`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:59:32 11/20/2021 
// Design Name: 
// Module Name:    Mux 
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
		  2'b10: temp_result = 5'd31;//jal将PC+4存入$ra
		endcase
    end
   assign RegAddr = temp_result;	 
endmodule

module ALUMUX(
    input [31:0] RD2,
    input [31:0] ext_imm,
	 input ALUSrc,
    output [31:0] ALUB	 
    );
	 
	 reg [31:0] temp_result;
	 
	 always @(*) begin
	   case(ALUSrc)
		  1'b0: temp_result = RD2;
		  1'b1: temp_result = ext_imm;
      endcase
	 end

    assign ALUB = temp_result;	 
endmodule

module RDMUX(
    input [31:0] ALUresult,
	 input [31:0] DMresult,
	 input [31:0] PC,
	 input [1:0] Memback,
	 output [31:0] RegData
	 );
	 
	 reg [31:0] temp_result;
 
    always @(*) begin
	   case(Memback)
		  2'b00: temp_result = ALUresult;
		  2'b01: temp_result = DMresult;
		  2'b10: temp_result = PC + 4;//jal将PC+4写入$ra
		endcase
    end		
 
    assign RegData = temp_result;
endmodule	 
    	 