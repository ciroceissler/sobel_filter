//===----- main.cpp - load png file and execute Sobel Filter --------------===//
//
// Copyright (c) 2017 Ciro Ceissler
//
// See LICENSE for details.
//
//===----------------------------------------------------------------------===//
//
// This file load png file with libpng, execute Sobel Filter
// detect edges and generate image file.
//
//===----------------------------------------------------------------------===//

#include <stdlib.h>
#include "include/image.h"

int main(int argc, char *argv[]) {
  Image image;

  if (argc != 3) abort();

  image.read_png_file(argv[1]);

  for (int y = 0; y < image.height; y++) {
    png_bytep row = image.row_pointers[y];
    for (int x = 0; x < image.width; x++) {
      png_bytep px = &(row[x * 4]);

      px[0] = px[0] + 30;
      px[1] = px[1] + 30;
      px[2] = px[2] + 30;
    }
  }

  image.write_png_file(argv[2]);

  return 0;
}

