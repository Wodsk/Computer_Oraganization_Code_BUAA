`timescale 1ns / 1ps
`include "macro.v"
module Forward (
    input [4:0] CMP1_ReadAddr,
    input [4:0] CMP2_ReadAddr,
    input [4:0] EA_ReadAddr,
    input [4:0] EB_ReadAddr,
    input [4:0] DMWD_ReadAddr,
    input [4:0] E_RegAddr,//这里只转发lui和PC + 8，不用担心转发了一个错误数据，我们的机制保证了暴力转发的正确�
    input E_RegWrite,
    input [4:0] M_RegAddr,
    input M_RegWrite,
    input [4:0] W_RegAddr,
    input W_RegWrite,
    output [2:0] CMP1FMUXSrc,
    output [2:0] CMP2FMUXSrc,
    output [2:0] EAFMUXSrc,
    output [2:0] EBFMUXSrc,
    output [2:0] DMWDFMUXSrc
);


    assign CMP1FMUXSrc = (CMP1_ReadAddr === E_RegAddr) && (CMP1_ReadAddr != 0) && (E_RegWrite === 1) ? `E_Forward :
                         (CMP1_ReadAddr === M_RegAddr) && (CMP1_ReadAddr != 0) && (M_RegWrite === 1) ? `M_Forward : `origin;

    assign CMP2FMUXSrc = (CMP2_ReadAddr === E_RegAddr) && (CMP2_ReadAddr != 0) && (E_RegWrite === 1) ? `E_Forward :
                         (CMP2_ReadAddr === M_RegAddr) && (CMP2_ReadAddr != 0) && (M_RegWrite === 1) ? `M_Forward : `origin;

    assign EAFMUXSrc = (EA_ReadAddr === M_RegAddr) && (EA_ReadAddr != 0) && (M_RegWrite === 1) ? `M_Forward :
                         (EA_ReadAddr === W_RegAddr) && (EA_ReadAddr != 0) && (W_RegWrite === 1) ? `W_Forward : `origin;

    assign EBFMUXSrc = (EB_ReadAddr === M_RegAddr) && (EB_ReadAddr != 0) && (M_RegWrite === 1) ? `M_Forward :
                         (EB_ReadAddr === W_RegAddr) && (EB_ReadAddr != 0) && (W_RegWrite === 1) ? `W_Forward : `origin;
    
    assign DMWDFMUXSrc = (DMWD_ReadAddr === W_RegAddr) && (DMWD_ReadAddr != 0) && (W_RegWrite === 1) ? `W_Forward : `origin;
endmodule