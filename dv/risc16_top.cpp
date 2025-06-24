#include "Vrisc16_top.h"
#include "verilated.h"

double sc_time_stamp() { return 0; }

int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);
    Vrisc16_top *top = new Vrisc16_top;

    for (int i = 0; i < 100; ++i)
    {
        top->clk = !top->clk;
        top->reset = (i < 2); // Assert reset for first 2 cycles
        top->eval();

        // Optional: print PC or instruction
        // printf("Cycle %d: PC = %04x, Instr = %04x\n", i, top->curr_pc, top->curr_instr);
    }

    delete top;
    return 0;
}
