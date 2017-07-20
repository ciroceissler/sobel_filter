//===----- interface.sv - simple package to simulation --------------------===//
//
// Copyright (c) 2017 Ciro Ceissler
//
// See LICENSE for details.
//
//===----------------------------------------------------------------------===//
//
// SystemVerilog Package to simulation (isn't the the same)
//
//===----------------------------------------------------------------------===//
package pcie_package;

  typedef struct packed {
    logic [127:0] data;
    logic         valid;
    logic         last;
    logic [15:0]  slot;
    logic [ 3:0]  pad;
  } PCIEPacket;

endpackage : pcie_package

