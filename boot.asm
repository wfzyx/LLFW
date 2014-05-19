; Pythonix Bootloader

org		0x7c00				; Load by BIOS in there
bits	16					; 16 bits real mode
start: 	jmp     boot

; BPB
; This block must after 3 bytes in the beginning of the file, use nop if needed

bpbOEM					db "Pythonix"
bpbBytesPerSector:  	DW 512
bpbSectorsPerCluster: 	DB 1
bpbReservedSectors: 	DW 1
bpbNumberOfFATs: 	    DB 2
bpbRootEntries: 	    DW 224
bpbTotalSectors: 	    DW 2880
bpbMedia: 	            DB 0xF0
bpbSectorsPerFAT: 	    DW 9
bpbSectorsPerTrack: 	DW 18
bpbHeadsPerCylinder: 	DW 2
bpbHiddenSectors: 	    DD 0
bpbTotalSectorsBig:     DD 0
bsDriveNumber: 	        DB 0
bsUnused: 	            DB 0
bsExtBootSignature: 	DB 0x29
bsSerialNumber:	        DD 0xa0a1a2a3
bsVolumeLabel: 	        DB "BOOT FLOPPY"	; Must be 11 bytes
bsFileSystem: 	        DB "FAT12   "		; Must be 08 bytes

; Main Routine
boot:	
	mov		dl, 0x0					; drive number. Remember Drive 0 is floppy drive.
	mov		dh, 0x0					; head number (0=base)
	mov		ch, 0x0				; we are reading the second sector past us, so its still on track 1
	mov		cl, 0x02				; sector to read (The second sector)
	mov		bx, 0x1000
	mov		es, bx
	xor		bx, bx 					; reset BX
	
.Read:
	mov		ah, 0x02				; read floppy sector function
	mov		al, 0x01				; read 1 sector
	int		0x13					; call BIOS - Read the sector
	jc		.Read
	
	mov		ax, 0x1000				; we are going to read sector to into address 0x1000:0
	mov		ds, ax					; Set segments register to new location
	mov		es, ax
	mov		fs, ax
	mov		gs, ax
	mov		ss, ax

	jmp		0x1000:0x0				; jump to execute the sector!

times 510 - ($-$$) db 0		; Fill from this line up to byte 510 with 0
dw 0xAA55					; Boot sign, 511 and 512 byte