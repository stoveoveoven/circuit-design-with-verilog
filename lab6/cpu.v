module cpu(clk, reset, s, load, in, out, N, V, Z, w);
    input clk, reset, s, load;
    input [15:0] in;
    output [15:0] out;
    output N,V,Z,w;

    wire [15:0] inst_regToDec, sximm5, sximm8;
    wire [2:0] readnum, writenum, nsel, opcode;
    wire [1:0] ALUop, shift, op;
    
    wire vsel, loada, loadb, asel, bsel, loadc, loads
    wire [15:0] mdata, C;
    wire [7:0] PC;

    regLoad #(16)   instructReg(in, load, clk, inst_regToDec);

    instructionDec  instructDec(inst_regToDec, nsel,                                //inputs
                                opcode, op, ALUop, sximm5, 
                                    sximm8, shift, readnum, writenum);              //outputs

    controller      ControlFSM (s, reset, w, opcode, op,                            //inputs
                                nsel, vsel, loada, loadb, loadc, asel, bsel, 
                                    loads, mdata, C, PC);                           //outputs

    datapath        dp         (clk, readnum, vsel, loada, loadb, shift, asel, 
                                    bsel, ALUop, loadc, loads, writenum, mdata, 
                                    sximm5, sximm8, PC, C,                          //inputs
                                status_out, datapath_out);                          //outputs

    assign N = status_out[2];
    assign V = status_out[1];
    assign Z = status_out[0];
endmodule