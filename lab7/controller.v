//should carry from toplevel, define for convenience
`define MWRITE 2'b11
`define MREAD 2'b01
`define MNONE 2'b00

//beforeAll
`define RST 5'b00000
`define IF1 5'b00001
`define IF2 5'b00010
`define updatePC 5'b00011

// primarily MOV, Rn, #<im8>
`define getRegIn 5'b00100
`define writeRn 5'b00101

// all purpose
`define loadB 5'b00110

// primarily MOV Rd,Rm {,<sh_op>}
`define writeRd 5'b00111
`define writeRd2 5'b01000
`define writeRd3 5'b01001

// primarily ADD
`define loadA 5'b01010

//CMP
`define loadS 5'b01011

//LDR and STR
`define getInt1 5'b01100
`define getInt2 5'b01101
`define getInt3 5'b01110
`define dataAddr 5'b01111
`define ldr1 5'b10000
`define ldr2 5'b10001
`define str1 5'b10010
`define str2 5'b10011

`define delay 5'b10100
//HALT state
`define HALT 5'b11111

`define ADD 2'b00
`define CMP 2'b01
`define AND 2'b10
`define MVN 2'b11

module controller(  clk, s, reset, opcode, op,                                              //inputs

                    w, write, nsel, vsel, loada, loadb, loadc, asel, bsel, 
                    loads, mdata, PC, load_pc, reset_pc, addr_sel, mem_cmd,
                    load_ir, bypass, load_addr);                                                    //outputs

    input            reset, clk, s;
    input      [1:0] op;
    input      [2:0] opcode;
    
    output reg       write, loada, loadb, loadc, asel, bsel, loads, w, 
                     load_pc, reset_pc, addr_sel, bypass, load_addr,load_ir;                                //NEED TO IMPLEMENT: load_pc, reset_pc, addr_sel, load_addr, mem_cmd
    output reg [1:0] vsel, mem_cmd, nsel;
    
    //need to check PC and mdata for this lab
    output reg [7:0] PC;
    output [15:0] mdata;

    reg [4:0] state;

    always@(posedge clk)begin
        if(reset)begin
            state    = `RST;
            reset_pc = 1'b1;
            load_pc  = 1'b1;
            mem_cmd  = `MNONE;
        end
        else begin
            case(state)
                `RST: begin
                    state    = `IF1;
                    reset_pc = 1'b0;
                    load_pc = 1'b0;  
                    addr_sel = 1'b1;
                    PC       = 8'b0;
                    mem_cmd  = `MREAD;
                end
                `IF1: begin
                    write = 1'b0;
                    state    = `IF2;
                    addr_sel = 1'b1;
                    load_ir  = 1'b1;
                end
                `IF2: begin
                    state   = `updatePC;
                    load_ir  = 1'b0;
                    load_pc = 1'b1;
                    mem_cmd  = `MNONE;
                end
                `updatePC: begin                                            // decoding instruction
                    mem_cmd  = `MREAD;
                    load_pc = 1'b0;                                       
                    case(opcode)
                        3'b110: begin                                       // if operation is MOV type
                            case(op)
                                2'b10:   state = `getRegIn;                 // MOV #sximm8
                                2'b00:   state = `loadB;                    // MOV Rd Rm
                                default: state = `IF1;                      // unreachable with valid MOV
                            endcase
                        end
                        3'b101: begin                                       // alu type
                            case(op)
                                `MVN:    state = `loadB;                    // MVN
                                `ADD:    state = `loadA;                    // ADD, CMP, AND
                                `CMP:    state = `loadA;
                                `AND:    state = `loadA;
                                default: state = `IF1;                      // unreachable with valid alu commands
                            endcase
                        end
                        3'b011: begin                                       // LDR
                            state = `loadA;                                // start by loadA
                        end
                        3'b100: begin                                       // STR
                            state = `loadA;                                // start by loadA
                        end
                        3'b111: begin                                       // special Halt stage
                            state   = `HALT;
                            load_pc = 1'b0;
                        end
                        default: state = `IF1;                              // defaults to starting stage if bad input
                    endcase
                end
                `getRegIn: begin                                            // MOV #sximm8: load integer value
                    nsel  = 2'b00;
                    vsel  = 2'b01;
                    write = 1'b1;
                    state = `writeRn;
                end
                `writeRn:begin                                              // MOV #sximm8: write value to reg
                    write = 1'b0;
                    state = `IF1;
                end
                `loadA: begin                                               // ADD, CMP, AND: load first value into regA
                    nsel = 2'b00;
                    loada = 1'b1;
                    asel = 1'b0;
                    
                    if (opcode == 3'b100 || opcode  == 3'b011)state = `getInt1;
                    else state = `loadB;
                end
                `loadB: begin
                    loada = 1'b0;                                           // ADD, CMP, AND: stops loading, proceed to reading next reg
                    nsel = 2'b11;
                    loadb = 1'b1;
                    bsel = 1'b0;
                    case (opcode)
                        3'b110: asel = (op == 2'b00) ? 1'b1 : 1'b0;         // if MOV Rd,Rm{,<sh_op>} or MVN Rd,Rm{,<sh_op>}, Rn doesnt matter
                        3'b101: asel = (op == 2'b11) ? 1'b1 : 1'b0; 
                        default: asel = 1'b0;
                    endcase
                    state = `writeRd;
                end
                `writeRd: begin
                    loadb = 1'b0;
                    if (op == 2'b01)begin
                        loads = 1'b1;
                        state = `loadS;
                    end
                    else begin
                        loadc = 1'b1;
                        state = `writeRd2;
                    end
                end
                `loadS: begin
                    loads = 1'b0;
                    state = `IF1;
                end
                `writeRd2: begin
                    nsel  = 2'b01;
                    vsel  = 2'b11;
                    write = 1'b1;
                    loadc = 1'b0;
                    state = `writeRd3;
                end
                `writeRd3: begin
                    asel = 1'b0;
                    bsel = 1'b0;
                    write = 1'b0;
                    state = `IF1;
                end
                `getInt1: begin
                    // vsel   = 2'b01;
                    // bypass = 1'b1;

                    loada  = 1'b0;
                    asel   = 1'b0;
                    loadb  = 1'b0;
                    bsel   = 1'b1;

                    state  = `getInt3;
                end
                // `getInt2: begin
                //     loada  = 1'b0;
                //     // bypass = 1'b0;
                //     nsel   = 2'b00;
                //     loadb  = 1'b1;
                //     bsel   = 1'b0;
                //     state  = `getInt3;
                // end
                `getInt3: begin
                    loadb = 1'b0;
                    loadc = 1'b1;
                    state = `dataAddr;
                end
                `dataAddr: begin
                    load_addr = 1'b1;
                    loadc     = 1'b0;
                    case(opcode)
                        3'b011: state = `ldr1;
                        3'b100: begin
                            state = `str1;
                            nsel  = 2'b01;
                            loadb = 1'b1;
                        end
                        default: state = `IF1;
                    endcase
                end
                `ldr1: begin
                    load_addr = 1'b0;
                    addr_sel  = 1'b0;
                    mem_cmd   = `MREAD;
                    state     = `ldr2;
                end
                `ldr2: begin
                    vsel  = 2'b00;
                    write = 1'b1;
                    nsel  = 2'b01;
                    addr_sel  = 1'b1;
                    state = `IF1;
                end
                `str1: begin
                    load_addr = 1'b0;
                    loadb     = 1'b0;
                    asel      = 1'b1;
                    bsel      = 1'b0;
                    loadc     = 1'b1;
                    state     = `str2;
                end
                `str2: begin
                    loadc    = 1'b0;
                    addr_sel = 1'b0;
                    mem_cmd  = `MWRITE;
                    state    = `delay;
                end
                `delay: begin
                    mem_cmd  = `MREAD;
                    state    = `IF1;
                    addr_sel  = 1'b1;
                end
                `HALT: begin
                    state   = `HALT;
                    load_pc = 1'b0;
                end
                default: state = `IF1;
            endcase 
        end
    end
endmodule