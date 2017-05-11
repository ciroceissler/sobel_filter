//===----- image.h - load image files -------------------------------------===//
//
// Copyright (c) 2017 Ciro Ceissler
//
// See LICENSE for details.
//
//===----------------------------------------------------------------------===//
//
// Class to load image file, only supports png format.
//
//===----------------------------------------------------------------------===//

#ifndef IMAGE_H_
#define IMAGE_H_

#include <png.h>
#include <stdlib.h>

class Image {
 private:
  png_byte color_type;
  png_byte bit_depth;

 public:
  Image() {}

  ~Image() {}

  int width;
  int height;
  png_bytep *row_pointers;

  void read_png_file(const char* filename);
  void write_png_file(const char* filename);
};

#endif  // IMAGE_H_

