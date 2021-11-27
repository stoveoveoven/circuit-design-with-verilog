module lab7_top(KEY, SW, LEDR, HEX), HEX1, HEX2, HEX3, HEX4, HEX5);
    input [3:0] KEY;
    input [9:0] SW;
    output [9:0] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    wire [15:0] r_data, w_data, dout;
    wire [8:0]  mem_addr;
    wire [1:0]  mem_cmd;
    wire        dout_enable, write;


    assign write       = (1'b0 == mem_addr[8:8]) && (`MWRITE == mem_cmd);
    assign dout_enable = (1'b0 == mem_addr[8:8]) && (`MREAD  == mem_cmd);

    assign r_data      = dout_enable ? dout : {16{1'bz}};
    

    ram MEM (   .clk(~KEY[0]),      .read_address(mem_addr[7:0]),   .write_address(mem_addr[7:0]), 
                .write(write),      .din(w_data),                   .dout(dout));

    cpu CPU (   .clk(~KEY[0]),      .reset(~KEY[1]),                .r_data(r_data), 
                .mem_cmd(mem_cmd),  .mem_addr(mem_addr)             .w_data(w_data));
endmodule

module input_iface(clk, SW, ir, LEDR);
  input clk;
  input [9:0] SW;

  output [15:0] ir;
  output [7:0] LEDR;

  wire sel_sw = SW[9];  
  wire [15:0] ir_next = sel_sw ? {SW[7:0],ir[7:0]} : {ir[15:8],SW[7:0]};

  vDFF #(16) REG(clk,ir_next,ir);

  assign LEDR = sel_sw ? ir[7:0] : ir[15:8];  
endmodule         

//Standard vDFF
module vDFF(clk,D,Q);
  parameter n=1;
  input clk;
  input [n-1:0] D;
  output [n-1:0] Q;
  reg [n-1:0] Q;

  always @(posedge clk)
    Q <= D;
endmodule

//Standard multiplexer
module MUX(zero, one, sel, out);
    parameter width = 1;
    input [width-1:0] zero, one;
    input sel;
    output [width-1:0] out;

    assign out = sel ? one : zero;
endmodule

//a register with load enable
module regLoad(in, load, clk, out);
    parameter n = 1;
    input [n-1:0] in;
    input load, clk;
    output [n-1:0] out;

    wire[n-1:0] muxToDFF, outToMux;
    assign outToMux = out; // could be problematic

    MUX  #(n) myMUX(outToMux, in, load, muxToDFF);
    vDFF #(n) myDFF(clk, muxToDFF, out);
endmodule

//Standard 3:8 decoder
module Dec38(in, out);
    input [2:0] in;
    output reg [7:0] out;

    always@(in)begin
        case(in)
            3'b000 : out = 8'b00000001;
            3'b001 : out = 8'b00000010;
            3'b010 : out = 8'b00000100;
            3'b011 : out = 8'b00001000;
            3'b100 : out = 8'b00010000;
            3'b101 : out = 8'b00100000;
            3'b110 : out = 8'b01000000;
            3'b111 : out = 8'b10000000;
            default: out = 8'bxxxxxxxx;
        endcase
    end
endmodule

// The sseg module below can be used to display the value of datpath_out on
// the hex LEDS the input is a 4-bit value representing numbers between 0 and
// 15 the output is a 7-bit value that will print a hexadecimal digit.  You
// may want to look at the code in Figure 7.20 and 7.21 in Dally but note this
// code will not work with the DE1-SoC because the order of segments used in
// the book is not the same as on the DE1-SoC (see comments below).

module sseg(in, segs);
  //
  // One bit per segment. On the DE1-SoC a HEX segment is illuminated when
  // the input bit is 0. Bits 6543210 correspond to:
  //
  //    0000
  //   5    1
  //   5    1
  //    6666
  //   4    2
  //   4    2
  //    3333
  //
  // Decimal value | Hexadecimal symbol to render on (one) HEX display
  //             0 | 0
  //             1 | 1
  //             2 | 2
  //             3 | 3
  //             4 | 4
  //             5 | 5
  //             6 | 6
  //             7 | 7
  //             8 | 8
  //             9 | 9
  //            10 | A
  //            11 | b
  //            12 | C
  //            13 | d
  //            14 | E
  //            15 | F
    input [3:0] in;
    output reg [6:0] segs;

    always@(in)begin
        case(in)
            4'b0000 : segs = 7'b1000000;
            4'b0001 : segs = 7'b1111001;
            4'b0010 : segs = 7'b0100100;
            4'b0011 : segs = 7'b0110000;
            4'b0100 : segs = 7'b0011001;
            4'b0101 : segs = 7'b0010010;
            4'b0110 : segs = 7'b0000010;
            4'b0111 : segs = 7'b1111000;
            4'b1000 : segs = 7'b0000000;
            4'b1001 : segs = 7'b0011000;
            4'b1010 : segs = 7'b0001000;
            4'b1011 : segs = 7'b0000011;
            4'b1100 : segs = 7'b1000110;
            4'b1101 : segs = 7'b0100001;
            4'b1110 : segs = 7'b0000110;
            4'b1111 : segs = 7'b0001110;
        endcase
    end
    
endmodule