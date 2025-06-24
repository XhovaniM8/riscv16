#include "Valu.h" // Verilated module
#include "verilated.h"
#include <cstdio>

double sc_time_stamp() { return 0; }

int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);

    Valu *top = new Valu;

    // ADD test: 5 + 3 = 8
    top->alu_src1 = 5;
    top->alu_src2 = 3;
    top->ADD = 1;
    top->NAND = 0;
    top->PASS1 = 0;
    top->EQ = 0;
    top->eval();
    printf("[ADD] alu_out: %d (expected 8)\n", top->alu_out);

    // NAND test: ~(0xFFFF & 0x0F0F) = 0xF0F0
    top->ADD = 0;
    top->NAND = 1;
    top->alu_src1 = 0xFFFF;
    top->alu_src2 = 0x0F0F;
    top->eval();
    printf("[NAND] alu_out: 0x%04X (expected 0xF0F0)\n", top->alu_out);

    // EQ test (equal)
    top->NAND = 0;
    top->EQ = 1;
    top->alu_src1 = 0xAAAA;
    top->alu_src2 = 0xAAAA;
    top->eval();
    printf("[EQ=1] eq_out: %d (expected 1)\n", top->eq_out);

    // EQ test (not equal)
    top->alu_src2 = 0xBBBB;
    top->eval();
    printf("[EQ=0] eq_out: %d (expected 0)\n", top->eq_out);

    delete top;
    return 0;
}
