module datapath (clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, datapath_in, Z_out, datapath_out);
    input [15:0] datapath_in;
    input [2:0] writenum, readnum;
    input clk, write, loada, loadb, loadc, loads, asel, bsel, vsel;
    input [1:0] shift, ALUop;

    output [15:0] datapath_out;
    output Z_out;

    wire [15:0] regFile_data_in, regFile_data_out, shifter_in, shifter_out, ALU_ain, ALU_bin, ALU_out, data_loop, bMUX_one, regA_out;
    wire Z_in;

    MUX #(16) vMUX(data_loop, datapath_in, vsel, regFile_data_in);

    regfile U0(regFile_data_in, writenum, write, readnum, clk, regFile_data_out);

    regLoad #(16) regA(regFile_data_out, loada, clk, regA_out);
    regLoad #(16) regB(regFile_data_out, loadb, clk, shifter_in);

    shifter U1(shifter_in, shift, shifter_out);

    MUX #(16) aMUX(regA_out, 16'b0, asel, ALU_ain);
    MUX #(16) bMUX(shifter_out, {11'b0, datapath_in[4:0]}, bsel, ALU_bin);

    ALU U2(ALU_ain, ALU_bin, ALUop, ALU_out, Z_in);

    regLoad #(1) status(Z_in, loads, clk, Z_out);
    regLoad #(16) regC(ALU_out, loadc, clk, data_loop);

    assign datapath_out = data_loop;
endmodule

