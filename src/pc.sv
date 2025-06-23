// Program Counter

module pc(
    input  logic clk;
    input  logic rst;
    input  logic [15:0] nextpc;
    output logic [15:0] pc;
);
    always @(posedge clk or posedge rst)
    begin
        if (rst) pc <= 16'b0;
        else pc <= nextpc;
    end
endmodule // program_counter

