
%{
#include <cstdio>
#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
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


//arrays de estados
vector<string> estado = {"Q2", "normal"};
vector<vector<string>> estados = {{"Q1", "inicial"}, {"Q2", "normal"},  {"Q3", "terminal"}};

//array de transiciones
vector<string> transicion = {"Q1", "a", "Q2"}; 
vector<vector<string>> transiciones = {{"Q1", "a", "Q2"}, {"Q2", "b", "Q3"}, {"Q3", "a", "Q3"}};

//estado actual 
vector<string> estado_actual; 

void iniciar_automata(){
    for(size_t i=0; i< estados.size(); i++){
        if(estados[i][1] == "inicial"){
            estado_actual = estados[i];
            cout <<  estado_actual[0] << endl; 
        }
    }
}



//testear caracter por caracter el automata
bool leer_cadena(string cadena){
    for(size_t i=0; i< transiciones.size(); i++){
        if(estado_actual[0] == transiciones[i][0] && cadena == transiciones[i][1]){
            //buscar el estado de llegada 
            for(int j=0; i< estados.size(); j++){
                if(transiciones[i][2] == estados[j][0]){
                    estado_actual = estados[j];
                    return 1 /*el caracter pertenece*/;
                }
            }
        }
    }

    return 0 /*el caracter no pertenece*/;
}

string es_terminal(vector <string> estado_actual){
    if(estado_actual[1]=="terminal"){
        return "el ultimo estado es terminal";
    }
    return "el ultimo estado no es terminal";
}

//verificar si existe el estado 
//devuelve true si el estado existe 
bool verificar_estado(string estado){
    for(size_t i=0; i< estados.size(); i++){
        if(count(estados[i].begin(), estados[i].end(), estado)){
            return true; 
        }
    }
    return false; 
}

string agregar_transicion(vector<string> transicion){

    //validar que los estado existen. 
    if(verificar_estado(transicion[0])){
        if(verificar_estado(transicion[2])){
            transiciones.push_back(transicion);
            return "la transición fue agregada con existo";
        }
    }


    return "uno de los estados de la transición no existe";
    
}

string agregar_estado(vector<string> estado){
    vector<string> tipos = {"inicial", "termianl", "normal"};
    //probamos si el tipo es correcto
    int tipo_correcto;
    for (size_t i = 0; i < tipos.size(); i++){
        if (estado[1] == tipos[i])
        {
            tipo_correcto = 1; 
        }
    }
    if(tipo_correcto != 1){
        return "error al ingresar el tipo de estado";
    }

    //revisamos si el estado es inicial y si existe un estado inicial ahora mismo 
    if(estado[1] == "inicial"){
        for(size_t i=0; i< estados.size(); i++){
            if(estados[i][1] == "inicial"){
                return "ya existe un estado inicial"; 
            }
        }
    }

    estados.push_back(estado);
    return "funcionó";
}


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
%token <sval> LEER
%token <sval> CONT_TRAN
%token <sval> CONT_INPUT
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
        | LEER AP content
        ;

nodo    : ESTADO  { cout << "el contenido es : " << $1 <<endl;}
        | nodo CP
        ;

content : CONT_ALF { cout << "el contenido es: "<<$1<<endl;aux=$1;}
        | CONT_TRAN { cout << "el contenido es: "<<$1<<endl;}
        | CONT_INPUT { cout << "el contenido es: " << $1<<endl;}
        | content CP
        ;

%%

main(int argc, char **argv){
  printf("\nIngresa una funcion\n");
  yyin = stdin;
  yyparse();
  cout << aux<<endl;
}


