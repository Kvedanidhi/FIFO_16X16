# FIFO_16X16

A synchronous **16-word × 16-bit FIFO** implemented in Verilog HDL. The repository also includes a simple producer/consumer demonstration, a top-level integration module, and a behavioral testbench.

## Features

- 16-bit data path
- 16 storage locations
- Synchronous read and write pointer updates on the rising clock edge
- 5-bit pointers for wraparound tracking
- `full` and `empty` status flags
- Simultaneous read and write support when both operations are valid
- Incrementing data generator and automatic data receiver for demonstration
- RTL and waveform reference images

## Repository structure

| File | Description |
| --- | --- |
| [`fifo_16X16.v`](fifo_16X16.v) | Core FIFO implementation with storage, pointers, and status flags |
| [`mod_a.v`](mod_a.v) | Producer that generates an incrementing 16-bit value and writes while the FIFO is not full |
| [`mod_b.v`](mod_b.v) | Consumer that reads while the FIFO is not empty and pulses `data_valid` |
| [`top_module.v`](top_module.v) | Connects the producer, FIFO, and consumer |
| [`top_module_tb`](top_module_tb) | Behavioral testbench with clock, reset, simulation duration, and output logging |
| [`fifo top rtl.png`](fifo%20top%20rtl.png) | RTL schematic/reference image |
| [`fifo top waveform.png`](fifo%20top%20waveform.png) | Waveform reference image |

## Architecture

```text
                 +---------+
        full --->|  mod_a  |-- wr_en -->+
                 +---------+             |
                                          v
                                    +-----------+
                         data_in -->| FIFO 16x16|--> data_out
                                    +-----------+
                                          ^
                 +---------+             |
       empty --->|  mod_b  |<-- rd_en ---+
                 +---------+
                    |
          received_data, data_valid
```

`mod_a` writes an incrementing value whenever `full` is low. `mod_b` reads whenever `empty` is low and captures the current FIFO output in `received_data`, asserting `data_valid` for that cycle.

## FIFO interface

| Signal | Direction | Width | Description |
| --- | --- | ---: | --- |
| `clk` | Input | 1 | Clock; state updates occur on its rising edge |
| `rst` | Input | 1 | Synchronous active-high reset for the read and write pointers |
| `wrt_enb` | Input | 1 | Write request; accepted only when the FIFO is not full |
| `rd_enb` | Input | 1 | Read request; accepted only when the FIFO is not empty |
| `data_in` | Input | 16 | Data written into the FIFO |
| `full` | Output | 1 | High when the FIFO cannot accept another write |
| `empty` | Output | 1 | High when no unread entries remain |
| `data_out` | Output | 16 | Combinational data at the current read address |

The FIFO uses the low four pointer bits as the memory address. The fifth bit records wraparound, allowing `full` and `empty` to be distinguished when the low address bits match.

## Simulation

The testbench instantiates `top_module`, holds `rst` high for five falling clock edges, then runs for 100 additional falling edges. Whenever the consumer receives data, the testbench prints the decimal and hexadecimal values:

```text
Time=... | Received Data=... | Hex=...
```

### Using Icarus Verilog

If Icarus Verilog is installed, compile and run from the repository root:

```bash
iverilog -o fifo_sim \
  fifo_16X16.v mod_a.v mod_b.v top_module.v top_module_tb
vvp fifo_sim
```

The testbench file intentionally has no `.v` extension, so include it explicitly in the compile command.

### Using Xilinx ISE / ISim

Add the four Verilog source files and `top_module_tb` to a simulation project, select `top_module_tb` as the simulation top module, and run behavioral simulation. The repository's original design was written with Xilinx ISE/ISim-compatible Verilog syntax in mind.

## Reset and operation notes

- Reset is synchronous and must be asserted at a rising edge of `clk` to reset the pointers.
- Writes are blocked while `full` is high.
- Reads are blocked while `empty` is high.
- The included demonstration continuously produces and consumes data, so it is intended to show the FIFO wiring and status behavior rather than provide a configurable verification environment.

## Reference images

### RTL view

![FIFO RTL view](fifo%20top%20rtl.png)

### Waveform view

![FIFO waveform](fifo%20top%20waveform.png)

## License

No license file is currently included in this repository.
