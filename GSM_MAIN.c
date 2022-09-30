void setup_28a(void){

         CMcon =0x07;             // puertoa como entrada salida digital.... apago los comparadores;
         TRISB =0b00000000;
         TRISA =0b00000000;
         PORTA =0X00;
         PORTB = 0X00;


         //uart1_init(9600);
         //GIE_BIT =1;  // HABILITO LAS INTERRUPCIONES GLOBALES
         //PEIE_BIT =1;  // HABILITO LAS INTERRUPCIONES DE LOS PERIFERICOS
         //RCIE_BIT =1;    // HABILITO LA INTERRUPCION DE "LLEGO UN DATO"
         //TXIE_BIT =1;
         //TXEN_BIT =1;
         //TMR1IE_bit=0;            // deshabilito interrupcion del timer1



}


void main() {

}