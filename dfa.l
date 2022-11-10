
/* Libro pagina 13*/
%{
//#include "calc_token.tab.h"
#include "dfa_token.tab.h"
//extern int yylval;
//#define YYSTYPE char *

%}

%option noyywrap  


%%
"inicial" { return INICIAL;}
"final" { return FINAL;}
"leer" { return LEER;}
"estados" { return ESTADOS;}
\= { return IGUAL;}
"alfabeto" { yylval.sval = strdup(yytext);return ALFABETO;}
"tran" { yylval.sval = strdup(yytext);return TRAN ;}
"{" { return AP; }
([A-Za-z0-9]+) { yylval.sval = strdup(yytext);return CONT_INPUT;}
([A-Za-z]+[0-9]*) { yylval.sval = strdup(yytext);return ESTADO;}
(\,*[A-Za-z]+)+ { yylval.sval = strdup(yytext); return CONT_ALF; }
(,*\([A-Za-z]+[0-9]*\,[A-Za-z]+\,[A-Za-z]+[0-9]*\))+ { yylval.sval = strdup(yytext);return CONT_TRAN; }
(,*[A-Za-z0-9]+)+ { yylval.sval = strdup(yytext);return CONT_ESTADOS;}
"}" { return CP; }
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

