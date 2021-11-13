//Standard multiplexer
module MUX(zero, one, sel, out);
    parameter width = 1;
    input [width-1:0] zero, one;
    output [width-1:0] out;

    out = sel ? one : zero;
endmodule

//a register with load enable
module regLoad(in, load, clk, out);
    parameter size = 16;
    input [size-1:0] in;
    input load;
    output [size-1:0] out;

    wire[size-1:0] muxToDFF, outToMux;

    MUX  #(size) myMUX(outToMux, in, load, muxToDFF);
    vDFF #(size) myDFF(muxToDFF, out, clk);
endmodule

module Dec38(in, out)
    input [2:0] in;
    output [7:0] out;

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
            default: out = 8'b00000000;
        endcase
    end
endmodule

// INSTRUCTIONS:
//
// You can use this file to demo your Lab5 on your DE1-SoC.  You should NOT 
// spend ANY time looking at this file until you have first read the Lab 5 
// handout completely and especially Sections 3 (Lab Procedure) and Section 4
// (which describes the marking scheme).
// 
// If you prefer you can instead use your own version of lab5_top.v.
//
// You MUST submit whichever lab5_top.v you used during your demo with handin.
//
// If you DO use this file you will need to fill in the sseg module as by
// default it will just print F's on HEX0 through HEX3.  Also, the signal 
// names inside the lab5_top module may need to be change to match the 
// ones you use in your own datapath module.



// DE1-SOC INTERFACE SPECIFICATION for lab5_top.v code in this file:
//
// clk input to datpath has rising edge when KEY0 is *pressed* 
//
// LEDR9 is the status register output (Z_out)
//
// HEX3, HEX2, HEX1, HEX0 are wired to datapath_out.
//
// When SW[9] is set to 1, SW[7:0] changes the lower 8 bits of datpath_in.
// (The upper 8-bits are hardwired to zero.) The LEDR[8:0] will show the
// current control inputs (LED "on" means input has logic value of 1).
//
// When SW[9] is set to 0, SW[8:0] changes the control inputs to the datapath
// as listed in the table below.  Note that the datapath has three main
// stages: register read, execute and writeback.  On any given clock cycle,
// you should only need to configure one of these stages so some switches are
// reused.  LEDR[7:0] will show the lower 8-bits of datapath_in (LED "on"
// means corresponding input has logic value of 1).
//
// control signal(s)  switch(es)
// ~~~~~~~~~~~~~~~~~  ~~~~~~~~~       
// <<register read stage>>
//           readnum  SW[3:1]
//             loada  SW[5]
//             loadb  SW[6]
// <<execute stage>>
//             shift  SW[2:1]
//              asel  SW[3]
//              bsel  SW[4]
//             ALUop  SW[6:5]
//             loadc  SW[7]
//             loads  SW[8]
// <<writeback stage>>
//             write  SW[0]      
//          writenum  SW[3:1]
//              vsel  SW[4]


module lab5_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,CLOCK_50);
  input [3:0] KEY;
  input [9:0] SW;
  
  output [9:0] LEDR; 
  output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  input CLOCK_50;

  wire [15:0] datapath_out, datapath_in;
  wire write, vsel, loada, loadb, asel, bsel, loadc, loads;
  wire [2:0] readnum, writenum;
  wire [1:0] shift, ALUop;

  input_iface IN(CLOCK_50, SW, datapath_in, write, vsel, loada, loadb, asel, 
                 bsel, loadc, loads, readnum, writenum, shift, ALUop, LEDR[8:0]);

  datapath DP ( .clk         (~KEY[0]), // recall from Lab 4 that KEY0 is 1 when NOT pushed

                // register operand fetch stage
                .readnum     (readnum),
                .vsel        (vsel),
                .loada       (loada),
                .loadb       (loadb),

                // computation stage (sometimes called "execute")
                .shift       (shift),
                .asel        (asel),
                .bsel        (bsel),
                .ALUop       (ALUop),
                .loadc       (loadc),
                .loads       (loads),

                // set when "writing back" to register file
                .writenum    (writenum),
                .write       (write),  
                .datapath_in (datapath_in),

                // outputs
                .Z_out       (LEDR[9]),
                .datapath_out(datapath_out)
             );

  // fill in sseg to display 4-bits in hexidecimal 0,1,2...9,A,B,C,D,E,F
  sseg H0(datapath_out[3:0],   HEX0);   
  sseg H1(datapath_out[7:4],   HEX1);
  sseg H2(datapath_out[11:8],  HEX2);
  sseg H3(datapath_out[15:12], HEX3);
  assign HEX4 = 7'b1111111;  // disabled
  assign HEX5 = 7'b1111111;  // disabled
endmodule


module input_iface(clk, SW, datapath_in, write, vsel, loada, loadb, asel, bsel, 
                   loadc, loads, readnum, writenum, shift, ALUop, LEDR);
  input clk;
  input [9:0] SW;
  output [15:0] datapath_in;
  output write, vsel, loada, loadb, asel, bsel, loadc, loads;
  output [2:0] readnum, writenum;
  output [1:0] shift, ALUop;
  output [8:0] LEDR;

  wire sel_sw = SW[9];  

  // When SW[9] is set to 1, SW[7:0] changes the lower 8 bits of datpath_in.
  wire [15:0] datapath_in_next = sel_sw ? {8'b0,SW[7:0]} : datapath_in;
  vDFF #(16) DATA(clk,datapath_in_next,datapath_in);

  // When SW[9] is set to 0, SW[8:0] changes the control inputs 
  //
  wire [8:0] ctrl_sw;
  wire [8:0] ctrl_sw_next = sel_sw ? ctrl_sw : SW[8:0];
  vDFF #(9) CTRL(clk,ctrl_sw_next,ctrl_sw);

  assign {readnum,vsel,loada,loadb,shift,asel,bsel,ALUop,loadc,loads,writenum,write}={
    // register operand fetch stage
    //     readnum       vsel        loada       loadb
           ctrl_sw[3:1], ctrl_sw[4], ctrl_sw[5], ctrl_sw[6], 
    // computation stage (sometimes called "execute")
    //     shift         asel        bse         ALUop         loadc       loads
           ctrl_sw[2:1], ctrl_sw[3], ctrl_sw[4], ctrl_sw[6:5], ctrl_sw[7], ctrl_sw[8],  
    // set when "writing back" to register file
    //   writenum        write
           ctrl_sw[3:1], ctrl_sw[0]    
  };

  // LEDR[7:0] shows other bits
  assign LEDR = sel_sw ? ctrl_sw : {1'b0, datapath_in[7:0]};  
endmodule         


module vDFF(clk,D,Q);
  parameter n=1;
  input clk;
  input [n-1:0] D;
  output [n-1:0] Q;
  reg [n-1:0] Q;

  always @(posedge clk)
    Q <= D;
endmodule


// The sseg module below can be used to display the value of datpath_out on
// the hex LEDS the input is a 4-bit value representing numbers between 0 and
// 15 the output is a 7-bit value that will print a hexadecimal digit.  You
// may want to look at the code in Figure 7.20 and 7.21 in Dally but note this
// code will not work with the DE1-SoC because the order of segments used in
// the book is not the same as on the DE1-SoC (see comments below).

module sseg(in, segs);
    input [3:0] in;
    output [6:0] segs;

    case(in)
        4'b0000 : segs = 7'b1000000;
        4'b0001 : segs = 7'b1111001;
        4'b0010 : segs = 7'b0100100;
        4'b0011 : segs = 7'b0110000;
        4'b0100 : segs = 7'b0011001;
        4'b0101 : segs = 7'b0010010;
        4'b0110 : segs = 7'b0000010;
        4'b0111 : segs = 7'b0111000;
        4'b1000 : segs = 7'b0000000;
        4'b1001 : segs = 7'b0011000;
        4'b1010 : segs = 7'b0001000;
        4'b1011 : segs = 7'b0000011;
        4'b1100 : segs = 7'b1000110;
        4'b1101 : segs = 7'b0100001;
        4'b1110 : segs = 7'b0000110;
        4'b1111 : segs = 7'b0001110;
    endcase
endmodule

