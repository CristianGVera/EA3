%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"

    void informarError(char *);

    FILE *yyin;
    char *yyltext;
    char lexema[100];

%}

%option noyywrap
%option yylineno

RES_WRITE               "WRITE"
RES_COLA                "cola"
RES_READ                "READ"
RES_ASIG                "="
RES_PARA                "("
RES_PARC                ")"
RES_CORA                "["
RES_CORC                "]"
RES_COMA                ","
RES_PYC                 ";"
RES_COM                 "\""
RES_DOSP                ":"

ARROBA                  "@"
ESP                     " "
NUMERAL                 "#"
PREGUNTA_ABRE           "¿"
PREGUNTA_CIERRA         "?"
ADMIRACION_ABRE         "¡"
ADMIRACION_CIERRA       "!"
OP_COCIENTE             "/"
OP_MULT                 "*"
OP_SUMA                 "+"
OP_RESTA                "-"
OP_PORCENTAJE           "%"

DIGITO [0-9]
LETRA [a-zA-ZáéíóúñÁÉÍÓÚÑ]

CTE                     {DIGITO}+
CTE_S                   {RES_COM}({ESP}*|{LETRA}*|{DIGITO}*|{RES_DOSP}*|{RES_ASIG}*|{RES_PARA}*|{RES_PARC}*|{RES_CORA}*|{RES_CORC}*|{RES_COMA}*|{RES_PYC}*|{ARROBA}*|{NUMERAL}*|{PREGUNTA_ABRE}*|{PREGUNTA_CIERRA}*|{ADMIRACION_ABRE}*|{ADMIRACION_CIERRA}*|{OP_COCIENTE}*|{OP_MULT}*|{OP_SUMA}*|{OP_RESTA}*|{OP_PORCENTAJE}*)*{RES_COM}
ID                      {LETRA}+({LETRA}*|{DIGITO}*)*

%%

{RES_WRITE}             {return RES_WRITE;};
{RES_COLA}              {return RES_COLA;};
{RES_READ}              {return RES_READ;};
{RES_ASIG}              {return RES_ASIG;};
{RES_PARA}              {return RES_PARA;};
{RES_PARC}              {return RES_PARC;};
{RES_CORA}              {return RES_CORA;};
{RES_CORC}              {return RES_CORC;};
{RES_COMA}              {return RES_COMA;};
{RES_PYC}               {return RES_PYC;};
{CTE}                   {
                          yylval.int_val=strtol(yytext,(char **)NULL,10);
                          return CTE;
                        };
{ID}                    {
                          sprintf(lexema,"%s", yytext);
                          if(strlen(yytext) > 100) {
                              informarError(yytext);
                          }
                              
                          yylval.str_val=lexema;
                          return ID;
                        };
{CTE_S}                 {
                          yylval.str_val=yytext;
                          return CTE_S;
                        };

{ESP}
"\n"
"\t"
"\n\t"
"\r\n"

%%

void informarError(char *error) {
  printf("Mensaje de error: %s\n", error);
  system ("Pause");
  exit(2);
}
