include macros.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h
.DATA

@str0 	db "Ingrese un valor pivot mayor o igual a 1: ", "$", 30 dup (?)
pivot 	dd ?
resul 	dd ?
@int3 	dd 10.00
@int4 	dd 20.00
@int5 	dd 30.00
@int6 	dd 40.00
@int7 	dd 5.00
@int8 	dd 4.00
@int9 	dd 2.00
@int10 	dd 1.00
@int11 	dd 50.00
@rangoMinimo  dd 1.00
@errorPivot  db "El valor debe ser mayor o igual a 1.", "$", 30 dup (?)
@cero  dd 0.00
@uno  dd 1.00
@pivot  dd ?
@listaVacia  db "La lista esta vacia.", "$", 30 dup (?)
@errorCantLista  db "La lista tiene menos elementos que el indicado.", "$", 30 dup (?)
@cantLista4  dd 6.00
@cantLista3  dd 4.00
@cantLista2  dd 4.00
@cantLista1  dd 6.00
@aux1	dd ?
@aux2	dd ?
@aux3	dd ?
@aux4	dd ?
@aux5	dd ?
@aux6	dd ?
@aux7	dd ?
@aux8	dd ?
@aux9	dd ?
@aux10	dd ?
@aux11	dd ?
@aux12	dd ?
@aux13	dd ?
@aux14	dd ?
@aux15	dd ?
@aux16	dd ?
@aux17	dd ?
@aux18	dd ?
@aux19	dd ?
@aux20	dd ?
@aux21	dd ?
@aux22	dd ?
@aux23	dd ?
@aux24	dd ?
@aux25	dd ?
@aux26	dd ?
@aux27	dd ?
@aux28	dd ?
@aux29	dd ?
@aux30	dd ?
@aux31	dd ?
@aux32	dd ?
@aux33	dd ?
@aux34	dd ?
@aux35	dd ?
@aux36	dd ?
@aux37	dd ?
@aux38	dd ?
@aux39	dd ?
@aux40	dd ?

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
newLine
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
fld @cero
fstp resul
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
fld @int8
fadd
fstp @aux2
fld @aux2
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
fstp @aux3
fld @aux3
fstp @pivot
fld resul
fld @int7
fadd
fstp @aux4
fld @aux4
fstp resul
_if2:
fld @pivot
fld @cero
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if3
fld @pivot
fld @uno
fsub
fstp @aux5
fld @aux5
fstp @pivot
fld resul
fld @int6
fadd
fstp @aux6
fld @aux6
fstp resul
_if3:
fld @pivot
fld @cero
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if4
fld @pivot
fld @uno
fsub
fstp @aux7
fld @aux7
fstp @pivot
fld resul
fld @int5
fadd
fstp @aux8
fld @aux8
fstp resul
_if4:
fld @pivot
fld @cero
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if5
fld @pivot
fld @uno
fsub
fstp @aux9
fld @aux9
fstp @pivot
fld resul
fld @int4
fadd
fstp @aux10
fld @aux10
fstp resul
_if5:
fld @pivot
fld @cero
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if6
fld @pivot
fld @uno
fsub
fstp @aux11
fld @aux11
fstp @pivot
fld resul
fld @int3
fadd
fstp @aux12
fld @aux12
fstp resul
_if6:
displayFloat resul,2
newLine
fld pivot
fld @cantLista2
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if7
displayString @errorCantLista
newLine
jmp _if8
_if7:
fld pivot
fstp @pivot
fld @cero
fstp resul
fld @pivot
fld @cero
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if8
fld @pivot
fld @uno
fsub
fstp @aux13
fld @aux13
fstp @pivot
fld resul
fld @int8
fadd
fstp @aux14
fld @aux14
fstp resul
_if8:
fld @pivot
fld @cero
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if9
fld @pivot
fld @uno
fsub
fstp @aux15
fld @aux15
fstp @pivot
fld resul
fld @int9
fadd
fstp @aux16
fld @aux16
fstp resul
_if9:
fld @pivot
fld @cero
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if10
fld @pivot
fld @uno
fsub
fstp @aux17
fld @aux17
fstp @pivot
fld resul
fld @int9
fadd
fstp @aux18
fld @aux18
fstp resul
_if10:
fld @pivot
fld @cero
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if11
fld @pivot
fld @uno
fsub
fstp @aux19
fld @aux19
fstp @pivot
fld resul
fld @int9
fadd
fstp @aux20
fld @aux20
fstp resul
_if11:
displayFloat resul,2
newLine
fld pivot
fld @cantLista3
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if12
displayString @errorCantLista
newLine
jmp _if13
_if12:
fld pivot
fstp @pivot
fld @cero
fstp resul
fld @pivot
fld @cero
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if13
fld @pivot
fld @uno
fsub
fstp @aux21
fld @aux21
fstp @pivot
fld resul
fld @int8
fadd
fstp @aux22
fld @aux22
fstp resul
_if13:
fld @pivot
fld @cero
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if14
fld @pivot
fld @uno
fsub
fstp @aux23
fld @aux23
fstp @pivot
fld resul
fld @int10
fadd
fstp @aux24
fld @aux24
fstp resul
_if14:
fld @pivot
fld @cero
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if15
fld @pivot
fld @uno
fsub
fstp @aux25
fld @aux25
fstp @pivot
fld resul
fld @int10
fadd
fstp @aux26
fld @aux26
fstp resul
_if15:
fld @pivot
fld @cero
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if16
fld @pivot
fld @uno
fsub
fstp @aux27
fld @aux27
fstp @pivot
fld resul
fld @int9
fadd
fstp @aux28
fld @aux28
fstp resul
_if16:
displayFloat resul,2
newLine
displayString @listaVacia
newLine
displayFloat resul,2
newLine
fld pivot
fld @cantLista4
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if17
displayString @errorCantLista
newLine
jmp _if18
_if17:
fld pivot
fstp @pivot
fld @cero
fstp resul
fld @pivot
fld @cero
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if18
fld @pivot
fld @uno
fsub
fstp @aux29
fld @aux29
fstp @pivot
fld resul
fld @int6
fadd
fstp @aux30
fld @aux30
fstp resul
_if18:
fld @pivot
fld @cero
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if19
fld @pivot
fld @uno
fsub
fstp @aux31
fld @aux31
fstp @pivot
fld resul
fld @int11
fadd
fstp @aux32
fld @aux32
fstp resul
_if19:
fld @pivot
fld @cero
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if20
fld @pivot
fld @uno
fsub
fstp @aux33
fld @aux33
fstp @pivot
fld resul
fld @int6
fadd
fstp @aux34
fld @aux34
fstp resul
_if20:
fld @pivot
fld @cero
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if21
fld @pivot
fld @uno
fsub
fstp @aux35
fld @aux35
fstp @pivot
fld resul
fld @int5
fadd
fstp @aux36
fld @aux36
fstp resul
_if21:
fld @pivot
fld @cero
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if22
fld @pivot
fld @uno
fsub
fstp @aux37
fld @aux37
fstp @pivot
fld resul
fld @int4
fadd
fstp @aux38
fld @aux38
fstp resul
_if22:
fld @pivot
fld @cero
fxch
fcomp
ffree St(0)
fstsw ax
sahf
jna _if23
fld @pivot
fld @uno
fsub
fstp @aux39
fld @aux39
fstp @pivot
fld resul
fld @int3
fadd
fstp @aux40
fld @aux40
fstp resul
_if23:
displayFloat resul,2
newLine
_fin:

MOV EAX, 4C00h
INT 21h

END START
