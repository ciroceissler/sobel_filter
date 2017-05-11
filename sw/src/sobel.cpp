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

#include <stdio.h>
#include <string.h>
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
    }
  }

  for (int y = 1; y < frame->height - 1; y++) {
    png_bytep row_out = frame->row_pointers[y];

    for (int x = 1; x < frame->width - 1; x++) {
      int x_dir = 0;
      int y_dir = 0;
      int value = 0;;

      png_bytep px_out = &(row_out[x * 4]);

      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          x_dir += Gx[i][j]*(frame_backup[x - 1 + i][y - 1 + j]);
          y_dir += Gy[i][j]*(frame_backup[x - 1 + i][y - 1 + j]);
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

