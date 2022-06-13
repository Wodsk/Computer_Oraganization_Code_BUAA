`timescale 1ns / 1ps
module F (
    input clk,
    input reset,
    input D_Enable,
    //D级信息用于b类与j类指令计算NPC)
    input [31:0] D_PC,
    input [31:0] D_offset,
    input [25:0] D_Instr_index,
    input [31:0] D_GRF_rs,
    input [31:0] EPC,
    input [2:0] D_Move,
	 input D_BrWE,
    input IntReq,
    input D_eret,
    //输出信息
    output [31:0] F_PC,
    output [31:0] F_PC8,
    output [4:0] F_ExcCode,
    output F_BD
);


    //声明部分
    wire [31:0] NPC, GRF_rs; 
    
    //数据通路部分
    NPC npc(.F_PC(F_PC),
            .D_PC(D_PC),
            .D_offset(D_offset),
            .D_Instr_index(D_Instr_index),
            .D_GRF_rs(D_GRF_rs),
            .EPC(EPC),
            .D_Move(D_Move),
	    .D_BrWE(D_BrWE),
            .IntReq(IntReq),
            .D_eret(D_eret),
            .NPC(NPC));


    IFU ifu(.clk(clk),
            .reset(reset),
	    .IntReq(IntReq),
            .D_Enable(D_Enable),
            .D_eret(D_eret),
            .EPC(EPC),
            .NPC(NPC),
            .PC(F_PC));

    assign F_PC8 = F_PC + 8;

    assign F_BD = |D_Move;
    
    F_Exception f_exception(.pc(F_PC),
                            .F_ExcCode(F_ExcCode));
    
    
endmodule