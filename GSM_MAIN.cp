#line 1 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
#line 49 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
unsigned char buffer_uart [ 20 ];
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
unsigned char comando_3 [] = {"time"};
unsigned char *puntero_comando[3] = {comando_1,comando_2,comando_3};
unsigned char parametro ;
unsigned char cont2=0;


unsigned int conversion = 0;
unsigned char buffer_conversion[2];









void control_luz(unsigned char valor_luz){

 rb5_bit = valor_luz;

}
void control_alarma(unsigned char valor_alarma){

 rb4_bit = valor_alarma;

}

unsigned char buscar_prefijo (unsigned char *buffer ,unsigned char caracter){
#line 106 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
unsigned char contador_de_letras = 0;

 while (buffer[contador_de_letras+1] != caracter){
 contador_de_letras ++;
 }
 return contador_de_letras;

}


void setup_28a(void){
 uart1_init(9600);
 CMcon =0x07;
 TRISB =0b00000010;
 TRISA =0b00000000;
 PORTA =0X00;
 PORTB = 0X00;

 GIE_BIT =1;
 PEIE_BIT =1;
 RCIE_BIT =1;

 PIR1.TMR1IF = 0;
 TMR1H = 0x00;
 TMR1L = 0x00;
 T1CON.TMR1CS = 0;
 T1CON.T1CKPS0 = 1;
 T1CON.T1CKPS1 = 1;
 PIE1.TMR1IE = 1 ;
 T1CON.TMR1ON = 1 ;






}

void asignar_flags (unsigned char dato){
#line 164 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
 if (contador_de_caracteres == 0 && dato == '@'){flag_inicio = 1; uart1_write(dato); }
 if (contador_de_caracteres >=3 && dato == '*'){flag_fin =1; flag_inicio = 0;}


}

unsigned char convertir_string_a_numero (unsigned char caracter){
#line 182 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
 if (caracter == 49)return 1;
 if (caracter == 48) return 0;
}

void cargar_buffer (unsigned char dato){
#line 200 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
 if ( contador_de_caracteres <  20  && flag_inicio == 1 ){

 RCIF_BIT = 0;
 buffer_uart[contador_de_caracteres] = dato ;
 contador_de_caracteres ++;




 }

}
#line 216 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
void (*ptr_funcion[2])(unsigned char )={control_luz,control_alarma};



unsigned char mapear_caracteres (unsigned char valor, unsigned char *indice){
#line 235 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
 for (i = 0 ; i < sizeof (puntero_comando); i++){

 for (x=0 ; x <valor ; x++){


 if (puntero_comando[i][x] == indice[x+1]){
 cont2++;
 if (cont2== valor){
 cont2=0;
 parametro = indice[valor +2];
 parametro = convertir_string_a_numero(parametro);
 eeprom_write(i,parametro);
 ptr_funcion[i](parametro);
 memset (buffer_uart,'0', 20 );
 flag_fin = 0;
 return 1;
 }
 }
 }
 }

 return 0;
}
unsigned char leer_buffer () {
#line 272 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
unsigned char i;
unsigned char cont_buff=0;
unsigned char cont_eeprom =10;
 if (flag_fin ) {
 RCIF_BIT = 0;
 contador_de_caracteres = 0;


 indice = memchr (buffer_uart,':', 20 );
 if (indice != 0){

 for (i=1 ; i < 12 ; i++) {
 if (isdigit(indice [i]) && cont_buff <2 ){
 buffer_conversion[cont_buff]=indice[i];
 cont_buff++;
 }
 if (cont_buff ==2){
 conversion = atoi(buffer_conversion);
 eeprom_write(cont_eeprom,conversion);
 delay_ms(50);
 memset(buffer_conversion,'0',2);
 cont_eeprom ++;
 cont_buff =0;
 }
 if (cont_eeprom == 14){
 cont_eeprom =10;

 }
 }
 memset (buffer_uart,'0', 20 );
 flag_fin = 0;
 }
 else {
 valor = buscar_prefijo (buffer_uart,'_');
 mapear_caracteres (valor,buffer_uart);
 }


 }

}

void main() {
 setup_28a();

 }

void interrupt (){

 dato = uart1_read();
 asignar_flags(dato);
 cargar_buffer(dato);
 leer_buffer();

 if (tmr1if_bit){


 rb7_bit ^=1;
 TMR1H = 0x00;
 TMR1L = 0x00;

 tmr1on_bit =0;
 delay_ms(500);
 uart1_write (eeprom_read(10));

 tmr1on_bit =1;
 tmr1if_bit =0;


 }
 }
