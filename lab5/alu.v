module ALU(Ain, Bin, ALUop, out, Z);
    input [15:0] Ain, Bin;
    input [1:0] ALUop;
    output [15:0] out;
    output Z;

    case(ALUop)
        2'b00 : out = Ain + Bin;
        2'b01 : out = Ain - Bin;
        2'b10 : out = Ain & Bin;
        2'b11 : ~Bin;
    endcase    
endmodule