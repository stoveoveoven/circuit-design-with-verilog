module instructionDec_tb;
    reg[15:0] in;
    reg[2:0] nsel;

    wire[15:0] sximm5, sximm8;
    wire[2:0] opcode, rnum, wnum;
    wire[1:0] op, ALUop, shift;

    instructionDec DUT(in, nsel, opcode, op, ALUop, sximm5, sximm8, shift, rnum, wnum);

    initial begin
        //nsel selects rn
        in = {16{1'b1}};
        nsel = 3'b001;
        #20;

        //nsel selects rd
        in = 16'b1101000000000111;  //MOV R0, #7
        nsel = 3'b010;
        #20;

        //nsel selects rm
        in = 16'b0;
        nsel = 3'b100;
        #20;

        //readwriteMux give xxx
        in = 16'b1010000101001000;  //ADD R2, R1, R0, LSL#1
        nsel = 3'b110;
        #20;
    end
endmodule