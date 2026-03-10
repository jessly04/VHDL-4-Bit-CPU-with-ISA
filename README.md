# VHDL-4-Bit-CPU-with-ISA
This project covers concepts such as instruction fetching, decoding, execution and utilization conditional logic through its VHDL implementation of a custom 4-bit Central Processing Unit (CPU) designed for the Altera/Intel MAX 10 DE10-Lite FPGA.
### Technical Features
- **Custom Instruction Set ARchitecture (ISA):** Supports 4-bit instructions, including:
  - LDA (Load Accumulator Immediate)
  - ADDA (Add Accumulator Immediate)
  - CMPA (Compare Accumulator Immediate)
  - BRA (Branch Always)
  - BEQ (Branch if Equal)
- **Micro-coded Finite State Machine (FSM):** `micro_code` entity controls the CPU's operation and transitions through states such as `fetch_in`, `decode`, `fetch_op`, `load_acc`, `add_acc`, `cmp_acc`, `test_flag`, `fetch_pc`, and `incr_pc`.
- **Arithmetic Logic Unit (ALU):** A 4-bit ALU that is able to complete `ADD` and `COMPARE` operations and has a dedicated `equal` output used for status flags.
- **Z-Flag Implementation:** Implemented a `z-flag` D-flip-flop to store the ALU's `equal` status and enables conditional program flow (e.g., the `BEQ` instruction).
- **Structural and Behavorial VHDL:** Utilizes a top-level structural architecture to connect a variety of behavioral components such as registers, ALU, ROM, and FSM.
### Hardware
- **Board:** Altera/Intel MAX 10 DE10-Lite FPGA
- **Debugging & Display:** Six 7-Segment HEX displays for real-time visualization of CPU registers (Address, Data, Instruction, Operand, ALU Output, Accumulator)
- **Clock Source:** External 1Hz clock (used Analog Discovery) for single-step execution and observation.
- **Additional Hardware:** Male-To-Female Jumper wires
### Software
- Quartus
### Challenge & Solution
The main problem that I faced was being able to understand and translate high-level program control (like if-else statements in C) into low-level hardware logic for the CPU. I was able to achieve this by designing `micro_code` FSM that interprets instruction opcodes and utilizes the `Z-flag` from the ALU. Because, instructions like BEQ, the FSM makes decisions based on the stored `Z-Flag` state and redirects the Program Counter (`inc_reg`) to a new address if the condition is met and so implements the program branching.
### Project Structure
- `Lab12.vhd`: The top-level structural entity that interconnects all CPU components
- `micro_code.vhd`: The Finite State Machine responsible for CPU control signals
- `ALU.vhd`: The Arithmetic Logic Unit definition
- `ROM.vhd`: The Read-Only Memory, pre-loaded with the CPU's program.
- `z_flag.vhd`: The D-flip-flop implementation for the Z-flag.
- `hex_encode.vhd`: Logic for driving 7-segments displays.
- `reg.vhd`: 4-bit register component
- `inc_reg.vhd:` Incrementing register component used for Program Counter
