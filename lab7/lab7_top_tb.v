module lab7_top_tb;
    reg [3:0] KEY;
    reg [9:0] SW;
    wire [9:0] LEDR; 
    wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    reg err;

    lab7_top DUT(KEY, SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

    initial forever begin
        KEY[0] = 1; #5;
        KEY[0] = 0; #5;
    end

    initial begin
        // taken from autograder
        err = 0;
        KEY[1] = 1'b0; // reset asserted

        // check if program fetched correctly
        if (DUT.MEM.mem[0] !== 16'b1101000000100011) begin err = 1; $display("FAILED: mem[0] wrong; please set data.txt using Figure 6"); $stop; end
        if (DUT.MEM.mem[1] !== 16'b1100000000101000) begin err = 1; $display("FAILED: mem[1] wrong; please set data.txt using Figure 6"); $stop; end
        if (DUT.MEM.mem[2] !== 16'b1010000101000000) begin err = 1; $display("FAILED: mem[2] wrong; please set data.txt using Figure 6"); $stop; end
        if (DUT.MEM.mem[3] !== 16'b1000000001000000) begin err = 1; $display("FAILED: mem[3] wrong; please set data.txt using Figure 6"); $stop; end
        if (DUT.MEM.mem[4] !== 16'b0110000001100000) begin err = 1; $display("FAILED: mem[4] wrong; please set data.txt using Figure 6"); $stop; end
        if (DUT.MEM.mem[5] !== 16'b1010001101100001) begin err = 1; $display("FAILED: mem[5] wrong; please set data.txt using Figure 6"); $stop; end
        if (DUT.MEM.mem[6] !== 16'b1000000101100000) begin err = 1; $display("FAILED: mem[6] wrong; please set data.txt using Figure 6"); $stop; end
        if (DUT.MEM.mem[7] !== 16'b1110000000000000) begin err = 1; $display("FAILED: mem[7] wrong; please set data.txt using Figure 6"); $stop; end

        #10; // wait until next falling edge of clock
        KEY[1] = 1'b1; // reset de-asserted, PC still undefined if as in Figure 4
        #10; // waiting for RST state to cause reset of PC
        if (DUT.CPU.PC !== 9'b0) begin err = 1; $display("FAILED: PC is not reset to zero."); $stop; end
        @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);
        if (DUT.CPU.PC !== 9'h1) begin err = 1; $display("FAILED: PC should be 1."); $stop; end
        
        
        // begin test MOV R0, #23
        @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);
        if (DUT.CPU.PC !== 9'h2) begin err = 1; $display("FAILED: PC should be 2."); $stop; end
        if (DUT.CPU.DP.REGFILE.R0 !== 16'h23) begin err = 1; $display("FAILED: R0 should be 23."); $stop; end

        // begin test MOV R1, R0, LSL#1
        @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);
        if (DUT.CPU.PC !== 9'h3) begin err = 1; $display("FAILED: PC should be 3."); $stop; end
        if (DUT.CPU.DP.REGFILE.R1 !== 16'h46) begin err = 1; $display("FAILED: R1 should be 46."); $stop; end

        // begin test ADD R2, R1, R0
        @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);
        if (DUT.CPU.PC !== 9'h4) begin err = 1; $display("FAILED: PC should be 4."); $stop; end
        if (DUT.CPU.DP.REGFILE.R2 !== 16'h69) begin err = 1; $display("FAILED: R2 should be 69."); $stop; end

        // begin test STR R2, [R0]
        @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);
        if (DUT.CPU.PC !== 9'h5) begin err = 1; $display("FAILED: PC should be 5."); $stop; end
        if (DUT.MEM.mem[35] !== 16'h69) begin err = 1; $display("FAILED: mem[35] wrong; looks like STR isn't working"); $stop; end

        // begin test LDR R3, [R2]
        @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);
        if (DUT.CPU.PC !== 9'h6) begin err = 1; $display("FAILED: PC should be 6."); $stop; end
        if (DUT.CPU.DP.REGFILE.R3 !== 16'h69) begin err = 1; $display("FAILED: R3 should be 69."); $stop; end

        // begin test ADD R3, R3, R1	
        @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);
        if (DUT.CPU.PC !== 9'h7) begin err = 1; $display("FAILED: PC should be 7."); $stop; end
        if (DUT.CPU.DP.REGFILE.R3 !== 16'hAF) begin err = 1; $display("FAILED: R3 should be AF."); $stop; end

        // begin test STR R3, [R1]	
        @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);
        if (DUT.CPU.PC !== 9'h8) begin err = 1; $display("FAILED: PC should be 8."); $stop; end
        if (DUT.MEM.mem[70] !== 16'hAF) begin err = 1; $display("FAILED: mem[70] wrong; looks like STR isn't working"); $stop; end

        // HALT
        if (~err) $display("ALL TESTS PASSED");
        $stop;

    end
endmodule