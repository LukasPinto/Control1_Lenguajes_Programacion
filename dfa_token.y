
%{
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdlib.h>
#include <string.h>
//#include "dfa_token.tab.h"
//#define YYSTYPE char * no colocar el define yyystype por que abajo en %union lo estoy definiendo
//#define YYSTYPE char *
extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char *s){
  fprintf(stderr, "Cadena no reconocida: %s\n", s);

}
%} 

%union {
    char *sval;
    int intval;
}
/* declaramos los tokens */
//%token NUMERO
//%token SUMA RESTA MULTIPLICA DIVIDE ABS
%token AP CP FINLINEA COMA 
%token <sval> CONT_ALF
%token <sval> ALFABETO
%token <sval> CONT_TRAN
%token <sval> TRAN
%%

input   : /* empty string */
        | input linea
        ;

linea   : FINLINEA
        | func FINLINEA
        ;

func    : ALFABETO AP content
        | TRAN AP content
        ;

content : CONT_ALF { printf("el contenido es : %s\n",$1); }
        | CONT_TRAN { printf("el contenido es : %s\n",$1); }
        | content CP
        ;

%%

main(int argc, char **argv){
  printf("\nIngresa una funcion\n");
  while (true){
    yyin = stdin;
    yyparse();
  }
}

