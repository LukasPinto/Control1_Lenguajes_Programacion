/* Libro pagina 13*/
%{
//#include "calc_token.tab.h"
#include "dfa_token.tab.h"
//extern int yylval;
//#define YYSTYPE char *
#include <string.h>
#include <stdlib.h>
%}

%option noyywrap  


%%
"alfabeto" { yylval.sval = strdup(yytext);return ALFABETO;}
"tran" { yylval.sval = strdup(yytext);return TRAN ;}
"(" { return AP; }
(\,*[A-Za-z]+)+ { yylval.sval = strdup(yytext); return CONT_ALF; }
(,*\([A-Za-z]+[0-9]*\,[A-Za-z]+\,[A-Za-z]+[0-9]*\))+ { yylval.sval = strdup(yytext);return CONT_TRAN; }
")" { return CP; }
\n	{ return FINLINEA; }
[ \t]   { /*ignoramos en este caso*/ } 
. 	{ printf("OTRO CARACTER %s \n", *yytext); }
%%
/*main(int argc, char **argv) {
  int tok;
  while(tok = yylex()) {
    printf("%d", tok);
    if(tok == NUMERO)
      printf(" = %d\n", yylval); 
    else
      printf("\n");
  }
}*/
// ((a,b))
//"," { return COMA; }
