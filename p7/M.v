`timescale 1ns / 1ps
`include "macro.v"
module M (
    input clk,
    input reset,
    input IntReturn,
    input IntReq,
    //从外置module中获得的数据
    input [31:0] m_data_rdata,
    input [31:0] CP0Result,
    //输入回写控制信息
    input [2:0] DMWDFMUXSrc,
    //E级信�
    input [31:0] E_Instr,
    input [31:0] E_PC,
    input [31:0] E_RegData,
    input [31:0] ALUResult,
    input [31:0] E_RD2,
    input [4:0] E_RegAddr,
    input E_RegWrite,
    input [4:0] E_ExcCode,
    input E_BD,
    //W级信�
    input [31:0] W_FRegData,
    //输出至外置DM信息
    output [31:0] m_data_wdata,/*经过转发,待写入数*/
    output [31:0] m_data_addr,//待写地址
    output [3:0] m_data_byteen,//字节写使�
    //流水信息
    output [31:0] M_Instr,
    output [31:0] M_PC,//既要输出到DM也要进行流水
    output [31:0] M_FRegData,
    output [31:0] M_RegData,
    output [4:0] M_RegAddr,
    output [4:0] M_rt,
    output [4:0] M_rd,//use in the write and read of CP0
    output M_RegWrite,
    output M_CP0Write,
    output [2:0] M_Tnew,
    output [4:0] M_ExcCode,
    output M_BD,
    output M_eret);

   //声明部分
   wire [31:0] M_ALUResult, M_RD2, DMResult, temp_m_data_wdata;
   wire [4:0] temp_M_ExcCode;
   wire [3:0] M_RDMUXSrc;
   wire [2:0] BEop, DMEXTop;
	wire temp_M_CP0Write;
   parameter [2:0] level = `M_level;

   //数据通路部分
   M_register m_register(.clk(clk),
                       .reset(reset || IntReq), 
                       .E_Instr(E_Instr), 
                       .E_PC(E_PC), 
                       .E_RegData(E_RegData), 
                       .ALUResult(ALUResult), 
                       .E_RD2(E_RD2), 
                       .E_RegAddr(E_RegAddr), 
                       .E_RegWrite(E_RegWrite),
                       .E_ExcCode(E_ExcCode),
                       .E_BD(E_BD), 
                       .M_Instr(M_Instr), 
                       .M_PC(M_PC), 
                       .M_FRegData(M_FRegData), 
                       .M_ALUResult(M_ALUResult), 
                       .M_RD2(M_RD2),
                       .M_RegAddr(M_RegAddr),
                       .M_RegWrite(M_RegWrite),
                       .M_ExcCode(temp_M_ExcCode),
                       .M_BD(M_BD));

    
      assign m_data_addr = (IntReturn) ? 32'h00007F20 : M_ALUResult;//输出待写地址
      
      BE be(.IntReturn(IntReturn),
		      .IntReq(IntReq),
		      .Addr(M_ALUResult[1:0]),
            .BEop(BEop),
		      .temp_m_data_wdata(temp_m_data_wdata),
		      .m_data_wdata(m_data_wdata),
            .m_data_byteen(m_data_byteen));//输出字节使能信号
    
    /*DM dm(.clk(clk),
          .WE(m_data_byteen),
          .reset(reset),
          .PC(M_PC),
          .A(M_ALUResult),
          .WD(m_data_wdata),
          .RD(DMResult));*/

    DMEXT dmext(.A(M_ALUResult[1:0]),
                .Din(m_data_rdata),
                .DMEXTop(DMEXTop),
                .Dout(DMResult));

     M_Exception m_exception(.Load(DMEXTop),//this two informaiton is to express which type the Instr is
                             .Store(BEop),
                             .m_data_addr(m_data_addr),
                             .E_ExcCode(temp_M_ExcCode),
                             .M_ExcCode(M_ExcCode));                 

    FMUX m_data_wdataFMUX(.Origin(M_RD2),
                  .W_FRegData(W_FRegData),
                  .FMUXSrc(DMWDFMUXSrc),
                  .RD(temp_m_data_wdata));//只需要W级的回写+输出经过转发后的写入DM数据
    
    RDMUX M_RDMUX(.Front_RegData(M_FRegData),
                  .DMResult(DMResult),
                  .CP0Result(CP0Result),
                  .RDMUXSrc(M_RDMUXSrc),
                  .RegData(M_RegData));
   
    assign M_CP0Write = (IntReq) ? 1'b0 : temp_M_CP0Write;//when interrupt come the mtc0 can not be done	

   //控制信号部分
   Control_Unit M_control_unit(.Instr(M_Instr),
                               .State(level),
                               .rt(M_rt),
                               .rd(M_rd),
                               .CP0Write(temp_M_CP0Write),
                               .eret(M_eret),
                               .BEop(BEop),
                               .DMEXTop(DMEXTop),
                               .M_RDMUXSrc(M_RDMUXSrc),
                               .Tnew(M_Tnew));

    
endmodule