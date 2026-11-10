`timescale 1ns / 1ps
module top_module(
    input clk,
    input rst,
    output [15:0] received_data,
    output data_valid,
    output full,
    output empty
);

wire [15:0] data_in;
wire [15:0] data_out;

wire wr_en;
wire rd_en;

mod_a A1 (
    .clk(clk),
    .rst(rst),
    .full(full),
    .data_in(data_in),
    .wr_en(wr_en)
);
fifo_16x16 F1 (
    .clk(clk),
    .rst(rst),
    .wrt_enb(wr_en),
    .rd_enb(rd_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
);
mod_b B1 (
    .clk(clk),
    .rst(rst),
    .empty(empty),
    .data_out(data_out),
    .rd_en(rd_en),
    .received_data(received_data),
    .data_valid(data_valid)
);

endmodule
