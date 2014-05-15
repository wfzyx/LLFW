; Pythonix Bootloader

org		0x7c00				; Load by BIOS in there
bits	16					; 16b real mode

Start:
	cli						; Clear all INTs
	hlt						; Halt system

times 510 - ($-$$) db 0		; Fill from this line up to byte 510 with 0
dw 0xAA55					; Boot sign, 511 and 512 byte