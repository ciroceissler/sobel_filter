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

import "DPI-C" function int get_image_size();

import "DPI-C" function void read_png_file(string filename);

import "DPI-C" function void write_png_file(string filename);

import "DPI-C" function void rd_image(output bit [31:0] image[]);

import "DPI-C" function void wr_image(input bit [31:0] image[]);

module testbench;

  reg clk;
  reg rst;
  reg [127:0] data_in;
  reg valid_in;

  wire [127:0] data_out;
  wire valid_out;

  int size;
  bit [31:0] image[];

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

    read_png_file("input.png");
    
    size = get_image_size();

    image = new[size*3];

    rd_image(image);

    for (int i = 0; i < 100; i++) begin
      image[i] = 0;
    end

    wr_image(image);

    write_png_file("output.png");

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
