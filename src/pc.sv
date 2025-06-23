// Program Counter

module counter (
  input  logic clk,
  input  logic rst,
  input  logic [15:0] nextpc,
  output logic [15:0] pc
);

initial begin 
    pc <= 16'h0000;
end

always @(posedge clk)
    begin
        if (rst == 1)
            begin
                pc <= 16'h0000;
            end
        else
            begin
                nextpc <= nextpc + 1;
            end
    end
endmodule // counter.sv

