`include "macro.v"
module M_Exception (
    input [2:0] Load,//switch which load Instr it is
    input [2:0] Store,//switch which store Instr it is
    input [31:0] m_data_addr,
    input [4:0] E_ExcCode,
    output [4:0] M_ExcCode
);
    wire InTimer0, InTimer1, InDM, InT0C, InT1C;

    assign InTimer0 = m_data_addr >= `Timer0begin && m_data_addr <= `Timer0end;
    assign InTimer1 = m_data_addr >= `Timer1begin && m_data_addr <= `Timer1end;
    assign InDM = m_data_addr >= `DMbegin && m_data_addr <= `DMend;
    assign InT0C = m_data_addr >= `T0Cbegin && m_data_addr <= `T0Cend;
    assign InT1C = m_data_addr >= `T1Cbegin && m_data_addr <= `T1Cend; 

    assign M_ExcCode = ((Load == `LW) && (m_data_addr[1:0] != 2'b00)) ? `AdEL :
                       ((Load == `LH || Load == `LHU) && (m_data_addr[0] != 1'b0)) ? `AdEL :
                       ((Load == `LH || Load == `LHU || Load == `LB || Load == `LBU) && (InTimer0 || InTimer1)) ? `AdEL :
                       ((Load != `Load_Default) && (E_ExcCode == `Ov)) ? `AdEL :
                       ((Load != `Load_Default) && (!InTimer0) && (!InTimer1) && (!InDM)) ? `AdEL :
                       ((Store == `SW) && (m_data_addr[1:0] != 2'b00)) ? `AdES :
                       ((Store == `SH) && (m_data_addr[0] != 1'b0)) ? `AdES :
                       ((Store == `SH || Store == `SB) && (InTimer0 || InTimer1)) ? `AdES :
                       ((Store != `Store_Default) && (E_ExcCode == `Ov)) ? `AdES :
                       ((Store != `Store_Default) && (InT0C || InT1C)) ? `AdES :
                       ((Store != `Store_Default) && (!InTimer0) && (!InTimer1) && (!InDM)) ? `AdES : E_ExcCode;

endmodule