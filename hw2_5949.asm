TITLE   Homework2           ; Jittin Jindanoraseth 6110405949
STACK   SEGMENT STACK 
        DW 64 DUP(?)
STACK   ENDS

DATA    SEGMENT
ROOM1   DW 138
ROOM2   DW 375
ROOM3   DW 24
PRICE1  DW ?
PRICE2  DW ?
PRICE3  DW ?
HEAD    DB 'ROOM NUMBER       ','UNIT ',9,' PRICE',13,10
LINE1   DB '   ROOM1',9
UNIT1A  DB 6 DUP(?),9
PRICE1A DB 6 DUP(?),13,10
LINE2   DB '   ROOM2',9
UNIT2A  DB 6 DUP(?),9
PRICE2A DB 6 DUP(?),13,10
LINE3   DB '   ROOM3',9
UNIT3A  DB 6 DUP(?),9
PRICE3A DB 6 DUP(?),13,10,'$'
DATA    ENDS

CODE    SEGMENT
        ASSUME  CS:CODE, DS:DATA, SS:STACK
MAIN    PROC
        MOV AX,DATA         ; initialize DS
        MOV DS,AX

        PUSH ROOM1
        CALL CALC
        POP PRICE1

        PUSH ROOM2
        CALL CALC
        POP PRICE2

        PUSH ROOM3
        CALL CALC
        POP PRICE3

        PUSH ROOM1
        LEA BX,UNIT1A
        CALL BTOA

        PUSH ROOM2
        LEA BX,UNIT2A
        CALL BTOA

        PUSH ROOM3
        LEA BX,UNIT3A
        CALL BTOA

        PUSH PRICE1
        LEA BX,PRICE1A
        CALL BTOA

        PUSH PRICE2
        LEA BX,PRICE2A
        CALL BTOA

        PUSH PRICE3
        LEA BX,PRICE3A
        CALL BTOA

        MOV AH,9            ; display string
        LEA DX,HEAD         ; offset of HEAD
        INT 21H

        MOV AH,4CH          ; return to DOS
        INT 21H
MAIN    ENDP


CALC    PROC
        MOV BP,SP           ; set pointer BP at top of stack
        MOV BX,[BP+2]       ; copy unit from stack into BX
        MOV CX,0            ; set 0 to CX(price)
        
RATE3:  CMP BX,150          ; compare BX(unit) with 150
        JBE RATE2           ; jump to RATE2 if unit <= 150

        MOV DI,5            ; RATE3 for unit > 150 // copy 5(baht) into DI
        MOV AX,BX           ; copy BX(unit) to AX
        MOV BX,150          ; set 150 to BX(unit)
        SUB AX,150          ; AX = AX(unit) - 150
        MUL DI              ; DX,AX = AX(unit) * DI(5)
        ADD CX,AX           ; CX(price) = CX + AX
   
RATE2:  CMP BX,25           ; compare BX(unit) with 25
        JBE RATE1           ; jump to RATE1 if unit <= 25

        MOV DI,4            ; RATE2 for unit > 25 // copy 4(baht) into DX
        MOV AX,BX           ; copy BX(unit) to AX
        MOV BX,25           ; set 25 to BX(unit)
        SUB AX,25           ; AX = AX(unit) - 25
        MUL DI              ; DX,AX = AX(unit) * DI(4)
        ADD CX,AX           ; CX(price) = CX + AX

RATE1:  MOV DI,3            ; RATE1 for unit <= 25 // copy 3(baht) into DX
        MOV AX,BX           ; copy BX(unit) to AX
        MUL DI              ; DX,AX = AX(unit) * DI(3)
        ADD CX,AX           ; CX(price) = CX + AX

        MOV [BP+2],CX       ; copy CX(price) into stack
        RET
CALC    ENDP


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
        DIV DI              ; DX|AX = DX,AX / DI(10)
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