import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer


@cocotb.test()
async def risc16_basic_test(dut):
    """Test PC increment and instruction fetch on NOPs"""
    clock = Clock(dut.clk, 10, units="ns")  # 100 MHz clock
    cocotb.start_soon(clock.start())

    # Apply reset
    dut.reset.value = 1
    await Timer(20, units="ns")
    dut.reset.value = 0

    # Wait for first instruction
    await RisingEdge(dut.clk)
    prev_pc = int(dut.curr_pc.value)

    for cycle in range(5):
        await RisingEdge(dut.clk)
        curr_pc = int(dut.curr_pc.value)
        curr_instr = dut.curr_instr.value

        dut._log.info(f"Cycle {cycle}: PC={curr_pc}, Instr={curr_instr.binstr}")

        # Simple check: PC should increment by 1 unless there's branching
        assert curr_pc == prev_pc + 1, f"PC did not increment correctly: {prev_pc} -> {curr_pc}"
        prev_pc = curr_pc