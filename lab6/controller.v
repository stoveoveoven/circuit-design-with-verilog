// primarily MOV, Rn, #<im8>
`define getRegIn 4'b0001
`define writeRn 4'b0010

// all purpose
`define loadB 4'b0011

// primarily MOV Rd,Rm {,<sh_op>}
`define writeRd 4'b0100
`define writeRd2 4'b0101
`define writeRd3 4'b0110

// primarily ADD
`define loadA 4'b0111


`define loadS 4'b1000


// `define shift 4'b0010

`define ALU 4'b0101
`define shiftread 4'b0100 
`define waiting 4'b1111

`define ADD 2'b00
`define CMP 2'b01
`define AND 2'b10
`define MVN 2'b11


module controller(  clk, s, reset, w, opcode, op,                                               //inputs
                    write, nsel, vsel, loada, loadb, loadc, asel, bsel, loads, mdata, PC);      //outputs

    input            reset, clk, s;
    input      [1:0] op;
    input      [2:0] opcode;
    
    output reg       write, loada, loadb, loadc, asel, bsel, loads, w;
    output reg [1:0] vsel;
    output reg [2:0] nsel;
    
    //not used for lab6
    output [7:0] PC;
    output [15:0] mdata;

    assign PC = 8'b0;
    assign mdata = 16'b0;

    reg [3:0] state;

    always@(posedge clk)begin
        if(reset)begin
            state = `waiting;
            w     = 1'b1;
        end
        else begin
            case(state)
                `waiting: if(s)begin                                        // decode state
                    case (opcode)
                        3'b110: begin                                       // if operation is MOV type
                            case (op)
                                2'b10: state = `getRegIn;                   // MOV #sximm8
                                2'b00: state = `loadB;                     // MOV Rd Rm
                                default: state = `waiting;                  // unreachable with valid uses of MOV
                            endcase
                        end
                        3'b101: begin                                       // if operation is ALU type
                            case (op)
                                `ADD: state = `loadA;       
                                `CMP: state = `loadA;
                                `AND: state = `loadA;                       // ADD, CMP, AND
                                `MVN: state = `loadB;                      // MVN
                                default: state = `waiting;                  // unreachable
                            endcase
                        end
                        default: state = `waiting;                          // unreachable unless invalid opcode and op
                    endcase
                    w     = 1'b0;                                           // setting the w counter
                end
                else begin
                    state = `waiting;                                       // simple waiting state
                    w     = 1'b1;
                end
                `getRegIn: begin                                            // MOV #sximm8: load integer value
                    nsel  = 3'b100;
                    vsel  = 2'b01;
                    write = 1'b1;
                    state = `writeRn;
                end
                `writeRn:begin                                              // MOV #sximm8: write value to reg
                    write = 1'b0;
                    state = `waiting;
                    w = 1'b1;
                end
//                `readRm: begin                                            // used for move and negate, which only requires reading one value
//                    nsel  = 3'b001;
//                    loadb = 1'b1;
//                    bsel = 1'b0;
                    
//                    case (opcode)
//                        3'b110: asel = (op == 2'b00) ? 1'b1 : 1'b0; 
//                        3'b101: asel = (op == 2'b11) ? 1'b1 : 1'b0; 
//                        default: asel = 1'b0;
//                    endcase
//                    state = `writeRd;
//                end
                `loadA: begin                                               // ADD, CMP, AND: load first value into regA
                    // read Rn
                    nsel = 3'b100;
                    loada = 1'b1;
                    asel = 1'b0;
                    state = `loadB;
                end
                `loadB: begin
                    loada = 1'b0;                                             // ADD, CMP, AND: stops loading, proceed to reading next reg
                    nsel = 3'b001;
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
                    state = `waiting;
                    w     = 1'b1;
                end
                `writeRd2:begin
                    nsel  = 3'b010;
                    vsel  = 2'b11;
                    write = 1'b1;
                    loadc = 1'b0;
                    state = `writeRd3;
                end
                `writeRd3:begin
                    asel = 1'b0;
                    bsel = 1'b0;
                    write = 1'b0;
                    state = `waiting;
                    w     = 1'b1;
                end
                default: state = `waiting;
            endcase 
        end
    end
endmodule