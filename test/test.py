# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # Set the input values you want to test
    dut.ui_in.value = 0x42

    # Wait for one clock cycle to see the output values
    await ClockCycles(dut.clk, 1)

    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    assert dut.uo_out.value == 0x08

    dut.ui_in.value = 0x42
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0x08

 # Test Case 2
    dut.ui_in.value = 0x0F  # First operand (4 bits)
    dut.uio_in.value = 0x0F  # Second operand (4 bits)
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0xE1, f"Test Case 2 failed: Expected 0xE1, got {hex(dut.uo_out.value)}"

    # Test Case 3
    dut.ui_in.value = 0x03  # First operand (4 bits)
    dut.uio_in.value = 0x04  # Second operand (4 bits)
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0x0C, f"Test Case 3 failed: Expected 0x0C, got {hex(dut.uo_out.value)}"

    # Test Case 4
    dut.ui_in.value = 0x07  # First operand (4 bits)
    dut.uio_in.value = 0x02  # Second operand (4 bits)
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0x0E, f"Test Case 4 failed: Expected 0x0E, got {hex(dut.uo_out.value)}"

    # Test Case 5
    dut.ui_in.value = 0x08  # First operand (4 bits)
    dut.uio_in.value = 0x08  # Second operand (4 bits)
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0x40, f"Test Case 5 failed: Expected 0x40, got {hex(dut.uo_out.value)}"


    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
