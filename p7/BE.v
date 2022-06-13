`include "macro.v"
module BE (
    input IntReturn,
    input IntReq, 
    input [1:0] Addr,
    input [2:0] BEop,
	input [31:0] temp_m_data_wdata,
	output [31:0] m_data_wdata,
    output [3:0] m_data_byteen
);//生成DM的字节使能信�
   
    reg [3:0] temp_byteen;
	reg [31:0] result;

   always @(*) begin
       if(IntReturn) begin
           result = 32'h00000001;
           temp_byteen = 4'b1111;
       end
       else if (IntReq) begin
           temp_byteen = 0;
            result = temp_m_data_wdata;
       end
       else begin
           case (BEop)
        `SW: begin
		        temp_byteen = `byte3 | `byte2 | `byte1 | `byte0;
				result = temp_m_data_wdata;
				end 
        `SH: begin
            if(Addr[1] == 0) begin
				   temp_byteen = `byte1 | `byte0;
               result[15:0] = temp_m_data_wdata[15:0]; 
				end 
            else begin
				   temp_byteen = `byte3 | `byte2;
               result[31:16] = temp_m_data_wdata[15:0];
				end		
        end
        `SB: begin
            case (Addr)
                2'b00: begin
                    temp_byteen = `byte0;
                    result[7:0] = temp_m_data_wdata[7:0];
                end
                2'b01: begin
                    temp_byteen = `byte1;
                    result[15:8] = temp_m_data_wdata[7:0];
                end
                2'b10: begin
                    temp_byteen = `byte2;
                    result[23:16] = temp_m_data_wdata[7:0];
                end
                2'b11: begin
                    temp_byteen = `byte3;
                    result[31:24] = temp_m_data_wdata[7:0];
                end
                default: temp_byteen = 0; 
            endcase
        end
        default: begin
            temp_byteen = 0;
            result = temp_m_data_wdata;
        end
       endcase
       end
   end

   assign m_data_byteen = temp_byteen;
   assign m_data_wdata = result; 
endmodule		