# 5-Stage Pipelined MIPS CPU — Verilog

**[▶ Live Pipeline Simulator](https://halkhoori2000.github.io/Pipelined-MIPS-CPU/)** — Interactive cycle-by-cycle browser simulation with forwarding visualization, stall detection, and BHT state tracking.

A working CPU processor built from scratch using hardware description code. It can execute real programs — arithmetic, memory operations, branches, and jumps — by processing multiple instructions simultaneously through a 5-stage assembly line. It also predicts which way a program will branch before it knows for sure, avoiding wasted cycles.

Implemented in Verilog as a 32-bit MIPS processor with a classic IF/ID/EX/MEM/WB pipeline. Includes hazard detection with pipeline stalls, EX/MEM/WB forwarding paths for data hazards, early branch resolution in the decode stage, a 2-bit bimodal Branch History Table and Branch Target Buffer for speculative fetch, separate instruction and data caches, and syscall emulation. Designed and simulated in Xilinx Vivado with XSim.

---

## Architecture

```
   ┌────────┐   ┌────────┐   ┌─────────┐   ┌────────┐   ┌────────┐
   │  Fetch │──▶│ Decode │──▶│ Execute │──▶│ Memory │──▶│  Write │
   │  (IF)  │   │  (ID)  │   │  (EX)   │   │  (MEM) │   │  Back  │
   └────────┘   └────────┘   └─────────┘   └────────┘   └────────┘
        │            │              │              │
        ▼            ▼              ▼              ▼
      IF/ID        ID/EX          EX/MEM        MEM/WB
     Register    Register        Register      Register
```

**Fetch:** PC, BTB lookup, BHT prediction, IMEM access, speculative instruction fetch

**Decode:** Register file read, control signal generation, hazard detection, branch resolution, decode-stage forwarding

**Execute:** ALU operation, EX-stage forwarding, HILO register access (MULT/DIV)

**Memory:** DMEM read/write, MEM-stage forwarding for store instructions

**Write Back:** Register file write, JAL/JALR link, LW/LB/LBU memory-to-register

---

## Features

### Hazard Handling
- **Data hazards** — detected in ID stage by comparing source registers against pending destination registers in EX and MEM stages; pipeline stalled by inserting a NOP bubble
- **Load-use hazards** — one-cycle stall inserted when a load instruction is immediately followed by a dependent instruction
- **Branch hazards** — resolved in ID stage with early branch detection and forwarding from MEM/WB; pipeline flushed on misprediction
- **Structural hazards** — stall logic propagates cleanly through all 5 stages

### Forwarding
- **EX forwarding** — MEM/WB → EX and WB → EX paths for ALU-ALU back-to-back dependencies
- **MEM forwarding** — WB → MEM for store-after-load dependencies
- **Decode forwarding** — WB → ID for branch comparisons resolved in decode
- **HILO forwarding** — bypass path for MFHI/MFLO immediately after MULT

### Branch Prediction
- **2-bit bimodal BHT** — indexed by PC; saturating counter predicts taken/not-taken; updated at decode on resolution
- **Branch Target Buffer (BTB)** — stores predicted target PC and prefetched instruction bits; enables speculative fetch of the predicted next instruction before the branch is resolved
- Pipeline flush on mispredict with correct target re-fetch

### Instruction Support
- R-type: ADD, SUB, AND, OR, XOR, NOR, SLT, SLTU, SLL, SRL, SRA, JR, JALR, MULT, MFHI, MFLO
- I-type: ADDI, ANDI, ORI, XORI, SLTI, SLTIU, LW, LB, LBU, SW, SB, BEQ, BNE, LUI
- J-type: J, JAL
- Syscall (emulated): print integer, print string, exit

### Other
- 32 general-purpose registers (REGFILE)
- 64-bit HILO register for multiply results
- Two-cycle multiplier
- Sign/zero extender for immediate operands
- Syscall emulation at WB stage (avoids forwarding/flushing edge cases)
- Checkpoint mechanism: flushes pipeline after N instructions and dumps register/memory state for correctness verification

---

## File Structure

```
src/
├── Top.v               ← Top-level CPU module (pipelinedCPU)
├── CONTROL.v           ← Control unit — decodes opcode/funct to control signals
├── ALU.v               ← 32-bit ALU (arithmetic, logic, shifts, comparisons)
├── REGFILE.v           ← 32-register file with async read, sync write
├── HazardDetection.v   ← Detects data and control hazards, issues stalls
├── BHT.v               ← 2-bit bimodal Branch History Table
├── BTB.v               ← Branch Target Buffer with prefetched instruction bits
├── DecodeForwarding.v  ← Forwarding into ID stage for branch resolution
├── EXForwarding.v      ← MEM→EX and WB→EX forwarding
├── MEMforwarding.v     ← WB→MEM forwarding for store instructions
├── EQComp.v            ← Equality comparator for branch condition in ID
├── SZExtender.v        ← Sign/zero extender for immediates
├── ScaledAdder.v       ← Branch target adder (PC+4 + offset<<2)
├── IncFour.v           ← PC+4 incrementer
├── IF_ID_PR.v          ← IF/ID pipeline register
├── ID_EX_PR.v          ← ID/EX pipeline register
├── EX_MEM_PR.v         ← EX/MEM pipeline register
├── MEM_WB_PR.v         ← MEM/WB pipeline register
├── IMEM.v              ← Instruction memory interface
├── DMEM.v              ← Data memory interface
├── MainMemory.v        ← Unified backing memory for IMEM and DMEM
├── mc_mult.v           ← Two-cycle multiplier
├── reg32.v             ← 32-bit register with enable
├── reg64.v             ← 64-bit HILO register
├── SYSCALL_EMU.v       ← Non-synthesizable syscall emulator (WB stage)
├── TestWrapper.v       ← Testbench — loads program, clocks CPU, checks output
├── hilo.mem            ← Initial HILO register value
├── mem.mem             ← Initial memory contents (MIPS program)
├── pc.mem              ← Initial PC value
└── reg.mem             ← Initial register file values
```

---

## Simulation

**Tool:** Xilinx Vivado with XSim

1. Open Vivado and create a new project
2. Add all `.v` files from `src/` as design sources
3. Add `TestWrapper.v` as simulation source
4. Set `TestWrapper` as the top-level simulation module
5. Load memory init files (`mem.mem`, `reg.mem`, `pc.mem`, `hilo.mem`) into the project directory
6. Run behavioral simulation — the testbench clocks the CPU and verifies register/memory state against expected output files

---

## Tech Stack

| Area | Detail |
|---|---|
| Language | Verilog (IEEE 1364) |
| Tool | Xilinx Vivado / XSim |
| ISA | MIPS-32 (subset) |
| Course | CMPEN 331 — Computer Organization and Design, Penn State (Fall 2021) |
