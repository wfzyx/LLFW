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

; Prints a string, DS=>SI: 0 terminated string
print:
	lodsb
	or			al, al			; al=current character
	jz			pdone			; null terminator found
	mov			ah, 0eh			; get next character
	int			10h
	jmp			print
pdone:
	ret

; Main Routine
start:
; Setup segments to insure they are 0. Remember that
; we have ORG 0x7c00. This means all addresses are based
; from 0x7c00:0. Because the data segments are within the same
; code segment, null em.
	xor ax, ax
	mov ds, ax
	mov es, ax

welcome:
	mov si, msg				; set up msg to print
	call print

	xor	ax, ax				; clear ax
	int	0x12				; get KB of RAM from the BIOS

	cli						; Clear all INTs
	hlt						; Halt system

msg	db	"Welcome to PYTHONIX!", 0

times 510 - ($-$$) db 0		; Fill from this line up to byte 510 with 0
dw 0xAA55					; Boot sign, 511 and 512 byte