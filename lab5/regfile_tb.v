module regfile_tb;
    reg [15:0] data_in;
    reg [2:0] writenum, readnum;
    reg clk, write;
    wire [15:0] data_out;
    regfile DUT(data_in, writenum, write, readnum, clk, data_out);

    reg err = 1'b0; // required by criteria.

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

        #8; // writing are coordinated to clock

        write = 1'b0;
        
        #2;

        // read value of j
        readnum = 3'b011;

        #2;
        // read should not be coordinated to clk
        if (data_out == 16'd42) $display("PASS");//0000000000101010
        else begin
            $display("FAIL, read is only activating at posedge clk");
            err = 1'b1;
        end

        #8;

        // Check that write corresponds to rising edge of clk
        data_in = 16'd69; // try to store 69
        writenum = 3'b001; // in R1
        write = 1'b1; // STORE NOW

        #2;

        readnum = 3'b001; // CHECK IF NEW NUM HAS BEEN STORED AT r1

    	#2;

        if (data_out === 16'bxxxxxxxxxxxxxxxx) $display("PASS");// should be nothing at r1
        else begin
            $display("FAIL, number has been stored outside of the posedge clk");
            err = 1'b1;
        end
        readnum = 3'b010; // check r2

        #2;

        if (data_out === 16'bxxxxxxxxxxxxxxxx) $display("PASS");// should be nothing at r2
        else begin
            $display("FAIL, number has been stored outside of the posedge clk");
            err = 1'b1;
        end
        readnum = 3'b001; // check r1 after rising edge

        #5;

        if (data_out == 16'd69) $display("PASS");// 69 stored at r1
        else begin
            $display("FAIL, 69 not stored at r1");
            err = 1'b1;
        end

        #1;

        // try to store and read at the same time
        data_in = 16'd420; // store 420
        writenum = 3'b010; // to r2
        write = 1'b1; // store
        readnum = 3'b011; // read stored value at r3

        #4;
        if (data_out == 16'd42) $display("PASS");// read 42 from r3
        else begin
            $display("FAIL, 42 not read from r3");
            err = 1'b1;
        end

        #4; // 40s
	// $stop;
    end
endmodule