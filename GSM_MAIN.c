
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

#define lengt_buffer 20
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






void control_luz(unsigned char valor_luz){

         rb5_bit = valor_luz;

}
void control_alarma(unsigned char valor_alarma){

         rb4_bit = valor_alarma;
}

unsigned char buscar_prefijo (unsigned char *buffer ,unsigned char caracter){

unsigned char contador_de_letras = 0;

              while (buffer[contador_de_letras+1] != caracter){
                    contador_de_letras ++;
              }
     return contador_de_letras;

}


void setup_28a(void){

         CMcon =0x07;             // puertoa como entrada salida digital.... apago los comparadores;
         TRISB =0b00000010;
         TRISA =0b00000000;
         PORTA =0X00;
         PORTB = 0X00;


          uart1_init(9600);
          GIE_BIT =1;  // HABILITO LAS INTERRUPCIONES GLOBALES
          PEIE_BIT =1;  // HABILITO LAS INTERRUPCIONES DE LOS PERIFERICOS
          RCIE_BIT =1;    // HABILITO LA INTERRUPCION DE "LLEGO UN DATO"
         //TXIE_BIT =1;
         //TXEN_BIT =1;
         //TMR1IE_bit=0;            // deshabilito interrupcion del timer1



}
void asignar_flags (unsigned char dato){
     if (contador_de_caracteres == 0 && dato == '@'){flag_inicio = 1; };
     if (contador_de_caracteres >=3 && dato == '*'){flag_fin =1; flag_inicio = 0;}


}
unsigned char convertir_string_a_numero (unsigned char caracter){

    if (caracter == 49)return 1;
    if (caracter == 48) return 0;
}

void cargar_buffer (unsigned char dato){

       if ( contador_de_caracteres < lengt_buffer && flag_inicio == 1 ){

        RCIF_BIT = 0;
        buffer_uart[contador_de_caracteres] = dato ;
        contador_de_caracteres ++;



     }

}
void (*ptr_funcion[2])(unsigned char )={control_luz,control_alarma};


unsigned char  mapear_caracteres (unsigned char valor, unsigned char *indice){

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


        /*
          for ( i= 0; i<=10 ; i++){
           eeprom_write(0x00 + i,indice[i+1]);
           delay_ms(10);

          }
          for ( i= 0; i<=10 ; i++){
           uart1_write (eeprom_read(i));
           delay_ms(100);

          }
          */

     }