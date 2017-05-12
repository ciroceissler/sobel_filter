#===----- run.f - script cadence irun --------------------------------------===#

# simulator configuration
-sv
-64bit
-lpng
-access +rwc

# dut filtes
../rtl/rgb2luma.sv
../rtl/sobel_filter.sv

# testbench files
../testbench/libpng_interface.c
../testbench/testbench.sv
