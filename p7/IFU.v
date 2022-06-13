`timescale 1ns / 1ps
`include "macro.v"
module IFU(
    input clk,
	input reset,
	input D_Enable,//暂停信号在D级产�
	input D_eret,
	input IntReq,
	input [31:0] EPC,
	input [31:0] NPC,
	output [31:0] PC
    );
	 
	reg [31:0] pc;
	 
	initial begin
	   pc = `PCbegin;
    end
	 
	always @(posedge clk) begin
		if(reset == 1) pc <= `PCbegin;
		else if (IntReq) pc <= NPC;
		else if(D_Enable) pc <= pc;
        else pc <= NPC;
	end
	  
	//IM  im(.A(PC),.RD(Instr));
	assign PC = (D_eret) ? EPC : pc;

endmodule
