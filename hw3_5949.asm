TITLE   Homework3           ; Jittin Jindanoraseth 6110405949
STACK   SEGMENT STACK 
        DW 64 DUP(?)
STACK   ENDS

DATA    SEGMENT
SALE    DW ?
PLAN1   DW ?
PLAN2   DW ?
HANDLE  DW ?
FNAME   DB 'SALE.DAT',0
HEAD    DB 9,'NAME',9,'SALE AMOUNT',9,'PLAN 1',9,'PLAN 2',9,'BEST PLAN',13,10,'$'
NAME_L  DB 20 DUP(?),9
SALEA   DB 5 DUP(?),9
PLAN1A  DB 6 DUP(?),9
PLAN2A  DB 6 DUP(?),9
PLAN    DB ?,13,10,'$'
TMP     DB ?,?
DATA    ENDS

CODE    SEGMENT
        ASSUME  CS:CODE, DS:DATA, SS:STACK
MAIN    PROC
        MOV AX,DATA         ; initialize DS
        MOV DS,AX

        MOV AH,3DH          ; open file
        MOV AL,0            ; read from file
        LEA DX,FNAME
        INT 21H

        JNC RUN             ; error?
        MOV AH,4CH          ; return to DOS
        INT 21H

RUN:    MOV HANDLE,AX       ; file handle in AX

        MOV AH,9            ; display string
        LEA DX,HEAD         ; offset of HEAD
        INT 21H

        MOV BX,HANDLE       ; handle of file that is already opened

READ:   MOV AH,3FH
        MOV CX,20
        LEA DX,NAME_L
        INT 21H

        MOV AH,3FH
        MOV CX,5
        LEA DX,SALEA
        INT 21H

        MOV AH,3FH
        MOV CX,2
        LEA DX,TMP
        INT 21H

        PUSH BX
        CALL ATOB
        CMP SALE,0
        JZ  ZERO
        
        MOV AX,SALE
        CWD
        MOV DI,100
        DIV DI
        MOV CX,AX           ; CX is 1% of SALE

        MOV DI,10
        MUL DI
        ADD AX,1600
        MOV PLAN1,AX
        MOV BX,AX

        MOV AX,CX
        MOV DI,15
        MUL DI
        MOV PLAN2,AX

        CMP BX,AX
        JB CPLAN2
CPLAN1: MOV PLAN,'1'
        JMP DISP
CPLAN2: MOV PLAN,'2'

DISP:   PUSH PLAN1
        LEA BX,PLAN1A
        CALL BTOA

        PUSH PLAN2
        LEA BX,PLAN2A
        CALL BTOA

        MOV AH,9            ; display string
        LEA DX,NAME_L       ; offset of HEAD
        INT 21H

        POP BX
        JMP READ

ZERO:   MOV AH,3EH
        MOV BX,HANDLE
        INT 21H
        MOV AH,4CH          ; return to DOS
        INT 21H
MAIN    ENDP


ATOB    PROC
        MOV CX,5
        LEA DI,SALEA
        MOV AX,0
        MOV SI,10
NEXT_A: IMUL SI             ; DX:AX = AX * 10
        SUB BX,BX
        MOV BL,[DI]         ; get ASCII code
        CMP BL,' '          ; compare BL with ' '
        JE  SKIP            ; jump if BL is ' ' not digit
        SUB BX,30H
        ADD AX,BX           ; update partial result
SKIP:   INC DI
        LOOP NEXT_A
        MOV SALE,AX
ATOB    ENDP


BTOA    PROC
        MOV BP,SP           ; set pointer BP at top of stack
        MOV AX,[BP+2]       ; copy unit from stack into AX
        MOV CX,6            ; set 6 to CX(count loop)

FILL:   MOV BYTE PTR[BX],' '; fill with blanks
        INC BX
        LOOP FILL

        MOV DI,10           ; divide by 10
        CMP AX,0            ; negative?
        JAE NEXT
        NEG AX              ; change to positive

NEXT:   CWD
        DIV DI              ; DX:AX = DX,AX / DI(10)
        ADD DX,'0'          ; convert to ASCII code
        DEC BX              ; BX--
        MOV [BX],DL         ; store character in string
        CMP AX,0            ; finish?
        JA  NEXT            ; no, get next digit

        MOV AX,[BP+2]       ; copy unit from stack into AX // get original number
        CMP AX,0            ; negative?
        JAE DONE
        DEC BX              ; store '-'
        MOV BYTE PTR[BX],'-'

DONE:   RET 2
BTOA    ENDP


CODE    ENDS
        END MAIN