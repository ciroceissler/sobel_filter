//===----- sobel_filter.sv - module Sobel Filter --------------------------===//
//
// Copyright (c) 2017 Ciro Ceissler
//
// See LICENSE for details.
//
//===----------------------------------------------------------------------===//
//
// SystemVerilog Module to Sobel Filter
//
//===----------------------------------------------------------------------===//

module sobel_filter
  (
    // system ports
    input clk,
    input rst,

    // data ports
    input [127:0] data_in,
    input valid_in,
    output reg [127:0] data_out,
    output reg valid_out
  );

  reg [15:0] valid_out_array;

  assign valid_out = (& valid_out_array);

  for (genvar i = 0; i < 16; i++) begin
    rgb2luma uu_rgb2luma
      (
        .clk       (clk),
        .rst       (rst),
        .data_in   (data_in[8*i + 7:8*i]),
        .valid_in  (valid_in),
        .data_out  (data_out[8*i + 7:8*i]),
        .valid_out (valid_out_array[i])
      );
  end

endmodule : sobel_filter

