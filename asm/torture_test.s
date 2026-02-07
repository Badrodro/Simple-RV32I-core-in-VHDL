# RV32I-Alpha Torture Test
# Goals: Validate LUI/ADDI (32-bit construction), SRAM Write/Read, 
#        Stall logic (CPI=2 on LW), and Branch/Jump integrity.

.text
_start:
    lui   x1, 0x12345      # x1 = 0x12345000
    addi  x1, x1, 0x678    # x1 = 0x12345678 (Full 32-bit test)
    sw    x1, 4(x0)        # Store x1 at RAM address 4
    lw    x2, 4(x0)        # Load from RAM address 4 (Triggers Stall)
    sub   x3, x2, x1       # x3 = x2 - x1. If LW/SW worked, x3 = 0
    beq   x3, x0, success   # If x3 == 0, jump to success (PC + 8)
    jal   x4, error        # If we reach here, the test failed
success:
    addi  x3, x3, 1        # x3 = 1
    sw    x3, 8(x0)        # Store '1' at address 8 to signal success
error:
    ebreak                 # Raise TRAP signal to end simulation
