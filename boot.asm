; Pythonix Bootloader

org		0x7c00				; Load by BIOS in there
bits	16					; 16 bits real mode
jmp     start

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
start:
	cli						; Clear all INTs
	hlt						; Halt system

times 510 - ($-$$) db 0		; Fill from this line up to byte 510 with 0
dw 0xAA55					; Boot sign, 511 and 512 byte