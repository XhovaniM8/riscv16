/***************************************************************************
 *
 * Module:  alu.sv
 *
 * Description: This module implements an 16b ALU
 *
 ****************************************************************************/
module alu (
    input logic [15:0] alu_sr1, alu_src2,
    input logic ADD, NAND, PASS1, EQ,
    output logic [15:0] alu_out,
    output logic eq_out
);
    assign alu_out = (ADD) ? alu_src1 + alu_src2 :
                     (NAND) ? ~(alu_src1 & alu_src2) :
                     (PASS1) ? alu_src1 : 16'b0;
    
    assign eq_out = (EQ) ? (alu_src1 == alu_src2) : 1'b0;
endmodule
