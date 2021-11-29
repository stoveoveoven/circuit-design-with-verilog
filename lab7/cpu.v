module cpu(clk, reset, r_data, mem_cmd, mem_addr, w_data);
    input clk, reset;
    input [15:0] r_data;
    output [15:0] w_data;
    output [8:0] mem_addr;
    output [1:0] mem_cmd;

    wire [15:0] inst_regToDec, sximm5, sximm8;
    wire [2:0] readnum, writenum, opcode;
    wire [1:0] ALUop, shift, op, vsel, nsel;
    
    wire load_ir, loada, loadb, asel, bsel, loadc, loads, write, load_pc, rst_pc, addr_sel, load_addr, bypass;
    wire [15:0] mdata, data_loop;
    wire [7:0] PC;
    wire [8:0] next_pc, PC_out, data_addr_out;

    wire [2:0] status_out; 
    //shit from lab 6 idk if we need
    wire N, V, Z, w, s;   
    wire [15:0] out;

    assign next_pc  = rst_pc   ? 9'b0 : (PC_out + 9'b1);    
    assign mem_addr = addr_sel ?  PC_out         : data_addr_out;

    regLoad #(16)   instructReg(.in(r_data),        .load(load_ir),     .clk(clk),          .out(inst_regToDec));

    instructionDec  instructDec(.in(inst_regToDec), .nsel(nsel),                                                    // inputs

                                .opcode(opcode),    .op(op),            .ALUop(ALUop),      .sximm5(sximm5), 
                                .sximm8(sximm8),    .shift(shift),      .rnum(readnum),     .wnum(writenum));       // outputs

    controller      ControlFSM (.clk(clk),          .s(s),              .reset(reset),      .opcode(opcode),    
                                .op(op),                                                                            // inputs

                                .w(w),              .write(write),      .nsel(nsel),        .vsel(vsel),        
                                .loada(loada),      .loadb(loadb),      .loadc(loadc),      .asel(asel),        
                                .bsel(bsel),        .loads(loads),      .mdata(mdata),      .PC(PC),             
                                .load_pc(load_pc),  .reset_pc(rst_pc),  .addr_sel(addr_sel),.mem_cmd(mem_cmd),
                                .load_ir(load_ir),  .bypass(bypass),    .load_addr(load_addr));                                         // outputs

    regLoad #(9)    pCounter   (.in(next_pc),       .load(load_pc),     .clk(clk),          .out(PC_out));       

    datapath        DP         (.clk(clk),          .readnum(readnum),  .vsel(vsel),        .loada(loada), 
                                .loadb(loadb),      .shift(shift),      .asel(asel),        .bsel(bsel),        
                                .ALUop(ALUop),      .loadc(loadc),      .loads(loads),      .writenum(writenum), 
                                .write(write),      .mdata(r_data),     .sximm5(sximm5),    .sximm8(sximm8), 
                                .PC(PC),            .bypass(bypass),                                                                           // inputs

                                .status_out(status_out),        .datapath_out(w_data));                             // outputs

    regLoad #(9)    dataAddr   (.in(w_data[8:0]),   .load(load_addr),   .clk(clk),          .out(data_addr_out));

    assign N = status_out[2];
    assign V = status_out[1];
    assign Z = status_out[0];
endmodule