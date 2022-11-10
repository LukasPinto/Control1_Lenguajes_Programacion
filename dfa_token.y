
%{
#include <cstdio>
#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <sstream>
#include <iterator>
#include <cstring>
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
//vector<string> estado = {"Q2", "normal"};
vector <string> alfabeto; 
vector <string> estado;
//vector<vector<string>> estados = {{"Q1", "inicial"}, {"Q2", "normal"},  {"Q3", "terminal"}};
vector <vector<string>> estados;
//array de transiciones
//vector<string> transicion = {"Q1", "a", "Q2"};
vector <string> transicion;
//vector<vector<string>> transiciones = {{"Q1", "a", "Q2"}, {"Q2", "b", "Q3"}, {"Q3", "a", "Q3"}};
vector<vector<string>> transiciones; 
//estado actual 
vector<string> estado_actual; 
string cadena;
void iniciar_automata(){
    for(size_t i=0; i< estados.size(); i++){
        if(estados[i][1] == "inicial"){
            estado_actual.clear();
            estado_actual = estados[i];
            cout <<  estado_actual[0] << endl;
            return ;
        }
    }
    cout << "no se ha definido un estado inicial "<<endl;
}



//testear caracter por caracter el automata
bool leer_cadena(string cadena){
    for(size_t i=0; i< transiciones.size(); i++){
        cout<<"sdfadfsadf"<<endl;
        cout << estado_actual[0]<<" "<<transiciones[i][0]<<" "<<cadena<<" "<<transiciones[i][1]<<endl; 
        if(estado_actual[0] == transiciones[i][0] && cadena == transiciones[i][1]){
            //buscar el estado de llegada 
            for(size_t j=0; j< estados.size(); j++){
                if(transiciones[i][2] == estados[j][0]){
                    estado_actual.clear();
                    estado_actual = estados[j];
                    return 1 /*el caracter pertenece*/;
                }
            }
        }
    }

    return 0 /*el caracter no pertenece*/;
}

string es_terminal(vector <string> estado_actual){
    if(estado_actual[estado_actual.size()-1]=="terminal"){
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


void limpiar_transiciones(string cadena){

  string aux;
  string aux2;
  string token;
  string delim = "),(";
  vector <string> trans;
  vector <string> result;

  // se parsean las transiciones para almacernarlas en el vector
  size_t pos = 0;
  while (( pos = cadena.find (delim)) != string::npos)  
  {  
    token = cadena.substr(0, pos); // store the substring   
    aux = token;
    aux.erase(remove(aux.begin(), aux.end(), ')'), aux.end());

    aux.erase(remove(aux.begin(), aux.end(), '('), aux.end());
    trans.push_back(aux);
    cadena.erase(0, pos + delim.length());  /* erase() function store the current positon and move to next token. */   
  }
  cadena.erase(remove(cadena.begin(), cadena.end(), ')'), cadena.end());
  cadena.erase(remove(cadena.begin(), cadena.end(), '('), cadena.end());
  trans.push_back(cadena);

  for(size_t i=0;i <trans.size();i++){
    aux = trans.at(i);

    stringstream ss(aux);
    while (getline(ss,token,',')){
      aux2=token;
        result.push_back(aux2);
        }
    transiciones.push_back(result);
    result.clear();
     
  }
  // una vez limpiados los valores se anaden al vector que almacena las transiciones
  for ( size_t i = 0;i < transiciones.size();i++){
      cout << transiciones[i][0]<<" "<<transiciones[i][1]<<" "<<transiciones[i][2]<<endl;
  }

}

void limpiar_estados(string cadena){
  vector<string> estado;
  string aux;
  string token;
  stringstream ss(cadena);
  while (getline(ss,token,',')){
    estado.push_back(token);
    estado.push_back("normal");
    estados.push_back(estado);
    estado.clear();
  }
  for (size_t i =0; i < estados.size();i++){
  
    cout <<estados[i][0] << ","<<estados[i][1]<< endl;
  } 
}

//funcion para asignar un estado a final
string asignar_terminal(string estado){
    
    if(verificar_estado(estado)){
      for (size_t i =0; i<estados.size();i++){
        if(estados[i][0] == estado){
          if(estados[i][1] == "inicial"){
            estados[i].push_back("terminal");
            return "Se seteo"+ estados[i][0]+ " a "+estados[i][2];
          }
          estados[i][1] = "terminal";
          return "Se seteo "+estados[i][0]+" a "+estados[i][1];
        }
      }
    }
    return "Error al setear el estado, no existe";

}

//Se limpiar el antiguo estados inicial y se asigna al nuevo
string asignar_incial(string estado){
    //Se eliminan el anterior estado incial y se deja como normal
    if(verificar_estado(estado)){
      for (size_t i =0; i<estados.size();i++){
        if(estados[i][1] == "inicial"){
          estados[i][1] = "normal";
        }
      }
      for (size_t i=0; i<estados.size(); i++){
        if(estados[i][0] == estado){
          estados[i][1] = "inicial";
          return "Se seteo "+estados[i][0]+" a "+estados[i][1];
        }
      }
    }
    return "Error al setear el estado, no existe";

}


vector<string> asignar_alfabeto(string cadena){
  cout << cadena << endl;
  vector<string> alf_auxiliar;
  string aux;
  string token;
  stringstream ss(cadena);
  while (getline(ss,token,',')){
    alf_auxiliar.push_back(token);
  }
  return alf_auxiliar;

  
}

void mostrar_transicion(){
  if(transiciones.size()){
    cout <<"Los valores de las transiciones son: "<<endl;
    for( size_t i = 0 ; i<transiciones.size();i++){
      cout <<"("<< transiciones[i][0] << ","<< transiciones[i][1]<<","<<transiciones[i][2]<<")"<<endl;
    }
  }
  else {
  
  cout << "No existen transiciones" << endl;

  }

}

void mostrar_estado_actual(){
  //modificar esto si se modifica lo del estado inicial y final a la vez
  cout<<"\nEl valor del estado actual es : "<<endl;
  cout << "(";
  for ( size_t i = 0 ;i < estado_actual.size();i++){
    if(estado_actual.size()-1 == i){
      cout << estado_actual[i]<<")"<<endl;
    }
    else{
      cout << estado_actual[i]<<",";
    }
  }
  
}
void mostrar_estados(){
  if(estados.size()){
    cout << "El conjunto de estados son : " << endl;
    for ( size_t i =0 ; i < estados.size() ; i++){
      cout << "(";
      for (size_t j =0 ;j < estados[i].size();j++){
        if (estados[i].size()-1 == j){
          cout << estados[i][j];
        }
        else{
          cout << estados[i][j]<<",";
        }
      }
      cout<<")"<<endl;
    }
  }
  else{
    cout << "No se han definido estados." << endl;
  }

}

void mostrar_alfabeto(){
  if(alfabeto.size()){
    cout << "El alfabeto es : "<<endl;
    for (size_t i =0 ; i < alfabeto.size();i++){
      if (i==alfabeto.size()-1){
        cout << alfabeto[i]<<endl;
      }
      else{
        cout << alfabeto[i]<<",";

      }
          }
  }
  else{
  cout << "El alfabeto está vacío "<<endl;
  }
  

}

void mostrar_todo(){
  mostrar_alfabeto();
  mostrar_estados();
  mostrar_transicion();
  mostrar_estado_actual();
}
%} 

%union {

    char *sval;
    int intval;
}
/* declaramos los tokens */
//%token NUMERO
//%token SUMA RESTA MULTIPLICA DIVIDE ABS
%token AP CP FINLINEA COMA INICIAL IGUAL FINAL ESTADOS MOSTRAR_TRAN MOSTRAR_ACT MOSTRAR_EST MOSTRAR_ALF
%token <sval> ALFABETO
%token <sval> LEER
%token <sval> CONT_TRAN
%token <sval> CONT_INPUT
%token <sval> TRAN
%%

input   : /* empty string */
        | input linea
        ;

linea   : FINLINEA
        | func FINLINEA
        ;

func    : ALFABETO AP content_alf
        | TRAN AP content
        | INICIAL AP nodo_inicial
        | FINAL AP nodo_final
        | LEER AP content
        | ESTADOS AP estado
        | MOSTRAR_TRAN AP mostrar_tran
        | MOSTRAR_ACT AP mostrar_act
        | MOSTRAR_EST AP mostrar_est
        | MOSTRAR_ALF AP mostrar_alf
        ;

mostrar_alf : CP { mostrar_alfabeto();}
mostrar_est : CP { mostrar_estados();}

mostrar_tran  : CP { mostrar_transicion(); }
              ;
mostrar_act : CP { mostrar_estado_actual();}
            ;

nodo_final  : CONT_INPUT  { cadena = $1;cout << "estado final  : " << asignar_terminal(cadena)<<endl;}
            | nodo_final CP
            ;
nodo_inicial : CONT_INPUT { cadena =$1;cout << "estado incial : " <<asignar_incial(cadena) << endl;iniciar_automata();}
             | nodo_inicial CP
             ;

estado  : CONT_INPUT { cout << "el contenido ess: " << $1<<endl;cadena = $1;limpiar_estados(cadena);}
            | estado CP
            ;
content_alf : CONT_INPUT { cadena = $1;alfabeto = asignar_alfabeto(cadena);}
            | content_alf CP
            ;

content : CONT_TRAN { cout << "el contenido es: "<<$1<<endl;cadena = $1;limpiar_transiciones(cadena);}
        | CONT_INPUT { cadena = $1;iniciar_automata();
        string aux;
        for (size_t i = 0;i<cadena.length();i++){
          aux = cadena[i];
          if(leer_cadena(aux)){
            cout << "el caracter "<< aux <<" pertenece al lenguaje" << endl;
          }else{
            cout << "el caracter "<< aux <<" no pertenece al lenguaje, la cadena no pertenece al lenguaje" << endl;
            estado_actual = {"Q0","normal"};
            break;
          }
        }
        cout << es_terminal(estado_actual) << endl; 
        iniciar_automata();
}
        | content CP
        ;

%%

main(int argc, char **argv){
  printf("\nIngresa una funcion\n");
  yyin = stdin;
  yyparse();
  cout << aux<<endl;
}
/* 
inputs de ej:
  estados{q1,q2,q3}
  inicial{q1}
  final{q3}
  tran{(q1,a,q2),(q2,b,q3),(q3,a,q3)}
  leer{abaa}
*/

