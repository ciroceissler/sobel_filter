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
    input  [9:0] r,
    input  [9:0] g,
    input  [9:0] b,
    output [9:0] y
  );

  // y = 0.299*r + 0.587*g + 0.114*b;
  assign y = (r >> 2) +
             (r >> 5) +
             (g >> 1) +
             (g >> 4) +
             (b >> 4) +
             (b >> 5);

endmodule : sobel_filter

