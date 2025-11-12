from vunit import VUnit

# Create VUnit instance by parsing command line arguments
vu = VUnit.from_argv()

# Optionally add VUnit's builtin HDL utilities for checking, logging, communication...
# See http://vunit.github.io/hdl_libraries.html.
vu.add_verilog_builtins()

# Create library 'lib'
lib = vu.add_library("lib")

# Add all files ending in .vhd in current working directory to library
lib.add_source_files("*.sv")
lib.add_source_files("../../../src/scmp.sv")
lib.add_source_files("../../../src/scmp_alu.sv")
lib.add_source_files("../../../src/scmp_micrcode.sv")
lib.add_source_files("../../../src/scmp_microcode_oppc.gen.sv")
lib.add_source_files("../../../src/scmp_microcode_pla.gen.sv")
lib.add_source_files("../../../src/scmp_microcode_pla.gen.pak.sv")
lib.add_source_files("../../../src/mux_oh.sv")
lib.add_source_files("../../../src/reg8.sv")

# Run vunit function

vu.set_sim_option("modelsim.vsim_flags", ["-voptargs=+acc"])
vu.main()