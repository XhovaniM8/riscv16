/***************************************************************************
 *
 * Module:  data_memory.sv
 *
 * Description: 256-word x 16-bit data memory
 *
 ***************************************************************************/
module data_memory (
    input  logic        clk,
    input  logic        we_mem,
    input  logic [15:0] addr,
    input  logic [15:0] data_in,
    output logic [15:0] data_out
);
    logic [15:0] memory [0:255];
    logic [7:0]  effective_addr;

    assign effective_addr = addr[7:0];  // Explicitly use lower 8 bits
    assign data_out = memory[effective_addr];

    always_ff @(posedge clk) begin
        if (we_mem)
            memory[effective_addr] <= data_in;
    end
endmodule
