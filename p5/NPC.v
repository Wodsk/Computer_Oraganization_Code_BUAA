`timescale 1ns / 1ps
`include "macro.v"
module NPC(
    input [31:0] F_PC,//当前取出的指令所在地址
	input [31:0] D_PC,//D级流水线取出的指令地址，用于b类与j�
	input [31:0] D_offset,
	input [25:0] D_Instr_index,
	input [31:0] GRF_rs,
	input [2:0] D_Move,
	input [2:0] D_Cmp,
	output [31:0] NPC
    );//这些多余的信息均是用于b类与j类跳转指令的，而这些指令均要在
	 
	reg [31:0] temp_NPC;
	 
	always @(*) begin
		temp_NPC = F_PC + 4;
		if(D_Move[0] && D_Cmp[1]) temp_NPC = D_PC + 4 + D_offset;//beq
		if(D_Move[1]) begin//j and jal
			temp_NPC[1:0] = 0;
			temp_NPC[27:2] = D_Instr_index;
			temp_NPC[31:28] = D_PC[31:28];
		end
        if(D_Move[2]) temp_NPC = GRF_rs;//jr
	end
      
	
	assign NPC = temp_NPC;
endmodule
