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

### Automated Build (May fail on macOS)
```sh
cmake -S . -B build
cmake --build build --target run_alu_tb -j
```

### Manual Build (Recommended for macOS)
```sh
# Clean previous build
rm -rf obj_dir

# Generate C++ sources with tracing enabled
verilator -Wall --cc src/alu.sv --exe dv/alu_tb.cpp -I./src --top-module alu --trace

# Navigate to generated directory
cd obj_dir

# Compile testbench
g++ -Os -I. -MMD -I/usr/local/share/verilator/include -I/usr/local/share/verilator/include/vltstd \
    -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TIMING=0 -DVM_TRACE=1 -DVM_TRACE_FST=0 -DVM_TRACE_VCD=1 \
    -faligned-new -fbracket-depth=4096 -fcf-protection=none \
    -Wno-bool-operation -Wno-sign-compare -Wno-unused-parameter -Wno-unused-variable \
    -c -o alu_tb.o ../dv/alu_tb.cpp

# Compile Verilator runtime libraries
g++ -Os -I. -MMD -I/usr/local/share/verilator/include -I/usr/local/share/verilator/include/vltstd \
    -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TIMING=0 -DVM_TRACE=1 -DVM_TRACE_FST=0 -DVM_TRACE_VCD=1 \
    -faligned-new -fbracket-depth=4096 -fcf-protection=none \
    -Wno-bool-operation -Wno-sign-compare -Wno-unused-parameter -Wno-unused-variable \
    -c /usr/local/share/verilator/include/verilated.cpp

g++ -Os -I. -MMD -I/usr/local/share/verilator/include -I/usr/local/share/verilator/include/vltstd \
    -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TIMING=0 -DVM_TRACE=1 -DVM_TRACE_FST=0 -DVM_TRACE_VCD=1 \
    -faligned-new -fbracket-depth=4096 -fcf-protection=none \
    -Wno-bool-operation -Wno-sign-compare -Wno-unused-parameter -Wno-unused-variable \
    -c /usr/local/share/verilator/include/verilated_vcd_c.cpp

g++ -Os -I. -MMD -I/usr/local/share/verilator/include -I/usr/local/share/verilator/include/vltstd \
    -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TIMING=0 -DVM_TRACE=1 -DVM_TRACE_FST=0 -DVM_TRACE_VCD=1 \
    -faligned-new -fbracket-depth=4096 -fcf-protection=none \
    -Wno-bool-operation -Wno-sign-compare -Wno-unused-parameter -Wno-unused-variable \
    -c /usr/local/share/verilator/include/verilated_threads.cpp

# Generate consolidated source file
python3 /usr/local/share/verilator/bin/verilator_includer -DVL_INCLUDE_OPT=include Valu*.cpp > Valu__ALL.cpp

# Compile generated ALU sources
g++ -Os -I. -MMD -I/usr/local/share/verilator/include -I/usr/local/share/verilator/include/vltstd \
    -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TIMING=0 -DVM_TRACE=1 -DVM_TRACE_FST=0 -DVM_TRACE_VCD=1 \
    -faligned-new -fbracket-depth=4096 -fcf-protection=none \
    -Wno-bool-operation -Wno-sign-compare -Wno-unused-parameter -Wno-unused-variable \
    -c Valu__ALL.cpp

# Link all object files
g++ -o Valu alu_tb.o verilated.o verilated_vcd_c.o verilated_threads.o Valu__ALL.o -pthread

# Run simulation
./Valu

# Return to project root
cd ..
```

### Viewing Waveforms
After successful simulation, open the generated VCD file with GTKWave:
```sh
# Check for VCD files
ls obj_dir/*.vcd

# Open with GTKWave
gtkwave obj_dir/*.vcd
```

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
Avoid using Verilator's `--build` flag within the `add_custom_command` in CMake. Instead, generate the C++ sources with Verilator first, then compile separately using CMake-managed targets or manual compilation.

## Key Lessons Learned

### Verilator Build Issues on macOS
- **Problem**: Verilator's `--build` flag is unreliable on macOS due to malformed archive (`.a`) file generation
- **Solution**: Use manual compilation workflow instead of auto-build
- **Impact**: Affects both direct Verilator usage and CMake integration
- **Critical**: Must include `verilated_threads.o` for ARM64 architecture support

### Manual Compilation Workflow (WORKING)
1. **Generate C++ sources with tracing**:
   ```sh
   verilator -Wall --cc src/alu.sv --exe dv/alu_tb.cpp -I./src --top-module alu --trace
   ```
2. **Compile all required object files individually**:
   - Testbench: `alu_tb.o`
   - Verilator runtime: `verilated.o`, `verilated_vcd_c.o`, `verilated_threads.o`
   - Generated ALU: `Valu__ALL.o` (created via `verilator_includer`)
3. **Link with pthread support**:
   ```sh
   g++ -o Valu *.o -pthread
   ```

### VCD Trace Generation
For VCD file generation, ensure your testbench includes:
```cpp
// In alu_tb.cpp
VerilatedVcdC* tfp = new VerilatedVcdC;
top->trace(tfp, 99);
tfp->open("alu_tb.vcd");
// During simulation:
tfp->dump(contextp->time());
```

### Debugging Tips
- Always verify generated C++ files exist before attempting compilation
- Clean build directory (`rm -rf obj_dir`) when switching between build methods
- Test with simpler modules first (like ALU) before complex systems (like RISC16 top-level)
- Include `verilated_threads.o` when linking on ARM64 to avoid threading symbol errors
- Use `--trace` flag during Verilator generation for VCD output

## Test Results
Recent successful simulation output:
```
[ADD] alu_out: 8 (expected 8)
[NAND] alu_out: 0xF0F0 (expected 0xF0F0)
[EQ=1] eq_out: 1 (expected 1)
[EQ=0] eq_out: 0 (expected 0)
```

## Status
- **ALU simulation**: ✅ Working correctly with manual build process
- **VCD generation**: ✅ Verified for waveform analysis
- **GTKWave integration**: ✅ Ready for signal inspection
- **RISC16 top-level**: Requires build system refactoring due to Verilator issues
- **Next steps**: Implement CMake-based manual compilation workflow to avoid Verilator's problematic auto-build
