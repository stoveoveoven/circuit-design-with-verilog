// TESTBENCHES

module test_success;
`define A 4'b0001
`define B 4'b0010
`define C 4'b0011
`define D 4'b0100
`define E 4'b0101
`define F 4'b0110

    reg [9:0] SW;
    reg [3:0] KEY;
    wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    wire [9:0] LEDR; // optional: use these outputs for debugging on your DE1-SoC

    wire [4:0] stateToLED;
    
    lab3_top DUT(SW,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,LEDR);

    initial begin
        
        //RESET LOCK
	KEY[0] = 1'b1;
        #5;        
	KEY[3] = 1'b0;
        #5;
	KEY[0] = 1'b0;        
        #5;
        KEY[3] = 1'b1;
        #5;

	//STATE A
        #5;
        SW[3:0] = `A;

        #5; 
        KEY[0] = 1'b1;
        #5;
        KEY[0] = 1'b0;

        $display("sw: %b display: %b",SW[3:0],HEX0);

	//STATE B
        #5;
        SW[3:0] = `B;

        #5; 
        KEY[0] = 1'b1;
        #5;
        KEY[0] = 1'b0;

        $display("sw: %b display: %b",SW[3:0],HEX0);

	//STATE C
        #5;
        SW[3:0] = `C;

        #5; 
        KEY[0] = 1'b1;
        #5;
        KEY[0] = 1'b0;

        $display("sw: %b display: %b",SW[3:0],HEX0);

	//STATE D
        #5;
        SW[3:0] = `D;

        #5; 
        KEY[0] = 1'b1;
        #5;
        KEY[0] = 1'b0;

        $display("sw: %b display: %b",SW[3:0],HEX0);

	//STATE E
        #5;
        SW[3:0] = `E;

        #5; 
        KEY[0] = 1'b1;
        #5;
        KEY[0] = 1'b0;

        $display("sw: %b display: %b",SW[3:0],HEX0);

	//STATE F
        #5;
        SW[3:0] = `F;

        #5; 
        KEY[0] = 1'b1;
        #5;
        KEY[0] = 1'b0;

        $display("sw: %b display: %b",SW[3:0],HEX0);

        // MUST INTERPRET BINARY RESULTS
        $display("%b %b %b %b %b %b",HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);  
    end
endmodule