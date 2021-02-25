; MS-DOS xmodem revice program

SOH	EQU	01H
STX	EQU	02H
EOT	EQU	04H
ACK	EQU	06H
NAK	EQU	15H
CAN	EQU	18H

	ORG	100H

	MOV	BX,80H
	XOR	CX,CX
	ADD	CL,[BX]
	DEC	CX
	MOV	SI,82H
	MOV	DI,FOPT
L5:
	MOV	AL,[SI]
	MOV	[DI],AL
	INC	SI
	INC	DI
	LOOP	L5
	MOV	[DI],BYTE 0

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

; XMODEM

	MOV	AH,04H
	MOV	DL,NAK
	INT	21H

L2:
	MOV	AH,03H
	INT	21H
	CMP	AL,EOT
	JE	L1

	MOV	CX,131
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

; write
	MOV	BX,[FHAND]
	MOV	CX,128
	MOV	DX,BUFF
	ADD	DX,2
	MOV	AH,40H
	INT	21H

	JMP	L2

L1:
	MOV	AH,04H
	MOV	DL,ACK
	INT	21H

; close
	MOV	BX,[FHAND]
	MOV	AH,3EH
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

	ERRSTR	DB	'ERROR$'
	FHAND	DW	0
	BUFF	DB	256 DUP(0)
	FOPT	DB	32 DUP(0)