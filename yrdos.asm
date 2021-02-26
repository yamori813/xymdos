; MS-DOS ymodem revice program

SOH	EQU	01H
STX	EQU	02H
EOT	EQU	04H
ACK	EQU	06H
NAK	EQU	15H
CAN	EQU	18H

	ORG	100H

; YMODEM

L8:
	MOV	AH,04H
;	MOV	DL,NAK
	MOV	DL,'C'
	INT	21H

L2:
	MOV	AH,03H
	INT	21H
	CMP	AL,EOT
	JE	L10
	MOV	CX,128
	ADD	CX,4
	MOV	BX,BUFF
L3:
	MOV	AH,03H
	INT	21H
	MOV	[BX],AL
	INC	BX
	LOOP	L3

	MOV	AH,04H
	MOV	DL,ACK
	INT	21H

	MOV	AL,[START]
	CMP	AL,0
	JE	L9
; write
	MOV	DL,'*'
	MOV	AH,02H
	INT	21H
	MOV	BX,[FHAND]
	MOV	CX,128
	MOV	AX,[BLOCKS]
	CMP	AX,0
	JNE	L16
	MOV	CL,[LAST]
L16:
	MOV	DX,[BLOCKS]
	DEC	DX
	MOV	[BLOCKS],DX
	MOV	DX,BUFF
	ADD	DX,2
	MOV	AH,40H
	INT	21H

	JMP	L2

L9:
	MOV	AL,1
	MOV	[START],AL
	MOV	DL,'#'
	MOV	AH,02H
	INT	21H
	MOV	AL,[BUFF+2]
	CMP	AL,0
	JE	L1

; copy file name
	MOV	SI,BUFF+2
	MOV	DI,FOPT
L11:
	MOV	AL,[SI]
	MOV	[DI],AL
	INC	SI
	INC	DI
	CMP	AL,0
	JNE	L11

; get file size
	XOR	BX,BX
	XOR	AX,AX
L13:
	MOV	AL,[SI]
	INC	SI
	CMP	AL,' '
	JE	L12

	MOV	CX,10
	XOR	DX,DX
L17:
	ADD	DL,AH
	LOOP	L17
	MOV	AH,DH

	MOV	CX,10
	XOR	DX,DX
L14:
	ADD	DX,BX
	JNC	L18
	INC	AH
L18:
	LOOP	L14
	MOV	BX,DX
	SUB	AL,'0'
	ADD	BX,AX
	JMP	L13

L12:
	MOV	AL,BL
	AND	AL,7FH
	CMP	AL,0
	JNE	L19
	MOV	AL,128
L19:
	MOV	[LAST],AL
	SHR	BX,7
	SHL	AH,1
	OR	BH,AH
	MOV	[BLOCKS],BX
;	MOV	[SIZE],BX

; create
	MOV	DX,FOPT
	XOR	CX,CX
	MOV	AH,3CH
	INT	21H
	JC	ER

; open
	MOV	DX,FOPT
	MOV	AH,3DH
	MOV	AL,01H
	INT	21H
	MOV	[FHAND],AX

	JMP	L8

L10:
	MOV	AH,04H
	MOV	DL,NAK
	INT	21H
	MOV	AH,03H
	INT	21H
	MOV	AH,04H
	MOV	DL,ACK
	INT	21H

; close
	MOV	BX,[FHAND]
	MOV	AH,3EH
	INT	21H

	MOV	AL,0
	MOV	[START],AL

	MOV	DL,'$'
	MOV	AH,02H
	INT	21H

	JMP	L8

L1:
	MOV	AH,04H
	MOV	DL,ACK
	INT	21H

	JMP	L4

ER:
	MOV	DX, ERRSTR
	MOV	AH,09H
	INT	21H

; EXIT
L4:
	MOV	AH,4CH
	INT	21H

	LAST	DB	0
	BLOCKS	DW	0
	ERRSTR	DB	'ERROR$'
	FHAND	DW	0
	BUFF	DB	2048 DUP(0)
	FOPT	DB	32 DUP(0)
	START	DB	0
