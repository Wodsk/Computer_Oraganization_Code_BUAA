`include "macro.v"
module CP0 (
    input [4:0] A1,// address of read
    input [4:0] A2,// address of write
    input [31:0] Din,
    input [31:0] M_PC,
    input [6:2] CPU_ExcCode,
    input [5:0] HWInt,
    input CPU_BD,
    input WE,
    input EXLClr,
    input clk,
    input reset,
    output IntReq,
    output [31:0] EPC,
    output [31:0] Dout,
    output IntReturn
);
    wire [31:0] SR, Cause;
	 reg [31:0] temp_Dout;
    reg [31:0] PRID;
    reg [31:0] temp_EPC;
    reg [15:10] IM, IP;
    reg [6:2] ExcCode;
    reg IE, EXL, BD, temp_IntReturn;
    

    assign SR = {16'b0, IM[15:10], 8'b0, EXL, IE};
    assign Cause = {BD, 15'b0, IP[15:10], 3'b0, ExcCode[6:2], 2'b0};
    
    wire OutInt = HWInt[2] && IE && IM[12] && !EXL;

    initial begin
        PRID = "p7";
        IM = 0;
        IP = 0;
        ExcCode = 0;
        temp_EPC = 0;
        IE = 0;
        EXL = 0;
        BD = 0;
        temp_Dout = 0;
        temp_IntReturn = 0;
    end

//Infomation about Interrupt and Exception
   wire IReq, EReq;
   
   assign IReq = (EXL == 0) && (|(IM & HWInt)) && IE;
   assign EReq = (EXL == 0) && (|CPU_ExcCode);

   assign IntReq = IReq | EReq;
//modify the CP0 register when Interrupt occur

  always @(posedge clk) begin
      IP[15:10] <= HWInt;
      if(IntReq) begin
          EXL <= 1;
          ExcCode <= (IReq) ? `Int : CPU_ExcCode;
          BD <= CPU_BD;
          if(CPU_BD) temp_EPC = M_PC - 4;
          else temp_EPC = M_PC;
      end
      if(EXLClr) begin
          EXL <= 0;
      end
      if(OutInt == 1) temp_IntReturn <= 1'b1;
      if(OutInt == 0) temp_IntReturn <= 1'b0;
  end

  assign IntReturn = temp_IntReturn;   
//Write the CP0 register
   always @(*) begin
        case (A1)
            5'd12: temp_Dout = SR;
            5'd13: temp_Dout = Cause;
            5'd14: temp_Dout = temp_EPC;
            5'd15: temp_Dout = PRID; 
            default: temp_Dout = 0;
        endcase
    end

    assign Dout = temp_Dout;

    always @(posedge clk) begin
        if(reset) begin
            PRID = "p7";
            IM = 0;
            IP = 0;
            ExcCode = 0;
            temp_EPC = 0;
            IE = 0;
            EXL = 0;
            BD = 0;
            temp_Dout = 0;
            temp_IntReturn = 0;
        end
        if(WE) begin
            case (A2)
                5'd12: begin
                    IM[15:10] <= Din[15:10];
                    EXL <= Din[1];
                    IE <= Din[0];
                end 
                5'd14: temp_EPC <= Din;
                default:;
            endcase
        end
    end
  
  assign EPC = temp_EPC;
endmodule