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
unsigned char resultado_comparacion ;
unsigned char *puntero_aux;
unsigned char *puntero_aux_2;
unsigned char parametro ;
unsigned char cont2=0;


void setup_28a(void);



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
     if (contador_de_caracteres == 0 && dato == '@')flag_inicio = 1;
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
                              puntero_aux = puntero_comando[i][x];
                              puntero_aux_2 = indice[x+1];
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



/*
void (*puntero_funcion)(unsigned char);
puntero_funcion = oscilar_led;
setup_28a();
puntero_funcion(1);
*/

  }


void interrupt (){



      dato =  uart1_read();

      asignar_flags(dato);
      cargar_buffer(dato);
      leer_buffer();


          //delay_ms(100);
          //uart1_write_text(indice);
          //memset (buffer_uart,'x',lengt_buffer);
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
     

