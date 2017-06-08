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

#include <boost/program_options/options_description.hpp>
#include <boost/program_options/parsers.hpp>
#include <boost/program_options/variables_map.hpp>
#include <boost/tokenizer.hpp>
#include <boost/token_functions.hpp>

#include <stdlib.h>
#include <iostream>

#include "include/image.h"
#include "include/sobel.h"
#include "include/gaussian.h"

namespace boost_po = boost::program_options;

int main(int argc, char *argv[]) {
  try {
    bool enable_diff    = false;
    bool disable_filter = false;
    std::string file_input;
    std::string file_output;

    boost_po::variables_map vm;
    boost_po::options_description general("General options");

    general.add_options()
      ("help", "produce a help message")
      ("enable-diff", boost_po::bool_switch(&enable_diff),
        "compare two files")
      ("disable-filter", boost_po::bool_switch(&disable_filter),
        "disable sobel filter")
      ("input",
       boost_po::value<std::string>(&file_input)->default_value("input.png"),
        "input image file")
      ("output",
       boost_po::value<std::string>(&file_output)->default_value("output.png"),
        "output image file")
      ("version", "print the version number");

    boost_po::store(boost_po::parse_command_line(argc, argv, general), vm);
    boost_po::notify(vm);

    if (vm.count("help")) {
      std::cout << general;
      return 0;
    } else if (vm.count("version")) {
      std::cout << "Sobel Filter 1.0" << std::endl;
      return 0;
    }

    if (!disable_filter) {
      Image image(file_input);
      Gaussian gaussian;
      Sobel sobel;

      clock_t init , end;

      init = clock();

      gaussian.execute(&image);
      sobel.execute(&image);
      end = clock() - init;

      std::cout << (float(end))/CLOCKS_PER_SEC << " seconds" << std::endl;

      image.write_png_file(file_output);
    }

    if (enable_diff) {
      Image image(file_input);

      image.compare(file_output);
    }
  } catch(std::exception& e) {
    std::cout << e.what() << "\n";
  }

  return 0;
}

