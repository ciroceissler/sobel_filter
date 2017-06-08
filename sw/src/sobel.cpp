//===----- sobel.cpp - Sobel Filter ----------------------------------------===//
//
// Copyright (c) 2017 Ciro Ceissler
//
// See LICENSE for details.
//
//===----------------------------------------------------------------------===//
//
// Sobel Filter algorithm.
//
//===----------------------------------------------------------------------===//

#include "include/sobel.h"

void Sobel::execute(Image *frame) {
  int **frame_backup;
  png_bytep *row_pointers;

  frame_backup = new int*[frame->width];

  for(int i = 0; i < frame->width; i++) {
    frame_backup[i] = new int[frame->height];
  }

  for (int y = 0; y < frame->height; y++) {
    png_bytep row = frame->row_pointers[y];

    for (int x = 0; x < frame->width; x++) {
      png_bytep px = &(row[x * 4]);

      frame_backup[x][y] = 0.30*px[0] + 0.59*px[1] + 0.11*px[2];

      // NOTES(ciroceissler):
      // another way to convert rgb to luma (without use fp).
      // frame_backup[x][y] =  ((px[0]*66 + px[1]*129 + px[2]*25) + 128 >> 8) + 16;
    }
  }

  for (int y = 0; y < frame->height; y++) {
    png_bytep row_out = frame->row_pointers[y];

    for (int x = 0; x < frame->width; x++) {
      int x_dir = 0;
      int y_dir = 0;
      int value = 0;

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
            x_dir += Gx[i][j]*(frame_backup[x - 1 + i][y - 1 + j]);
            y_dir += Gy[i][j]*(frame_backup[x - 1 + i][y - 1 + j]);
          }
        }
      }

      value = sqrt(pow(x_dir, 2) + pow(y_dir, 2));

      value /= 3;

      px_out[0] = value;
      px_out[1] = value;
      px_out[2] = value;
    }
  }
}

