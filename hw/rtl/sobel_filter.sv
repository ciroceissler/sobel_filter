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
    input      [7:0] data_in,
    input            valid_in,
    output reg [7:0] data_out,
    output reg       valid_out
  );

  reg [127:0] data_grayscale;
  reg         valid_grayscale;

  reg [ 0:0] valid_grayscale_array;
  reg [ 0:0] valid_sobel_array;

  assign valid_out       = (& valid_sobel_array);
  assign valid_grayscale = (& valid_grayscale_array);

  rgb2luma uu_rgb2luma
    (
      .clk       (clk),
      .rst       (rst),
      .data_in   (data_in[8*0 +: 8]),
      .valid_in  (valid_in),
      .data_out  (data_grayscale[8*0 +: 8]),
      .valid_out (valid_grayscale_array[0])
    );

  sobel_unit uu_sobel_unit
    (
      .clk       (clk),
      .rst       (rst),
      .data_in   (data_grayscale[8*0 +: 8]),
      .valid_in  (valid_grayscale),
      .data_out  (data_out[8*0 +: 8]),
      .valid_out (valid_sobel_array[0])
    );

endmodule : sobel_filter

