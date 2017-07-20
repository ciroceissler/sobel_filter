//===----- rgb2luma.sv - module convert RGB to luma ----------------------===//
//
// Copyright (c) 2017 Ciro Ceissler
//
// See LICENSE for details.
//
//===----------------------------------------------------------------------===//
//
// SystemVerilog Module to convert RGB to luma
//
//===----------------------------------------------------------------------===//

import pcie_package::*;

module rgb2luma
  (
    // system ports
    input clk,
    input rst,

    // PCIe ports
    input  PCIEPacket pcie_packet_in,
    output PCIEPacket pcie_packet_out
  );

  reg [127:0] data_out;
  reg         valid_out;
  reg         last_out;
  reg [15:0]  slot_out;
  reg [ 3:0]  pad_out;

  assign pcie_packet_out.slot  = slot_out;
  assign pcie_packet_out.pad   = pad_out;
  assign pcie_packet_out.last  = last_out;
  assign pcie_packet_out.valid = valid_out;
  assign pcie_packet_out.data  = data_out;

  always_ff@(posedge clk) begin
    slot_out  <= pcie_packet_in.slot;
    pad_out   <= pcie_packet_in.pad;
    last_out  <= pcie_packet_in.last;
    valid_out <= pcie_packet_in.valid;
    data_out  <= (((pcie_packet_in.data[7:0]*66 +
                    pcie_packet_in.data[15:8]*129 +
                    pcie_packet_in.data[23:16]*25) + 128) >> 8) + 16;
  end


endmodule : rgb2luma

