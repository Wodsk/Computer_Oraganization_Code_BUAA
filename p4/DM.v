`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:01:59 11/15/2021 
// Design Name: 
// Module Name:    DM 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module DM(
    input clk,
	 input WE,
	 input reset,
	 input [31:0] PC,
	 input [31:0] A,
	 input [31:0] WD,
	 output [31:0] data
    );
    
	 reg [31:0] DM_Reg [0:1023];
	 integer i;
   
    initial begin
	   for(i = 0; i < 1024; i = i + 1)
		  begin
		    DM_Reg[i] = 0;
        end
    end
	 
    always @(posedge clk)
      begin
        if(reset == 1)
          begin
            for(i = 0; i < 1024; i = i + 1)
				  begin
					 DM_Reg[i] = 0;
              end					 
          end
		  else
          begin		  
            if(WE == 1)
              begin
                DM_Reg [A[11:2]] <= WD;
					 $display("@%h: *%h <= %h", PC, A, WD);
              end
			 end	  
      end  			 

      assign data = DM_Reg[A[11:2]];
endmodule
