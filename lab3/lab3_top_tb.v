// TESTBENCHES
`define A 4'b0001
`define B 4'b0010
`define C 4'b0011
`define D 4'b0100
`define E 4'b0101
`define F 4'b0110
module test_success;
    reg [9:0] SW;
    reg [3:0] KEY;
    wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    wire [9:0] LEDR; // optional: use these outputs for debugging on your DE1-SoC

    wire [4:0] stateToLED;
    reg[23:0] STATES;

    assign STATES[3:0] = `A;
    assign STATES[7:4] = `B;
    assign STATES[11:8] = `C;
    assign STATES[15:12] = `D;
    assign STATES[19:16] = `E;
    assign STATES[23:20] = `F;

    lab3_top DUT(SW,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,LEDR);

    initial begin
        int i;
        //RESET LOCK
        KEY[3] = 1'b1;
        #5;
        KEY[0] = 1'b1;
        #5;
        KEY[0] = 1'b0;
        #5;
        KEY[3] = 1'b0;
        #5;

        //START UNLOCKING
        for (i = 3; i < 24; i = i + 4) begin
            #5;
            SW[3:0] = STATES[i:i-3];

            #5; 
            KEY[0] = 1'b1;
            #5;
            KEY[0] = 1'b0;

            $display("sw: %b display: %b",SW[3:0],HEX0);
        end
        // MUST INTERPRET BINARY RESULTS
        $display("%b %b %b %b %b %b",HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);  

        $display("TEST TEST TEST");
    end
endmodule