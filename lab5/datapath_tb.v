module datapath_tb;
    reg [15:0] datapath_in;
    reg [2:0] writenum, readnum;
    reg clk, write, loada, loadb, loadc, loads, asel, bsel, vsel;
    reg [1:0] shift, ALUop;

    wire [15:0] datapath_out;
    wire Z;

    datapath DUT(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, datapath_in, Z, datapath_out); // use named association kms
    reg err = 1'b0;

    initial begin
        forever begin
            clk = 1'b0; #5;
            clk = 1'b1; #5;
        end
    end

    initial begin
        // THE MAIN TEST THAT THEY GAVE US IN ONE OF THE CRITERIA
        // REGISTERS USED: r0,r1,r2
        // MOV R0, #7
        datapath_in = 16'd7;
        writenum = 3'b000;
        write = 1'b1;
        vsel = 1'b1;
        #10;
        // MOV R1, #2
        datapath_in = 16'd2;
        writenum = 3'b001;
        write = 1'b1;
        #10;
        // ADD R2,R1,R0,LSL#1
        readnum = 3'd0;
        loadb = 1'b1;
        #10;
        loadb = 1'b0;
        readnum = 3'd1;
        loada = 1'b1;
        #10;
        loada = 1'b0;
        ALUop = 2'b00;
        asel = 1'b0;
        bsel = 1'b0;
        shift = 2'b01;
        loadc = 1'b1;
        #10;
        loadc = 1'b0;
        vsel = 1'b0;
        write = 1'b1;
        writenum = 3'd2;
        if (datapath_out == 16'd16) $display("PASS");
        else begin
            $display("FAIL");
            err = 1'b1;
        end

        readnum = 3'd0;
        #5;
        if (DUT.REGFILE.R0 == 16'd7) $display("PASS");
        else begin
            $display("FAIL");
            err = 1'b1;
        end

        readnum = 3'd2;
        #5;
        if (DUT.REGFILE.R2 == 16'd16) $display("PASS");
        else begin
            $display("FAIL");
            err = 1'b1;
        end

        readnum = 3'd1;
        #5;
        if (DUT.REGFILE.R1 == 16'd2) $display("PASS");
        else begin
            $display("FAIL");
            err = 1'b1;
        end

	    #5;
        // TEST FOR NEG 1

         // MOV R3, #0
        datapath_in = 16'd0;
        writenum = 3'd3;
        write = 1'b1;
        vsel = 1'b1;
        #10;
        // SUB R4,R3,R1 LSR#1
        readnum = 3'd1;
        loadb = 1'b1;
        #10;
        loadb = 1'b0;
        readnum = 3'd3;
        loada = 1'b1;
        #10;
        loada = 1'b0;
        ALUop = 2'b01;
        asel = 1'b0;
        bsel = 1'b0;
        shift = 2'b10;
        loadc = 1'b1;
        #10;
        loadc = 1'b0;
        vsel = 1'b0;
        write = 1'b1;
        writenum = 3'd4;
        #10;
        if (DUT.REGFILE.R4 == {16{1'b1}}) $display("PASS");
        else begin
            $display("FAIL");
            err = 1'b1;
        end

        readnum = 3'd2;
        #5;
        if (datapath_out == 16'd16) $display("PASS");
        else begin
            $display("FAIL");
            err = 1'b1;
        end

        readnum = 3'd3;
        #5;
        if (DUT.REGFILE.R3 == 16'd0) $display("PASS");
        else begin
            $display("FAIL");
            err = 1'b1;
        end

        readnum = 3'd4;
        #5;
        if (datapath_out == {16{1'b1}}) $display("PASS");
        else begin
            $display("FAIL");
            err = 1'b1;
        end
    end
endmodule