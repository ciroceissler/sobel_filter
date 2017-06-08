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
  float **frame_backup;
  png_bytep *row_pointers;

  frame_backup = new float*[frame->width];

  for(int i = 0; i < frame->width; i++) {
    frame_backup[i] = new float[frame->height];
  }

  for (int color = 0; color < 3; color++) {
    for (int y = 0; y < frame->height; y++) {
      png_bytep row = frame->row_pointers[y];

      for (int x = 0; x < frame->width; x++) {
        png_bytep px = &(row[x * 4]);

        frame_backup[x][y] = px[color];
      }
    }

    for (int y = 0; y < frame->height; y++) {
      png_bytep row_out = frame->row_pointers[y];

      for (int x = 0; x < frame->width; x++) {
        float value = 0.0;

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
              value += G[i][j]*(frame_backup[x - 1 + i][y - 1 + j]);
            }
          }
        }

        px_out[color] = value;
      }
    }
  }

  for(int i = 0; i < frame->width; i++) {
    free(frame_backup[i]);
  }

  free(frame_backup);
}

