#line 1 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
#line 49 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
unsigned char buffer_uart [ 21 ];
unsigned char contador_de_caracteres;
unsigned char *indice;
unsigned char *indice_rtc;
unsigned char valor ;
unsigned char dato;
unsigned char flag_inicio = 0;
unsigned char flag_fin = 0;
unsigned char i =0;
unsigned char x = 0;
unsigned char comando_1 [] = {"luz"};
unsigned char comando_2 [] = {"alarma"};
unsigned char *puntero_comando[3] = {comando_1,comando_2};
unsigned char parametro ;
unsigned char cont2=0;


unsigned int conversion = 0;
unsigned char buffer_conversion_2[2];
unsigned char contador_timer=0;
unsigned char buffer_conversion[2];
unsigned int conversion_2 [2] ;

unsigned int conversion_10 =9;
unsigned int conversion_20 =10;
unsigned int *almacen[2]= {&conversion_10,&conversion_20};









void control_luz(unsigned char valor_luz){

 rb5_bit = valor_luz;

}
void control_alarma(unsigned char valor_alarma){

 rb4_bit = valor_alarma;

}

unsigned char buscar_prefijo (unsigned char *buffer ,unsigned char caracter){
#line 113 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
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
#line 171 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
 if (contador_de_caracteres == 0 && (dato == '@' || dato == ',')){flag_inicio = 1; flag_fin =0; }
 if (contador_de_caracteres >=3 && (dato == '*' || dato == '-') ){flag_fin =1; flag_inicio = 0; }


}

unsigned char convertir_string_a_numero (unsigned char caracter){
#line 189 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
 if (caracter == 49)return 1;
 if (caracter == 48) return 0;
}

void cargar_buffer (unsigned char dato){
#line 207 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
 if ( contador_de_caracteres <  21  && flag_inicio == 1 ){

 RCIF_BIT = 0;
 buffer_uart[contador_de_caracteres] = dato ;
 contador_de_caracteres ++;




 }

}
#line 223 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
void (*ptr_funcion[2])(unsigned char )={control_luz,control_alarma};



unsigned char mapear_caracteres (unsigned char valor, unsigned char *indice){
#line 242 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
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
 memset (buffer_uart,'0', 21 );
 flag_fin = 0;
 return 1;
 }
 }
 }
 }

 return 0;
}

unsigned char verificar_hora_actual_con_eeprom (unsigned char inicio){

unsigned char contador_2 = 0;
 for (i = 0 ; i<2 ; i++){

 if (*almacen[i] == eeprom_read(inicio + i)) {
 delay_ms(50);
 contador_2++;

 }
 if (contador_2 == 2){return 1;}

 }

 return 0;

}
void validar_hora (unsigned char *buffer){

unsigned char conversion_array [5] ={"xxxx"};
unsigned char aux_conversion[3];
unsigned char i =0;
unsigned char contador =0;





 for (i =1 ; i <6 ; i++){

 if (isdigit(buffer[i])){
 conversion_array[contador]=buffer[i];
 contador++;




 }
 }
 aux_conversion[0] = conversion_array[0];
 aux_conversion[1] = conversion_array [1];
 conversion_20 = atoi (&conversion_array[2]);
 conversion_10 = atoi (aux_conversion);

 if (verificar_hora_actual_con_eeprom(0) ==1 ){rb5_bit = 1 ; memset (buffer_uart,'0', 21 ); }
 if (verificar_hora_actual_con_eeprom(2) ==1 ){rb5_bit = 0 ; memset (buffer_uart,'0', 21 ); }

}

void guardar_datos_en_eeprom(unsigned char *indice){
unsigned char i;
unsigned char cont_buff=0;
unsigned char cont_eeprom =0;


 for (i=1 ; i < 13 ; i++) {
 if (isdigit(indice [i]) && cont_buff <2 ){
 buffer_conversion[cont_buff]=indice[i];
 cont_buff++;
 }
 if (cont_buff ==2){
 conversion = atoi(buffer_conversion);
 eeprom_write(cont_eeprom,conversion);
 delay_ms(30);
 memset(buffer_conversion,'0',2);
 cont_eeprom ++;
 cont_buff =0;
 }
 if (cont_eeprom == 4){
 cont_eeprom =10;

 }
 }
 memset (buffer_uart,'0', 21 );
 flag_fin = 0;


}

void buscar_comandos (){



 indice = memchr (buffer_uart,':', 21 );
 if (indice != 0){
 guardar_datos_en_eeprom(indice);
 }
 else {
 valor = buscar_prefijo (buffer_uart,'_');
 mapear_caracteres (valor,buffer_uart);
 }



}
unsigned char leer_buffer () {
#line 375 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
 if (flag_fin ) {
 RCIF_BIT = 0;
 contador_de_caracteres = 0;

 if (buffer_uart[0]== ','){ validar_hora(buffer_uart); flag_fin =0;}

 else{ buscar_comandos();}
 }

}

void main() {

 setup_28a();

 }

void interrupt (){

 if (uart1_data_ready()){
 dato = uart1_read();
 asignar_flags(dato);
 cargar_buffer(dato);
 leer_buffer();

 }

 if (tmr1if_bit){
 tmr1if_bit =0;
 TMR1H = 0x00;
 TMR1L = 0x00;
 contador_timer++;
 tmr1on_bit =1;
 if (contador_timer == 3){
 contador_timer =0;
 rb6_bit ^=1;
 uart1_write_text ("AT+CCLK?\r\n");



 }



 }
 }
