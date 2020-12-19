[BITS 16]
[ORG 0x7C00]

MOV SI, DataString
CALL OutString
HLT

OutCharacter: ;modified registers: AH, BH, BL
     ;ASCII value is in register AL
MOV AH, 0x0E  ;Tell BIOS that we need to print one character on screen.
MOV BH, 0x00  ;Page no.
MOV BL, 0x07  ;Text attribute 0x07 is light grey font on black background

INT 0x10      ;Call video interrupt
RET

OutString: ;modified registers AL, SI, AH, BH, BL
    ;String Pointer in SI
MOV AL, [SI]       ;Load next character from string into AL to send to OutCharacter
INC SI
OR AL, AL          ;Check if AL is zero without changing AL
JZ OutString_Exit  ;if zero stop
CALL OutCharacter  ;print character in AL
JMP OutString      ;loop until end of string
OutString_Exit:
RET                ;End of routine

;Data
DataString db 'NotAnOS Bootloader',0

TIMES 510 - ($ - $$) db 0    ;Fill the rest of sector 0 with zeroes
DW 0xAA55                    ;Legacy boot signature
