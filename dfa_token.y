
%{
#include <cstdio>
#include <iostream>
#include <string>
//#include "dfa_token.tab.h"
//#define YYSTYPE char * no colocar el define yyystype por que abajo en %union lo estoy definiendo
//#define YYSTYPE char *
using namespace std;
extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char *s){
  fprintf(stderr, "Cadena no reconocida: %s\n", s);

}
string aux="";
%} 

%union {

    char *sval;
    int intval;
}
/* declaramos los tokens */
//%token NUMERO
//%token SUMA RESTA MULTIPLICA DIVIDE ABS
%token AP CP FINLINEA COMA INICIAL IGUAL FINAL 
%token <sval> CONT_ALF
%token <sval> ALFABETO
%token <sval> CONT_TRAN
%token <sval> TRAN
%token <sval> ESTADO
%%

input   : /* empty string */
        | input linea
        ;

linea   : FINLINEA
        | func FINLINEA
        ;

func    : ALFABETO AP content
        | TRAN AP content
        | INICIAL AP nodo
        | FINAL AP nodo
        ;

nodo    : ESTADO  { cout << "el contenido es : " << $1 <<endl;return 0;}
        | nodo CP
        ;

content : CONT_ALF { cout << "el contenido es: "<<$1<<endl;aux=$1; return 0;}
        | CONT_TRAN { cout << "el contenido es: "<<$1<<endl;return 0;}
        | content CP
        ;

%%

main(int argc, char **argv){
  printf("\nIngresa una funcion\n");
  yyin = stdin;
  yyparse();
  cout << aux<<endl;
}


