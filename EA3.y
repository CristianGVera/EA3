%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

int n = 0;
int yystopparser=0;
FILE  *yyin;
int yyerror();
int yylex();

typedef struct {
    char nombre[100]; // Nombre del token
    char tipo[14];  // Tipo de Dato
    int  tipoDato; // Manejo interno del tipo tipo[14]
    int flag;  // Para saber si el token fue almacenado o no en la TS
    char valor[100];
} tsimbolo;

typedef struct
{
    char valor[100];
    int nro;
    int nroNodo;
}t_info;

typedef struct s_nodo
{
    t_info info;
    struct s_nodo *izq;
    struct s_nodo *der;
}t_nodo;

char tipo[11][14]={"","ENTERO","CTE ENTERA","REAL","CTE REAL","STRING","CTE STRING","ID","CONST ENTERA","CONST REAL","CONST STRING"};
tsimbolo simbolo[100];

t_nodo *s;
t_nodo *prog;
t_nodo *sent;
t_nodo *read;
t_nodo *write;
t_nodo *asig;
t_nodo *cola;
int nroNodo = 0;
char ultimoId [100];
int esListaVacia = 0;

void insertarHijo(t_nodo ** , t_nodo * );
t_nodo * crearHojaT(const char*);
t_nodo * crearNodo(const t_info *, t_nodo *, t_nodo *);
t_nodo * crearHoja(const t_info *);

/*Generar archivo ts.txt*/
void crearArchivoTS(void);
int cargarEnTS(char*,int);

/*Generar archivo arbol.dot*/
void generarArchivoGraphViz(t_nodo*);
void enumerarNodos(t_nodo*);
void recorrerGenerandoViz(const t_nodo*, FILE*);

/*Generar archivo EA3.asm*/
void generarAssembler(t_nodo*);
int contarAux(t_nodo*);
void cargarDATA(FILE*, t_nodo *);
char * tipoDatoASM(int);
void generarCodigo (FILE*, t_nodo*);
void recorrerGenerandoCodigo(t_nodo*, FILE*);
void escribirAssembler(t_nodo*, t_nodo *, t_nodo *, FILE*);
int esHoja(t_nodo*);
int obtenerIndiceTSPorValor(char*);
int obtenerTipoDatoPorID(char*);
void recorrer_en_orden(const t_nodo*);

/*Generar archivo intermedia.txt*/
void grabarArbol(t_nodo*);
void recorrer_guardando(const t_nodo*, FILE*);

%}

%union {
    int int_val;
    double float_val;
    char *str_val;
}

%type <str_val> ID CTE_S
%type <int_val> CTE

%token RES_DIM
%token RES_WRITE
%token RES_COLA
%token RES_READ
%token RES_ASIG
%token RES_PARA
%token RES_PARC
%token RES_CORA
%token RES_CORC
%token RES_COMA
%token RES_PYC
%token ID
%token CTE
%token CTE_S

%%

s: prog {
            s=prog;
            crearArchivoTS();
            grabarArbol(s);
            generarArchivoGraphViz(s);
            generarAssembler(s);
        };
prog: sent  {
                prog = sent;
            };
prog: prog sent{
                    t_info info;
                    strcpy(info.valor,"sentencia");
                    prog=crearNodo(&info,prog,sent);
                };
sent: read  {
                sent = read;
            }|
    write   {
                sent = write;
            }|
    asig{
            sent = asig;
        };
read: RES_READ ID   {
                        printf("RES_READ %s\n", $2);
                        cargarEnTS($2, 1); 
                        read=crearHojaT("READ");
                        insertarHijo(&read->izq,crearHojaT("stdin"));
                        insertarHijo(&read->der,crearHojaT($2));
                    };
asig:   ID  {
                strcpy(ultimoId, $1);
                cargarEnTS($1, 1); 
            }
        RES_ASIG cola  {
                            if(esListaVacia == 0)
                            {
                                t_info info;
                                strcpy(info.valor,"=");
                                t_info info_id;
                                strcpy(info_id.valor,ultimoId);
                                asig= crearNodo(&info,crearHoja(&info_id),cola);
                            }	
                            else
                            {
                                asig=crearHojaT("WRITE");
                                insertarHijo(&asig->izq,crearHojaT("stdout"));
                                insertarHijo(&asig->der,crearHojaT("\"La lista está vacía.\""));
                                esListaVacia = 0;
                            }
                        };
cola: RES_COLA RES_PARA ID RES_PYC RES_CORA lista RES_CORC RES_PARC {
                                                                        printf("RES_COLA RES_PARA ID RES_PYC RES_CORA lista RES_CORC RES_PARC\n");
                                                                    };
cola: RES_COLA RES_PARA ID RES_PYC RES_CORA RES_CORC RES_PARC   {
                                                                    printf("RES_COLA RES_PARA ID RES_PYC RES_CORA RES_CORC RES_PARC\n");
                                                                    esListaVacia = 1;
                                                                };
lista: CTE  {
                char valorString[100];
                sprintf(valorString, "%d", $1);
                cargarEnTS(valorString, 2);
            };
lista: lista RES_COMA CTE   {
                                char valorString[100];
                                sprintf(valorString, "%d", $3);
                                cargarEnTS(valorString, 2);
                            };
write: RES_WRITE CTE_S  {
                            printf("RES_WRITE %s\n", $2);
                            cargarEnTS($2, 6); 
                            write=crearHojaT("WRITE");
                            insertarHijo(&write->izq,crearHojaT("stdout"));
                            insertarHijo(&write->der,crearHojaT($2));
                        };
write: RES_WRITE ID {
                        printf("RES_WRITE %s\n", $2);
                        cargarEnTS($2, 1); 
                        write=crearHojaT("WRITE");
                        insertarHijo(&write->izq,crearHojaT("stdout"));
                        insertarHijo(&write->der,crearHojaT($2));
                    };

%%

int main(int argc, char *argv[])
{
    if((yyin = fopen(argv[1], "rt"))==NULL)
    {
        printf("\nNo se puede abrir el archivo de prueba: %s\n", argv[1]);
    }
    else
    { 
        yyparse();
    }
	fclose(yyin);

    return 0;
}

int yyerror(void)
{
    printf("\nError Sintactico\n");
	exit(1);
}

t_nodo * crearHojaT(const char* info)
{
    t_nodo *p = (t_nodo*) malloc(sizeof(t_nodo));
    if(!p){ 
        printf("No hay memoria disponible. El programa se cerrará\n");
        exit(1);
    }
    strcpy(p->info.valor,info);
    p->der=p->izq=NULL;
    return p;
}

void insertarHijo (t_nodo ** puntero, t_nodo * hijo){
    *puntero=hijo;
}

t_nodo * crearNodo(const t_info *d, t_nodo * hijo_izq, t_nodo * hijo_der)
{
    t_nodo *p = (t_nodo*) malloc(sizeof(t_nodo));
    if(!p){ 
        printf("No hay memoria disponible. El programa se cerrará\n");
        exit(1);
    }
    p->info=*d;
    p->izq= hijo_izq;
    p->der= hijo_der;
    return p;
}

t_nodo * crearHoja(const t_info *d)
{
    t_nodo *p = (t_nodo*) malloc(sizeof(t_nodo));
    if(!p){ 
        printf("No hay memoria disponible. El programa se cerrará\n");
        exit(1);
    }
    p->info=*d;
    p->der=p->izq=NULL;
    return p;
}

/*Generar archivo arbol.dot*/
void generarArchivoGraphViz(t_nodo *raiz){
    nroNodo=0;
    enumerarNodos(raiz);
    FILE*pf=fopen("arbol.dot","w+");
    if(!pf){
        printf("Error al generar el archivo para GraphViz\n");
        return;
    }
    fprintf(pf, "graph g{\n");
    recorrerGenerandoViz(raiz,pf);
    fprintf(pf, "}\n");
    fclose(pf);
}

void enumerarNodos(t_nodo *n){
    if(n){
        n->info.nroNodo=nroNodo;
        nroNodo++;
        enumerarNodos(n->izq);
        enumerarNodos(n->der);
    }
}

void recorrerGenerandoViz(const t_nodo* nodo, FILE* pf)
{
    if(nodo)
    {
        if(nodo->izq!=NULL&&nodo->der!=NULL){
            fprintf(pf,"\t%d[label=<%s>]\n", nodo->info.nroNodo,nodo->info.valor);
            fprintf(pf,"\t%d[label=<%s>]\n", nodo->izq->info.nroNodo,nodo->izq->info.valor);
            fprintf(pf,"\t%d[label=<%s>]\n", nodo->der->info.nroNodo,nodo->der->info.valor);
            if(nodo->izq)
                fprintf(pf,"\t%d--%d\n", nodo->info.nroNodo,nodo->izq->info.nroNodo);
            if(nodo->der)
                fprintf(pf,"\t%d--%d\n", nodo->info.nroNodo,nodo->der->info.nroNodo);
        }
        recorrerGenerandoViz(nodo->izq,pf);
        recorrerGenerandoViz(nodo->der,pf);
    }
}

/*Generar archivo ts.txt*/
void crearArchivoTS(void) {
	FILE *fp;
	int x, i;
	fp = fopen ( "ts.txt", "w+" );
	if (fp == NULL) {
		fputs ("File error",stderr); 
		exit (1);
	}
	    
    fprintf(fp, "NOMBRE %93s | TIPO %9s | VALOR %94s\n", " ", " ", " ");
    for (i=0; i<220; i++)
        fprintf(fp, "-");
    fprintf(fp, "\n");   
    
	for (x = 0; x < 100; x++)
    {
        if( simbolo[x].tipoDato != 0 )
            fprintf(fp, "%-100s | %-14s | %-100s\n", simbolo[x].nombre, simbolo[x].tipo, simbolo[x].valor);
        else
            break;
    		
	}
	fclose(fp);
	
    printf("\n\nSe ha cerrado el archivo y la Tabla de Simbolos fue cargada sin errores.\n");
        
 }

int cargarEnTS ( char *nombre, int val ){
    int x;
	int l_repetido=0;
    char nombreConGuion[strlen(nombre)+1];    

    for (x=0; x<100; x++ ){
        if (simbolo[x].flag==1){//para saber si el token ya esta en la tabla
            if (strcmp (nombre,simbolo[x].nombre)==0){
                if( simbolo[x].valor == 0 ){
                    printf("ERROR! Variable duplicada");
                    exit(0);
                }

                return x;
                
            }else{
                strcpy(nombreConGuion, "_");   
                strcat(nombreConGuion, nombre);
                if (strcmp (nombreConGuion,simbolo[x].nombre)==0){
                    return x;
                }
            }
        }
    }
        
    for (x=0; x<100 ; x++){
        if(simbolo[x].flag==0){

            if(strstr(tipo[val],"CTE")){
                
                strcpy(nombreConGuion, "_");   
                strcat(nombreConGuion, nombre);
                strcpy(simbolo[x].nombre,nombreConGuion);
                strcpy(simbolo[x].valor,nombre);
            }else{
                strcpy(simbolo[x].nombre,nombre);
            }
            
            strcpy(simbolo[x].tipo,tipo[val]);
            simbolo[x].tipoDato=val;
            simbolo[x].flag=1;//para indicar que ya se almaceno en la tabla

            return x;
        }
    }
		
	return x;
 }//retorna posicion en la tabla de simbolos
 
 void asignarValorConstante()
 {
     int x;
     for (x=0; x<99; x++ ){
        if (simbolo[x].flag==1){//para saber si el token ya esta en la tabla
            if (simbolo[x].tipoDato==8 || simbolo[x].tipoDato==9 || simbolo[x].tipoDato==10){
                char *aux=simbolo[x-1].nombre;
                strcpy(simbolo[x].valor,++aux);//valor reconocido                
            }
        }
    }
 }

/*Generar archivo EA3.asm*/
void generarAssembler(t_nodo* arbol){
    FILE*fp=fopen("EA3.asm","w+");
    if(!fp){
        printf("Error al generar el assembler.\n");
        return;
    }

    
    fprintf(fp, "include macros.asm\n");
    fprintf(fp, "include number.asm\n\n");          
    fprintf(fp, ".MODEL LARGE\n");
    fprintf(fp, ".386\n");
    fprintf(fp, ".STACK 200h\n");
    cargarDATA(fp, arbol);
    generarCodigo(fp, arbol);
    fprintf(fp, "\n");
    fprintf(fp, "MOV EAX, 4C00h\n");
    fprintf(fp, "INT 21h\n\n");
    fprintf(fp, "END START");
    fprintf(fp, "\n");
	fclose(fp);
	
    printf("\n\nFin generacion codigo asm.\n");
}

void cargarDATA(FILE* fp, t_nodo *arbol){
    fprintf(fp, ".DATA\n\n");

    for (int x = 0; x < 100; x++)
    {
        if( simbolo[x].flag == 1 )
        {
            if(simbolo[x].tipoDato == 2)
            {
                fprintf(fp,  "@int%d \t%s %.2f\n", x, tipoDatoASM(simbolo[x].tipoDato),atof(simbolo[x].valor));
            }
            else if(simbolo[x].tipoDato == 4)
            {
                fprintf(fp,  "@float%d \t%s %.2f\n", x, tipoDatoASM(simbolo[x].tipoDato),atof(simbolo[x].valor));
            }
            else if(simbolo[x].tipoDato == 6)
            {
                fprintf(fp,  "@str%d \t%s %s, \"$\", 30 dup (?)\n", x, tipoDatoASM(simbolo[x].tipoDato),simbolo[x].valor);
            }
            else if(simbolo[x].tipoDato == 5){
                fprintf(fp,  "%s \t%s %s 30 dup (?), \"$\"\n", simbolo[x].nombre, tipoDatoASM(simbolo[x].tipoDato),simbolo[x].valor);
            }
            else if(simbolo[x].tipoDato == 8 || simbolo[x].tipoDato == 9 || simbolo[x].tipoDato == 10){
                fprintf(fp,  "%s \t%s %s\n", simbolo[x].nombre, tipoDatoASM(simbolo[x].tipoDato),simbolo[x].valor);
            }
            else{
                fprintf(fp,  "%s \t%s ?\n", simbolo[x].nombre, tipoDatoASM(simbolo[x].tipoDato));
            }
        
        }else{
            break;
        }    		
	}

    
    //DECLARACION DE AUXILIARES
    int cantAux=contarAux(arbol);
    int j;
    for(j=0;j<cantAux;j++){
         fprintf(fp,  "@aux%d\tdd ?\n",j+1);
    }
 }

char * tipoDatoASM(int tipoDato){
     if(tipoDato==5||tipoDato==6){
        return "db";
     }else{
        return "dd";
     }
 }

int contarAux(t_nodo* nodo){
    if(nodo){
        if(strcmp(nodo->info.valor,"*") == 0 || strcmp(nodo->info.valor,"-") == 0
            ||strcmp(nodo->info.valor,"+") == 0 || strcmp(nodo->info.valor,"/") == 0)
            return 1+contarAux(nodo->izq)+contarAux(nodo->der);
        else 
            return contarAux(nodo->izq)+contarAux(nodo->der);
    }
    return 0;
}

void generarCodigo (FILE* fp, t_nodo *arbol) {
    fprintf(fp, "\n.CODE\n\n");
    fprintf(fp, "START:\n");
    fprintf(fp, "MOV EAX, @DATA\n");
    fprintf(fp, "MOV DS, EAX\n");
    fprintf(fp, "MOV ES, EAX\n\n");
    //recorrer_en_orden(arbol);
    recorrerGenerandoCodigo(arbol, fp);    
}

void recorrerGenerandoCodigo(t_nodo* nodo, FILE* fp)
{
    if(nodo)
	{
        //if(esHoja(nodo)==0 && esHoja(nodo->izq) && esHoja(nodo->der))
        if(nodo->izq!=NULL&&nodo->der!=NULL)
        {            
            escribirAssembler(nodo->izq,nodo->der,nodo,fp);
        }
        recorrerGenerandoCodigo(nodo->izq,fp);
        recorrerGenerandoCodigo(nodo->der,fp);
    }
}

void recorrer_en_orden(const t_nodo* nodo)
{
    if(nodo)
    {
        printf("a\n");
        if(nodo->izq!=NULL&&nodo->der!=NULL)
            printf("%s\t%s\t%s\n", nodo->info.valor,nodo->izq->info.valor,nodo->der->info.valor);
        recorrer_en_orden(nodo->izq);
        recorrer_en_orden(nodo->der);
    }
}

int esHoja(t_nodo* nodo){
    if(nodo->izq==NULL&&nodo->der==NULL)
        return 1;
    return 0;
}

void escribirAssembler(t_nodo* op1, t_nodo *op2, t_nodo *opr, FILE* pf)
{  
    if(strcmp(opr->info.valor,"WRITE")==0)
    {
        if(obtenerTipoDatoPorID(op2->info.valor)==1)
        {
            fprintf(pf,"displayFloat %s,0\n", op2->info.valor);
            fprintf(pf, "newLine\n");
        }
        else
        {
            fprintf(pf,"displayString @str%d\n", obtenerIndiceTSPorValor(op2->info.valor));
            fprintf(pf, "newLine\n");
        }
    }

    if(strcmp(opr->info.valor,"READ")==0)
    {
        if(obtenerTipoDatoPorID(op2->info.valor)==1)
        {
            fprintf(pf,"getFloat %s,0\n", op2->info.valor);
        }
    }
}

int obtenerIndiceTSPorValor(char* nombre)
{
    int x;
    for (x=0; x<99; x++ ){
        if ( strcmp(simbolo[x].valor, nombre) == 0 && simbolo[x].flag==1)
        {
            return x;
        }
    }
    return -1;
}

int obtenerTipoDatoPorID(char *nombre)
{
    int x;
    for (x=0; x<99; x++ ){
        if ( strcmp(simbolo[x].nombre, nombre) == 0 && simbolo[x].flag==1)
        {
            return simbolo[x].tipoDato;
        }
    }
    return -1;
}

/*Generar archivo intermedia.txt*/
void grabarArbol(t_nodo* arbol)
{
    FILE*pf=fopen("intermedia.txt","w+");
    if(!pf){
        printf("Error al guardar el arbol\n");
        return;
    }
    fprintf(pf,"%-32s|\t%-32s|\t%-32s\n","PADRE","HIJO IZQ","HIJO DER");
    recorrer_guardando(arbol,pf);
    fclose(pf);
}

void recorrer_guardando(const t_nodo* nodo, FILE* pf)
{
    if(nodo)
    {
        if(nodo->izq!=NULL&&nodo->der!=NULL)
            fprintf(pf,"%-32s\t%-32s\t%-32s\n", nodo->info.valor,nodo->izq->info.valor,nodo->der->info.valor);
        recorrer_guardando(nodo->izq,pf);
        recorrer_guardando(nodo->der,pf);
    }
}
