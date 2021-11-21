module controller(s, reset, w, opcode, op, nsel, vsel, loada, loadb, loadc, asel, bsel, loads, mdata, C, PC);
    input s, reset;
    input[2:0] opcode;
    input[1:0] op;
    output w, vsel, loada, loadb, loadc asel, bsel, loads;
    output[2:0] nsel;
    output[7:0] PC;
    output[15:0] mdata, C;



endmodule