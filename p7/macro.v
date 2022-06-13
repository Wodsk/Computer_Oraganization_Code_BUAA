`timescale 1ns / 1ps
//ALU内部选择信号的编�
`define AND 5'b00000
`define OR 5'b00001
`define XOR 5'b00010
`define NOR 5'b00011
`define ADD 5'b00100
`define ADDU 5'b00101
`define SUB 5'b00110
`define SUBU 5'b00111
`define SLT 5'b01000
`define SLTU 5'b01001
`define SLL 5'b01010
`define SRL 5'b01011
`define SRA 5'b01100
`define SLLV 5'b01101
`define SRLV 5'b01110
`define SRAV 5'b01111
`define ALU_Default 5'b10000
//MAD内部选择信号的编�
`define MAD_Default 3'b000
`define HI_Write 3'b001
`define LO_Write 3'b010
`define MULT 3'b011
`define MULTU 3'b100
`define DIV 3'b101
`define DIVU 3'b110
//EXT内部选择信号的编�
`define Sign_EXT 1'b1
`define Zero_EXT 1'b0
`define Shiftop_Default 2'b00
`define two_bits_lshift 2'b01
`define sixteen_bits_lshift 2'b10

//funct字段的编�
`define add_func 6'b100000
`define addu_func 6'b100001
`define sub_func 6'b100010
`define subu_func 6'b100011

`define mult_func 6'b011000
`define multu_func 6'b011001
`define div_func 6'b011010
`define divu_func 6'b011011

`define sll_func 6'b000000
`define srl_func 6'b000010
`define sra_func 6'b000011
`define sllv_func 6'b000100
`define srlv_func 6'b000110
`define srav_func 6'b000111

`define and_func 6'b100100
`define or_func 6'b100101
`define xor_func 6'b100110
`define nor_func 6'b100111

`define slt_func 6'b101010
`define sltu_func 6'b101011

`define jalr_func 6'b001001
`define jr_func 6'b001000

`define mfhi_func 6'b010000
`define mflo_func 6'b010010
`define mthi_func 6'b010001
`define mtlo_func 6'b010011

`define eret_func 6'b011000
//op字段的编�
`define lb 6'b100000
`define lbu 6'b100100
`define lh 6'b100001
`define lhu 6'b100101
`define lw 6'b100011

`define sb 6'b101000
`define sh 6'b101001
`define sw 6'b101011

`define addi 6'b001000
`define addiu 6'b001001
`define andi 6'b001100
`define ori 6'b001101
`define xori 6'b001110

`define lui 6'b001111

`define slti 6'b001010
`define sltiu 6'b001011

`define beq 6'b000100
`define bne 6'b000101
`define blez 6'b000110
`define bgtz 6'b000111
`define bltz 6'b000001
`define bgez 6'b000001

`define j 6'b000010
`define jal 6'b000011

`define COP0 6'b010000
`define Rtype 6'b000000
//特殊区分字段编码
`define bgez_rt 5'b00001
`define bltz_rt 5'b00000
`define mfc0_rs 5'b00000
`define mtc0_rs 5'b00100
//Address of PC
`define PCbegin 32'h00003000
`define PCend 32'h00006ffc
//Address of Timer
`define Timer0begin 32'h00007F00
`define Timer0end 32'h00007F0B
`define Timer1begin 32'h00007F10
`define Timer1end 32'h00007F1B
`define T0Cbegin 32'h00007F08
`define T0Cend 32'h00007F0B
`define T1Cbegin 32'h00007F18
`define T1Cend 32'h00007F1B
//Address of DM
`define DMbegin 32'h00000000
`define DMend 32'h00002FFF
//Exception Handler
`define Exception_Handler 32'h00004180
//流水寄存器级数编码就是离D级的距离
`define D_level 3'b000;
`define E_level 3'b001;
`define M_level 3'b010;
`define W_level 3'b011;
//各类指令在D级产生的Tnew(CU)
`define D_ALU_Tnew 3'b010
`define D_MAD_Tnew 3'b010
`define D_Link_Tnew 3'b001
`define D_EXT_Tnew 3'b001
`define D_DM_Tnew 3'b011
`define D_CP0_Tnew 3'b011
//转发指令的优先级(Forward)
`define origin 3'b000
`define E_Forward 3'b011
`define M_Forward 3'b010
`define W_Forward 3'b001
//define the type of load Instr, use it in the DMEXT and M_Exception
`define Load_Default 3'b000
`define LBU 3'b001
`define LB 3'b010
`define LHU 3'b011
`define LH 3'b100
`define LW 3'b101
//跳转类型的编�Npc)
`define Move_Default 3'b000
`define Branch 3'b001
`define Index 3'b010
`define Register 3'b100
//跳转条件的编�Cmp)
`define Branch_Default 4'b0000
`define BEQ 4'b0001
`define BNE 4'b0010
`define BLEZ 4'b0011
`define BGTZ 4'b0100
`define BLTZ 4'b0101
`define BGEZ 4'b0110
//define the type of store Instr, use it in the DMEXT and M_Exception
`define Store_Default 3'b000
`define SW 3'b001
`define SH 3'b010
`define SB 3'b011
//写寄存器字段的选择信号的编�
`define rt 2'b00
`define rd 2'b01
`define ra 2'b10
//流水寄存器数据选择信号的编�
`define RD_Default 4'b0000
`define PC8 4'b0001
`define LuiData 4'b0010
`define ALUResult 4'b0011
`define HIResult 4'b0100
`define LOResult 4'b0101
`define DMResult 4'b0110
`define CP0Result 4'b0111
`define Front_RegData 4'b1000
//字节的宏定义
`define byte0 4'b0001
`define byte1 4'b0010
`define byte2 4'b0100
`define byte3 4'b1000
//ExcCode
`define Int 5'd0
`define AdEL 5'd4
`define AdES 5'd5
`define RI 5'd10
`define Ov 5'd12
