module regfile (data_in, writenum, write, readnum, clk, data_out);
    input [15:0] data_in;
    input [2:0] writenum, readnum;
    output [15:0] data_out;

    wire[7:0] regSel;
    Dec38 writeDec(writenum, regSel);

    
endmodule