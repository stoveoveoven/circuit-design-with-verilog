module datapath (   clk, readnum, vsel, loada, loadb, shift, asel, bsel, 
                    ALUop, loadc, loads, writenum, write, mdata, sximm5, sximm8, 
                    PC, bypass,

                    status_out, datapath_out);

    input [15:0] mdata, sximm8, sximm5;
    input [7:0] PC;
    input [2:0] writenum, readnum;
    input [1:0] shift, ALUop, vsel;
    input clk, write, loada, loadb, loadc, loads, asel, bsel, bypass;

    output [15:0] datapath_out;
    output [2:0] status_out;

    wire [15:0] regFile_data_in, regFile_out, data_out, shifter_in, shifter_out, ALU_ain, ALU_bin, ALU_out, data_loop, bMUX_one, regA_out;
    wire [2:0] stat;

    MUX4 vMUX(mdata, sximm8, {8'b0, PC}, data_loop, vsel, regFile_data_in);             // for lab6, mdata and PC are not used, and will be assigned 0

    regfile REGFILE(regFile_data_in, writenum, write, readnum, clk, regFile_out);       // regfile remains unchanged from lab5

    bypass #(16) bypass(regFile_out, regFile_data_in, bypass, data_out);                   // MUX added to allow for #sximm8 to bypass regFile

    regLoad #(16) regA(data_out, loada, clk, regA_out);                                 // regA remains unchanged from lab5
    regLoad #(16) regB(data_out, loadb, clk, shifter_in);                               // regB remains unchnaged from lab5

    shifter U1(shifter_in, shift, shifter_out);                                         // shifter remains unchanged from lab5

    MUX #(16) aMUX(regA_out, 16'b0, asel, ALU_ain);                                     // aMux remains unchanged
    MUX #(16) bMUX(shifter_out, sximm5, bsel, ALU_bin);                                 // bMux remains unchanged

    ALU U2(ALU_ain, ALU_bin, ALUop, ALU_out, stat);                                     // ALU status has changed, refer to comments in ALU.v

    regLoad #(3) status(stat, loads, clk, status_out);                                  // Status is now a 3bit register, refer to comments in ALU.v to the interpretation of status
    regLoad #(16) regC(ALU_out, loadc, clk, data_loop);                                 // regC remains unchanged

    assign datapath_out = data_loop;
endmodule

module MUX4(one, two, three, four, sel, out);
    input [15:0] one, two, three, four;
    input [1:0] sel;
    output reg [15:0] out;

    always@(*)begin
        case(sel)
            2'b00: out = one;        
            2'b01: out = two;
            2'b10: out = three;       
            2'b11: out = four;
        endcase
    end
endmodule

module bypass(deflt, bp, sel, out);
    parameter width = 16;

    input [width-1:0] deflt, bp;
    input sel;
    output [width-1:0] out;

    if(sel==bp)
        out = bp;
    else begin
        out = deflt;
    end
endmodule

