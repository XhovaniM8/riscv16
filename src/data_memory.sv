module data_memory (
    input logic clk,
    input logic we_mem,
    input logic [15:0] addr,
    input logic [15:0] data_in,
    output logic [15:0] data_out;
);
    reg [15:0] memory[0:255];
    assign data_out = memory[addr[7:0]];

    always @(posedge clk) begin
        if (we_mem)
        memory[addr[7:0]] <= data_in 
    end
endmodule
