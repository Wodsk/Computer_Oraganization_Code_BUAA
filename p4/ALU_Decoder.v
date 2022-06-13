`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:03:45 11/15/2021 
// Design Name: 
// Module Name:    ALU_Decoder 
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
module ALU_Decoder(
    input [5:0] funct,
	 input [1:0] ALUop,
	 output [2:0] ALUControl,
	 output jr
    );
    
	 reg [2:0] temp_Control;
	 reg temp_jr;
	 
	 initial begin
	   temp_Control = 0;
		temp_jr = 0;
	 end	
    always @(*)
    begin
	   temp_Control = 0;
		temp_jr = 0;
      case(ALUop)
		  2'b00: temp_Control = `ADD;
		  2'b01: temp_Control = `SUB;
		  2'b10: temp_Control = `OR;
		  2'b11: begin
		           case(funct)
					    `addu_func: temp_Control = `ADD;
						 `subu_func: temp_Control = `SUB;
						 `and_func: temp_Control = `AND;
						 `or_func: temp_Control = `OR;
						 `slt_func: temp_Control = `SLT;
						 `jr_func: temp_jr = 1'b1;
					  endcase
					end  
	   endcase
	 end  	 

   assign ALUControl = temp_Control;
	assign jr = temp_jr;
endmodule
