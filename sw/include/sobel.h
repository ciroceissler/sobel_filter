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

class Sobel {
 public:
  Sobel() {}

  ~Sobel() {}

  void execute(unsigned int *frame_in,
               unsigned int *frame_out,
               unsigned int interations,
               unsigned int threshold);

};

#endif  // SOBEL_H_

