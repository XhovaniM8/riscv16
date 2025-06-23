// This is a Verilog description for an 8 x 16 register file

`timescale 1ns / 1ps

module regfile(
    input logic clk,
    input logic we_reg,
    input logic [2:0] src1, src2, tgt,
    input logic [15:0] write_data,
    output logic [15:0] src1_val, src2_val
);

   reg [15:0] registers[7:0];

   assign src1_val = (src == 3'b000) ? 16'b0 : register[src1]
   assign src2_val = (src == 3'b000) ? 16'b0 : register[src2]

   always @(posedge clk) begin
      if (we_reg && tgt != 3'b000)
         registers[tgt] <= write_data;
   end
endmodule
