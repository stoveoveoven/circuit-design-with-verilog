module instructionDec(in, nsel, opcode, op, ALUop, sximm5, sximm8, shift, rnum, wnum);
    input  [15:0] in;
    input  [1:0]  nsel;

    output [1:0]  ALUop,  shift, op;
    output [2:0]  opcode, rnum,  wnum;
    output [15:0] sximm5, sximm8;

    wire   [2:0]  rn, rd, rm, rwnum;

    // opcode |   op   |  rn   |  rd  |  shift  |  rm   |
    //        |  ALUop |
    //  xxx   |   xx   |  xxx  |  xxx |   xx    |  xxx  |
    // NOTE THAT OP and ALUOP OCCUPY THE SAME BITS
    assign opcode = in[15:13];
    assign op     = in[12:11];
    assign ALUop  = in[12:11];
    assign shift  = in[4:3];
    assign rn     = in[10:8];
    assign rd     = in[7:5];
    assign rm     = in[2:0];

    // sign extend, extends the binary integer to 16 bits
    assign sximm5 = {{11{in[4]}}, in[4:0]};     
    assign sximm8 = {{8{in[7]}}, in[7:0]};

    // input nsel is given by controller this mux simply acts as a selector of what 
    // register to read from/write to
    MUX3 readwriteMux(rn, rd, rm, nsel, rwnum);

    // which ever register address is selected is assinged readnum as well as writenum 
    // as this module does not know if the controller will require a read or write 
    // operation from the regFile
    assign rnum   = rwnum;
    assign wnum   = rwnum;
endmodule

module MUX3(zero, one, two, sel, out);
    input [2:0] one, two, three;
    input [1:0] sel;
    output reg [2:0] out;

    always@(*)begin
        case(sel)
            2'b00: out = zero;
            2'b01: out = one;
            2'b11: out = two;
            default: out = 3'bxxx;
        endcase
    end
endmodule