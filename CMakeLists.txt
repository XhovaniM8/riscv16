cmake_minimum_required(VERSION 3.24)
project(riscv16 LANGUAGES CXX)

find_program(VERILATOR_BIN verilator REQUIRED)
find_package(ZLIB REQUIRED)

set(VERILATOR_OUT ${CMAKE_BINARY_DIR}/verilated)
set(OBJ_DIR ${VERILATOR_OUT}/obj_dir)
file(MAKE_DIRECTORY ${VERILATOR_OUT} ${OBJ_DIR})

add_custom_command(
  OUTPUT ${OBJ_DIR}/Valu_tb.cpp
  COMMAND ${VERILATOR_BIN}
    --cc ${CMAKE_SOURCE_DIR}/tb/alu_tb.sv ${CMAKE_SOURCE_DIR}/src/alu.sv
    --exe ${CMAKE_SOURCE_DIR}/dv/alu_tb.cpp
    -I${CMAKE_SOURCE_DIR}/src
    --top-module alu_tb
    --Mdir ${OBJ_DIR}
    --trace
    --no-timing
    --Wno-STMTDLY
    --Wno-UNOPTFLAT
    DEPENDS
    ${CMAKE_SOURCE_DIR}/src/alu.sv
    ${CMAKE_SOURCE_DIR}/tb/alu_tb.sv
    ${CMAKE_SOURCE_DIR}/dv/alu_tb.cpp
  COMMENT "Running Verilator (C++ generation only)..."
)
add_custom_target(verilate_tb DEPENDS ${OBJ_DIR}/Valu_tb.cpp)

file(GLOB_RECURSE VERILATED_SRCS
  "${OBJ_DIR}/Valu_tb*.cpp"
  "${OBJ_DIR}/verilated*.cpp"
)

add_executable(run_alu_tb
  ${VERILATED_SRCS}
  dv/alu_tb.cpp
)

add_dependencies(run_alu_tb verilate_tb)

target_compile_features(run_alu_tb PRIVATE cxx_std_20)
target_include_directories(run_alu_tb PRIVATE
  ${OBJ_DIR}
  src
  /opt/homebrew/Cellar/verilator/5.036/share/verilator/include
)

# Add Verilator runtime support
target_sources(run_alu_tb PRIVATE
  /opt/homebrew/Cellar/verilator/5.036/share/verilator/include/verilated.cpp
  /opt/homebrew/Cellar/verilator/5.036/share/verilator/include/verilated_vcd_c.cpp
)

# Link zlib for compression
target_link_libraries(run_alu_tb PRIVATE ${ZLIB_LIBRARIES})
