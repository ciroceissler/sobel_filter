//===----- sobel_unit.sv - module Unit of Sobel Filter --------------------===//
//
// Copyright (c) 2017 Ciro Ceissler
//
// See LICENSE for details.
//
//===----------------------------------------------------------------------===//
//
// SystemVerilog Module to Unit of Sobel Filter
//
//===----------------------------------------------------------------------===//

module sobel_unit
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

  reg [7:0] row_buffer[2][640];

  reg [7:0] pipeline_dir_x[3][3];
  reg [7:0] pipeline_dir_y[3][3];

  reg [7:0] window[3];

  reg [9:0] ptr_buffer;

  reg [7:0] dir_x;
  reg [7:0] dir_y;

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      ptr_buffer <= 0;
    end
    else if (valid_in) begin
      ptr_buffer <= (ptr_buffer < 639) ? (ptr_buffer + 1) : 0;
    end
  end

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      for (int i = 0; i < 640; i++) begin
        row_buffer[0][i] <= 8'h00;
        row_buffer[1][i] <= 8'h00;
      end
    end
    else if (valid_in) begin
      row_buffer[0][ptr_buffer] <= data_in;
      row_buffer[1][ptr_buffer] <= row_buffer[0][(ptr_buffer + 639)%640];
    end
  end

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      for (int i = 0; i < 3; i++) begin
        window[0] <= 8'h00;
      end
    end
    else if (valid_in) begin
      window[0] <= data_in;
      window[1] <= row_buffer[0][(ptr_buffer + 639)%640];
      window[2] <= row_buffer[1][(ptr_buffer + 639)%640];
    end
  end

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      valid_out <= 1'b0;
    end
    else if (valid_in) begin
      valid_out <= 1'b1;
    end
    else begin
      valid_out <= 1'b0;
    end
  end

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      for (int i = 0; i < 3; i++) begin
        for (int j = 0; j < 3; j++) begin
          pipeline_dir_x[i][j] <= 8'h0;
        end
      end
    end
    else if (valid_in) begin
      pipeline_dir_x[0][0] <= ( 1*window[0]);
      pipeline_dir_x[0][1] <= ( 2*window[1]);
      pipeline_dir_x[0][2] <= ( 1*window[2]);
      pipeline_dir_x[1][0] <= ( 0*window[0]) + pipeline_dir_x[0][0];
      pipeline_dir_x[1][1] <= ( 0*window[1]) + pipeline_dir_x[0][1];
      pipeline_dir_x[1][2] <= ( 0*window[2]) + pipeline_dir_x[0][2];
      pipeline_dir_x[2][0] <= (-1*window[0]) + pipeline_dir_x[1][0];
      pipeline_dir_x[2][1] <= (-2*window[1]) + pipeline_dir_x[1][1];
      pipeline_dir_x[2][2] <= (-1*window[2]) + pipeline_dir_x[1][2];
    end
  end

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      for (int i = 0; i < 3; i++) begin
        for (int j = 0; j < 3; j++) begin
          pipeline_dir_y[i][j] <= 8'h0;
        end
      end
    end
    else if (valid_in) begin
      pipeline_dir_y[0][0] <= ( 1*window[0]);
      pipeline_dir_y[0][1] <= ( 0*window[1]);
      pipeline_dir_y[0][2] <= (-1*window[2]);
      pipeline_dir_y[1][0] <= ( 2*window[0]) + pipeline_dir_y[0][0];
      pipeline_dir_y[1][1] <= ( 0*window[1]) + pipeline_dir_y[0][1];
      pipeline_dir_y[1][2] <= (-2*window[2]) + pipeline_dir_y[0][2];
      pipeline_dir_y[2][0] <= ( 1*window[0]) + pipeline_dir_y[1][0];
      pipeline_dir_y[2][1] <= ( 0*window[1]) + pipeline_dir_y[1][1];
      pipeline_dir_y[2][2] <= (-1*window[2]) + pipeline_dir_y[1][2];
    end
  end

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      data_out <= 8'h00;
    end
    else if (valid_in) begin
      dir_x = pipeline_dir_x[2][0] +
              pipeline_dir_x[2][1] +
              pipeline_dir_x[2][2];

      dir_y = pipeline_dir_y[2][0] +
              pipeline_dir_y[2][1] +
              pipeline_dir_y[2][2];

      dir_x = dir_x[7] ? ~dir_x + 1 : dir_x;
      dir_y = dir_y[7] ? ~dir_y + 1 : dir_y;

      data_out <= dir_x + dir_y;

      // TODO(ciroceissler): use threshold?
      // data_out <= (dir_x + dir_y > 8'h55) ? 8'hff : 8'h00;
    end
  end

endmodule : sobel_unit

