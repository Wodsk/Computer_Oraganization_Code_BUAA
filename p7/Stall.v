`timescale 1ns / 1ps
`include "macro.v"
module Stall (
    input [2:0] Tuse_rs,
    input [2:0] Tuse_rt,
    input [4:0] D_rs,
    input [4:0] D_rt,
    input D_eret,
    input HILO,
    input E_Busy,
    input E_CP0Write,
    input [2:0] E_Tnew,
    input [4:0] E_rd,
    input [4:0] E_RegAddr,
    input M_CP0Write,
    input [2:0] M_Tnew,
    input [4:0] M_rd,
    input [4:0] M_RegAddr,
    output Stall);

    wire E_Stall, M_Stall, HILO_Stall, CP0_Stall;

   assign E_Stall = ((D_rs == E_RegAddr) && (Tuse_rs < E_Tnew) && (D_rs != 0)) ||
                    ((D_rt == E_RegAddr) && (Tuse_rt < E_Tnew) && (D_rt != 0));

   assign M_Stall = ((D_rs == M_RegAddr) && (Tuse_rs < M_Tnew) && (D_rs != 0)) ||
                    ((D_rt == M_RegAddr) && (Tuse_rt < M_Tnew) && (D_rt != 0));

   assign HILO_Stall = HILO && E_Busy;
   assign CP0_Stall = D_eret && ((E_CP0Write && E_rd == 5'd14) || (M_CP0Write && M_rd == 5'd14));
   assign Stall = E_Stall || M_Stall || HILO_Stall || CP0_Stall;                                  
    
endmodule