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
  image.write_png_file(argv[2]);

  return 0;
}

