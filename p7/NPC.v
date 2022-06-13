`timescale 1ns / 1ps
`include "macro.v"
module NPC(
    input [31:0] F_PC,//当前取出的指令所在地址
	input [31:0] D_PC,//D级流水线取出的指令地址，用于b类与j�
	input [31:0] D_offset,
	input [25:0] D_Instr_index,
	input [31:0] D_GRF_rs,
	input [31:0] EPC,
	input [2:0] D_Move,
	input D_BrWE,
	input IntReq,
	input D_eret,
	output [31:0] NPC
    );//这些多余的信息均是用于b类与j类跳转指令的
	 
	reg [31:0] temp_NPC;
	 wire [2:0] Move;
	 
	 assign Move[0] = D_Move[0] && D_BrWE;
	 assign Move[1] = D_Move[1];
	 assign Move[2] = D_Move[2];
	 
	always @(*) begin
		if(IntReq) begin
			temp_NPC = `Exception_Handler;
		end
		else if(D_eret) begin
			temp_NPC = EPC + 4;
		end
		else begin
			case (Move)
			`Branch: begin
                temp_NPC = D_PC + 4 + D_offset;
			end
		    `Index: begin
			    temp_NPC[1:0] = 0;
			    temp_NPC[27:2] = D_Instr_index;
			    temp_NPC[31:28] = D_PC[31:28];
		    end
		    `Register: temp_NPC = D_GRF_rs;
		    default: temp_NPC = F_PC + 4; 
		    endcase
		end
	end
      
	
	assign NPC = temp_NPC;
endmodule
