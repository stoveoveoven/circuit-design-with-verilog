module ALU(Ain, Bin, ALUop, out, stat);
    input [15:0] Ain, Bin;
    input [1:0] ALUop;
    output reg [15:0] out;
    output [2:0] stat;

    always@(*)begin
        case(ALUop)
            2'b00 : out = Ain + Bin;
            2'b01 : out = Ain - Bin;
            2'b10 : out = Ain & Bin;
            2'b11 : out = ~Bin;
        endcase
    end

    //stat assignment
    assign stat[0] = (out == 16'd0);                                                            //Z - checks if answer is 0
    assign stat[1] = (~out[15] && Ain[15] && ~Bin[15]) || (out[15] && ~Ain[15] && Bin[15]);     //V - overflow detection
    assign stat[2] = out[15];                                                                   //N - 2's complement status
endmodule
