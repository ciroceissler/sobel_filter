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
#include "include/sobel.h"

int main(int argc, char *argv[]) {
  Image image;
  Sobel sobel;

  if (argc != 3) abort();

  image.read_png_file(argv[1]);
  sobel.execute(&image);
  image.write_png_file(argv[2]);

  return 0;
}

