module cpu(clk, reset, s, load, in, out, N, V, Z, w);
    input clk, reset, s, load;
    input [15:0] in;
    output [15:0] out;
    output N,V,Z,w;

    wire [15:0] inst_regToDec

    regLoad #(16) instructReg(in, load, clk, inst_regToDec);

endmodule