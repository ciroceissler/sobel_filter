//===----- gaussian.cpp - Gaussian Filter ---------------------------------===//
//
// Copyright (c) 2017 Ciro Ceissler
//
// See LICENSE for details.
//
//===----------------------------------------------------------------------===//
//
// Gaussian Filter algorithm.
//
//===----------------------------------------------------------------------===//

#include "include/gaussian.h"

void Gaussian::execute(Image *frame) {
  float ***frame_backup;
  png_bytep *row_pointers;

  frame_backup = new float**[frame->width];

  for(int i = 0; i < frame->width; i++) {
    frame_backup[i] = new float*[frame->height];
  }

  for (int y = 0; y < frame->height; y++) {
    png_bytep row = frame->row_pointers[y];

    for (int x = 0; x < frame->width; x++) {
      png_bytep px = &(row[x * 4]);

      frame_backup[x][y] = new float[3];

      frame_backup[x][y][0] = px[0];
      frame_backup[x][y][1] = px[1];
      frame_backup[x][y][2] = px[2];
    }
  }

  for (int y = 0; y < frame->height; y++) {
    png_bytep row_out = frame->row_pointers[y];

    for (int x = 0; x < frame->width; x++) {
      float value_r = 0;
      float value_g = 0;
      float value_b = 0;

      bool is_out_of_bounds = false;

      if ((x == 0) |
          (y == 0) |
          (x == frame->width - 1) |
          (y == frame->height - 1)) {
        is_out_of_bounds = true;
      }

      png_bytep px_out = &(row_out[x * 4]);

      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {

          if (!is_out_of_bounds) {
            value_r += G[i][j]*(frame_backup[x - 1 + i][y - 1 + j][0]);
            value_g += G[i][j]*(frame_backup[x - 1 + i][y - 1 + j][1]);
            value_b += G[i][j]*(frame_backup[x - 1 + i][y - 1 + j][2]);
          }
        }
      }

      px_out[0] = value_r;
      px_out[1] = value_g;
      px_out[2] = value_b;
    }
  }
}

