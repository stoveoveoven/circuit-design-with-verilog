module alu_tb
    reg[15:0] Ain, Bin;
    reg[1:0] ALUop;
    wire Z_out;
    wire [15:0] out;

    ALU DUT(Ain, Bin, ALUop, out, Z_out);

    initial begin
        Ain = 16'h0000; #10;
        Bin = 16'h1111; #10;
        ALUop = 2'b00; #10;

        #10;

        Ain = 16'h1111; #10;
        Bin = 16'h1111; #10;
        ALUop = 2'b01; #10;

        $stop;
    end

endmodule