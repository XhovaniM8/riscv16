//-----------------------------------------------------------------------------
// Module: risc16_top
// Description: Top-level integration of the RiSC-16 datapath
//              - Includes PC, instruction memory, register file, ALU, data memory, control
//              - Supports basic instruction execution flow with branching
//-----------------------------------------------------------------------------

`include "pc.sv"
`include "regfile.sv"
`include "instr_memory.sv"
`include "data_memory.sv"
`include "alu.sv"
`include "control.sv"

`timescale 1ns/1ps

/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off PINCONNECTEMPTY */

module risc16_top(
    input  wire        clk,
    input  wire        reset,
    output wire [15:0] curr_pc,
    output wire [15:0] curr_instr
);

    // Intermediate signals
    wire [15:0] nextpc, alu_out, data_out;
    wire [15:0] src1_val, src2_val;

    // Decode instruction fields
    wire [2:0] opcode = curr_instr[15:13];
    wire [2:0] regA   = curr_instr[12:10];
    wire [2:0] regB   = curr_instr[9:7];
    wire [6:0] imm    = curr_instr[6:0];

    wire [15:0] imm_ext = {{9{imm[6]}}, imm};  // Sign-extended immediate

    // Control signals
    wire we_reg, ADD, NAND, PASS1, we_mem, BR;
    wire eq_out_unmasked;
    wire eq_out = eq_out_unmasked;

    // Program Counter
    pc pc_inst(
        .clk(clk),
        .rst(reset),
        .nextpc(nextpc),
        .pc_out(curr_pc)
    );

    // Instruction Memory
    instr_memory imem(
        .pc(curr_pc),
        .instr(curr_instr)
    );

    // Register File
    regfile rf(
        .clk(clk),
        .we_reg(we_reg),
        .src1(regA),
        .src2(regB),
        .tgt(regB),
        .write_data((opcode == 3'b101) ? data_out : alu_out),
        .src1_val(src1_val),
        .src2_val(src2_val)
    );

    // ALU
    alu alu_inst(
        .alu_src1(src1_val),
        .alu_src2((opcode == 3'b000 || opcode == 3'b001) ? src2_val : imm_ext),
        .ADD(ADD),
        .NAND(NAND),
        .PASS1(PASS1),
        .EQ(1'b1),  // Always compare
        .alu_out(alu_out),
        .eq_out(eq_out_unmasked)
    );

    // Data Memory
    data_memory dmem(
        .clk(clk),
        .we_mem(we_mem),
        .addr(alu_out),
        .data_in(src2_val),
        .data_out(data_out)
    );

    // Control Unit
    control ctrl(
        .opcode(opcode),
        .eq_out(eq_out_unmasked),
        .we_reg(we_reg),
        .ADD(ADD),
        .NAND(NAND),
        .PASS1(PASS1),
        .we_mem(we_mem),
        .EQ(),      // Add this line — explicitly leave EQ unconnected
        .BR(BR)
    );


    // Next PC logic
    assign nextpc = reset ? 16'b0 : (BR ? curr_pc + imm_ext : curr_pc + 16'd1);

endmodule

/* verilator lint_on UNUSEDSIGNAL */
/* verilator lint_on PINCONNECTEMPTY */
