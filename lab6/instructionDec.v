module instructionDec(in, nsel, opcode, op, ALUop, sximm5, sximm8, shift, rnum, wnum);
    input [15:0] in;
    input [2:0] nsel;
    output [2:0] opcode, rnum, wnum;
    output [1:0] op, ALUop, shift;
    output [15:0] sximm5, sximm8;

    wire [2:0] rn, rd, rm, rwnum;

    assign opcode = in[15:13];
    assign op     = in[12:11];
    assign ALUop  = in[12:11];
    assign shift  = in[4:3];
    assign rn     = in[10:8];
    assign rd     = in[7:5];
    assign rm     = in[2:0];

    //sign extend
    assign sximm5 = {{11{in[4]}}, in[4:0]};     //this is supposed to be replication operator not sure if implmented correctly
    assign sximm8 = {{8{in[7]}}, in[7:0]};

    MUX3 readwriteMux(rn, rd, rm, nsel, rwnum);

    assign rnum   = rwnum;
    assign wnum   = rwnum;
endmodule

module MUX3(one, two, three, sel, out);
    input [2:0] one, two, three, sel;
    output reg [2:0] out;

    always@(*)begin
        case(sel)
            3'b001: out = one;
            3'b010: out = two;
            3'b100: out = three;
            default: out = 3'bxxx;
        endcase
    end
endmodule