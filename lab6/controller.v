// primarily MOV, Rn, #<im8>
`define getRegIn 4'b0001
`define writeRn 4'b0010

// all purpose
`define readRm 4'b0011
`define loadA 4'b0111
`define loadA2 4'b1000


// primarily MOV Rd,Rm {,<sh_op>}
`define writeRd 4'b0100
`define writeRd2 4'b0101
`define writeRd3 4'b0110

// primarily ADD
// `define shift 4'b0010

`define ALU 4'b0101
`define shiftread 4'b0100 
`define waiting 4'b1111
`define MOV 4'b0110

`define ADD 2'b00
`define CMP 2'b01
`define AND 2'b10
`define MVN 2'b11


module controller(  clk, s, reset, w, opcode, op,                                                    //inputs
                    write, nsel, vsel, loada, loadb, loadc, asel, bsel, loads, mdata, PC);      //outputs
    input s, reset, clk;
    input [2:0] opcode;
    input [1:0] op;
    output reg w, write, loada, loadb, loadc, asel, bsel, loads;
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
                `waiting: if(s)begin
                    case (opcode)
                        3'b110: begin
                            case (op)
                                2'b10: state = `getRegIn;
                                2'b00: state = `readRm;
                                default: state = `waiting; // unreachable with valid uses of MOV
                            endcase
                        end
                        3'b101: begin
                            case (op)
                                `ADD: state = `loadA;
                                `CMP: state = `waiting;
                                `AND: state = `waiting;
                                `MOV: state = `waiting;
                                default: state = `waiting; // unreachable
                            endcase
                        end
                        default: state = `waiting; // unreachable unless invalid opcode and op
                    endcase
                    w     = 1'b0;
                end
                else begin
                    state = `waiting;
                    w     = 1'b1;
                end
                `getRegIn: begin
                    nsel  = 3'b100;
                    vsel  = 2'b01;
                    write = 1'b1;
                    state = `writeRn;
                    w     = 1'b1;
                end
                `writeRn:begin
                    write = 1'b0;
                    state = `waiting;
                end
                `readRm: begin
                    nsel  = 3'b001;
                    loadb = 1'b1;
                    bsel = 1'b0;
                    // if MOV Rd,Rm{,<sh_op>} or MVN Rd,Rm{,<sh_op>}, Rn doesnt matter
                    case (opcode)
                        3'b110: asel = (op == 2'b00) ? 1'b1 : 1'b0; 
                        3'b101: asel = (op == 2'b11) ? 1'b1 : 1'b0; 
                        default: asel = 1'b0;
                    endcase
                    loadc = 1'b1;
                    state = `writeRd;
                    w     = 1'b0;
                end
                `loadA: begin
                    // read Rn
                    nsel = 3'b100;
                    loada = 1'b1;
                    asel = 1'b0;
                    state = `loadA2;
                end
                `loadA2: begin
                    loada = 1'b0;
                    state = `readRm;
                end
                // `shift: begin
                //     asel  = 1'b1;
                //     bsel  = 1'b0;
                //     loadc = 1'b1;
                //     state = (opcode == 3'b101) ? `ALU : `writeRd;
                //     w     = 1'b0;
                // end
                // `shiftread: begin
                //     nsel  = 3'b001;
                //     loada = 1'b1;
                //     bsel  = 1'b0;
                //     asel  = 1'b0;
                //     state = `ALU;
                //     w     = 1'b0;
                // end
                // `ALU: begin
                //     asel = 1'b0;
                //     bsel = 1'b0;
                //     //if command is CMP
                //     if(op == 2'b01)begin
                //         loads = 1'b1;
                //         loadc = 1'b0;
                //         state = `waiting;
                //         w     = 1'b1;
                //     end
                //     else begin
                //         loadc = 1'b1;
                //         state = `writeRd;
                //         w     = 1'b0;
                //     end
                // end
                `writeRd: begin
                    state = `writeRd2;
                end
                `writeRd2:begin
                    nsel  = 3'b010;
                    vsel  = 2'b11;
                    write = 1'b1;
                    state = `writeRd3;
                end
                `writeRd3:begin
                    loadc = 1'b0;
                    write = 1'b0;
                    state = `waiting;
                    w     = 1'b1;
                end
                default: state = `waiting;
            endcase 
        end
    end
endmodule