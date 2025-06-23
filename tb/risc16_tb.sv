`timescale 1ns/1ps

module top_tb;
    reg clk;
    reg reset;
    wire [15:0] curr_pc;
    wire [15:0] curr_instr;

    // Instantiate the top-level module
    top uut (
        .clk(clk),
        .reset(reset),
        .curr_pc(curr_pc),
        .curr_instr(curr_instr)
    );

    // Clock generator: 10ns period
    always #5 clk = ~clk;

    initial begin
        $display("==== RiSC-16 Processor Simulation Start ====");
        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);

        // Initialize inputs
        clk = 0;
        reset = 1;

        // Wait for reset
        #10;
        reset = 0;

        // Run for 100 cycles
        repeat (100) begin
            @(posedge clk);
            $display("PC: %d | Instr: %b", curr_pc, curr_instr);
        end

        $display("==== Simulation Finished ====");
        $finish;
    end
endmodule