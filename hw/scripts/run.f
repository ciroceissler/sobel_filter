#===----- run.f - script cadence irun --------------------------------------===#

# simulator configuration
-sv
-64bit
-lpng
-access +rwc

-top testbench

# packages
../rtl/pcie_package.sv

# dut filtes
../rtl/rgb2luma.sv
../rtl/sobel_unit.sv
../rtl/sobel_filter.sv

# testbench files
../testbench/libpng_interface.c
../testbench/testbench.sv
