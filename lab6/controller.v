`define writeRn 3'b000
`define readRm 3'b001
`define shift 3'b010
`define writeRd 3'b011
`define ALU 3'b101
`define shiftread 3'b100 
`define waiting 3'b111
`define MOV 3'b110

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

    reg [2:0] state;

    always@(posedge clk)begin
        if(reset)begin
            state = `waiting;
            w     = 1'b1;
        end
        else begin
            case(state)
                `waiting: if(s)begin
                    state = (opcode == 3'b110 && op == 2'b10) ? `writeRn : `readRm;

                    case (opcode)
                        3'b110: begin
                            case (op)
                                2'b10: state = `writeRn;
                                2'b00: state = `readRm;
                                default: state = `waiting; // unreachable with valid uses of MOV
                            endcase
                        end
                        `ALU: begin
                            case (op)
                                `ADD: state = `waiting;
                                `CMP: state = `waiting;
                                `AND: state = `waiting;
                                `MOV: state = `waiting;
                                default: state = `waiting; // unreachable
                            endcase
                        end
                        default: state = `waiting; // unreachable unless invalid opcode and op
                    endcase
                    write = 1'b0;
                    w     = 1'b0;
                end
                else begin
                    write = 1'b0;
                    state = `waiting;
                    w     = 1'b1;
                end
                `writeRn: begin
                    nsel  = 3'b001;
                    vsel  = 2'b01;
                    write = 1'b1;
                    state = `waiting;
                    w     = 1'b1;
                end
                // `readRm: begin
                //     nsel  = 3'b100;
                //     loadb = 1'b1;
                //     state = (opcode == 3'b101 && op != 2'b11) ? `shiftread : `shift;
                //     w     = 1'b0;
                // end
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
                // `writeRd: begin
                //     nsel  = 3'b010;
                //     vsel  = 2'b11;
                //     write = 1'b1;
                //     state = `waiting;
                //     w     = 1'b1;
                // end
                default: state = `waiting;
            endcase 
        end
    end
endmodule