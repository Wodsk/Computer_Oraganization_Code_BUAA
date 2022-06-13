`timescale 1ns / 1ps
module M_register (
    input [31:0] E_Instr,
    input [31:0] E_PC,
    input [31:0] E_PC8,
    input [31:0] ALUResult,
    input [31:0] E_RD2,
    input [4:0] E_RegAddr,
    input E_RegWrite,
    input clk,
    input reset,
    output [31:0] M_Instr,
    output [31:0] M_PC,
    output [31:0] M_PC8,
    output [31:0] M_ALUResult,
    output [31:0] M_RD2,
    output [4:0] M_RegAddr,
    output M_RegWrite);

    reg [31:0] instr, pc, pc8, aluresult, rd2;
    reg [4:0] regaddr;
    reg regwrite;
    
    initial begin
      instr = 0;
      pc = 0;
      pc8 = 0;
      aluresult = 0;
      rd2 = 0;
      regaddr = 0;
      regwrite = 0;    
    end

    always @(posedge clk) begin
        if(reset == 1)begin
            instr <= 0;
            pc <= 0;
            pc8 <= 0;
            aluresult <= 0;
            rd2 <= 0;
            regaddr <= 0;
            regwrite <= 0;
        end    
        else begin
            instr <= E_Instr;
            pc <= E_PC;
            pc8 <= E_PC8;
            aluresult <= ALUResult;
            rd2 <= E_RD2;
            regaddr <= E_RegAddr;
            regwrite <= E_RegWrite;
        end    
    end

    assign M_Instr = instr;
    assign M_PC = pc;
    assign M_PC8 = pc8;
    assign M_ALUResult = aluresult;
    assign M_RD2 = rd2;
    assign M_RegAddr = regaddr;
    assign M_RegWrite = regwrite;
endmodule