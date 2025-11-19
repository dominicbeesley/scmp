; Functions.
L FUNCTION VAL16, (VAL16 & 0xFF)
H FUNCTION VAL16, ((VAL16 >> 8) & 0xFF)

;; This code is not position independant

      ORG   0x0001
      LDI   L(HALT-1)
      XPAL  P3
      LDI   H(HALT-1)
      XPAH  P3
TEST:
      LDI   00
      CAS                  ; Set status to a known value
      XAE                  ; Set E to a known value
      LDI	L(RANGES)      ; Load P3 with the LSB of the ranges table
      XPAL  P3
      ST    ORIGP3         ; Save the LSB of the return address
      LDI   H(RANGES)      ; Load P3 with the MSB of the ranges table
      XPAH  P3
      ST    ORIGP3+1       ; Save the MSB of the return address
LOOP1:
      LD    @1(P3)         ; Load the starting opcode from a range, auto inc
      JZ    RETURN         ; If zero, that's the end
      ST    OP1            ; Write the opcode to be tested
LOOP2:
      CSA                  ; Set the carry and overflow bits
      ORI   0xC0
      CAS
      LDI   0x55           ; Set the E register
      XAE
      LDI   0xAA           ; Set the accumulator
OP1:
      NOP
      NOP
      ST    RESULT         ; expose the accumulator
      CSA
      ST    RESULT         ; expose the status register
      LDE
      ST    RESULT         ; expose the E register
      
      ILD   OP1            ; increment opcode
      XOR   (P3)           ; Test against end of range
      JNZ   LOOP2          ; Loop back for more

      LD    @1(P3)         ; Move to next range
      JMP   LOOP1
      
RETURN:
      LD    ORIGP3
      XPAL  P3
      LD    ORIGP3 + 1
      XPAH  P3
      XPPC  P3


HALT:
      HALT
      HALT
      HALT
      HALT
HERE: JMP  HERE

ORIGP3:
      DW    0
      
RESULT:
      DB    0x00
      
RANGES:
      DB    0x09, 0x18+1
      DB    0x1A, 0x1B+1
      DB    0x20, 0x2F+1
      DB    0x38, 0x3B+1
      DB    0x41, 0x4F+1
      DB    0x51, 0x57+1
      DB    0x59, 0x5F+1
      DB    0x61, 0x67+1
      DB    0x69, 0x6F+1
      DB    0x71, 0x77+1
      DB    0x79, 0x8E+1
      DB    0xA0, 0xA7+1
      DB    0xAC, 0xAF+1
      DB    0xB0, 0xB7+1
      DB    0xBC, 0xBF+1
      DB    0xCC, 0xCC+1
      DB    0x00, 0x00+1      
