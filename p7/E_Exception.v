`include "macro.v"
module E_Exception (
    input Ov,
    input [4:0] D_ExcCode,
    output [4:0] E_ExcCode
);
  
   assign E_ExcCode = (Ov) ? `Ov : D_ExcCode;
    
endmodule