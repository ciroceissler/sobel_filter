//===----- testbench.sv - module Sobel Filter -----------------------------===//
//
// Copyright (c) 2017 Ciro Ceissler
//
// See LICENSE for details.
//
//===----------------------------------------------------------------------===//
//
// SystemVerilog Testbench
//
//===----------------------------------------------------------------------===//

module testbench;

  reg  [9:0] r;
  reg  [9:0] g;
  reg  [9:0] b;
  wire [9:0] y;

  sobel_filter uu_sobel_filter
    (
      .r(r),
      .g(g),
      .b(b),
      .y(y)
    );

  initial begin : MAIN
    int i;

    for (i = 0; i < 10; i++) begin : DUMMY_DATA
      r = $urandom;
      g = $urandom;
      b = $urandom;
      #10;
      $display("y = %d\n", y);
    end : DUMMY_DATA

  end : MAIN

endmodule : testbench
