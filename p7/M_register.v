`timescale 1ns / 1ps
module M_register (
    input [31:0] E_Instr,
    input [31:0] E_PC,
    input [31:0] E_RegData,
    input [31:0] ALUResult,
    input [31:0] E_RD2,
    input [4:0] E_RegAddr,
    input E_RegWrite,
    input [4:0] E_ExcCode,
    input E_BD,
    input clk,
    input reset,
    output [31:0] M_Instr,
    output [31:0] M_PC,
    output [31:0] M_FRegData,
    output [31:0] M_ALUResult,
    output [31:0] M_RD2,
    output [4:0] M_RegAddr,
    output M_RegWrite,
    output [4:0] M_ExcCode,
    output M_BD);

    reg [31:0] instr, pc, regdata, aluresult, rd2;
    reg [4:0] regaddr, exccode;
    reg regwrite, bd;
    
    initial begin
      instr = 0;
      pc = 0;
      regdata = 0;
      aluresult = 0;
      rd2 = 0;
      regaddr = 0;
      regwrite = 0;
      exccode = 0;
      bd = 0;    
    end

    always @(posedge clk) begin
        if(reset == 1)begin
            instr <= 0;
            pc <= 0;
            regdata <= 0;
            aluresult <= 0;
            rd2 <= 0;
            regaddr <= 0;
            regwrite <= 0;
            exccode <= 0;
            bd <= 0;
        end    
        else begin
            instr <= E_Instr;
            pc <= E_PC;
            regdata <= E_RegData;
            aluresult <= ALUResult;
            rd2 <= E_RD2;
            regaddr <= E_RegAddr;
            regwrite <= E_RegWrite;
            exccode <= E_ExcCode;
            bd <= E_BD;
        end    
    end

    assign M_Instr = instr;
    assign M_PC = pc;
    assign M_FRegData = regdata;
    assign M_ALUResult = aluresult;
    assign M_RD2 = rd2;
    assign M_RegAddr = regaddr;
    assign M_RegWrite = regwrite;
    assign M_ExcCode = exccode;
    assign M_BD = bd;
endmodule