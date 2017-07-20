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

    // PCIe ports
    input  PCIEPacket pcie_packet_in,
    output PCIEPacket pcie_packet_out
  );

  /* PCIEPacket pcie_packet_grayscale; */

  rgb2luma uu_rgb2luma
    (
      .clk             (clk),
      .rst             (rst),
      .pcie_packet_in  (pcie_packet_in),
      .pcie_packet_out (pcie_packet_out)
      /* .pcie_packet_out (pcie_packet_grayscale) */
    );

  /* sobel_unit uu_sobel_unit */
  /*   ( */
  /*     .clk             (clk), */
  /*     .rst             (rst), */
  /*     .pcie_packet_in  (pcie_packet_grayscale), */
  /*     .pcie_packet_out (pcie_packet_out) */
  /*   ); */

endmodule : sobel_filter

