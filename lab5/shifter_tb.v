module shifter_tb;
    reg[15:0] in;
    reg[1:0]  shift;
    wire[15:0] sout;

    shifter DUT(in, shift, sout);

    reg err = 1'b0;


    initial begin
        
        in = 16'b1111000011001111;
        shift = 2'b00; #5;
        if (sout == 16'b1111000011001111) $display("PASS");
        else begin
            $display("FAIL");
            err = 1'b1;
        end

        in = 16'b1111000011001111;
        shift = 2'b01; #5;
        if (sout == 16'b1110000110011110) $display("PASS");
        else begin
            $display("FAIL");
            err = 1'b1;
        end

        in = 16'b1111000011001111;
        shift = 2'b10; #5;
        if (sout == 16'b0111100001100111) $display("PASS");
        else begin
            $display("FAIL");
            err = 1'b1;
        end

        in = 16'b1111000011001111;
        shift = 2'b11; #5;
        if (sout == 16'b1111100001100111) $display("PASS");
        else begin
            $display("FAIL");
            err = 1'b1;
        end

        #5;
        // $stop;
    end

endmodule