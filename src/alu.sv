//-----------------------------------------------------------------------------
// Module: alu
// Description: 16-bit Arithmetic Logic Unit
//              Supports ADD, NAND, PASS1 operations and EQ comparison
//-----------------------------------------------------------------------------

`timescale 1ns/1ps

module alu (
    input  logic [15:0] alu_src1,
    input  logic [15:0] alu_src2,
    input  logic ADD,
    input  logic NAND,
    input  logic PASS1,
    input  logic EQ,
    output logic [15:0] alu_out,
    output logic eq_out
);
    always_comb begin
        if (ADD)
            alu_out = alu_src1 + alu_src2;
        else if (NAND)
            alu_out = ~(alu_src1 & alu_src2);
        else if (PASS1)
            alu_out = alu_src1;
        else
            alu_out = 16'h0000;

        eq_out = (EQ) ? (alu_src1 == alu_src2) : 1'b0;
    end
endmodule
