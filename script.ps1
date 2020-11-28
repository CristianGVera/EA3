flex EA3.l
bison -dyv EA3.y
gcc lex.yy.c y.tab.c -o EA3
./EA3 test.txt
dot.exe -Tpng arbol.dot -o intermedia.png
Remove-Item lex.yy.c
Remove-Item y.output
Remove-Item y.tab.c
Remove-Item y.tab.h