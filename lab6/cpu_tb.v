module cpu_tb;

    reg clk, reset, s, load;
    reg [15:0] in;
    wire [15:0] out;
    wire N,V,Z,w;

    cpu DUT(clk, reset, s, load, in, out, N, V, Z, w);

    initial begin
        forever begin
            clk = 1'b1; #5;
            clk = 1'b0; #5;
        end
    end

    initial begin
        reset = 1'b1;#10;

        reset = 1'b0;
        load = 1'b0; #10; // nothing should change

        // GENERAL MOV Rn #num TESTS!!!
        
        // mov 0 into R6
        in = 16'b1101011000000000;
        load = 1'b1;
        #10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // yes
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.DP.REGFILE.R6 == 16'd0) $display("PASS");
        else begin
            $display("FAIL, R%d not updated",in[10:8]);
        end
        #5;
        // mov -1 into R7, also checks bit extension
        in = 16'b1101011111111111;
        load = 1'b1;
        #10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // yes
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.DP.REGFILE.R7 == 16'b1111111111111111) $display("PASS");
        else begin
            $display("FAIL, R%d not updated",in[10:8]);
        end
        #5;

        // GENERAL MOV Rd, Rm <sh_op> TESTS!!!

        // MOV R5, R7, LSL #1
        in = 16'b1100000010101111;
        load = 1'b1;
        #10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // yes
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.DP.REGFILE.R5 == 16'b1111111111111110) $display("PASS");
        else begin
            $display("FAIL, R%d not updated",in[7:5]);
        end
        #5;

        // MOV R0, #7
        // 1101000000000111
        in = 16'b1101000000000111;
        load = 1'b1;
        #10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // yes
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.DP.REGFILE.R0 == 16'd7) $display("PASS");
        else begin
            $display("FAIL, R%d not updated",in[10:8]);
        end
        #5;

        // MOV R3, R0, LSL #1
        // 1100000001101000
        in = 16'b1100000001101000;
        load = 1'b1;
        #10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // yes
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.DP.REGFILE.R3 == 16'd14) $display("PASS");
        else begin
            $display("FAIL, R%d not updated",in[7:5]);
        end
        #5;

        // MOV R1, #2
        // 1101000100000010
        in = 16'b1101000100000010;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // yes
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.DP.REGFILE.R1 == 16'd2) $display("PASS");
        else begin
            $display("FAIL, R%d not updated",in[10:8]);
        end
        #5;
        
        // ADD R2,R1,R0,LSL#1 should be 16
        // 1010000101001000
        in = 16'b1010000101001000;
        load = 1'b1;
        #10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // yes
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.DP.REGFILE.R2 == 16'd16) $display("PASS");
        else begin
            $display("FAIL, R%d not updated",in[7:5]);
        end
        #5;

        // ADD R4,R3,R2,LSR#1 should be 14+8 = 22
        // 1010001110010010
        in = 16'b1010001110010010;
        load = 1'b1;
        #10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // yes
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.DP.REGFILE.R4 == 16'd22) $display("PASS");
        else begin
            $display("FAIL, R%d not updated",in[7:5]);
        end
        #5;

        // MOV R1, #69
        // 1101000101000101
        in = 16'b1101000101000101;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // yes
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.DP.REGFILE.R1 == 16'd69) $display("PASS");
        else begin
            $display("FAIL, R%d not updated",in[10:8]);
        end
        #5;

        // MVN R0,R0, LSL#1 should be 1111110001 = -(2*7) = -14
        // 1011100000001000
        in = 16'b1011100000001000;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // yes
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.DP.REGFILE.R0 == 16'b1111111111110001) $display("PASS");
        else begin
            $display("FAIL, R%d not updated",in[7:5]);
        end
        #5;

        // AND R0,R0, LSL#1 should be 1111110001 = -(2*7) = -14
        // 1011000000001000
        in = 16'b1011000000001000;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // yes
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.DP.REGFILE.R0 == 16'b1111111111100000) $display("PASS");
        else begin
            $display("FAIL, R%d not updated",in[7:5]);
        end
        #5;



        // CMP R1,R1 TEST for 0
        // 1010100100000001
        in = 16'b1010100100000001;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // yes
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.N == 1'b0) $display("PASS");
        else begin
            $display("FAIL, N not updated for %b",in);
        end

        if (DUT.V == 1'b0) $display("PASS");
        else begin
            $display("FAIL, V not updated for %b",in);
        end

        if (DUT.Z == 1'b1) $display("PASS");
        else begin
            $display("FAIL, Z not updated for %b",in);
        end


        // CMP R1,R2, LSR#1  TEST for normal input
        // 1010100100010010
        in = 16'b1010100100010010;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // yes
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.N == 1'b0) $display("PASS");
        else begin
            $display("FAIL, N not updated for %b",in);
        end

        if (DUT.V == 1'b0) $display("PASS");
        else begin
            $display("FAIL, V not updated for %b",in);
        end

        if (DUT.Z == 1'b0) $display("PASS");
        else begin
            $display("FAIL, Z not updated for %b",in);
        end

        // CMP R2,R1, LSR#1  TEST for negative result and no overflow 16-69
        // 1010101000000001
        in = 16'b1010101000000001;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // yes
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.N == 1'b1) $display("PASS");
        else begin
            $display("FAIL, N not updated for %b",in);
        end

        if (DUT.V == 1'b0) $display("PASS");
        else begin
            $display("FAIL, V not updated for %b",in);
        end

        if (DUT.Z == 1'b0) $display("PASS");
        else begin
            $display("FAIL, Z not updated for %b",in);
        end
        
        // MOV R5, #1
        in = 16'b1101010100000001;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // yes
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.DP.REGFILE.R5 == 16'd1) $display("PASS");
        else begin
            $display("FAIL, R%d not updated",in[10:8]);
        end
        #5;

        // MOV R6, #2
        in = 16'b1101011000000010;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // yes
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.DP.REGFILE.R6 == 16'd2) $display("PASS");
        else begin
            $display("FAIL, R%d not updated",in[10:8]);
        end
        #5;

        // MVN R5,R5
        // 1011100010100101
        in = 16'b1011100010100101;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // yes
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.DP.REGFILE.R5 == 16'b1111111111111110) $display("PASS");
        else begin
            $display("FAIL, R%d not updated",in[7:5]);
        end
        #5;

        // CMP R5,R6, LSR#1  TEST for -1-(2) which apparently isnt overflow
        // 1010110100000110
        in = 16'b1010110100000110;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // yes
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.N == 1'b1) $display("PASS");
        else begin
            $display("FAIL, N not updated for %b",in);
        end

        if (DUT.V == 1'b0) $display("PASS");
        else begin
            $display("FAIL, V not updated for %b",in);
        end

        if (DUT.Z == 1'b0) $display("PASS");
        else begin
            $display("FAIL, Z not updated for %b",in);
        end

        // MORE TEST CASES FOR ADD,AND,MVN using posedge w

        // MOV R0, biggest number
        in = 16'b1101000001111111;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // now do these instructions, 2 clock cycles + 1 for load = 3 clock cycles for moving number into reg
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.DP.REGFILE.R0 == 16'd127) $display("PASS");
        else begin
            $display("FAIL, R%d not updated",in[10:8]);
        end

        // MOV R1, funny number
        in = 16'b1101000101010101;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // now do these instructions, 2 clock cycles + 1 for load = 3 clock cycles for moving number into reg
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.DP.REGFILE.R1 == 16'b0000000001010101) $display("PASS");
        else begin
            $display("FAIL, R%d not updated",in[10:8]);
        end

        // MVN R2, R0  opposite of funny number
        in = 16'b1011100001000001;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // now do these instructions, 2 clock cycles + 1 for load = 3 clock cycles for moving number into reg
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.DP.REGFILE.R2 == 16'b1111111110101010) $display("PASS");
        else begin
            $display("FAIL, R%d not updated",in[10:8]);
        end

        // AND R3,R1,R2 should be all 0s
        in = 16'b1011000101100010;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // yes
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.DP.REGFILE.R3 == 16'd0) $display("PASS");
        else begin
            $display("FAIL, R%d not updated",in[7:5]);
        end

        // AND R4,R1,R1 should be equal to R1
        // 1011000000001000
        in = 16'b1011000110000001;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // yes
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.DP.REGFILE.R4 == DUT.DP.REGFILE.R1) $display("PASS");
        else begin
            $display("FAIL, R%d not updated",in[7:5]);
        end

        // MVN R3, R3  alll 1
        in = 16'b1011100001100011;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #10; // now do these instructions, 2 clock cycles + 1 for load = 3 clock cycles for moving number into reg
        s = 1'b0;
        @ (posedge w)
        #10;
        if (DUT.DP.REGFILE.R3 == {16{1'b1}}) $display("PASS");
        else begin
            $display("FAIL, R%d not updated",in[10:8]);
        end



        #10;
        $stop;
    end


endmodule
