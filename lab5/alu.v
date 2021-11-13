module ALU(Ain, Bin, ALUop, out, Z_out);
    input [15:0] Ain, Bin;
    input [1:0] ALUop;
    output [15:0] out;
    output Z_out;

    case(ALUop)
        2'b00 : out = Ain + Bin;
        2'b01 : out = Ain - Bin;
        2'b10 : out = Ain & Bin;
        2'b11 : ~Bin;
    endcase

    if(out == 2'b00)
        Z = 1'b1;
    else begin
        Z = 1'b0;
    end
endmodule