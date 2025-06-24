//-----------------------------------------------------------------------------
// Module: data_memory
// Description: 256 x 16-bit data memory (byte-addressed using lower 8 bits of addr)
//-----------------------------------------------------------------------------

`timescale 1ns/1ps
/* verilator lint_off UNUSEDSIGNAL */
module data_memory (
    input  logic        clk,
    input  logic        we_mem,
    input  logic [15:0] addr,
    input  logic [15:0] data_in,
    output logic [15:0] data_out
);

    logic [15:0] memory [0:255];       // 256-word memory
    logic [7:0]  effective_addr;

    assign effective_addr = addr[7:0]; // Use lower 8 bits of addr
    assign data_out = memory[effective_addr];

    always_ff @(posedge clk) begin
        if (we_mem)
            memory[effective_addr] <= data_in;
    end

endmodule
/* verilator lint_on UNUSEDSIGNAL */
