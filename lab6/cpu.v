module cpu(clk, reset, s, load, in, out, N, V, Z, w);
    input clk, reset, s, load;
    input [15:0] in;
    output [15:0] out;
    output N,V,Z,w;

    wire [15:0] inst_regToDec, sximm5, sximm8;
    wire [2:0] readnum, writenum, nsel, opcode;
    wire [1:0] ALUop, shift, op, vsel;
    
    wire loada, loadb, asel, bsel, loadc, loads,write;
    wire [15:0] mdata, data_loop;
    wire [7:0] PC;

    wire [15:0] datapath_out;
    wire [2:0] status_out;    

    regLoad #(16)   instructReg(in, load, clk, inst_regToDec);

    instructionDec  instructDec(.in(inst_regToDec), .nsel(nsel),                                                    // inputs

                                .opcode(opcode),    .op(op),            .ALUop(ALUop),      .sximm5(sximm5), 
                                .sximm8(sximm8),    .shift(shift),      .rnum(readnum),     .wnum(writenum));       // outputs

    controller      ControlFSM (.clk(clk),          .s(s),              .reset(reset),      .w(w),          
                                .opcode(opcode),    .op(op),                                                        // inputs

                                .write(write),      .nsel(nsel),        .vsel(vsel),        .loada(loada),  
                                .loadb(loadb),      .loadc(loadc),      .asel(asel),        .bsel(bsel), 
                                .loads(loads),      .mdata(mdata),      .PC(PC));                                   // outputs

    datapath        DP         (.clk(clk),          .readnum(readnum),  .vsel(vsel),        .loada(loada), 
                                .loadb(loadb),      .shift(shift),      .asel(asel),        .bsel(bsel),        
                                .ALUop(ALUop),      .loadc(loadc),      .loads(loads),      .writenum(writenum), 
                                .write(write),      .mdata(mdata),      .sximm5(sximm5),    .sximm8(sximm8), 
                                .PC(PC),                                                                            // inputs

                                .status_out(status_out),        .datapath_out(datapath_out));                       // outputs

    assign N = status_out[2];
    assign V = status_out[1];
    assign Z = status_out[0];
endmodule