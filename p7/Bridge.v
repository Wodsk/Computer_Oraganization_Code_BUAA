`include "macro.v"
module Bridge (
    input [31:0] PrAddr,
    input [31:0] DMRD,
    input [31:0] Timer0RD,
    input [31:0] Timer1RD,
    input [3:0] byteen,
    output [3:0] DM_byteen,
    output Timer0WE,
    output Timer1WE,
    output [31:0] PrRD
);
   
   wire WE;//use in the Timer write
   assign WE = |byteen;
   
//Information about WE
   assign DM_byteen = ((PrAddr >= `DMbegin && PrAddr <= `DMend) || PrAddr == 32'h00007F20) ? byteen : 4'b0;
   assign Timer0WE = (PrAddr >= `Timer0begin && PrAddr <= `Timer0end) ? WE : 1'b0;
   assign Timer1WE = (PrAddr >= `Timer1begin && PrAddr <= `Timer1end) ? WE : 1'b0;  
//Information about RD

  assign PrRD = (PrAddr >= `DMbegin && PrAddr <= `DMend) ? DMRD : 
                (PrAddr >= `Timer0begin && PrAddr <= `Timer0end) ? Timer0RD :
                (PrAddr >= `Timer1begin && PrAddr <= `Timer1end) ? Timer1RD : 32'hxxxxxxxx; 


endmodule