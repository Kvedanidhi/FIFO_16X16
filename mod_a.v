`timescale 1ns / 1ps

module mod_a(
    input clk,
    input rst,
    input full,
    output reg [15:0] data_in,
    output wire wr_en
);

assign wr_en = ~full;

always @(posedge clk) begin
    if (rst)
        data_in <= 16'd0;
    else if (wr_en)
        data_in <= data_in + 1'b1;
end

endmodule
