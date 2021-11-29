`define MWRITE 2'b11
`define MREAD 2'b01
`define MNONE 2'b00

module lab7_top(KEY, SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
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


    ram     MEM (   .clk(~KEY[0]),          .read_address(mem_addr[7:0]),   .write_address(mem_addr[7:0]), 
                    .write(write),          .din(w_data),                   .dout(dout));

    cpu     CPU (   .clk(~KEY[0]),          .reset(~KEY[1]),                .r_data(r_data), 
                    .mem_cmd(mem_cmd),      .mem_addr(mem_addr),            .w_data(w_data));

    SWctrl  SWctrl( .SW(SW),                .memCmdIn(mem_cmd),             .memAddrIn(mem_addr),
                    .readDataOut(r_data));

    LEDctrl LEDctrl(.LEDR(LEDR),            .memCmdIn(mem_cmd),             .memAddrIn(mem_addr),
                    .writeDataIn(w_data),   .clk(~KEY[0]));
endmodule

module SWctrl(SW, memCmdIn, memAddrIn, readDataOut);
    input [8:0] SW, memAddrIn;
    input [1:0] memCmdIn;

    output [15:0] readDataOut;

    wire triStateCtrl;

    assign triStateCtrl = (memCmdIn == `MREAD) && (memAddrIn == 9'h140);    //not sure about this second part
    assign readDataOut[15:8] = triStateCtrl ? 8'h00 : {8{1'bx}};
    assign readDataOut[7:0]  = triStateCtrl ? SW    : {8{1'bx}};            //not sure to use x or z
endmodule

module LEDctrl(LEDR, memCmdIn, memAddrIn, writeDataIn, clk);
    input [8:0] memAddrIn;
    input [7:0] writeDataIn;
    input [1:0] memCmdIn;
    input clk;

    output [7:0] LEDR;

    wire load;

    assign load = (memCmdIn == `MWRITE) && (memAddrIn == 9'h100); 

    regLoad #(8) LEDreg(writeDataIn, load, clk, LEDR);
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