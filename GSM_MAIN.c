
////////////////////////////////
/*

Definicion de Variables Globales y macros

---------Macros-------------------
lengt_buffer : Esta macro se encarga de dar el tamño fijo a un buffer que almacenara caracteres que seran recibidos del puerto serie (UART)

--------Variables-----------------

buffer_uart : Este Array es el encargado de funcionar como buffer para el almacenamiento de caracteres que van a ser recibidos del puerto serie
es del tipo "char" y tiene asociado un tamaño que viene dado por la macro lengt_buffer

contador_de_caracteres: Esta Variable se utiliza como indice de carga en el buffer_uart donde se almacenan los caracteres recibidos del puerto serie

*indice : este puntero se utiliza para almacenar la posicion de memoria del caracter de inicio "@" que se extrae por medio de la funcion "memchr"

valor : Esta variable se encarga de almacenar la cantidad de caracteres que existen entre el "@" y el caracter "_" para este caso tenemos
        dos comandos @luz_1* @luz_0* y @alarma_1* , @alarma_0* . valor para el caso del comando "luz" me va retornar el valor "3"
        y para el caso del comando "alarma" me va retornar el valor "6"

dato :  Esta variable se encarga de recibir los caracteres uno a uno por medio de la funcion UART1_READ() que sera llamada por medio de la
        interrupcion del puerto serie

Flag_inicio : Esta variable cambia su estado de 0 a 1 cuando se detecta el caracter "@"

Flag_fin : Esta variable cambia su estado de 0 a 1 cuando detecta el caracter "*"

i,x : son indices de iteradores para recorrer el buffer y el array de punteros a funciones

comando_1 y comando_2 : Son las cadenas que se esperan recibir desde el puerto serie para poder luego mapearlas y ejecutar
                         la funcion correspondiente asociada a cada comando en el array de punteros a funcion

*puntero_comando[2] = {comando_1,comando_2} : array que almacena la posicion inicial cada comando (comando_1,comando_2) ,
                      puntero_comando[0][0] es igual a "l" que corresponde al vector del comando_1 que contiene "luz"
                      puntero_comando [1][0] es igual  a "a" que corresponde al vector del comando_2 que contiene "alarma"

parametro : se encarga de extraer el valor que le sigue al caracter "_" que es el luego se pasara a una funcion
            ejemplo : se recibe por el puerto serie "@alarma_1*" parametro va tomar el valor despues del "_" que puede ser 1 o 0

cont_2: Se encarga de contabilizar los valores recibidos como comandos por el puerto serie y matchearlos con los comandos que estan almacenados
        en memoria si cont_2 es igual a la cantidad de caracteres de alguno de los comandos se ejecutara una funcion asociada al mismo
        

*/

#define lengt_buffer 10
unsigned char buffer_uart [lengt_buffer];
unsigned char contador_de_caracteres;
unsigned char *indice;
unsigned char valor ;
unsigned char dato;
unsigned char flag_inicio = 0;
unsigned char flag_fin = 0;
unsigned char i =0;
unsigned char x = 0;
unsigned char comando_1 [] = {"luz"};
unsigned char comando_2 [] = {"alarma"};
unsigned char *puntero_comando[2] = {comando_1,comando_2};
unsigned char parametro ;
unsigned char cont2=0;


//unsigned char resultado_comparacion ;
//unsigned char *puntero_aux;
//unsigned char *puntero_aux_2;



/////////////////////////////////////////////////////////////////////////////////
void control_luz(unsigned char valor_luz){

         rb5_bit = valor_luz;

}
void control_alarma(unsigned char valor_alarma){

         rb4_bit = valor_alarma;
}
/////////////////////////////////////////////////////////////////////////////////
unsigned char buscar_prefijo (unsigned char *buffer ,unsigned char caracter){

/*
Proposito : Esta funcion esta encargada de recibir un puntero a cadena y buscar dentro de esa cadena el caracter pasado por parametro.
            cuando lo encuentra me va retornar el valor de un contador que se incrementa mientras busca de forma secuencial ese caracter.
            
            ejemplo :  "@YAMIL_1" esta funcion me va retornar el valor "5"
            
Precondicion: ninguna

parametros:
            *buffer : Puede ser un puntero a cadena o una cadena
            caracter : caracter a buscar dentro del buffer

Return : valor entero entre 0 y 255 correspondiente a la posicion donde se encuentre el caracter dentro del buffer
*/


unsigned char contador_de_letras = 0;

              while (buffer[contador_de_letras+1] != caracter){
                    contador_de_letras ++;
              }
     return contador_de_letras;

}

/////////////////////////////////////////////////////////////////////////////////
void setup_28a(void){
         uart1_init(9600);
         CMcon =0x07;             // puertoa como entrada salida digital.... apago los comparadores;
         TRISB =0b00000010;
         TRISA =0b00000000;
         PORTA =0X00;
         PORTB = 0X00;

         GIE_BIT =1;  // HABILITO LAS INTERRUPCIONES GLOBALES
         PEIE_BIT =1;  // HABILITO LAS INTERRUPCIONES DE LOS PERIFERICOS
         RCIE_BIT =1;    // HABILITO LA INTERRUPCION DE "LLEGO UN DATO"
         rb5_bit = eeprom_read (0);
         rb4_bit = eeprom_read(1);
         //TXIE_BIT =1;
         //TXEN_BIT =1;
         //TMR1IE_bit=0;            // deshabilito interrupcion del timer1



}
/////////////////////////////////////////////////////////////////////////////////
void asignar_flags (unsigned char dato){
/*
proposito: Esta funcion se encarga de triggerear el inicio y fin de almacenamiento de caracteres en el buffer .
           Como lo hace ?
                --- imagine que le llegan al puerto serie los siguientes caracteres ---
                    "123455abcd@yamil1234*"
           Como vera hay 2 caracteres especiales el arroba "@" y el asterisco "*"
           _El caracter arroba "@" es el que se encarga de buscar esta funcion asignar flag en primera instancia , porque ?
           para poder iniciar el almacenamiento de los caracteres que si nos importan que son los que estan a partir del caractere
           arroba, de lo contrario tendriamos que almacenar todo lo que nos llegue y deberiamos tener un buffer muy grande.
           _El caracter asterisco "*" esta funcion se encarga de asociarlo como caracter de finalizacion de almacenamiento , adicionalmente
           cuando se encuentra el caracter asterisco tambien se reinicia el flag_inicio que para poder reiniciar el ciclo de almacenamiento
           nuevamente

precondicion: Esta funcion debe estar ubicada dentro de la funcion de sistema  interrupt() y tener  el micro con los bits GIE Y PIE habilitados

parametros : dato puede tomar valores como "@" y  "*" pero pueden ser modificados de acuerdo a la necesidad inherente a la aplicacion
           
*/

     if (contador_de_caracteres == 0 && dato == '@'){flag_inicio = 1; uart1_write(dato); }
     if (contador_de_caracteres >=3 && dato == '*'){flag_fin =1; flag_inicio = 0;}


}
/////////////////////////////////////////////////////////////////////////////////
unsigned char convertir_string_a_numero (unsigned char caracter){

/*
Proposito: convertir caracter a valor entero,  esta funcion esta diseñada para recibir como parametro dos tipos de valores {0,1}
           que corresponden a activar o desactivar una salida del puerto b

precondicion: La funcion esta asociada a la funcion mapear caracteres , asi que debe estar ok esa funcion para poder ejecutar esta

parametros : "0", "1"

return : valores del tipo char 0 y 1
*/
    if (caracter == 49)return 1;
    if (caracter == 48) return 0;
}
/////////////////////////////////////////////////////////////////////////////////
void cargar_buffer (unsigned char dato){

/*
  Proposito : Esta funcion se ejecuta previo a la de asignacion de flags cuando detecta el caracter de inicio .
              Cada vez que llega un nuevo caracter se encarga de verificar que el contador de caracteres no exceda el del tamaño del buffer
              y lo va almacenando en el buffer e incrementando el contador de caracteres

  precondicion : Se tiene que ejecutar primero la funcion asignar flag
  
  parametros : ninguno
  
  Return : ninguno
*/

       if ( contador_de_caracteres < lengt_buffer && flag_inicio == 1 ){

        RCIF_BIT = 0;
        buffer_uart[contador_de_caracteres] = dato ;
        contador_de_caracteres ++;




     }

}
/////////////////////////////////////////////////////////////////////////////////
/*
vector de puntero a funciones que contiene las funciones que controlan los puertos
*/
void (*ptr_funcion[2])(unsigned char )={control_luz,control_alarma};

/////////////////////////////////////////////////////////////////////////////////

unsigned char  mapear_caracteres (unsigned char valor, unsigned char *indice){

/*
  Proposito : Esta funcion se encarga de recibir un parametro valor el cual es un valor numerico que indica cuantas letras tiene que matchear
              entre el valor del buffer y el valor de alguno de los comandos almacenados en el microcontrolado
              Ejemplo :
                             buffer_uart = "@alarma_1*"
                             comando_1 = "luz"
                             comando_2 = "alarma"
                             valor = 6
              Como valor es 6 que corresponde a las 6 letras {"alarma"} dentro del buffer_uart , esta funcion va matchear con el comando_2
              una vez que matchea , ejecuta la funcion asociada a dicho comando despues limpia el buffer y limpia el flag_fin

*/

      for (i = 0 ; i < sizeof (puntero_comando); i++){

                     for (x=0 ; x <valor ; x++){
                              //puntero_aux = puntero_comando[i][x];
                              //puntero_aux_2 = indice[x+1];
                           if (puntero_comando[i][x] == indice[x+1]){
                                 cont2++;
                               if (cont2== valor){
                                  cont2=0;
                                  parametro = indice[valor +2];
                                  parametro = convertir_string_a_numero(parametro);
                                  eeprom_write(i,parametro);
                                  ptr_funcion[i](parametro);
                                  memset (buffer_uart,'0',lengt_buffer);
                                  flag_fin = 0;
                                  return 1;
                                }
                           }
                     }
          }

             return 0;
}
unsigned char leer_buffer () {

/*
  Proposito: Esta funcion se encarga de segmentar el buffer a partir del caracter de inicio "@" y luego de forma escalonada se van a ejecutar
  las funciones buscar_prefijo y mapear caracteres que son las encargadas de realizar la validacion y posterior ejecucion de los comandos
  asociados a la cadena recibida en el buffer
  
  Precondicion: El buffer se tiene q haber llenado y el flag de fin tiene que estar en 1, esta funcion tiene que estar dentro de la funcion interrupt() de sistema
  
  Parametros: Ninguno
  
  Return : Ninguno
*/
      
      if (flag_fin ) {
          RCIF_BIT = 0;
          contador_de_caracteres = 0;
          indice = memchr (buffer_uart,'@',lengt_buffer);
          valor = buscar_prefijo (indice,'_');

          if (mapear_caracteres (valor,indice)== 1)
          {
           uart1_write_text(buffer_uart);
          }
          else {return 0;}
      
      
      }

}

void main() {
setup_28a();

  }


void interrupt (){

      dato =  uart1_read();
      
      asignar_flags(dato);
      cargar_buffer(dato);
      leer_buffer();
     }