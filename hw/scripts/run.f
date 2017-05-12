#===----- run.f - script cadence irun --------------------------------------===#

# simulator configuration
-sv

# dut filtes
../rtl/rgb2luma.sv
../rtl/sobel_filter.sv

# testbench files
../testbench/testbench.sv
