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

        // MOV R0, #7
        // 1101000000000111
        in = 16'b1101000000000111;
        load = 1'b1;
        #10; // load instruction in
        load = 1'b0;
        s = 1'b1; 
        #20; // now do these instructions, 2 clock cycles
        s = 1'b0;

        // MOV R3, R0, LSL #1
        // 1100000001101000
        in = 16'b1100000001101000;
        load = 1'b1;
        #10; // load instruction in
        load = 1'b0;
        s = 1'b1; 
        #40; // now do these instructions, 4 clock cycles
        s = 1'b0;

        // MOV R1, #2
        // 1101000100000010
        in = 16'b1101000100000010;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        
        #50; // now do these instructions, 2 clock cycles

        s = 1'b0;

        // ADD R2,R1,R0,LSL#1 should be 16
        // 1010000101001000
        in = 16'b1010000101001000;
        load = 1'b1;
    
        #10; // load instruction in

        load = 1'b0;
        s = 1'b1; 

        #80; // now do these instructions

        s = 1'b0;




        $stop;
    end


endmodule
