#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
using namespace std;

//arrays de estados
vector<string> estado = {"Q2", "normal"};
vector<vector<string>> estados = {{"Q1", "inicial","terminal"}, {"Q2", "normal",},  {"Q3", "terminal"}};

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
//funcion para asignar un estado a final
string asignar_terminal(string estado){
    
    if(verificar_estado(estado)){
      for (size_t i =0; i<estados.size();i++){
        if(estados[i][0] == estado){
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

int main(int argc, char const *argv[])
{
    string cadena = "";
    string aux; 
    iniciar_automata();
    //cout << asignar_terminal("Q2") << endl;
    
    //cout << asignar_incial("Q2") << endl;
    //iniciar_automata(); //recordar utilizar el iniciar_automata() para setear de nuevo el estado inicial
    for(size_t i=0; i < cadena.length(); i++){
        aux = cadena[i];
        if(leer_cadena(aux)){
            cout << "el caracter el pertenece al lenguaje" << endl;
        }else{
            cout << "el caracter no pertenece al lenguaje, la cadena no pertenece al lenguaje" << endl;
            estado_actual = estado;
            break;
        }
    }
    
    cout << es_terminal(estado_actual) << endl; 

    return 0;
}
