#!/bin/bash
verilator -Wall --cc ../src/risc16_top.v \
  --exe ../tb/risc16_tb.v \
  -I../src -o risc16_sim

make -C obj_dir -f Vrisc16_top.mk Vrisc16_top
