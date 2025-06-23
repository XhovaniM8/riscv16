`include "pc.v"
`include "regfile.v"
`include "instr_mem.v"
`include "data_mem.v"
`include "alu.v"
`include "control.v"

module top(
    input wire clk,
    input wire reset,
    output wire [15:0] curr_pc,
    output wire [15:0] curr_instr
);
    wire [15:0] nextpc, alu_out, data_out;
    wire [15:0] src1_val, src2_val;
    wire [2:0] opcode = curr_instr[15:13];
    wire [2:0] regA = curr_instr[12:10];
    wire [2:0] regB = curr_instr[9:7];
    wire [6:0] imm = curr_instr[6:0];
    wire [15:0] imm_ext = {{9{imm[6]}}, imm};

    wire we_reg, ADD, NAND, PASS1, we_mem, EQ, BR;
    wire eq_out;

    pc pc_inst(.clk(clk), .rst(reset), .nextpc(nextpc), .pc(curr_pc));
    instr_mem imem(.pc(curr_pc), .instr(curr_instr));
    regfile rf(
        .clk(clk), .we_reg(we_reg),
        .src1(regA), .src2(regB), .tgt(regB),
        .write_data((opcode == 3'b101) ? data_out : alu_out),
        .src1_val(src1_val), .src2_val(src2_val)
    );
    alu alu_inst(
        .alu_src1(src1_val),
        .alu_src2((opcode == 3'b000 || opcode == 3'b001) ? src2_val : imm_ext),
        .ADD(ADD), .NAND(NAND), .PASS1(PASS1), .EQ(EQ),
        .alu_out(alu_out), .eq_out(eq_out)
    );
    data_mem dmem(
        .clk(clk), .we_mem(we_mem),
        .addr(alu_out),
        .data_in(src2_val),
        .data_out(data_out)
    );
    control ctrl(
        .opcode(opcode), .eq_out(eq_out),
        .we_reg(we_reg), .ADD(ADD), .NAND(NAND), .PASS1(PASS1),
        .we_mem(we_mem), .EQ(EQ), .BR(BR)
    );

    assign nextpc = reset ? 16'b0 : (BR ? curr_pc + imm_ext : curr_pc + 1);
endmodule