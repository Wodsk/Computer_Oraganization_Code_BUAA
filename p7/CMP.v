`timescale 1ns / 1ps
`include "macro.v"
module CMP (
    input [31:0] RD1,
    input [31:0] RD2,
    input [3:0] Branch,//传入对应跳转的指令类型
    output BrWE);//是否进行跳转的使能信号，1表示进行跳转
    
    wire [31:0] rd1, rd2;
    reg temp_WE;
    wire [2:0] Cmp;

    assign rd1 = RD1;
    assign rd2 = (Branch == `BGEZ) ? 0 : RD2;

    assign Cmp[0] = $signed(rd1) > $signed(rd2);
    assign Cmp[1] = rd1 == rd2;
    assign Cmp[2] = $signed(rd1) < $signed(rd2);

    always @(*) begin
        case (Branch)
            `BEQ: begin
                if(Cmp[1] == 1) temp_WE = 1;//RD1 == RD2 then move
                else temp_WE = 0;
            end
            `BNE: begin
                if(Cmp[1] == 0) temp_WE = 1;//RD1 != RD2 then move
                else temp_WE = 0;
            end
            `BLEZ: begin
                if(Cmp[0] == 0) temp_WE = 1;//RD1 <= 0 then move(RD1 > 0 do not success)
                else temp_WE = 0;
            end
            `BGTZ: begin
                if(Cmp[0] == 1) temp_WE = 1;//RD1 > 0 then move
                else temp_WE = 0;
            end
            `BLTZ: begin
                if(Cmp[2] == 1) temp_WE = 1;//RD1 < 0 then move
                else temp_WE = 0;
            end
            `BGEZ: begin
                if(Cmp[2] == 0) temp_WE = 1;//RD1 >= 0 then move
                else temp_WE = 0;
            end
            default: temp_WE = 0;  
        endcase
        
    end

    assign BrWE = temp_WE;

endmodule