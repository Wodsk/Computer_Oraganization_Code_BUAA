`timescale 1ns / 1ps
`include "macro.v"
module Forward (
    input [4:0] ReadAddr,
    input [4:0] M_RegAddr,
    input M_RegWrite,
    input [4:0] W_RegAddr,
    input W_RegWrite,
    output [1:0] ForwardSrc
);

    assign ForwardSrc = (ReadAddr === M_RegAddr) && (ReadAddr != 0) && (M_RegWrite === 1) ? `M_Forward :
                        (ReadAddr === W_RegAddr) && (ReadAddr != 0) && (W_RegWrite === 1) ? `W_Forward : 2'b00;

endmodule