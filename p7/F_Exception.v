`include "macro.v"
module F_Exception (
    input [31:0] pc,
    output [4:0] F_ExcCode
);
    
    assign F_ExcCode = (pc < `PCbegin || pc > `PCend) ? `AdEL : 
                     (pc[1:0] != 2'b00) ? `AdEL : `Int;

endmodule