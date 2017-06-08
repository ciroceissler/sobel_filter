//===----- sobel.h - Sobel Filter ------------------------------------------===//
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

#ifndef SOBEL_H_
#define SOBEL_H_

#include <iostream>
#include <math.h>
#include "include/image.h"

class Sobel {
 private:

 // filter coefficients
 int Gx[3][3] = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};
 int Gy[3][3] = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};

 public:
  Sobel() {}

  ~Sobel() {}

  void execute(Image *frame);
};

#endif  // SOBEL_H_

