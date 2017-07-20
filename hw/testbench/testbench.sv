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

typedef bit [127:0] block_t;

module testbench;

  localparam int RED   = 0,
                 GREEN = 1,
                 BLUE  = 2;

  reg clk;
  reg rst;

  PCIEPacket pcie_packet_in;
  PCIEPacket pcie_packet_out;

  reg [127:0] data_in;
  reg valid_in;

  wire [127:0] data_out;
  wire valid_out;

  assign pcie_packet_in = '{valid: valid_in,
                            data : data_in,
                            slot : 16'h0,
                            pad  : 4'h0,
                            last : 1'b0};

   assign data_out  = pcie_packet_out.data;
   assign valid_out = pcie_packet_out.valid;

  int size;
  int output_ptr;
  bit [31:0] image[];
  bit [31:0] image_out[];

  sobel_filter uu_sobel_filter
    (
      .clk             (clk),
      .rst             (rst),
      .pcie_packet_in  (pcie_packet_in),
      .pcie_packet_out (pcie_packet_out)
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

    for (int i = 0; i < size*3; i = i + 3) begin
      data_in  <= {104'h0, image[i + 2][7:0], image[i + 1][7:0], image[i][7:0]};
      valid_in <= 1'b1;
      @(posedge clk);
    end

    valid_in <= 1'b0;

    #1000;

    wr_image(image_out);
    write_png_file("output.png");

    $display("size output: %d", output_ptr++);

    $finish;

  end

  always@(posedge clk) begin
    if (valid_out) begin
      image_out[output_ptr++] = data_out[7:0];
      image_out[output_ptr++] = data_out[7:0];
      image_out[output_ptr++] = data_out[7:0];
    end
  end

endmodule : testbench

