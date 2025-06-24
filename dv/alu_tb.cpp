#include "Valu.h" // Verilated module
#include "verilated.h"
#include "verilated_vcd_c.h" // For VCD tracing
#include <cstdio>

double sc_time_stamp() { return 0; }

int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);

    // CRITICAL: Enable tracing before creating any traced objects
    Verilated::traceEverOn(true);

    // Create ALU instance
    Valu *top = new Valu;

    // Initialize VCD tracing
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);     // Trace 99 levels of hierarchy
    tfp->open("alu_tb.vcd"); // Open VCD file

    int time_counter = 0;

    printf("Starting ALU testbench with VCD tracing...\n");

    // ADD test: 5 + 3 = 8
    top->alu_src1 = 5;
    top->alu_src2 = 3;
    top->ADD = 1;
    top->NAND = 0;
    top->PASS1 = 0;
    top->EQ = 0;
    top->eval();
    tfp->dump(time_counter++); // Dump to VCD
    printf("[ADD] alu_out: %d (expected 8)\n", top->alu_out);

    // NAND test: ~(0xFFFF & 0x0F0F) = 0xF0F0
    top->ADD = 0;
    top->NAND = 1;
    top->alu_src1 = 0xFFFF;
    top->alu_src2 = 0x0F0F;
    top->eval();
    tfp->dump(time_counter++); // Dump to VCD
    printf("[NAND] alu_out: 0x%04X (expected 0xF0F0)\n", top->alu_out);

    // EQ test (equal)
    top->NAND = 0;
    top->EQ = 1;
    top->alu_src1 = 0xAAAA;
    top->alu_src2 = 0xAAAA;
    top->eval();
    tfp->dump(time_counter++); // Dump to VCD
    printf("[EQ=1] eq_out: %d (expected 1)\n", top->eq_out);

    // EQ test (not equal)
    top->alu_src2 = 0xBBBB;
    top->eval();
    tfp->dump(time_counter++); // Dump to VCD
    printf("[EQ=0] eq_out: %d (expected 0)\n", top->eq_out);

    // Close VCD file
    tfp->close();
    printf("VCD trace saved to alu_tb.vcd\n");

    // Cleanup
    delete top;
    delete tfp;
    return 0;
}
