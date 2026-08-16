# Design and Verification of a 5-Stage Pipelined RISC-V (RV32I) Processor in Verilog
# Final Capstone Project — Nisha Tiwari (G4-25 VLSI)

## Design and Verification of a 5-Stage Pipelined RISC-V (RV32I) Processor in Verilog

Designed and implemented a 5-stage pipelined RV32I RISC-V processor in Verilog HDL, covering Fetch, Decode, Execute, Memory, and Write-Back stages with dedicated hazard detection and data-forwarding logic. Built and verified every module individually before integrating them into a complete top-level CPU, and confirmed correct pipelined execution using cycle-by-cycle waveform analysis.

## Features
- Full 5-stage pipeline (IF, ID, EX, MEM, WB) with IF/ID, ID/EX, EX/MEM, and MEM/WB pipeline registers
- Hazard Unit for load-use hazard detection (stall + flush)
- Forwarding Unit resolving EX-hazard and MEM-hazard data dependencies without unnecessary stalls
- Modular RTL: PC unit, instruction memory, decoder, register file, immediate/extend unit, ALU, control unit, ALU control, data memory, load unit, store unit, branch unit
- Verified module-by-module in dependency order before full-CPU integration

## Tools Used
- Verilog HDL for RTL design
- Verilator (`--lint-only` for syntax/interface checks, `--binary --trace` for simulation)
- Icarus Verilog for module-level testbenches
- GTKWave for cycle-by-cycle waveform verification
- WSL (Ubuntu 24.04) as the development environment

## Folder Structure         

## How to Run
```bash
# Lint-check all RTL
verilator --lint-only -Wno-MULTITOP rtl/*.v

# Compile and build the simulation
verilator --binary --trace rtl/*.v tb/tb_riscv_pipeline_cpu.v --top-module tb_riscv_pipeline_cpu

# Run the simulation
./obj_dir/Vtb_riscv_pipeline_cpu

# View the waveform
gtkwave waves/pipeline.vcd
```

## Verification
The pipeline was tested against a program covering register-immediate arithmetic (ADDI), register-register arithmetic (ADD), memory store (SW), and memory load (LW). Waveform analysis in GTKWave confirmed correct instruction fetch, decode, ALU computation, memory access, and write-back, with multiple instructions visibly overlapping across pipeline stages on the same clock edge — confirming genuine pipelined execution.

## Author
Nisha Tiwari — B.Tech ECE, Babasaheb Bhimrao Ambedkar University, Lucknow
Mentored by Devi Prasad Mishra & Razi Ahmed, SURE Trust
