`timescale 1ns / 1ps

module fifo_16x16(
    input clk,
    input rst,
    input wrt_enb,
    input rd_enb,
    input [15:0] data_in,
    output full,
    output empty,
    output wire [15:0] data_out
);

reg [4:0] wrt_ptr;
reg [4:0] rd_ptr;

reg [15:0] mem [0:15];

assign empty = (wrt_ptr == rd_ptr);
assign full = (wrt_ptr[4] != rd_ptr[4]) &&
              (wrt_ptr[3:0] == rd_ptr[3:0]);

assign data_out = mem[rd_ptr[3:0]];

always @(posedge clk) begin

    if (rst) begin
        wrt_ptr <= 5'b00000;
        rd_ptr <= 5'b00000;
    end

    else begin

        if (wrt_enb && !full) begin
            mem[wrt_ptr[3:0]] <= data_in;
            wrt_ptr <= wrt_ptr + 1'b1;
        end

        if (rd_enb && !empty) begin
            rd_ptr <= rd_ptr + 1'b1;
        end

    end

end

endmodule
