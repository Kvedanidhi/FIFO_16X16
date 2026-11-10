`timescale 1ns / 1ps
module mod_b(
    input clk,
    input rst,
    input empty,
    input [15:0] data_out,
    output wire rd_en,
    output reg [15:0] received_data,
    output reg data_valid
);

assign rd_en = ~empty;

always @(posedge clk) begin
    if (rst) begin
        received_data <= 16'd0;
        data_valid <= 1'b0;
    end
    else begin
	  if (rd_en) begin
            received_data <= data_out;
            data_valid <= 1'b1;
        end
        else begin
            data_valid <= 1'b0;
        end
    end
end

endmodule
