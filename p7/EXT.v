`timescale 1ns / 1ps
`include "macro.v"
module EXT(
   input [15:0] Imm,
   input EXTop,
   input [1:0] Shiftop,
   output [31:0] EXT_Imm
    );
   
   reg [31:0] temp_data;
	 
	always @(*) begin
	  if(EXTop == `Sign_EXT) temp_data = {{16{Imm[15]}}, Imm};
	  else if(EXTop == `Zero_EXT) temp_data = {{16{1'b0}}, Imm};
	  else temp_data = 0;
		  
	  if(Shiftop == `two_bits_lshift) temp_data = temp_data << 2;
	  else if(Shiftop == `sixteen_bits_lshift) temp_data = temp_data << 16;	
	end

    
	assign EXT_Imm = temp_data;		
endmodule
