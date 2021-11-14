module shifter_tb;
    reg[15:0] in;
    reg[1:0]  shift;
    wire[15:0] sout;

    shifter DUT(in, shift, sout);

    initial begin
        
        in = 16'b0000000000000001; #50;
        shift = 2'b00; #10;

        shift = 2'b01; #10;

        shift = 2'b10; #10;

        shift = 2'b11; #10;
        $stop;
    end

endmodule