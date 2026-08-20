# Logic Analyzer

FPGA-based logic analyzer implemented for the Basys 3 (Artix‑7) board. The design samples external signals (from Pmod headers), stores them in a circular buffer, triggers on configurable conditions (rising/falling/level), and streams captured samples over UART to a host.

## Key features
- 8‑bit sampled input (JA + JB Pmod pins)
- Asynchronous input synchronization (sampler)
- Circular buffer for pre/post-trigger capture
- Configurable trigger modes: rising edge, falling edge, level high, level low
- UART command interface for updating trigger settings
- Host-side Python script to capture and decode UART output
- 7‑segment display of trigger mode/channel

## Repository layout
- Logic Analyzer.srcs/ — Vivado project sources and constraints
  - sources_1/new/ — SystemVerilog/Verilog modules:
    - LogicAnalyzerTop.v — top-level interconnect
    - sampler.v — input synchronizer
    - circular_buffer.sv — capture memory
    - trigger_engine.sv — trigger detection logic
    - readout_fsm.sv — buffer readout controller
    - uart_rx.sv, uart_tx.sv — UART receive/transmit
    - display_controller.sv — 7-seg display driver
  - constrs_1/ — board constraints (XDC) — pin mappings for Basys 3
- logic_analyzer.py — Python host script to read serial output and decode captures
- synthesized_schematic.pdf, implemented_schematic.pdf, elaborated_schematic.pdf — schematics from tool flow

## Media
This repository includes simulation screenshots and board/display output images in the `Media/` directory. Below are thumbnails/links to the most relevant images included with the project.

- Sampler Testbench: ![Sampler Testbench](Media/Sampler%20Testbench.png)
- Circular Buffer Testbench: ![Circular Buffer Testbench](Media/Circular%20Buffer%20Testbench.png)
- Trigger Engine Testbench: ![Trigger Engine Testbench](Media/Trigger%20Engine%20Testbench.png)
- Readout FSM Testbench: ![Readout FSM Testbench](Media/Readout%20FSM%20Testbench.png)
- UART TX Testbench: ![UART TX Testbench](Media/UART%20TX%20Testbench.png)
- Display Controller Testbench: ![Display Controller Testbench](Media/Display%20Controller%20Testbench.png)
- LogicAnalyzerTop Testbench: ![LogicAnalyzerTop Testbench](Media/LogicAnalyzerTop%20Testbench.png)

Display output examples (captured from the board/simulation):

- Rising Edge CH0 Display Output: ![Rising Edge CH0](Media/Rising%20Edge%20CH0%20Display%20Output.png)
- Falling Edge CH7 Display Output: ![Falling Edge CH7](Media/Falling%20Edge%20CH7%20Display%20Output.png)
- High CH4 Display Output: ![High CH4](Media/High%20CH4%20Display%20Output.png)
- Low CH2 Display Output: ![Low CH2](Media/Low%20CH2%20Display%20Output.png)

> Tip: If images do not render on GitHub's web view, navigate directly to the `Media/` folder: https://github.com/nortanner/Logic-Analyzer/tree/main/Media

## How to build and program (short)
1. Open Vivado and create or open a project for the Basys 3 board.
2. Add all source files from `Logic Analyzer.srcs/sources_1/new/` and the constraints in `Logic Analyzer.srcs/constrs_1/`.
3. Synthesize → Implement → Generate Bitstream.
4. Program the Basys 3 via Vivado Hardware Manager.

## Host capture
- Requirements: Python 3, pyserial
- Install: `pip install pyserial`
- Run: `python3 logic_analyzer.py`
- Configure the script to use the FTDI serial device and the UART baud rate that matches the FPGA UART modules.

## Common tweaks
- To change which signals are sampled, update the pin assignments in the constraints (.xdc).
- To change buffer depth, adjust the `DEPTH` parameter in `circular_buffer.sv` and `readout_fsm.sv`.
- To change sampling rate or UART baud, inspect `readout_fsm.sv`, `uart_tx.sv`, and `uart_rx.sv` for clock divisor logic.

## Notes
- This project assumes a Basys 3 board. If using a different FPGA board, update the constraints and board target accordingly.
- The host Python script expects a simple byte stream over UART; verify baud and framing in the UART modules before capture.

## Questions or contributions
If you make improvements (higher sample depth, richer trigger patterns, PC GUI), please open a PR and add usage notes.
