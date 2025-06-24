//-----------------------------------------------------------------------------
// Module: regfile
// Description: 8-register file with two read ports and one write port
//              - Register 0 is hardwired to zero (read-only)
//              - Write occurs on positive clock edge when we_reg is high
//-----------------------------------------------------------------------------

`timescale 1ns / 1ps

module regfile(
    input  logic        clk,
    input  logic        we_reg,
    input  logic [2:0]  src1, src2, tgt,
    input  logic [15:0] write_data,
    output logic [15:0] src1_val, src2_val
);

    logic [15:0] registers [7:0];

    // Read logic with register zero hardwired to zero
    assign src1_val = (src1 == 3'b000) ? 16'b0 : registers[src1];
    assign src2_val = (src2 == 3'b000) ? 16'b0 : registers[src2];

    // Write logic with register zero protected
    always_ff @(posedge clk) begin
        if (we_reg && tgt != 3'b000)
            registers[tgt] <= write_data;
    end

endmodule
