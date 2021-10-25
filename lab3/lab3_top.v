//top level module
module lab3_top(SW,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,LEDR);
    input [9:0] SW;
    input [3:0] KEY;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    output [9:0] LEDR; // optional: use these outputs for debugging on your DE1-SoC

    wire [3:0] state;

    stateMachine lock(SW[3:0], ~KEY[0], ~KEY[3], state);
    HEXDisplay SWtoHEX(SW[3:0], HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, state);
endmodule

//State machine for numerical inputs
`define A 4'b0001
`define B 4'b0010
`define C 4'b0011
`define D 4'b0100
`define E 4'b0101
`define F 4'b0110

`define Abad 4'b1001
`define Bbad 4'b1010
`define Cbad 4'b1011
`define Dbad 4'b1100
`define Ebad 4'b1101

`define unlocked 4'b0000
`define failed 4'b1111
module stateMachine(in, clk, rst, out);
    input clk, rst;
    input [3:0] in;
    output reg [3:0] out;
    reg [3:0] state;

    always@(posedge clk)begin
        if(rst)begin
            state = `A;
        end
        else begin
            case(state)
                `A: state = (in == 4'b0100) ? `B : `Abad;
                `B: state = (in == 4'b1000) ? `C : `Bbad;
                `C: state = (in == 4'b0011) ? `D : `Cbad;
                `D: state = (in == 4'b1000) ? `E : `Dbad;
                `E: state = (in == 4'b0001) ? `F : `Ebad;
                `F: state = (in == 4'b0101) ? `unlocked : `failed;
                `Abad: state = `Bbad;
                `Bbad: state = `Cbad;
                `Cbad: state = `Dbad;
                `Dbad: state = `Ebad;
                `Ebad: state = `failed;
                `failed: state = `failed;
            endcase	
        end
        out <= state;
    end
endmodule

//CL block for input to LED display
`define zero 7'b1000000
`define one 7'b1001111
`define two 7'b0100100
`define three 7'b0110000
`define four 7'b0011001
`define five 7'b0010010
`define six 7'b0000010
`define seven 7'b1111000
`define eight 7'b0000000
`define nine 7'b0011000

`define letE 7'b0000110
`define letO 7'b0100011
`define letR 7'b0101111
`define letC 7'b1000110
`define letL 7'b1000111
`define letS 7'b0010010
`define letD 7'b0100001
`define letP 7'b0001100
`define letN 7'b0101011

`define OFF 7'b1111111
module HEXDisplay(in, hex0, hex1, hex2, hex3, hex4, hex5, state);
    input [3:0] in;
    input [3:0] state;
    output reg [6:0] hex0, hex1, hex2, hex3, hex4, hex5;

    always @(in, state) begin
        if(state == 4'b1111 || state == 4'b0000)begin
            case(state)
                4'b0000: begin
                    hex5 = `OFF;
                    hex4 = `OFF;
                    hex3 = `letO;
                    hex2 = `letP;
                    hex1 = `letE;
                    hex0 = `letN;
                end
                4'b1111: begin
                    hex5 = `letC;
                    hex4 = `letL;
                    hex3 = `letO;
                    hex2 = `letS;
                    hex1 = `letE;
                    hex0 = `letD;
                end
                default: begin //unreachable
                    hex5 = `OFF;
                    hex4 = `letE;
                    hex3 = `letR;
                    hex2 = `letR;
                    hex1 = `letO;
                    hex0 = `letR;
		        end
            endcase
        end
        else begin
            hex5 = `OFF;
            casex(in)
                4'b1010: begin
                    hex4 = `letE;
                    hex3 = `letR;
                    hex2 = `letR;
                    hex1 = `letO;
                    hex0 = `letR;
                end
                4'b1011: begin
                    hex4 = `letE;
                    hex3 = `letR;
                    hex2 = `letR;
                    hex1 = `letO;
                    hex0 = `letR;
                end
                4'b11XX: begin
                    hex4 = `letE;
                    hex3 = `letR;
                    hex2 = `letR;
                    hex1 = `letO;
                    hex0 = `letR;
                end
                default: begin
                    hex4 = `OFF;
                    hex3 = `OFF;
                    hex2 = `OFF;
                    hex1 = `OFF;
                    case(in)
                        4'b0000: hex0 = `zero;
                        4'b0001: hex0 = `one;
                        4'b0010: hex0 = `two;
                        4'b0011: hex0 = `three;
                        4'b0100: hex0 = `four;
                        4'b0101: hex0 = `five;
                        4'b0110: hex0 = `six;
                        4'b0111: hex0 = `seven;
                        4'b1000: hex0 = `eight;
                        4'b1001: hex0 = `nine;
                        default: hex0 = `OFF;
                    endcase
                end
            endcase
        end
    end
endmodule

