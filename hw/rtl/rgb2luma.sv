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
    input [7:0] data_in,
    input valid_in,
    output reg [7:0] data_out,
    output reg valid_out
  );

  localparam [2:0] RED   = 3'b001,
                   GREEN = 3'b010,
                   BLUE  = 3'b100;

  reg [2:0] color;

  always_ff@(posedge clk or posedge rst) begin : GRAYSCALE
    if (rst) begin : RESET
      data_out  <= 8'h00;
      valid_out <= 1'b0;
      color     <= RED;
    end : RESET
    else begin : NORMAL_FLOW
      if (valid_in) begin : VALID
        case (color)
          RED:
            begin
              data_out  <= data_in*0.299;
              valid_out <= 1'b0;
              color     <= GREEN;
            end

          GREEN:
            begin
              data_out  <= data_out + data_in*0.587;
              valid_out <= 1'b0;
              color     <= BLUE;
            end

          BLUE:
            begin
              data_out  <= data_out + data_in*0.114;
              valid_out <= 1'b1;
              color     <= RED;
            end

          default:
            begin
              valid_out <= 1'b0;
            end
        endcase
      end : VALID
      else begin : NOT_VALID
        valid_out <= 1'b0;
      end : NOT_VALID
    end : NORMAL_FLOW
  end : GRAYSCALE

endmodule : rgb2luma

