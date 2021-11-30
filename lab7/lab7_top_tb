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
        if (DUT.MEM.mem[23] !== 16'h69) begin err = 1; $display("FAILED: mem[23] wrong; looks like STR isn't working"); $stop; end

        // begin test LDR R3, [R2]
        @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);
        if (DUT.CPU.PC !== 9'h6) begin err = 1; $display("FAILED: PC should be 6."); $stop; end
        if (DUT.CPU.DP.REGFILE.R3 !== 16'h23) begin err = 1; $display("FAILED: R3 should be 23."); $stop; end

        // begin test ADD R3, R3, R1	
        @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);
        if (DUT.CPU.PC !== 9'h7) begin err = 1; $display("FAILED: PC should be 7."); $stop; end
        if (DUT.CPU.DP.REGFILE.R3 !== 16'h92) begin err = 1; $display("FAILED: R3 should be 92."); $stop; end

        // begin test STR R3, [R1]	
        @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);
        if (DUT.CPU.PC !== 9'h8) begin err = 1; $display("FAILED: PC should be 8."); $stop; end
        if (DUT.MEM.mem[46] !== 16'h92) begin err = 1; $display("FAILED: mem[46] wrong; looks like STR isn't working"); $stop; end


        // HALT
        if (~err) $display("INTERFACE OK");
        $stop;

    end
endmodule