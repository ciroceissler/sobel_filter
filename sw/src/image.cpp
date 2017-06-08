//===----- image.cpp - load image files -----------------------------------===//
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

#include "include/image.h"

void Image::read_png_file(const std::string& filename) {
  FILE *fp = fopen(filename.c_str(), "rb");

  png_structp png = png_create_read_struct(PNG_LIBPNG_VER_STRING,
                                           NULL,
                                           NULL,
                                           NULL);
  if (!png) abort();

  png_infop info = png_create_info_struct(png);
  if (!info) abort();

  if (setjmp(png_jmpbuf(png))) abort();

  png_init_io(png, fp);

  png_read_info(png, info);

  width      = png_get_image_width(png, info);
  height     = png_get_image_height(png, info);
  color_type = png_get_color_type(png, info);
  bit_depth  = png_get_bit_depth(png, info);

  // Read any color_type into 8bit depth, RGBA format.
  // See http://www.libpng.org/pub/png/libpng-manual.txt

  if (bit_depth == 16)
    png_set_strip_16(png);

  if (color_type == PNG_COLOR_TYPE_PALETTE)
    png_set_palette_to_rgb(png);

  // PNG_COLOR_TYPE_GRAY_ALPHA is always 8 or 16bit depth.
  if (color_type == PNG_COLOR_TYPE_GRAY && bit_depth < 8)
    png_set_expand_gray_1_2_4_to_8(png);

  if (png_get_valid(png, info, PNG_INFO_tRNS))
    png_set_tRNS_to_alpha(png);

  // These color_type don't have an alpha channel then fill it with 0xff.
  if (color_type == PNG_COLOR_TYPE_RGB ||
     color_type == PNG_COLOR_TYPE_GRAY ||
     color_type == PNG_COLOR_TYPE_PALETTE)
    png_set_filler(png, 0xFF, PNG_FILLER_AFTER);

  if (color_type == PNG_COLOR_TYPE_GRAY ||
     color_type == PNG_COLOR_TYPE_GRAY_ALPHA)
    png_set_gray_to_rgb(png);

  png_read_update_info(png, info);

  row_pointers =
    reinterpret_cast<png_bytep*>(malloc(sizeof(png_bytep) *height));

  for (int y = 0; y < height; y++) {
    row_pointers[y] =
      reinterpret_cast<png_byte*>(malloc(png_get_rowbytes(png, info)));
  }

  png_read_image(png, row_pointers);

  fclose(fp);
}

void Image::write_png_file(const std::string& filename) {
  int y;

  FILE *fp = fopen(filename.c_str(), "wb");
  if (!fp) abort();

  png_structp png = png_create_write_struct(PNG_LIBPNG_VER_STRING,
                                            NULL,
                                            NULL,
                                            NULL);
  if (!png) abort();

  png_infop info = png_create_info_struct(png);
  if (!info) abort();

  if (setjmp(png_jmpbuf(png))) abort();

  png_init_io(png, fp);

  // Output is 8bit depth, RGBA format.
  png_set_IHDR(png,
               info,
               width,
               height,
               8,
               PNG_COLOR_TYPE_RGBA,
               PNG_INTERLACE_NONE,
               PNG_COMPRESSION_TYPE_DEFAULT,
               PNG_FILTER_TYPE_DEFAULT);

  png_write_info(png, info);

  // To remove the alpha channel for PNG_COLOR_TYPE_RGB format,
  // Use png_set_filler().
  // png_set_filler(png, 0, PNG_FILLER_AFTER);

  png_write_image(png, row_pointers);
  png_write_end(png, NULL);

  for (int y = 0; y < height; y++) {
    free(row_pointers[y]);
  }
  free(row_pointers);

  fclose(fp);
}

void Image::compare(const std::string& filename) {
  Image image(filename);
  int cnt_diff = 0;

  if (this->height != image.height) {
    std::cout << "different height between images:" << std::endl;
    std::cout << " > image 1 - " << this->height << " pixels." << std::endl;
    std::cout << " > image 2 - " << image.height << " pixels." << std::endl;

    return;
  }

  if (this->width != image.width) {
    std::cout << "different width between images:" << std::endl;
    std::cout << " > image 1 - " << this->height << " pixels." << std::endl;
    std::cout << " > image 2 - " << image.height << " pixels." << std::endl;

    return;
  }

  for (int x = 1; x < this->height - 1; x++) {

    png_bytep row1 = this->row_pointers[x];
    png_bytep row2 = image.row_pointers[x];

    for (int y = 1; y < this->width - 1; y++) {
      png_bytep px1 = &(row1[y * 4]);
      png_bytep px2 = &(row2[y * 4]);

      if ((px1[0] != px2[0]) |
          (px1[1] != px2[1]) |
          (px1[2] != px2[2])) {

        cnt_diff++;

        std::cout << "different pixel: (" << x << "," << y << ") = ";
        std::cout << "(" << static_cast<int>(px1[0])
                  << "," << static_cast<int>(px1[1])
                  << "," << static_cast<int>(px1[2]) << ")";
        std::cout << " | ";
        std::cout << "(" << static_cast<int>(px2[0])
                  << "," << static_cast<int>(px2[1])
                  << "," << static_cast<int>(px2[2]) << ")";
        std::cout << std::endl;
      }
    }
  }

  std::cout << "different counter: " << cnt_diff << std::endl;
}

