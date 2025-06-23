`timescale 1ns / 1ps

module alu_tb;

    logic clk;
    logic [15:0] alu_src1, alu_src2;
    logic ADD, NAND, PASS1, EQ;
    logic [15:0] alu_out;
    logic eq_out;

    // Clock generator: 100MHz (10ns period)
    always #5 clk = ~clk;

    // Instantiate ALU
    alu uut (
        .alu_src1(alu_src1),
        .alu_src2(alu_src2),
        .ADD(ADD),
        .NAND(NAND),
        .PASS1(PASS1),
        .EQ(EQ),
        .alu_out(alu_out),
        .eq_out(eq_out)
    );

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        clk = 0;

        // --- ADD test ---
        alu_src1 = 16'd5;
        alu_src2 = 16'd3;
        ADD = 1; NAND = 0; PASS1 = 0; EQ = 0;
        repeat (1) @(posedge clk);
        $display("ADD: %0d + %0d = %0d", alu_src1, alu_src2, alu_out);

        // --- NAND test ---
        alu_src1 = 16'hFFFF;
        alu_src2 = 16'h00FF;
        ADD = 0; NAND = 1; PASS1 = 0; EQ = 0;
        repeat (1) @(posedge clk);
        $display("NAND: ~(%h & %h) = %h", alu_src1, alu_src2, alu_out);

        // --- PASS1 test ---
        alu_src1 = 16'hDEAD;
        alu_src2 = 16'hBEEF;
        ADD = 0; NAND = 0; PASS1 = 1; EQ = 0;
        repeat (1) @(posedge clk);
        $display("PASS1: alu_out = %h (should be %h)", alu_out, alu_src1);

        // --- EQ test: equal case ---
        alu_src1 = 16'hAAAA;
        alu_src2 = 16'hAAAA;
        ADD = 0; NAND = 0; PASS1 = 0; EQ = 1;
        repeat (1) @(posedge clk);
        $display("EQ (equal): eq_out = %b", eq_out);

        // --- EQ test: not equal case ---
        alu_src2 = 16'h1234;
        repeat (1) @(posedge clk);
        $display("EQ (not equal): eq_out = %b", eq_out);

        $display("ALU testbench completed.");
        $finish;
    end
endmodule
