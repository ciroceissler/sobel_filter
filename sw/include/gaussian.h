//===----- gaussian.h - Gaussian Filter -----------------------------------===//
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

#ifndef GAUSSIAN_H_
#define GAUSSIAN_H_

#include <iostream>
#include <math.h>
#include "include/image.h"

class Gaussian {
 private:

 // filter coefficients
 float G[3][3] = {{0.0625, 0.125, 0.0625},
                  {0.125, 0.25, 0.125},
                  {0.0625, 0.125, 0.0625}};

 public:
  Gaussian() {}

  ~Gaussian() {}

  void execute(Image *frame);
};

#endif  // GAUSSIAN_H_

