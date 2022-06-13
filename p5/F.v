`timescale 1ns / 1ps
module F (
    input clk,
    input reset,
    input D_Enable,
    //D级信�用于b类与j类指令计算NPC)
    input [31:0] D_PC,
    input [31:0] D_offset,
    input [25:0] D_Instr_index,
    input [31:0] D_GRF_rs,
    input [4:0] D_rs,
    input [2:0] D_Cmp,
    input [2:0] D_Move,
    //M级信�
    input [31:0] M_RegData,
    input [4:0] M_RegAddr,
    input M_RegWrite,
    //输出信息
    output [31:0] F_Instr,
    output [31:0] F_PC,
    output [31:0] F_PC8
);


    //声明部分
    wire [31:0] NPC, GRF_rs;
    wire [1:0] NPCFMUXSrc; 
    
    //数据通路部分
    NPC npc(.F_PC(F_PC),
            .D_PC(D_PC),
            .D_offset(D_offset),
            .D_Instr_index(D_Instr_index),
            .GRF_rs(GRF_rs),
            .D_Move(D_Move),
            .D_Cmp(D_Cmp),
            .NPC(NPC));

    FMUX NPCFMUX(.Origin(D_GRF_rs),
                 .M_RegData(M_RegData),
                 .FMUXSrc(NPCFMUXSrc),
                 .RD(GRF_rs));

    IFU ifu(.clk(clk),
            .reset(reset),
            .D_Enable(D_Enable),
            .NPC(NPC),
            .Instr(F_Instr),
            .PC(F_PC));

    assign F_PC8 = F_PC + 8;

    //控制信号部分(只需M级的转发)
    Forward NPCForward(.ReadAddr(D_rs),
                       .M_RegAddr(M_RegAddr),
                       .M_RegWrite(M_RegWrite),
                       .ForwardSrc(NPCFMUXSrc));
    
endmodule