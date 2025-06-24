//-----------------------------------------------------------------------------
// Module: control
// Description: Control unit for 16-bit RISC-style processor.
//              Decodes 3-bit opcode and generates control signals.
//-----------------------------------------------------------------------------

`timescale 1ns/1ps

module control (
    input  wire [2:0] opcode,
    input  wire       eq_out,
    output reg        we_reg,
    output reg        ADD,
    output reg        NAND,
    output reg        PASS1,
    output reg        we_mem,
    output reg        EQ,
    output reg        BR
);

    always @(*) begin
        // Default all control signals to zero
        {we_reg, ADD, NAND, PASS1, we_mem, EQ, BR} = 7'b0;

        case (opcode)
            3'b000: begin ADD   = 1; we_reg = 1; end // ADD
            3'b001: begin NAND  = 1; we_reg = 1; end // NAND
            3'b010: begin PASS1 = 1; we_reg = 1; end // LUI / JALR
            3'b011: begin EQ    = 1; BR     = eq_out; end // BEQ
            3'b100: begin we_mem = 1; end             // SW
            3'b101: begin we_reg = 1; end             // LW
            default: ; // No operation
        endcase
    end

endmodule
