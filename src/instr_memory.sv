/***************************************************************************
 *
 * Module:  instr_memory.sv
 *
 * Description: This module implements an 16b instruction memory
 *
 ****************************************************************************/
module instr_memory(
    input logic [15:0] pc,
    output logic [15:0] instr
);
    reg [15:0] memory[0:255];
    assign instr = memory[pc[7:0]];

    initial $readmemb("program.mem", memory);
endmodule
