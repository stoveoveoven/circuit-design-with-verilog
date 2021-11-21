`define writeRn 3'b000
`define readRm  3'b001
`define shift   3'b010
`define writeRd 3'b011
`define readRn  3'b100 
`define ALU     3'b101 
`define waiting 3'b111

module controller(s, reset, w, opcode, op, nsel, vsel, loada, loadb, loadc, asel, bsel, loads, mdata, C, PC);
    input s, reset;
    input[2:0] opcode;
    input[1:0] op;
    output w, vsel, loada, loadb, loadc asel, bsel, loads;
    output[2:0] nsel;
    output[7:0] PC;
    output[15:0] mdata, C;

    wire[2:0] state;

    always@(posedge clk)begin
        if(reset)
            state = `waiting;
        else begin
            case(state)
                `waiting: 
                    if(s)begin
                        if(opcode == 3'b110 && op == 2'b01)
                            state = `writeRn;
                        else begin
                            state = `readRm;
                        end
                    end
                `writeRn:
                `readRm:
                `shift:
                `writeRd:
                `readRn:
                `ALU:
                default: state = `waiting;
            endcase 
        end
    end

endmodule