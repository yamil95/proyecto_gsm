#line 1 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"



void setup_28a(void){

 CMcon =0x07;
 TRISB =0b00000000;
 TRISA =0b00000000;
 PORTA =0X00;
 PORTB = 0X00;
#line 23 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
}

void oscilar_led (unsigned char dato ){

 rb5_bit = dato;



}

void main() {
void (*puntero_funcion)(unsigned char);
puntero_funcion = oscilar_led;
setup_28a();
puntero_funcion(1);

}
