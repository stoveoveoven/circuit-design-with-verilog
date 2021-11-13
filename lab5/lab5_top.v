//top level module for the RISC
module labt_top();

endmodule

//Register file
module regFile(writenum, write, data_in, clk, readnum, data_out);
    input [2:0] writenum, readnum;
    input write, clk;
    input [15:0] data_in;
    output [15:0] data_out;

    wire[7:0] decOut;

    Dec38 dec(writenum, decOut);


endmodule

//Standard multiplexer
module MUX(zero, one, sel, out);
    parameter width = 1;
    input [width-1:0] zero, one;
    output [width-1:0] out;

    out = sel ? one : zero;
endmodule

//Shifter units that shifts left or right depending on input
module shifter16(in, cmd, out);
    input [15:0] in;
    input [1:0] cmd;
    output [15:0] out;

    case(cmd)
        2'b00 : out = in;
        2'b01 : out = {in[14:0], 1'b0};
        2'b10 : out = {1'b0, in[15:1]};
        2'b11 : out = {in[15], in[15:1]};
    endcase
endmodule

//a register with load enable
module regLoad(in, load, clk, out);
    parameter size = 16;
    input [size-1:0] in;
    input load;
    output [size-1:0] out;

    wire[size-1:0] muxToDFF, outToMux;

    MUX #(size) myMUX(outToMux, in, load, muxToDFF);
    DFF #(size) myDFF(muxToDFF, out, clk);
endmodule

//Arithmetic Logic unit, handles ADD/SUB
module ALU(Ain, Bin, cmd, out);
    parameter width = 16;
    input [width-1:0] Ain, Bin;
    input [1:0] cmd;
    output [width-1:0] out;

    case(cmd)
        2'b00 : out = Ain + Bin;
        2'b01 : out = Ain - Bin;
        2'b10 : out = Ain & Bin;
        2'b11 : ~Bin;
    endcase    
endmodule

module DFF(in, out, clk);
    parameter width = 1;
    input [width-1:0] in;
    output reg [width-1:0] out;
    
    always@(posedge clk)begin
        out = in;
    end
endmodule

module Dec38(in, out){
    input [2:0] in;
    output [7:0] out;

    always@(in){
        case(in)
            3'b000 : out = 7'b0000000;
            3'b001 : out = 7'b0000001;
            3'b010 : out = 7'b0000010;
            3'b011 : out = 7'b0000100;
            3'b100 : out = 7'b0001000;
            3'b101 : out = 7'b0010000;
            3'b110 : out = 7'b0100000;
            3'b111 : out = 7'b1000000;
        endcase
    }
}
