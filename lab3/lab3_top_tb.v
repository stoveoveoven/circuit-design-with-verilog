//`timescale 1 ps/ 1 ps // uncomment for gate level sim

module testFSM;
`define A 4'b0100
`define B 4'b1000
`define C 4'b0011
`define D 4'b1000
`define E 4'b0001
`define F 4'b0101

    reg [9:0] SW;
    reg [3:0] KEY;
    wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    wire [9:0] LEDR; // optional: use these outputs for debugging on your DE1-SoC

    wire [4:0] stateToLED;
    
    lab3_top DUT(SW,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,LEDR);
	

    initial begin
	KEY[0] = 1'b1; #5;
	forever begin
	    KEY[0] = 1'b0; #5;
	    KEY[0] = 1'b1; #5;
	end
    end

    initial begin

	KEY[3] = 1'b0; #10;
	KEY[3] = 1'b1;

	// WRONG ENTRY AND ERROR
        SW[3:0] = 4'b1010; #10;
        $display("sw: %b display: %b",SW[3:0],HEX0);
        
        //RESET
        KEY[3] = 1'b0; #10;
	KEY[3] = 1'b1;

        //UNLOCK
        SW[3:0] = `A; #10;
        $display("sw: %b display: %b",SW[3:0],HEX0);
        SW[3:0] = `B; #10;
        $display("sw: %b display: %b",SW[3:0],HEX0);
        SW[3:0] = `C; #10;
        $display("sw: %b display: %b",SW[3:0],HEX0);
        SW[3:0] = `D; #10;
        $display("sw: %b display: %b",SW[3:0],HEX0);
        SW[3:0] = `E; #10;
        $display("sw: %b display: %b",SW[3:0],HEX0);
        SW[3:0] = `F; #10;
        $display("sw: %b display: %b",SW[3:0],HEX0);

        // MUST INTERPRET BINARY RESULTS
        $display("%b %b %b %b %b %b",HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);  

        //RESET
        KEY[3] = 1'b0; #10;
	KEY[3] = 1'b1;
        
        //ENTER VALID BUT WRONG COMBO, SHOULD OUTPUT CLOSED
        SW[3:0] = `B; #10;
        $display("sw: %b display: %b",SW[3:0],HEX0);
        SW[3:0] = `C; #10;
        $display("sw: %b display: %b",SW[3:0],HEX0);
        SW[3:0] = `D; #10;
        $display("sw: %b display: %b",SW[3:0],HEX0);
        SW[3:0] = `E; #10;
        $display("sw: %b display: %b",SW[3:0],HEX0);
        SW[3:0] = `F; #10;
        $display("sw: %b display: %b",SW[3:0],HEX0);
        SW[3:0] = `A; #10;
        $display("sw: %b display: %b",SW[3:0],HEX0);
        // MUST INTERPRET BINARY RESULTS
        $display("%b %b %b %b %b %b",HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);  

	$stop;  
    end
endmodule