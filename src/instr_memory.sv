//-----------------------------------------------------------------------------
// Module: instr_memory
// Description: 256 x 16-bit instruction memory (read-only)
//              Initialized from "program.mem"
//-----------------------------------------------------------------------------

`timescale 1ns/1ps
/* verilator lint_off UNUSEDSIGNAL */
module instr_memory (
    input  logic [15:0] pc,
    output logic [15:0] instr
);

    logic [15:0] memory [0:255];

    assign instr = memory[pc[7:0]];

    initial begin
        $readmemb("program.mem", memory);
    end

endmodule
/* verilator lint_on UNUSEDSIGNAL */
