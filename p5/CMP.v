`timescale 1ns / 1ps
module CMP (
    input [31:0] RD1,
    input [31:0] RD2,
    output [2:0] Cmp
);
    
    assign Cmp[0] = RD1 > RD2;
    assign Cmp[1] = RD1 == RD2;
    assign Cmp[2] = RD1 < RD2;
endmodule