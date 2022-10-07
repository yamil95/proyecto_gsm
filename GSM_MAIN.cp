#line 1 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"

unsigned char buffer_uart [ 20 ];
unsigned char contador_de_caracteres;
unsigned char indice;
unsigned char dato ;
unsigned char flag_inicio = 0;
void setup_28a(void){

 CMcon =0x07;
 TRISB =0b00000010;
 TRISA =0b00000000;
 PORTA =0X00;
 PORTB = 0X00;


 uart1_init(9600);
 GIE_BIT =1;
 PEIE_BIT =1;
 RCIE_BIT =1;






}


void oscilar_led (unsigned char dato ){

 rb5_bit = dato;



}

void main() {
setup_28a();
#line 48 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
}

void interrupt (){


 dato = uart1_read();
 if (dato == '@'){flag_inicio = 1;}
 if ( contador_de_caracteres <  20  && flag_inicio == 1 ){

 rb5_bit = 1;
 RCIF_BIT = 0;
 buffer_uart[contador_de_caracteres] = dato ;
 contador_de_caracteres ++;



 }
 if (contador_de_caracteres >=  20 ) {
 rb5_bit= 0 ;
 RCIF_BIT = 0;
 contador_de_caracteres = 0;
 indice = memchr (buffer_uart,'@', 20 );
 delay_ms(100);
 uart1_write_text(indice);
 memset (buffer_uart,'x', 20 );
 flag_inicio = 0;

 }


}
