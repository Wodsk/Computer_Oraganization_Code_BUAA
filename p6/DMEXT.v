`include "macro.v"
module DMEXT (
    input [1:0] A,
    input [31:0] Din,
    input [2:0] DMEXTop,
    output [31:0] Dout
);//用于对DM取出的数据进行处�
    
    reg [7:0] Byte;
    reg [15:0] half_word;
    reg [31:0] temp_Dout;
    
    always @(*) begin
        case (DMEXTop)
            `LBU: begin
                case (A)
                    2'b00: Byte = Din[7:0];
                    2'b01: Byte = Din[15:8];
                    2'b10: Byte = Din[23:16];
                    2'b11: Byte = Din[31:24]; 
                endcase
                temp_Dout = {{24{1'b0}}, Byte};
            end
            `LB: begin
                case (A)
                    2'b00: Byte = Din[7:0];
                    2'b01: Byte = Din[15:8];
                    2'b10: Byte = Din[23:16];
                    2'b11: Byte = Din[31:24]; 
                endcase
                temp_Dout = {{24{Byte[7]}}, Byte};
            end
            `LHU: begin
                case (A[1])
                    1'b0: half_word = Din[15:0];
                    1'b1: half_word = Din[31:16];
                endcase
                temp_Dout = {{16{1'b0}}, half_word};
            end
            `LH: begin
                case (A[1])
                    1'b0: half_word = Din[15:0];
                    1'b1: half_word = Din[31:16];
                endcase
                temp_Dout = {{16{half_word[15]}}, half_word};
            end
            default: temp_Dout = Din; 
        endcase
    end

    assign Dout = temp_Dout;
endmodule