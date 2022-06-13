`include "macro.v"
module MAD (
    input clk,
    input reset,
    input [31:0] A, //转发后的GRF[rs]
    input [31:0] B, //转发后的GRF[rt]
    input [2:0] MADop,
    output [31:0] HI,
    output [31:0] LO,
    output Busy);

    reg [31:0] High, Low;

    reg [70:0] prod;
    wire [32:0] UA, UB;
    reg [31:0] rest, div;
    reg [3:0] Tnum;
    reg [2:0] op;
    reg busy;
	 
	 assign UA = {1'b0,A};
	 assign UB = {1'b0,B};

    initial begin
        High = 0;
        Low = 0;
		  prod = 0;
		  rest = 0;
		  div = 0;
        Tnum = 0;
        busy = 0;
        op = 0;
    end    

    always @(posedge clk) begin
        if(reset == 1) begin
            High <= 0;
            Low <= 0;
				prod <= 0;
				rest <= 0;
				div <= 0;
            Tnum <= 0;
            busy <= 0 ;
            op <= 0;
        end    
        else begin
            if(busy == 1) begin//doing mult or div now
              if((op == `MULT || op == `MULTU) && Tnum == 4) begin
                  High <= prod[63:32];
                  Low <= prod[31:0];
                  busy <= 0; 
              end
              else if ((op == `DIV || op ==`DIVU) && Tnum == 9) begin
                  Low <= div;
                  High <= rest;
                  busy <= 0;
              end
              else begin
                  Tnum <= Tnum + 1;
              end
            end
            else begin
                case (MADop)
                    `HI_Write: High <= A;
                    `LO_Write: Low <= A;
                    `MULT: begin
                        op <= MADop;
								prod <= $signed(A) * $signed(B);
                        Tnum <= 0;
                        busy <= 1;
                    end
                    `DIV: begin
                        op <= MADop;
								div = $signed(A) / $signed(B);
								rest = $signed(A) % $signed(B);
                        Tnum <= 0;
                        busy <= 1;
                    end
                    `MULTU: begin
                        op <= MADop;
								prod <= UA * UB;
                        Tnum <= 0;
                        busy <= 1;
                    end
                    `DIVU:  begin
                        op <= MADop;
                        div <= UA / UB;
								rest <= UA % UB;
                        Tnum <= 0;
                        busy <= 1;
                    end
                endcase
            end
        end    
    end
    
    assign HI = High;
    assign LO = Low;
    assign Busy = busy;
    
endmodule