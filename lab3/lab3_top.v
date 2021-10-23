module lab3_top(SW,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,LEDR);
  input [9:0] SW;
  input [3:0] KEY;
  output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  output [9:0] LEDR; // optional: use these outputs for debugging on your DE1-SoC

  

  
endmodule

//State machine for numerical inputs
module stateMachine(in, clk, rst, out);
    `define A 4b'0001
    `define B 4b'0010
    `define C 4b'0011
    `define D 4b'0100
    `define E 4b'0101
    `define F 4b'0110

    `define Abad 4b'1001
    `define Bbad 4b'1010
    `define Cbad 4b'1011
    `define Dbad 4b'1100
    `define Ebad 4b'1101

    `define unlocked 4b'0000
    `define failed 4b'1111
    
    input clk, rst;
    input [3:0] in;
    output [4:0] out;
    reg [4:0] out;
    reg [3:0] state;

    always@(posedge clk)begin
        if(rst)begin
            state = A;
        end
        else begin
            if(state == 4b'0000 || state == 4b'1111)begin
                out = {1 , state};
            end
            else if(state[3] == 0)begin
                case(state)
                    `A: state = (in == 4b'0100) ? `B : `Abad;
                    `B: state = (in == 4b'1000) ? `C : `Bbad;
                    `C: state = (in == 4b'0011) ? `D : `Cbad;
                    `D: state = (in == 4b'1000) ? `E : `Dbad;
                    `E: state = (in == 4b'0001) ? `F : `Ebad;
                    `F: state = (in == 4b'0101) ? `unlocked : `failed;
                endcase
                out = {1, in};
            end
            else if(state[3] == 1)begin
                case(state)
                    `Abad: state = `Bbad;
                    `Bbad: state = `Cbad;
                    `Cbad: state = `Dbad;
                    `Dbad: state = `Ebad;
                    `Ebad: state = `failed;
                    `failed: state = `failed;
                endcase
                out = {1, in};
            end
        end
    end
endmodule

//CL block for input to LED display
module LEDDisplay(in, hex0, hex1, hex2, hex3, hex4, hex5);
    `define zero 7b'1111110
    `define one 7b'0000110
    `define two 7b'1101101
    `define three 7b'1111001
    `define four 7b'0110011
    `define five 7b'1011011
    `define six 7b'1011111
    `define seven 7b'1110000
    `define eight 7b'1111111
    `define nine 7b'1110011

    `define letE 7b'1001111
    `define letO 7b'0011101
    `define letR 7b'0000101
    `define letC 7b'1001110
    `define letL 7b'0001110
    `define letS 7b'1011011
    `define letD 7b'0111101
    `define letP 7b'1100111
    `define letN 7b'0010101

    input [4:0] in;
    output [6:0] hex0, hex1, hex2, hex3, hex4, hex5;

    always @(*) begin
        if(in[4] == 1)begin
            case(in)
                5b'10000:
                    hex3 = `letO;
                    hex2 = `letP;
                    hex1 = `letE;
                    hex0 = `letN;
                5b'11111:
                    hex5 = `letC;
                    hex4 = `letL;
                    hex3 = `letO;
                    hex2 = `letS;
                    hex1 = `letE;
                    hex0 = `letD;
            endcase
        end
        else begin
            hex5 = 7b'0000000;
            if(in[3] == 0)begin
            hex1 = 7b'0000000;
            hex2 = 7b'0000000;
            hex3 = 7b'0000000;
            hex4 = 7b'0000000;
            case(in)
                4b'00000: hex0 = `zero;
                4b'00001: hex0 = `one;
                4b'00010: hex0 = `two;
                4b'00011: hex0 = `three;
                4b'00100: hex0 = `four;
                4b'00101: hex0 = `five;
                4b'00110: hex0 = `six;
                4b'00111: hex0 = `seven;
            endcase
            end
            else begin
                casex(in)
                    4b'01000: 
                        hex0 = `eight;
                        hex1 = 7b'0000000;
                        hex2 = 7b'0000000;
                        hex3 = 7b'0000000;
                        hex4 = 7b'0000000;
                    4b'01001: 
                        hex0 = `nine;
                        hex1 = 7b'0000000;
                        hex2 = 7b'0000000;
                        hex3 = 7b'0000000;
                        hex4 = 7b'0000000;
                    4b'01010, 4b'1011, 4b'11XX: 
                        hex4 = `letE;
                        hex3 = `letR;
                        hex2 = `letR;
                        hex1 = `letO;
                        hex0 = `letR;
                    default:
                        hex0 = 7b'0000000;
                        hex1 = 7b'0000000;
                        hex2 = 7b'0000000;
                        hex3 = 7b'0000000;
                        hex4 = 7b'0000000;
                endcase
            end
        end
    end
endmodule

