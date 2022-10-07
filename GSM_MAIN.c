#define lengt_buffer 20
unsigned char buffer_uart [lengt_buffer];
unsigned char contador_de_caracteres;
unsigned char indice;
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


void oscilar_led (unsigned char dato ){

           rb5_bit = dato;



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

     if (RCIF_BIT ==1 && contador_de_caracteres < lengt_buffer){

        RCIF_BIT = 0;
        buffer_uart[contador_de_caracteres] = uart1_read();
        contador_de_caracteres ++;

        
     }
     else {
          RCIF_BIT = 0;
          contador_de_caracteres = 0;
          indice = memchr (buffer_uart,'y',lengt_buffer);
          delay_ms(100);
          uart1_write_text(indice);
          memset (buffer_uart,'x',lengt_buffer);

     }
}