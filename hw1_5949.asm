TITLE   Homework1           ; Jittin Jindanoraseth 6110405949
STACK   SEGMENT STACK
        DW 64 DUP(?)
STACK   ENDS

DATA    SEGMENT 
UNIT    DB 101
NET     DW ?
SAVE    DW ?
TOTAL   DW ?
DATA    ENDS

CODE    SEGMENT
        ASSUME CS:CODE, DS:DATA, SS:STACK
FIRST   PROC
        MOV AX,DATA         ; initialize DS
        MOV DS,AX
        MOV AL,UNIT         ; copy UNIT into AL
        CBW                 ; convert byte to word
        MOV BX,39           ; copy 39 (price) into BX
        MUL BX              ; BX (price) * AX (unit)
        MOV NET,AX          ; copy AX (result net) to NET
        MOV AL,UNIT         ; copy UNIT into AL
        CBW                 ; convert byte to word
        MOV BX,4            ; copy 4 (piece per set) into BX
        DIV BX              ; AX (unit) / BX (4)
        MOV CX,39           ; copy 39 (price) into CX
        MUL CX              ; CX (39 price) * AX (amount set promotion)
        MOV SAVE,AX         ; copy AX (result save) into SAVE
        MOV DX,NET          ; copy NET into DX
        MOV TOTAL,DX        ; copy DX (net) into TOTAL
        SUB TOTAL,AX        ; TOTAL (net) - AX (save)
        MOV AH,4CH          ; return to DOS
        INT 21H
FIRST   ENDP
CODE    ENDS
        END FIRST