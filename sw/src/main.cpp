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

namespace boost_po = boost::program_options;

int main(int argc, char *argv[]) {
  try {
    boost_po::variables_map vm;
    boost_po::options_description general("General options");

    general.add_options()
      ("help", "produce a help message")
      ("input", boost_po::value<std::string>()->default_value("input.png"),
        "input image file")
      ("output", boost_po::value<std::string>()->default_value("output.png"),
        "output image file")
      ("version", "print the version number");

    boost_po::store(boost_po::parse_command_line(argc, argv, general), vm);

    if (vm.count("help")) {
      std::cout << general;
    } else if (vm.count("version")) {
      std::cout << "Sobel Filter 1.0" << std::endl;
    } else {
      Image image;
      Sobel sobel;

      image.read_png_file(vm["input"].as<std::string>());
      sobel.execute(&image);
      image.write_png_file(vm["output"].as<std::string>());
    }
  } catch(std::exception& e) {
    std::cout << e.what() << "\n";
  }

  return 0;
}

