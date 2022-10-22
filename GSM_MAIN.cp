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
unsigned char *puntero_comando[2] = {comando_1,comando_2};
unsigned char parametro ;
unsigned char cont2=0;









void control_luz(unsigned char valor_luz){

 rb5_bit = valor_luz;

}
void control_alarma(unsigned char valor_alarma){

 rb4_bit = valor_alarma;
}

unsigned char buscar_prefijo (unsigned char *buffer ,unsigned char caracter){
#line 100 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
unsigned char contador_de_letras = 0;

 while (buffer[contador_de_letras+1] != caracter){
 contador_de_letras ++;
 }
 return contador_de_letras;

}


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

void asignar_flags (unsigned char dato){
#line 151 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
 if (contador_de_caracteres == 0 && dato == '@'){flag_inicio = 1; };
 if (contador_de_caracteres >=3 && dato == '*'){flag_fin =1; flag_inicio = 0;}


}

unsigned char convertir_string_a_numero (unsigned char caracter){
#line 169 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
 if (caracter == 49)return 1;
 if (caracter == 48) return 0;
}

void cargar_buffer (unsigned char dato){
#line 187 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
 if ( contador_de_caracteres <  20  && flag_inicio == 1 ){

 RCIF_BIT = 0;
 buffer_uart[contador_de_caracteres] = dato ;
 contador_de_caracteres ++;



 }

}
#line 202 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
void (*ptr_funcion[2])(unsigned char )={control_luz,control_alarma};



unsigned char mapear_caracteres (unsigned char valor, unsigned char *indice){
#line 221 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
 for (i = 0 ; i < sizeof (puntero_comando); i++){

 for (x=0 ; x <valor ; x++){


 if (puntero_comando[i][x] == indice[x+1]){
 cont2++;
 if (cont2== valor){
 cont2=0;
 parametro = indice[valor +2];
 parametro = convertir_string_a_numero(parametro);
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
#line 257 "C:/Users/feyam/Desktop/gsm/GSM_MAIN.c"
 if (flag_fin ) {
 RCIF_BIT = 0;
 contador_de_caracteres = 0;
 indice = memchr (buffer_uart,'@', 20 );
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

 dato = uart1_read();

 asignar_flags(dato);
 cargar_buffer(dato);
 leer_buffer();
 }
