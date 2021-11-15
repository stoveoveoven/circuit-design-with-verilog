module ALU_tb;
    reg[15:0] Ain, Bin;
    reg[1:0] ALUop;
    wire Z;
    wire [15:0] out;

    reg err = 1'b0;

    ALU DUT(Ain, Bin, ALUop, out, Z);

    initial begin
        Ain = 16'd0;
        Bin = 16'd0;
        ALUop = 2'b00; #5;

        assert (ALU_tb.DUT.out == 16'd0) $display("PASS");
        else begin
            $error("FAIL");
            err = 1'b1;
        end
        assert (ALU_tb.DUT.Z == 1'b1) $display("PASS");
        else begin
            $error("FAIL");
            err = 1'b1;
        end

        #5;
        
        Ain = 16'h1111; 
        Bin = 16'h1111;
        ALUop = 2'b01; #5;
        assert (ALU_tb.DUT.out == 16'd0) $display("PASS");
        else begin
            $error("FAIL");
            err = 1'b1;
        end
        assert (ALU_tb.DUT.Z == 1'b1) $display("PASS");
        else begin
            $error("FAIL");
            err = 1'b1;
        end
        
        #5;
        
        Ain = {16{1'b1}}; 
        Bin = {16{1'b0}}; 
        ALUop = 2'b01; #5;
        assert (ALU_tb.DUT.out == {16{1'b1}} ) $display("PASS");
        else begin
            $error("FAIL");
            err = 1'b1;
        end
        assert (ALU_tb.DUT.Z == 1'b0) $display("PASS");
        else begin
            $error("FAIL");
            err = 1'b1;
        end

        #5;
        
        Ain = 16'd0; 
        Bin = 16'd1; 
        ALUop = 2'b01; #5;
        assert (ALU_tb.DUT.out == {16{1'b1}} ) $display("PASS");
        else begin
            $error("FAIL");
            err = 1'b1;
        end
        assert (ALU_tb.DUT.Z == 1'b0) $display("PASS");
        else begin
            $error("FAIL");
            err = 1'b1;
        end


        #5;
        
        Ain = {8{2'b10}}; 
        Bin = {8{2'b01}}; 
        ALUop = 2'b10; #5;
        assert (ALU_tb.DUT.out == 16'd0) $display("PASS");
        else begin
            $error("FAIL");
            err = 1'b1;
        end
        assert (ALU_tb.DUT.Z == 1'b1) $display("PASS");
        else begin
            $error("FAIL");
            err = 1'b1;
        end

        #5;
        
        Ain = {8{2'b01}}; 
        Bin = {8{2'b01}}; 
        ALUop = 2'b10; #5;
        assert (ALU_tb.DUT.out == {8{2'b01}}) $display("PASS");
        else begin
            $error("FAIL");
            err = 1'b1;
        end
        assert (ALU_tb.DUT.Z == 1'b0) $display("PASS");
        else begin
            $error("FAIL");
            err = 1'b1;
        end

        #5;
        
        Ain = {8{2'b01}}; 
        Bin = {8{2'b01}}; 
        ALUop = 2'b11; #5;
        assert (ALU_tb.DUT.out == {8{2'b10}}) $display("PASS");
        else begin
            $error("FAIL");
            err = 1'b1;
        end
        assert (ALU_tb.DUT.Z == 1'b0) $display("PASS");
        else begin
            $error("FAIL");
            err = 1'b1;
        end

        #5;
        // $stop;
    end

endmodule