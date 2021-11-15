module regfile_test;
    input [15:0] data_in;
    input [2:0] writenum, readnum;
    input clk, write;
    output [15:0] data_out;
    reg [15:0] j;

    regfile DUT(data_in, writenum, write, readnum, clk, data_out);

    initial begin
        forever begin
            clk = 1'b0; #5;
            clk = 1'b1; #5;
        end
    end

    initial begin
        // make j have value 42 before code is executed
        data_in = 16'd42;
        writenum = 3'b011;
        write = 1'b1;
        #10;
        $display("regSel should be 00001000");
        $display("load should be 1");
        $display("0000000000101010 should be copied to R3");
        $display("Only one load enable input should be 1");
        $display("If write is 0 all 8 load-enable signals are 0");
        write = 0'b1;

        // read value of j
        readnum = 3'b011;
        j = data_out;
        $display("%b, should be 0000000000101010",j ); // read should not depend on clock
        readnum = 3'b000;
        #10;

        // Check the write corresponds to rising edge of clk
        data_in = 16'd69; // try to store 69
        writenum = 3'b001; // in R1
        write = 1'b1; // STORE NOW
        readnum = 3'b001; // CHECK IF NEW NUM HAS BEEN STORED
        j = data_out;
        $display("%b, should be XXXXXXXXXXXXXXXXXXXXXXX",j);
        #10;
        $display("%b, should be 69 in binary",j);
    end

    $stop;
endmodule