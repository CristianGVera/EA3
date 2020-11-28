include macros.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h
.DATA

@str0 	db "Ingrese un valor pivot mayor o igual a 1: ", "$", 30 dup (?)
pivot 	dd ?
resul 	dd ?
@int3 	dd 1.00
@int4 	dd 2.00
@int5 	dd 3.00
@str6 	db "El resultado es: ", "$", 30 dup (?)

.CODE

START:
MOV EAX, @DATA
MOV DS, EAX
MOV ES, EAX

displayString @str0
newLine
getFloat pivot,0
displayFloat pivot,0
newLine
displayString @str-1
newLine
displayString @str6
newLine
displayFloat resul,0
newLine

MOV EAX, 4C00h
INT 21h

END START
