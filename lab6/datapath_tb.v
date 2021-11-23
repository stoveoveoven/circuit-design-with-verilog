module datapath_tb;
    reg [15:0] mdata, sximm8, sximm5;
    reg [7:0] PC;
    reg [2:0] writenum, readnum;
    reg [1:0] shift, ALUop, vsel;
    reg clk, write, loada, loadb, loadc, loads, asel, bsel;
    
    wire [15:0] datapath_out;
    wire [2:0] status_out;

    datapath DUT(   .clk(clk),          .readnum(readnum),  .vsel(vsel),  
                    .loada(loada),      .loadb(loadb),      .shift(shift), 
                    .asel(asel),        .bsel(bsel),        .ALUop(ALUop),  
                    .loadc(loadc),      .loads(loads),      .writenum(writenum), 
                    .write(write),      .mdata(mdata),      .sximm5(sximm5), 
                    .sximm8(sximm8),    .PC(PC), 

                    .status_out(status_out), .datapath_out(datapath_out)
                );

    initial begin
        forever begin
            clk = 1'b0; #5;
            clk = 1'b1; #5;

            mdata = 16'b0;              //not used
            PC    = 8'b0;               //not used
        end
    end

    initial begin
        //MOV R0 #7
        sximm8 = 16'd7;
        writenum = 3'b000;
        write = 1'b1;
        vsel = 1'b1;
        #10;

        //MOV R1, #2
        sximm8 = 16'd2;
        writenum = 3'b001;
        write = 1'b1;
        #10;

        //ADD R2, R1, R0 LSL #1
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
        loads = 1'b1;
        #10;

        loadc = 1'b0;
        loads = 1'b0;
        vsel = 1'b0;
        write = 1'b1;
        writenum = 3'd2;

        if (datapath_out == 16'd16) $display("PASS");
        else begin
            $display("FAIL");
        end
        if (status_out[0] == 1'b0) $display("PASS");
        else begin
            $display("FAIL");
        end

        readnum = 3'd0;
        #5;
        if (DUT.REGFILE.R0 == 16'd7) $display("PASS");
        else begin
            $display("FAIL");
        end

        readnum = 3'd1;
        #5;
        if (DUT.REGFILE.R1 == 16'd2) $display("PASS");
        else begin
            $display("FAIL");
        end

	    #5;
    end

endmodule