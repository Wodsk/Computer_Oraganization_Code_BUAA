`timescale 1ns / 1ps
`include "macro.v"
module NPC(
    input [31:0] F_PC,//当前取出的指令所在地址
	input [31:0] D_PC,//D级流水线取出的指令地址，用于b类与j�
	input [31:0] D_offset,
	input [25:0] D_Instr_index,
	input [31:0] D_GRF_rs,
	input [2:0] D_Move,
	output [31:0] NPC
    );//这些多余的信息均是用于b类与j类跳转指令的
	 
	reg [31:0] temp_NPC;
	 
	always @(*) begin
		case (D_Move)
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
      
	
	assign NPC = temp_NPC;
endmodule
