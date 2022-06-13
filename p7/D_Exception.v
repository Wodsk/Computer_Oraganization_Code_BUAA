`include "macro.v"
module D_Exception (
    input RI,
    input [4:0] F_ExcCode,
    output [4:0] D_ExcCode
);
    assign D_ExcCode = (RI) ? `RI : F_ExcCode;
endmodule