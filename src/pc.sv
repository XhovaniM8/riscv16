// Program Counter

module pc(
    input  logic        clk,
    input  logic        rst,
    input  logic [15:0] nextpc,
    output logic [15:0] pc_out  // renamed from 'pc'
);
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            pc_out <= 16'b0;
        else
            pc_out <= nextpc;
    end
endmodule
