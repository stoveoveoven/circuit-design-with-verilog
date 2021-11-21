`define writeRn     3'b000
`define readRm      3'b001
`define shift       3'b010
`define writeRd     3'b011
`define ALU         3'b101
`define shiftread   3'b100 
`define waiting     3'b111

module controller(  s, reset, w, opcode, op,                                                    //inputs
                    write, nsel, vsel, loada, loadb, loadc, asel, bsel, loads, mdata, PC);      //outputs
    input s, reset;
    input [2:0] opcode;
    input [1:0] op;
    output reg w, loada, loadb, loadc asel, bsel, loads;
    output reg [1:0] vsel;
    output reg [2:0] nsel;
    output reg [7:0] PC;
    output reg [15:0] mdata;

    reg [2:0] state;

    always@(posedge clk)begin
        if(reset)
            state = `waiting;
            w     = 1'b1;
        else begin
            case(state)
                `waiting: if(s)
                    state = (opcode == 3'b110 && op == 2'b01) ? `writeRn : `readRm;
                    w     = 1'b0;
                else begin
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
                `readRm: begin
                    nsel  = 3'b100;
                    loadb = 1'b1;
                    state = (opcode == 3'b101 && op != 2'b11) ? `shiftread : `shift;
                    w     = 1'b0;
                end
                `shift: begin
                    asel  = 1'b1;
                    bsel  = 1'b0;
                    loadc = 1'b1;
                    state = (opcode == 3'b101) ? `ALU : `writeRd;
                    w     = 1'b0
                end
                `shiftread: begin
                    nsel  = 3'b001;
                    loada = 1'b1;
                    bsel  = 1'b0;
                    asel  = 1'b0;
                    state = `ALU;
                    w     = 1'b0;
                end
                `ALU: begin
                    asel = 1'b0;
                    bsel = 1'b0;
                    //if command is CMP
                    if(op == 2'b01)begin
                        loads = 1'b1;
                        loadc = 1'b0;
                        state = `waiting;
                        w     = 1'b1;
                    end
                    else begin
                        loadc = 1'b1;
                        state = `writeRd;
                        w     = 1'b0;
                    end
                end
                `writeRd: begin
                    
                end
                default: state = `waiting;
            endcase 
        end
    end

endmodule