// tb/alu_tb.v
`timescale 1ns / 1ps
module alu_tb;

    logic [15:0] op1, op2;
    logic [2:0]  alu_op;
    logic [15:0] result;

    alu uut (
        .op1(op1),
        .op2(op2),
        .alu_op(alu_op),
        .result(result)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, alu_tb);

        // ADD
        op1 = 16'd5; op2 = 16'd3; alu_op = 3'b000;
        #10;

        // NAND
        op1 = 16'hFFFF; op2 = 16'h00FF; alu_op = 3'b001;
        #10;

        $finish;
    end
endmodule
