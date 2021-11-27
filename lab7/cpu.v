module cpu(clk, reset, read_data, mem_cmd, mem_addr);
    input clk, reset, s, load;
    input [15:0] read_data;
    output [15:0] out;
    output [8:0] mem_addr;
    output [1:0] mem_cmd;

    wire [15:0] inst_regToDec, sximm5, sximm8;
    wire [2:0] readnum, writenum, nsel, opcode;
    wire [1:0] ALUop, shift, op, vsel;
    
    wire loada, loadb, asel, bsel, loadc, loads, write, load_pc, reset_pc, addr_sel;
    wire [15:0] mdata, data_loop;
    wire [7:0] PC;
    wire [8:0] next_pc, PC_out;

    wire [2:0] status_out; 
    //shit from lab 6 idk if we need
    wire N, V, Z, w, s, load;   
    wire [15:0] out;

    assign next_pc  = reset_pc ? (PC_out + 1) : 9'b0;
    assign mem_addr = addr_sel ?  PC_out      : 9'b0;

    regLoad #(16)   instructReg(read_data, load, clk, inst_regToDec);

    instructionDec  instructDec(.in(inst_regToDec), .nsel(nsel),                                                    // inputs

                                .opcode(opcode),    .op(op),            .ALUop(ALUop),      .sximm5(sximm5), 
                                .sximm8(sximm8),    .shift(shift),      .rnum(readnum),     .wnum(writenum));       // outputs

    controller      ControlFSM (.clk(clk),          .s(s),              .reset(reset),      .opcode(opcode),    
                                .op(op),                                                                            // inputs

                                .w(w),              .write(write),      .nsel(nsel),        .vsel(vsel),        
                                .loada(loada),      .loadb(loadb),      .loadc(loadc),      .asel(asel),        
                                .bsel(bsel),        .loads(loads),      .mdata(mdata),      .PC(PC)             
                                .load_pc(load_pc)   .reset_pc(reset_pc) .addr_sel(addr_sel) .mem_cmd(mem_cmd));     // outputs

    regLoad #(9)    pCounter   (.next_pc(next_pc),  .load_pc(load_pc),  .clk(clk),          .PC_out(PC_out));       

    datapath        DP         (.clk(clk),          .readnum(readnum),  .vsel(vsel),        .loada(loada), 
                                .loadb(loadb),      .shift(shift),      .asel(asel),        .bsel(bsel),        
                                .ALUop(ALUop),      .loadc(loadc),      .loads(loads),      .writenum(writenum), 
                                .write(write),      .mdata(mdata),      .sximm5(sximm5),    .sximm8(sximm8), 
                                .PC(PC),                                                                            // inputs

                                .status_out(status_out),        .datapath_out(out));                       // outputs

    assign N = status_out[2];
    assign V = status_out[1];
    assign Z = status_out[0];
endmodule