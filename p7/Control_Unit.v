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
    output [4:0] s,
    output [1:0] RegDst,
    output RegWrite,
    output CP0Write,
    output [3:0] Branch,
    output EXTop,
    output [1:0] Shiftop,
    output ALUSrc,
    output [4:0] ALUop,
    output Start,
    output [2:0] MADop,
    output [2:0] BEop,
    output [2:0] DMEXTop,
    output [2:0] Move,
    output [2:0] Tnew,
    output [2:0] Tuse_rs,
    output [2:0] Tuse_rt,
    output HILO,//表示指令需要用到HI/LO寄存�
    output [3:0] D_RDMUXSrc,
    output [3:0] E_RDMUXSrc,
    output [3:0] M_RDMUXSrc,
    output RI,
    output eret);
 // 将指令进行译�
    wire [5:0] op,funct;

    assign Imm = Instr[15:0];
    assign Instr_index = Instr[25:0];
    assign op = Instr[31:26];
    assign funct = Instr[5:0];
    assign rs = Instr[26:21];
    assign rt = Instr[20:16];
    assign rd = Instr[15:11];
    assign s = Instr[10:6];

 //进行功能信号的译码，这部分与单周期相�
   wire add = (op == `Rtype) && (funct == `add_func);
   wire addu = (op == `Rtype) && (funct == `addu_func);
   wire sub = (op == `Rtype) && (funct == `sub_func);
   wire subu = (op == `Rtype) && (funct == `subu_func);
   wire mult = (op == `Rtype) && (funct == `mult_func);
   wire multu = (op == `Rtype) && (funct == `multu_func);
   wire div = (op == `Rtype) && (funct == `div_func);
   wire divu = (op == `Rtype) && (funct == `divu_func);
   wire sll = (op == `Rtype) && (funct == `sll_func);
   wire srl = (op == `Rtype) && (funct == `srl_func);
   wire sra = (op == `Rtype) && (funct == `sra_func);
   wire sllv = (op == `Rtype) && (funct == `sllv_func);
   wire srlv = (op == `Rtype) && (funct == `srlv_func);
   wire srav = (op == `Rtype) && (funct == `srav_func);
   wire instr_and = (op == `Rtype) && (funct == `and_func);
   wire instr_or = (op == `Rtype) && (funct == `or_func);
   wire instr_xor = (op == `Rtype) && (funct == `xor_func);
   wire instr_nor = (op == `Rtype) && (funct == `nor_func);
   wire slt = (op == `Rtype) && (funct == `slt_func);
   wire sltu = (op == `Rtype) && (funct == `sltu_func);
   wire jalr = (op == `Rtype) && (funct == `jalr_func);
   wire jr = (op == `Rtype) && (funct == `jr_func);
   wire mfhi = (op == `Rtype) && (funct == `mfhi_func);
   wire mflo = (op == `Rtype) && (funct == `mflo_func);
   wire mthi = (op == `Rtype) && (funct == `mthi_func);
   wire mtlo = (op == `Rtype) && (funct == `mtlo_func);

   wire lb = (op == `lb);
   wire lbu = (op == `lbu);
   wire lh = (op == `lh);
   wire lhu = (op == `lhu);
   wire lw = (op == `lw);
   wire sb = (op == `sb);
   wire sh = (op == `sh);
   wire sw = (op == `sw);
   wire addi = (op == `addi);
   wire addiu = (op == `addiu);
   wire andi = (op == `andi);
   wire ori = (op == `ori);
   wire xori = (op == `xori);
   wire lui = (op == `lui);
   wire slti = (op == `slti);
   wire sltiu = (op == `sltiu);
   wire beq = (op == `beq);
   wire bne = (op == `bne);
   wire blez = (op == `blez);
   wire bgtz = (op == `bgtz);
   wire bltz = (op == `bltz) && (rt == `bltz_rt);
   wire bgez = (op == `bgez) && (rt == `bgez_rt);
   wire j = (op == `j);
   wire jal = (op == `jal);
   wire mfc0 = (op == `COP0) && (rs == `mfc0_rs);
   wire mtc0 = (op == `COP0) && (rs == `mtc0_rs);
   assign eret = (op == `COP0) && (funct == `eret_func);  

//将指令进行分类，方便控制信号的生�指令的分类是为了方便整体数据通路的选择，至于部件内部的选择信号，还是需要依据不同的指令进行不同的操�
    wire calc_r = add || addu || sub || subu || instr_and || instr_or || instr_xor || instr_nor || slt || sltu;//r型计算指�
    wire calc_i = addi || addiu || andi || ori || xori || slti || sltiu;//i型计算指令除lui)
    wire load = lb || lbu || lh || lhu || lw;
    wire store = sb || sh || sw;
    wire branch = beq || bne || blez || bgtz || bltz || bgez;
    wire shiftS = sll || srl || sra;
    wire shiftV = sllv || srlv || srav;
    wire j_r = jr || jalr;
    wire j_addr = j || jal;
    wire j_link = jal || jalr;
    wire m_delay = mult || multu || div || divu;//有延迟的乘除�
    wire mf = mfhi || mflo;//读HI/LO寄存�数据写入rd字段寄存�
    wire mt = mthi || mtlo;//写HI/LO寄存�

// some information about the exception
    assign RI = !(calc_r || calc_i || load || store || branch || shiftS || shiftV || j_r || j_addr || m_delay || mf || mt || lui || mfc0 || mtc0 || eret);
    
//控制信号的编�数据通路与部件内部相区别)    
    assign RegDst = (calc_r || shiftS || shiftV || mf || jalr) ? `rd :
                    (jal) ? `ra : `rt;
    assign RegWrite = calc_r || calc_i || load || lui || j_link || mf || shiftS || shiftV || mfc0;
    assign CP0Write = mtc0;
    
    assign Branch = (beq) ? `BEQ :
                    (bne) ? `BNE :
                    (blez) ? `BLEZ :
                    (bgtz) ? `BGTZ :
                    (bltz) ? `BLTZ :
                    (bgez) ? `BGEZ : `Branch_Default; 

    assign EXTop =  addi || addiu || slti || sltiu || load || store || branch;//需要符号扩展立即数的指�
    assign Shiftop = (branch) ? `two_bits_lshift : 
                     (lui) ? `sixteen_bits_lshift : `Shiftop_Default;

    assign ALUSrc = lui || calc_i || branch || load || store;//选择输入立即数还是寄存器
    assign ALUop = (instr_and || andi) ? `AND :
                   (instr_or || ori) ? `OR :
                   (instr_xor || xori) ? `XOR :
                   (instr_nor) ? `NOR :
                   (add || addi || load || store) ? `ADD :
                   (addu || addiu) ? `ADDU :
                   (sub) ? `SUB :
                   (subu) ? `SUBU :
                   (slt || slti) ? `SLT :
                   (sltu || sltiu) ? `SLTU :
                   (sll) ? `SLL :
                   (srl) ? `SRL :
                   (sra) ? `SRA :
                   (sllv) ? `SLLV :
                   (srlv) ? `SRLV :
                   (srav) ? `SRAV : `ALU_Default;
    
    assign Start = m_delay;
    assign MADop = (mult) ? `MULT :
                   (multu) ? `MULTU :
                   (div) ? `DIV :
                   (divu) ? `DIVU :
                   (mthi) ? `HI_Write :
                   (mtlo) ? `LO_Write : `MAD_Default;
    
    assign BEop = (sw) ? `SW :
                  (sh) ? `SH :
                  (sb) ? `SB : `Store_Default;
    assign DMEXTop = (lbu) ? `LBU :
                     (lb) ? `LB :
                     (lhu) ? `LHU :
                     (lh) ? `LH : 
                     (lw) ? `LW : `Load_Default;
    
   assign Move = (branch) ? `Branch :
                 (j_addr) ? `Index :
                 (j_r) ? `Register : `Move_Default;
   //各级流水的寄存器数据选择信号
   assign D_RDMUXSrc = (j_link) ? `PC8 :
                       (lui) ? `LuiData : `RD_Default;
   assign E_RDMUXSrc = (calc_r || calc_i || shiftS || shiftV) ? `ALUResult : 
                       (mfhi) ? `HIResult : 
                       (mflo) ? `LOResult : `Front_RegData;

   assign M_RDMUXSrc = (load) ? `DMResult : 
                       (mfc0) ? `CP0Result : `Front_RegData;                                  

//进行AT信号的生�
    reg  [2:0] tnew, tuse_rs, tuse_rt;//每条指令最多写一条寄存器，因此只需一个Tnew
    //将指令进行一个分类，方便计算
    wire ALU = calc_r || calc_i || shiftS || shiftV;
    wire MAD = mf;
    wire EXT = lui;
    wire Link = j_link;
    wire DM = load;
    wire CP0 = mfc0;

    always @(*) begin
        tnew = 0;
        tuse_rs = 5;//default
        tuse_rt = 5;
        if(ALU)
            tnew = (`D_ALU_Tnew > State) ? `D_ALU_Tnew - State : 0;
        else if(MAD)
            tnew = (`D_MAD_Tnew > State) ? `D_MAD_Tnew - State : 0;
        else if(EXT)
            tnew = (`D_EXT_Tnew > State) ? `D_EXT_Tnew - State : 0;
        else if(Link)
            tnew = (`D_Link_Tnew > State) ? `D_Link_Tnew - State : 0;        
        else if (DM)
            tnew = (`D_DM_Tnew > State) ? `D_DM_Tnew - State : 0;
        else if (CP0)
            tnew = (`D_CP0_Tnew > State) ? `D_CP0_Tnew - State : 0;    

        if(calc_r || shiftV || m_delay) begin
            tuse_rs = `E_level;
            tuse_rt = `E_level; 
        end
        else if(calc_i || load || mt) begin
            tuse_rs = `E_level;
        end
		else if(shiftS) begin
		     tuse_rt = `E_level;
		end
        else if(store) begin
            tuse_rs = `E_level;
            tuse_rt = `M_level;
        end
        else if(beq || bne) begin
            tuse_rs = `D_level;
            tuse_rt = `D_level;
        end
        else if(j_r || bgez || bgtz || blez || bltz) begin
            tuse_rs = `D_level;
        end
        else if(mtc0) begin
            tuse_rt = `M_level;
        end
    end    
    
    assign Tnew = tnew;
    assign Tuse_rs = tuse_rs;
    assign Tuse_rt = tuse_rt;

    assign HILO = m_delay || mf || mt;

endmodule