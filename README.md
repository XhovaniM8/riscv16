# ALU Testbench with Verilator and CMake

## Overview

This project implements a 16-bit Arithmetic Logic Unit (ALU) in SystemVerilog with a Verilator/C++ testbench. The build system uses CMake to automate simulation builds. Development was done on macOS using Apple Clang and Verilator 5.036.

## Directory Structure

```
riscv16/
├── src/           # ALU SystemVerilog source (alu.sv)
├── tb/            # Testbench SystemVerilog file (alu_tb.sv)
├── dv/            # Verilator C++ entrypoint (alu_tb.cpp)
├── build/         # CMake-generated build directory
├── verilated/     # Verilator intermediate files
└── CMakeLists.txt # CMake configuration
```

## Build & Run

```sh
cmake -S . -B build
cmake --build build --target run_alu_tb -j
```

If successful, the simulation will run and produce `alu_tb.vcd` for waveform viewing.

## Design Note: Verilator + CMake Issue on macOS

### Description

During build, Verilator is invoked with `--build`, which uses an internal Makefile to link object files. On macOS (Apple Silicon), the generated Makefile sometimes includes an invalid `/` entry in the archive list, leading to a linker failure:

```
ld: archive member '/' not a mach-o file in 'Valu_tb__ALL.a'
clang++: error: linker command failed with exit code 1
```

### Root Cause

This appears to be a Verilator-specific bug in Makefile generation, likely due to a malformed dependency or path during object aggregation.

### Workaround

Avoid using Verilator's `--build` flag within the `add_custom_command` in CMake. Instead, generate the C++ sources with Verilator first, then compile separately using CMake-managed targets. Example adjustment:

```cmake
# Step 1: Generate Verilated sources only
verilator --cc ... --exe ... --Mdir ... --trace --timing

# Step 2: Add_executable + target_link_libraries in CMake manually
```

This gives more explicit control over the build flow and avoids platform-specific issues introduced by Verilator's Makefile auto-generation.

## Key Lessons Learned

### Verilator Build Issues on macOS

- **Problem**: Verilator's `--build` flag is unreliable on macOS due to malformed archive (`.a`) file generation
- **Solution**: Use manual compilation workflow instead of auto-build
- **Impact**: Affects both direct Verilator usage and CMake integration

### Manual Compilation Workflow

1. **Generate C++ sources only**:
   ```sh
   verilator -Wall --cc src/alu.sv --exe dv/alu_tb.cpp -I./src --top-module alu
   ```

2. **Check generated files exist**:
   ```sh
   ls obj_dir/Valu__*.cpp
   ```

3. **Compile manually**:
   ```sh
   make -C obj_dir -f Valu.mk
   ```

### Debugging Tips

- Always verify generated C++ files exist before attempting compilation
- Clean build directory (`rm -rf obj_dir`) when switching between build methods
- Test with simpler modules first (like ALU) before complex systems (like RISC16 top-level)

## Status

- **ALU simulation**: Working correctly with manual build process
- **RISC16 top-level**: Requires build system refactoring due to Verilator issues
- **Next steps**: Implement CMake-based manual compilation workflow to avoid Verilator's problematic auto-build
