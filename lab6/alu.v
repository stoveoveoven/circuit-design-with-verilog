module ALU(Ain, Bin, ALUop, out, Z);
    input [15:0] Ain, Bin;
    input [1:0] ALUop;
    output reg [15:0] out;
    output Z;

    always@(*)begin
        case(ALUop)
            2'b00 : out = Ain + Bin;
            2'b01 : out = Ain - Bin;
            2'b10 : out = Ain & Bin;
            2'b11 : out = ~Bin;
        endcase
    end

    assign Z = (out == 2'b00) ? 1'b1 : 1'b0;
endmodule