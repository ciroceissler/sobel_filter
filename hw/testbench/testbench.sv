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

typedef bit [127:0] image_t;

module testbench;

  reg clk;
  reg rst;
  reg [127:0] data_in;
  reg valid_in;

  wire [127:0] data_out;
  wire valid_out;

  int size;
  int output_ptr;
  bit [31:0] image[];
  bit [31:0] image_out[];

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
    clk        = 0;
    rst        = 0;
    output_ptr = 0;
    valid_in   = 1'b0;
    data_in    = {128{1'b0}};

    #10 rst = 1;
    #10 rst = 0;

    read_png_file("input.png");

    size = get_image_size();

    image     = new[size*3];
    image_out = new[size*3];

    rd_image(image);

    for (int i = 0; i < size*3; i = i + 48) begin
      bit [7:0] r[16];
      bit [7:0] g[16];
      bit [7:0] b[16];

      for (int j = 0; j < 16; j++) begin
        r[15 - j] = image[i + 3*j];
        g[15 - j] = image[i + 3*j + 1];
        b[15 - j] = image[i + 3*j + 2];
      end

      data_in  <= image_t'(r);
      valid_in <= 1'b1;
      @(posedge clk);

      data_in  <= image_t'(g);
      valid_in <= 1'b1;
      @(posedge clk);

      data_in  <= image_t'(b);
      valid_in <= 1'b1;
      @(posedge clk);
    end

    valid_in <= 1'b0;

    #1000;

    wr_image(image_out);
    write_png_file("output.png");

    $finish;

  end

  always@(posedge clk) begin
    if (valid_out) begin
      for (int j = 0; j < 16; j++) begin
        image_out[output_ptr++] = data_out[8*j +: 8];
        image_out[output_ptr++] = data_out[8*j +: 8];
        image_out[output_ptr++] = data_out[8*j +: 8];
      end
    end
  end

endmodule : testbench

