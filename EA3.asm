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
@rangoMinimo  dd 1.00
@errorPivot  db "El valor debe ser mayor o igual a 1.", "$", 30 dup (?)
@cero  dd 0.00
@uno  dd 1.00
@pivot  dd ?
@listaVacia  db "La lista esta vacia.", "$", 30 dup (?)
@errorCantLista  db "La lista tiene menos elementos que el indicado.", "$", 30 dup (?)
@cantLista1  dd 1.00
@aux1   dd ?
@aux2   dd ?

.CODE

START:
MOV EAX, @DATA
MOV DS, EAX
MOV ES, EAX

displayString @str0
newLine
getFloat pivot,2
fld pivot
fld @rangoMinimo
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jae _ErrorPivot
displayString @errorPivot
jmp _fin
_ErrorPivot:
fld pivot
fld @cantLista1
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if0
displayString @errorCantLista
newLine
jmp _if1
_if0:
fld pivot
fstp @pivot
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
fstp @aux1
fld @aux1
fstp @pivot
fld resul
fld @int3
fadd
fstp @aux2
fld @aux2
fstp resul
_if1:
displayFloat resul,2
newLine
_fin:

MOV EAX, 4C00h
INT 21h

END START
