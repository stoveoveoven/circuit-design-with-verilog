module regfile (data_in, writenum, write, readnum, clk, data_out);
    input [15:0] data_in;
    input [2:0] writenum, readnum;
    output [15:0] data_out;

    wire[7:0] regSel;
    Dec38 writeDec(writenum, regSel);

    assign wire load0 = regSel[0] && write;
    assign wire load1 = regSel[1] && write;
    assign wire load2 = regSel[2] && write;
    assign wire load3 = regSel[3] && write;
    assign wire load4 = regSel[4] && write;
    assign wire load5 = regSel[5] && write;
    assign wire load6 = regSel[6] && write;
    assign wire load7 = regSel[7] && write;

    wire[15:0] r0, r1, r2, r3, r4, r5, r6, r7;

    always@(posedge clk)
        regLoad #(16) reg0(data_in, load0, clk, r0);
        regLoad #(16) reg1(data_in, load1, clk, r1);
        regLoad #(16) reg2(data_in, load2, clk, r2);
        regLoad #(16) reg3(data_in, load3, clk, r3);
        regLoad #(16) reg4(data_in, load4, clk, r4);
        regLoad #(16) reg5(data_in, load5, clk, r5);
        regLoad #(16) reg6(data_in, load6, clk, r6);
        regLoad #(16) reg7(data_in, load7, clk, r7);
    end
    
    wire[7:0] readSel;
    Dec38 readDec(readnum, readSel);
    MUX8bit16 readMUX(r0, r1, r2, r3, r4, r5, r6, r7, readSel, data_out);

endmodule

module MUX8bit16(ain, bin, cin, din, ein, fin, gin, hin, sel, out)
    input [15:0] ain, bin, cin, din, ein, fin, gin, hin;
    input [7:0] sel;
    output [15:0] out;

    case(sel)
        8'b00000001 : out = ain;
        8'b00000010 : out = bin;
        8'b00000100 : out = cin;
        8'b00001000 : out = din;
        8'b00010000 : out = ein;
        8'b00100000 : out = fin;
        8'b01000000 : out = gin;
        8'b10000000 : out = hin;
        default : out = 16'b1111111111111111;
    endcase    

endmodule