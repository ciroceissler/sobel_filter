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

  reg clk;
  reg rst;
  reg [127:0] data_in;
  reg valid_in;

  wire [127:0] data_out;
  wire valid_out;

  sobel_filter uu_sobel_filter
    (
      .clk       (clk),
      .rst       (rst),
      .data_in   (data_in),
      .valid_in  (valid_in),
      .data_out  (data_out),
      .valid_out (valid_out)
    );

  always begin
    #10 clk <= ~clk;
  end

  initial begin
    clk      = 0;
    rst      = 0;
    valid_in = 1'b0;
    data_in  = {128{1'b0}};

    #10 rst = 1;
    #10 rst = 0;

    // TODO(ciroceissler): connect with libpng using DPI-C
    for (int i = 0; i < 30; i++) begin
      data_in  <= {4{$urandom}};
      valid_in <= $urandom%2;

      if (valid_in) begin
        $display("data_in = %d", data_in[7:0]);
      end

      @(posedge clk);
    end

    valid_in <= 1'b0;

    #1000 $finish;
  end

  always@(posedge clk) begin
    if (valid_out) begin
      $display("data_out = %d", data_out[7:0]);
    end
  end

endmodule : testbench
