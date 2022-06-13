`timescale 1ns / 1ps
`include "macro.v"

module Control_Unit (
    input [31:0] Instr,
    input [2:0] State,//当前流水级数的输�
    output [15:0] Imm,
    output [25:0] Instr_index,
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd, 
    output [1:0] RegDst,
    output RegWrite,
    output EXTop,
    output [1:0] Shiftop,
    output ALUSrc,
    output [2:0] ALUop,
    output MemWrite,
    output [1:0] WBDst,
    output [2:0] Move,
    output [2:0] Tnew,
    output [2:0] Tuse_rs,
    output [2:0] Tuse_rt );
 // 将指令进行译�
    wire [5:0] op,funct;

    assign Imm = Instr[15:0];
    assign Instr_index = Instr[25:0];
    assign op = Instr[31:26];
    assign funct = Instr[5:0];
    assign rs = Instr[26:21];
    assign rt = Instr[20:16];
    assign rd = Instr[15:11];

 //进行功能信号的译码，这部分与单周期相�
    wire addu = (op == `Rtype) && (funct == `addu_func);
    wire subu = (op == `Rtype) && (funct == `subu_func);
    wire slt = (op == `Rtype) && (funct == `slt_func);
    wire jr = (op == `Rtype) && (funct == `jr_func);
    wire lw = (op == `lw);
    wire sw = (op == `sw);
    wire beq = (op == `beq);
    wire ori = (op == `ori);
    wire lui = (op == `lui);
    wire addi = (op == `addi);
    wire j = (op == `j);
    wire jal = (op == `jal);   
    
    assign RegDst[0] = addu || subu || slt;
    assign RegDst[1] = jal;//jal将PC+8写入31号寄存器，而不是jr，jr没有写寄存器的需�
    assign RegWrite = addu || subu || slt || lw || ori || lui || addi || jal;
    assign EXTop =  addi || sw || lw || beq;
    assign Shiftop[0] = beq;
    assign Shiftop[1] = lui;
    assign ALUSrc = lui || ori || sw || lw || addi;
    assign ALUop[0] = ori || slt;
    assign ALUop[1] = addu || addi || lw || sw || slt || jr || lui || subu;
    assign ALUop[2] = slt || subu;
    assign MemWrite = sw;
    assign WBDst[0] = lw;
    assign WBDst[1] = jal;
    assign Move[0] = beq;
    assign Move[1] = j || jal;
    assign Move[2] = jr;

//进行AT信号的生�
    reg  [2:0] tnew, tuse_rs, tuse_rt;//每条指令最多写一条寄存器，因此只需一个Tnew
    //将指令进行一个分类，方便计算
    wire ALU = addu || subu || slt || ori || lui || addi;
    wire DM = lw;

    always @(*) begin
        tnew = 0;
        tuse_rs = 3;//注意tuse缺省值的设定(default)
        tuse_rt = 3;
        if(ALU)
            tnew = (`D_ALU_Tnew > State) ? `D_ALU_Tnew - State : 0;
        else if (DM)
            tnew = (`D_DM_Tnew > State) ? `D_DM_Tnew - State : 0;

        if(addu || subu || slt) begin
            tuse_rs = `E_level;
            tuse_rt = `E_level; 
        end
        else if(addi || ori || lw ) begin
            tuse_rs = `E_level;
        end
        else if(sw) begin
            tuse_rs = `E_level;
            tuse_rt = `M_level;
        end
        else if(beq) begin
            tuse_rs = `D_level;
            tuse_rt = `D_level;
        end
        else if(jr) begin
            tuse_rs = `D_level;
        end
    end    
    
    assign Tnew = tnew;
    assign Tuse_rs = tuse_rs;
    assign Tuse_rt = tuse_rt;

endmodule