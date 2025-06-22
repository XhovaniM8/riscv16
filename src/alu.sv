// src/alu.v
module alu (
    input  logic [15:0] op1,
    input  logic [15:0] op2,
    input  logic [2:0]  alu_op,   // e.g., 000 = ADD, 001 = NAND
    output logic [15:0] result
);

    always_comb begin
        case (alu_op)
            3'b000: result = op1 + op2;             // ADD
            3'b001: result = ~(op1 & op2);          // NAND
            default: result = 16'h0000;
        endcase
    end

endmodule
