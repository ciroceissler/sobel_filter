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

module rgb2luma
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

  localparam [2:0] RED   = 3'b001,
                   GREEN = 3'b010,
                   BLUE  = 3'b100;

  reg [2:0] color;

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      data_out <= 8'h00;
    end
    else if (valid_in) begin
      case (color)
        RED    : data_out <= data_in*0.299;
        GREEN  : data_out <= data_out + data_in*0.587;
        BLUE   : data_out <= data_out + data_in*0.114;
      endcase
    end
  end

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      color <= RED;
    end
    else if (valid_in) begin
      case (color)
        RED    : color <= GREEN;
        GREEN  : color <= BLUE;
        BLUE   : color <= RED;
        default: color <= RED;
      endcase
    end
  end

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      valid_out <= 1'b0;
    end
    else begin
      case (color)
        BLUE   : valid_out <= valid_in;
        default: valid_out <= 1'b0;
      endcase
    end
  end

endmodule : rgb2luma

