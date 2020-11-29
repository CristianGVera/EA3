include macros.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h
.DATA

@str0   db "Ingrese un valor pivot mayor o igual a 1: ", "$", 30 dup (?)
pivot   dd ?
resul   dd ?
@int3   dd 1.00
@int4   dd 2.00
@int5   dd 3.00
@rangoMinimo  dd 1.00
@errorPivot  db "El valor de pivot debe ser mayor o igual a 1.", "$", 30 dup (?)
@cero  dd 0.00
@uno  dd 1.00
@pivot  dd ?
@aux1   dd ?
@aux2   dd ?
@aux3   dd ?
@aux4   dd ?
@aux5   dd ?
@aux6   dd ?

.CODE

START:
MOV EAX, @DATA
MOV DS, EAX
MOV ES, EAX

displayString @str0
newLine
getFloat pivot,2
fld pivot
fstp @pivot
fld @pivot
fld @cero
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if0
fld @pivot
fld @uno
fsub
fstp @aux1
fld @aux1
fstp @pivot
fld resul
fld @int5
fadd
fstp @aux2
fld @aux2
fstp resul
_if0:
fld @pivot
fld @cero
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if1
fld @pivot
fld @uno
fsub
fstp @aux3
fld @aux3
fstp @pivot
fld resul
fld @int4
fadd
fstp @aux4
fld @aux4
fstp resul
_if1:
fld @pivot
fld @cero
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if2
fld @pivot
fld @uno
fsub
fstp @aux5
fld @aux5
fstp @pivot
fld resul
fld @int3
fadd
fstp @aux6
fld @aux6
fstp resul
_if2:
displayFloat resul,2
newLine

MOV EAX, 4C00h
INT 21h

END START
