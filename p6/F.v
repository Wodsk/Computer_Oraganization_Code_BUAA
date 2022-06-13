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
    //input [4:0] D_rs,
    input [2:0] D_Move,
    //输出信息
    output [31:0] F_PC,
    output [31:0] F_PC8
);


    //声明部分
    wire [31:0] NPC, GRF_rs; 
    
    //数据通路部分
    NPC npc(.F_PC(F_PC),
            .D_PC(D_PC),
            .D_offset(D_offset),
            .D_Instr_index(D_Instr_index),
            .D_GRF_rs(D_GRF_rs),
            .D_Move(D_Move),
            .NPC(NPC));


    IFU ifu(.clk(clk),
            .reset(reset),
            .D_Enable(D_Enable),
            .NPC(NPC),
            .PC(F_PC));

    assign F_PC8 = F_PC + 8;

    
    
endmodule