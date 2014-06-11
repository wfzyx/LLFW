; Pythonix Bootloader

[BITS 16]					; 16 bits real mode
[ORG 0x7C00]				; Load by BIOS in there
start: 	JMP     boot

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
	reset_drive:
	MOV 	AH, 0x00
	INT 	13h 				; Reset disk
	OR 		AH, AH
	JNZ		reset_drive

	MOV 	AX, 0x00
	MOV 	ES, AX 				; Load location
	MOV 	BX, 0x1000
	MOV 	AH, 0x02 			; int 13 function
	MOV 	AL, 0x02 			; number of sectors to read
	MOV 	CH, 0x00 			; cylinder	
	MOV 	CL, 0x02			; Second disk sector
	MOV 	DH, 0x00 			; Head
	INT 	13h					; Read sectors
	OR 		AH, AH
	JNZ		reset_drive

	CLI 						; Disable interrupts

	XOR		AX, AX
	MOV		DS, AX				; Set data seg to 0 to lgdt

	LGDT 	[gdt_desc]			; Load GDT descriptor

	MOV 	EAX, CR0			
	OR 		EAX, 0x01 			; Set to True bit 0
	MOV 	CR0, EAX

	JMP 	0x08:clear_pipe		; Jump to code seg, offset clear_pipe

[BITS 32]
clear_pipe:
	MOV 	AX, 0x10 			; Save data seg indentifyer
	MOV 	DS, AX 				; move a valid data seg into DS
	MOV 	SS, AX				; same for SS
	MOV 	ESP, 0x090000
	JMP 	0x08:0x01000

gdt:                    ; Address for the GDT

gdt_null:               ; Null Segment
        dd 0
        dd 0

gdt_code:               ; Code segment, read/execute, nonconforming
        dw 0FFFFh
        dw 0
        db 0
        db 10011010b
        db 11001111b
        db 0

gdt_data:               ; Data segment, read/write, expand down
        dw 0FFFFh
        dw 0
        db 0
        db 10010010b
        db 11001111b
        db 0

gdt_end:                ; Used to calculate the size of the GDT


gdt_desc:                       ; The GDT descriptor
        dw gdt_end - gdt - 1    ; Limit (size)
        dd gdt                  ; Address of the GDT

times 510 - ($-$$) db 0		; Fill from this line up to byte 510 with 0
dw 0xAA55					; Boot sign, 511 and 512 byte