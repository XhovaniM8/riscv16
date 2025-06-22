# RiSC-16 Instruction Set Summary

## Registers
- 8 registers (r0–r7), 16-bit wide
- `r0` is always 0 by hardware convention

## Instruction Formats

- **RRR-type:** `add`, `nand`
- **RRI-type:** `addi`, `lw`, `sw`, `beq`, `jalr`
- **RI-type:** `lui`

## Base Instructions

| Mnemonic | Format  | Action |
|----------|---------|--------|
| `add`    | RRR     | `rA = rB + rC` |
| `addi`   | RRI     | `rA = rB + imm` |
| `nand`   | RRR     | `rA = ~(rB & rC)` |
| `lui`    | RI      | `rA = (imm << 6)` |
| `lw`     | RRI     | `rA = Mem[rB + imm]` |
| `sw`     | RRI     | `Mem[rB + imm] = rA` |
| `beq`    | RRI     | if `rA == rB`, `PC = PC + 1 + imm` |
| `jalr`   | RRI     | `rA = PC + 1`, `PC = rB` |

## Pseudo-instructions

| Mnemonic | Description |
|----------|-------------|
| `nop`    | `add r0, r0, r0` |
| `halt`   | `jalr r0, r0` with non-zero immediate |
| `lli`    | `addi rA, rA, imm & 0x3F` |
| `movi`   | `lui + lli` |
| `.fill`  | Embed constant or label address |
| `.space` | Reserve memory (zero-filled) |

