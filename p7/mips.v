`include "macro.v"
module mips (
    input clk,                       // 时钟信号
    input reset,                     // 同步复位信号
    input interrupt,                 // 外部中断信号
    output [31:0] macroscopic_pc,    // 宏观 PC（见下文）

    output [31:0] i_inst_addr,       // 取指 PC
    input  [31:0] i_inst_rdata,      // i_inst_addr 对应的 32 位指令

    output [31:0] m_data_addr,       // 数据存储器待写入地址
    input  [31:0] m_data_rdata,      // m_data_addr 对应的 32 位数据,from DM not the bridge
    output [31:0] m_data_wdata,      // 数据存储器待写入数据
    output [3 :0] m_data_byteen,     // 字节使能信号,for DM not for the bridge 

    output [31:0] m_inst_addr,       // M 级PC

    output w_grf_we,                 // grf 写使能信号
    output [4 :0] w_grf_addr,        // grf 待写入寄存器编号
    output [31:0] w_grf_wdata,       // grf 待写入数据

    output [31:0] w_inst_addr        // W 级 PC
);
    
    wire [31:0] EPC, CP0Result, Timer0RD, Timer1RD, CPU_rdata;
    wire [31:2] TimerAddr;
    wire [5:0] HWInt;
    wire [4:0] M_rd, M_ExcCode;
    wire [3:0] CPU_byteen;
    wire IntReq, IntReturn, M_CP0Write, T0IRQ, T1IRQ, Timer0WE, Timer1WE, M_BD, M_eret;
    

    CPU cpu(.clk(clk),
            .reset(reset),
            .IntReq(IntReq),
            .IntReturn(IntReturn),
            .EPC(EPC),
            .i_inst_rdata(i_inst_rdata),
            .m_data_rdata(CPU_rdata),
            .CP0Result(CP0Result),
            .i_inst_addr(i_inst_addr),
            .m_data_addr(m_data_addr),
            .m_data_wdata(m_data_wdata),
            .m_data_byteen(CPU_byteen),
            .m_inst_addr(m_inst_addr),
            .M_rd(M_rd),
            .M_ExcCode(M_ExcCode),
            .M_CP0Write(M_CP0Write),
            .M_BD(M_BD),
            .M_eret(M_eret),
            .w_grf_we(w_grf_we),
            .w_grf_addr(w_grf_addr),
            .w_grf_wdata(w_grf_wdata),
            .w_inst_addr(w_inst_addr));

    assign HWInt = {3'b0, interrupt, T1IRQ, T0IRQ}; 

    CP0 cp0(.A1(M_rd),
            .A2(M_rd),
            .Din(m_data_wdata),
            .M_PC(m_inst_addr),
            .CPU_ExcCode(M_ExcCode),
            .HWInt(HWInt),
            .CPU_BD(M_BD),
            .WE(M_CP0Write),
            .EXLClr(M_eret),
            .clk(clk),
            .reset(reset),
            .IntReq(IntReq),
            .EPC(EPC),
            .Dout(CP0Result),
            .IntReturn(IntReturn));

   Bridge bridge(.PrAddr(m_data_addr),
                 .DMRD(m_data_rdata),
                 .Timer0RD(Timer0RD),
                 .Timer1RD(Timer1RD),
                 .byteen(CPU_byteen),
                 .DM_byteen(m_data_byteen),
                 .Timer0WE(Timer0WE),
                 .Timer1WE(Timer1WE),
                 .PrRD(CPU_rdata));

   assign TimerAddr =  m_data_addr[31:2];
   Timer Timer0(.clk(clk),
                .reset(reset),
                .Addr(TimerAddr),
                .WE(Timer0WE),
                .Din(m_data_wdata),
                .Dout(Timer0RD),
                .IRQ(T0IRQ));

    Timer Timer1(.clk(clk),
                .reset(reset),
                .Addr(TimerAddr),
                .WE(Timer1WE),
                .Din(m_data_wdata),
                .Dout(Timer1RD),
                .IRQ(T1IRQ));

    assign macroscopic_pc =  m_inst_addr;                                                      

endmodule