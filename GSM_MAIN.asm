
_control_luz:

;GSM_MAIN.c,25 :: 		void control_luz(unsigned char valor_luz){
;GSM_MAIN.c,27 :: 		rb5_bit = valor_luz;
	BTFSC      FARG_control_luz_valor_luz+0, 0
	GOTO       L__control_luz28
	BCF        RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L__control_luz29
L__control_luz28:
	BSF        RB5_bit+0, BitPos(RB5_bit+0)
L__control_luz29:
;GSM_MAIN.c,29 :: 		}
L_end_control_luz:
	RETURN
; end of _control_luz

_control_alarma:

;GSM_MAIN.c,30 :: 		void control_alarma(unsigned char valor_alarma){
;GSM_MAIN.c,32 :: 		rb4_bit = valor_alarma;
	BTFSC      FARG_control_alarma_valor_alarma+0, 0
	GOTO       L__control_alarma31
	BCF        RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L__control_alarma32
L__control_alarma31:
	BSF        RB4_bit+0, BitPos(RB4_bit+0)
L__control_alarma32:
;GSM_MAIN.c,33 :: 		}
L_end_control_alarma:
	RETURN
; end of _control_alarma

_buscar_prefijo:

;GSM_MAIN.c,35 :: 		unsigned char buscar_prefijo (unsigned char *buffer ,unsigned char caracter){
;GSM_MAIN.c,37 :: 		unsigned char contador_de_letras = 0;
	CLRF       buscar_prefijo_contador_de_letras_L0+0
;GSM_MAIN.c,39 :: 		while (buffer[contador_de_letras+1] != caracter){
L_buscar_prefijo0:
	MOVF       buscar_prefijo_contador_de_letras_L0+0, 0
	ADDLW      1
	MOVWF      R0+0
	CLRF       R0+1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       R0+0, 0
	ADDWF      FARG_buscar_prefijo_buffer+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORWF      FARG_buscar_prefijo_caracter+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_buscar_prefijo1
;GSM_MAIN.c,40 :: 		contador_de_letras ++;
	INCF       buscar_prefijo_contador_de_letras_L0+0, 1
;GSM_MAIN.c,41 :: 		}
	GOTO       L_buscar_prefijo0
L_buscar_prefijo1:
;GSM_MAIN.c,42 :: 		return contador_de_letras;
	MOVF       buscar_prefijo_contador_de_letras_L0+0, 0
	MOVWF      R0+0
;GSM_MAIN.c,44 :: 		}
L_end_buscar_prefijo:
	RETURN
; end of _buscar_prefijo

_setup_28a:

;GSM_MAIN.c,47 :: 		void setup_28a(void){
;GSM_MAIN.c,49 :: 		CMcon =0x07;             // puertoa como entrada salida digital.... apago los comparadores;
	MOVLW      7
	MOVWF      CMCON+0
;GSM_MAIN.c,50 :: 		TRISB =0b00000010;
	MOVLW      2
	MOVWF      TRISB+0
;GSM_MAIN.c,51 :: 		TRISA =0b00000000;
	CLRF       TRISA+0
;GSM_MAIN.c,52 :: 		PORTA =0X00;
	CLRF       PORTA+0
;GSM_MAIN.c,53 :: 		PORTB = 0X00;
	CLRF       PORTB+0
;GSM_MAIN.c,56 :: 		uart1_init(9600);
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;GSM_MAIN.c,57 :: 		GIE_BIT =1;  // HABILITO LAS INTERRUPCIONES GLOBALES
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;GSM_MAIN.c,58 :: 		PEIE_BIT =1;  // HABILITO LAS INTERRUPCIONES DE LOS PERIFERICOS
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;GSM_MAIN.c,59 :: 		RCIE_BIT =1;    // HABILITO LA INTERRUPCION DE "LLEGO UN DATO"
	BSF        RCIE_bit+0, BitPos(RCIE_bit+0)
;GSM_MAIN.c,66 :: 		}
L_end_setup_28a:
	RETURN
; end of _setup_28a

_asignar_flags:

;GSM_MAIN.c,67 :: 		void asignar_flags (unsigned char dato){
;GSM_MAIN.c,68 :: 		if (contador_de_caracteres == 0 && dato == '@')flag_inicio = 1;
	MOVF       _contador_de_caracteres+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_asignar_flags4
	MOVF       FARG_asignar_flags_dato+0, 0
	XORLW      64
	BTFSS      STATUS+0, 2
	GOTO       L_asignar_flags4
L__asignar_flags25:
	MOVLW      1
	MOVWF      _flag_inicio+0
L_asignar_flags4:
;GSM_MAIN.c,69 :: 		if (contador_de_caracteres >=3 && dato == '*'){flag_fin =1; flag_inicio = 0;}
	MOVLW      3
	SUBWF      _contador_de_caracteres+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_asignar_flags7
	MOVF       FARG_asignar_flags_dato+0, 0
	XORLW      42
	BTFSS      STATUS+0, 2
	GOTO       L_asignar_flags7
L__asignar_flags24:
	MOVLW      1
	MOVWF      _flag_fin+0
	CLRF       _flag_inicio+0
L_asignar_flags7:
;GSM_MAIN.c,72 :: 		}
L_end_asignar_flags:
	RETURN
; end of _asignar_flags

_convertir_string_a_numero:

;GSM_MAIN.c,73 :: 		unsigned char convertir_string_a_numero (unsigned char caracter){
;GSM_MAIN.c,75 :: 		if (caracter == 49)return 1;
	MOVF       FARG_convertir_string_a_numero_caracter+0, 0
	XORLW      49
	BTFSS      STATUS+0, 2
	GOTO       L_convertir_string_a_numero8
	MOVLW      1
	MOVWF      R0+0
	GOTO       L_end_convertir_string_a_numero
L_convertir_string_a_numero8:
;GSM_MAIN.c,76 :: 		if (caracter == 48) return 0;
	MOVF       FARG_convertir_string_a_numero_caracter+0, 0
	XORLW      48
	BTFSS      STATUS+0, 2
	GOTO       L_convertir_string_a_numero9
	CLRF       R0+0
	GOTO       L_end_convertir_string_a_numero
L_convertir_string_a_numero9:
;GSM_MAIN.c,77 :: 		}
L_end_convertir_string_a_numero:
	RETURN
; end of _convertir_string_a_numero

_cargar_buffer:

;GSM_MAIN.c,79 :: 		void cargar_buffer (unsigned char dato){
;GSM_MAIN.c,81 :: 		if ( contador_de_caracteres < lengt_buffer && flag_inicio == 1 ){
	MOVLW      20
	SUBWF      _contador_de_caracteres+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_cargar_buffer12
	MOVF       _flag_inicio+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_cargar_buffer12
L__cargar_buffer26:
;GSM_MAIN.c,83 :: 		RCIF_BIT = 0;
	BCF        RCIF_bit+0, BitPos(RCIF_bit+0)
;GSM_MAIN.c,84 :: 		buffer_uart[contador_de_caracteres] = dato ;
	MOVF       _contador_de_caracteres+0, 0
	ADDLW      _buffer_uart+0
	MOVWF      FSR
	MOVF       FARG_cargar_buffer_dato+0, 0
	MOVWF      INDF+0
;GSM_MAIN.c,85 :: 		contador_de_caracteres ++;
	INCF       _contador_de_caracteres+0, 1
;GSM_MAIN.c,89 :: 		}
L_cargar_buffer12:
;GSM_MAIN.c,91 :: 		}
L_end_cargar_buffer:
	RETURN
; end of _cargar_buffer

_mapear_caracteres:

;GSM_MAIN.c,93 :: 		unsigned char  mapear_caracteres (unsigned char valor, unsigned char *indice){
;GSM_MAIN.c,95 :: 		for (i = 0 ; i < sizeof (puntero_comando); i++){
	CLRF       _i+0
L_mapear_caracteres13:
	MOVLW      2
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_mapear_caracteres14
;GSM_MAIN.c,97 :: 		for (x=0 ; x <valor ; x++){
	CLRF       _x+0
L_mapear_caracteres16:
	MOVF       FARG_mapear_caracteres_valor+0, 0
	SUBWF      _x+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_mapear_caracteres17
;GSM_MAIN.c,98 :: 		puntero_aux = puntero_comando[i][x];
	MOVF       _i+0, 0
	ADDLW      _puntero_comando+0
	MOVWF      R2+0
	MOVF       R2+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       _x+0, 0
	ADDWF      R0+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      _puntero_aux+0
;GSM_MAIN.c,99 :: 		puntero_aux_2 = indice[x+1];
	MOVF       _x+0, 0
	ADDLW      1
	MOVWF      R0+0
	CLRF       R0+1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       R0+0, 0
	ADDWF      FARG_mapear_caracteres_indice+0, 0
	MOVWF      R3+0
	MOVF       R3+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      _puntero_aux_2+0
;GSM_MAIN.c,100 :: 		if (puntero_comando[i][x] == indice[x+1]){
	MOVF       R2+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       _x+0, 0
	ADDWF      R0+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R1+0
	MOVF       R3+0, 0
	MOVWF      FSR
	MOVF       R1+0, 0
	XORWF      INDF+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_mapear_caracteres19
;GSM_MAIN.c,101 :: 		cont2++;
	INCF       _cont2+0, 1
;GSM_MAIN.c,102 :: 		if (cont2== valor){
	MOVF       _cont2+0, 0
	XORWF      FARG_mapear_caracteres_valor+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_mapear_caracteres20
;GSM_MAIN.c,103 :: 		cont2=0;
	CLRF       _cont2+0
;GSM_MAIN.c,104 :: 		parametro = indice[valor +2];
	MOVLW      2
	ADDWF      FARG_mapear_caracteres_valor+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       R0+0, 0
	ADDWF      FARG_mapear_caracteres_indice+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _parametro+0
;GSM_MAIN.c,105 :: 		parametro = convertir_string_a_numero(parametro);
	MOVF       R0+0, 0
	MOVWF      FARG_convertir_string_a_numero_caracter+0
	CALL       _convertir_string_a_numero+0
	MOVF       R0+0, 0
	MOVWF      FLOC__mapear_caracteres+0
	MOVF       FLOC__mapear_caracteres+0, 0
	MOVWF      _parametro+0
;GSM_MAIN.c,106 :: 		ptr_funcion[i](parametro);
	MOVLW      3
	MOVWF      R0+0
	MOVF       _i+0, 0
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVF       R0+0, 0
	ADDLW      _ptr_funcion+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	INCF       FSR, 1
	MOVF       INDF+0, 0
	MOVWF      R0+1
	INCF       FSR, 1
	MOVF       INDF+0, 0
	MOVWF      R0+2
	INCF       FSR, 1
	MOVF       INDF+0, 0
	MOVF       R0+2, 0
	MOVWF      FSR
	MOVF       FLOC__mapear_caracteres+0, 0
	MOVWF      INDF+0
	INCF       FSR, 1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoIFC+0
;GSM_MAIN.c,107 :: 		memset (buffer_uart,'0',lengt_buffer);
	MOVLW      _buffer_uart+0
	MOVWF      FARG_memset_p1+0
	MOVLW      48
	MOVWF      FARG_memset_character+0
	MOVLW      20
	MOVWF      FARG_memset_n+0
	MOVLW      0
	MOVWF      FARG_memset_n+1
	CALL       _memset+0
;GSM_MAIN.c,108 :: 		flag_fin = 0;
	CLRF       _flag_fin+0
;GSM_MAIN.c,109 :: 		return 1;
	MOVLW      1
	MOVWF      R0+0
	GOTO       L_end_mapear_caracteres
;GSM_MAIN.c,110 :: 		}
L_mapear_caracteres20:
;GSM_MAIN.c,111 :: 		}
L_mapear_caracteres19:
;GSM_MAIN.c,97 :: 		for (x=0 ; x <valor ; x++){
	INCF       _x+0, 1
;GSM_MAIN.c,112 :: 		}
	GOTO       L_mapear_caracteres16
L_mapear_caracteres17:
;GSM_MAIN.c,95 :: 		for (i = 0 ; i < sizeof (puntero_comando); i++){
	INCF       _i+0, 1
;GSM_MAIN.c,113 :: 		}
	GOTO       L_mapear_caracteres13
L_mapear_caracteres14:
;GSM_MAIN.c,115 :: 		return 0;
	CLRF       R0+0
;GSM_MAIN.c,116 :: 		}
L_end_mapear_caracteres:
	RETURN
; end of _mapear_caracteres

_leer_buffer:

;GSM_MAIN.c,117 :: 		unsigned char leer_buffer () {
;GSM_MAIN.c,119 :: 		if (flag_fin ) {
	MOVF       _flag_fin+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_leer_buffer21
;GSM_MAIN.c,120 :: 		RCIF_BIT = 0;
	BCF        RCIF_bit+0, BitPos(RCIF_bit+0)
;GSM_MAIN.c,121 :: 		contador_de_caracteres = 0;
	CLRF       _contador_de_caracteres+0
;GSM_MAIN.c,122 :: 		indice = memchr (buffer_uart,'@',lengt_buffer);
	MOVLW      _buffer_uart+0
	MOVWF      FARG_memchr_p+0
	MOVLW      64
	MOVWF      FARG_memchr_n+0
	MOVLW      20
	MOVWF      FARG_memchr_v+0
	MOVLW      0
	MOVWF      FARG_memchr_v+1
	CALL       _memchr+0
	MOVF       R0+0, 0
	MOVWF      _indice+0
;GSM_MAIN.c,123 :: 		valor = buscar_prefijo (indice,'_');
	MOVF       R0+0, 0
	MOVWF      FARG_buscar_prefijo_buffer+0
	MOVLW      95
	MOVWF      FARG_buscar_prefijo_caracter+0
	CALL       _buscar_prefijo+0
	MOVF       R0+0, 0
	MOVWF      _valor+0
;GSM_MAIN.c,125 :: 		if (mapear_caracteres (valor,indice)== 1)
	MOVF       R0+0, 0
	MOVWF      FARG_mapear_caracteres_valor+0
	MOVF       _indice+0, 0
	MOVWF      FARG_mapear_caracteres_indice+0
	CALL       _mapear_caracteres+0
	MOVF       R0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_leer_buffer22
;GSM_MAIN.c,127 :: 		uart1_write_text(buffer_uart);
	MOVLW      _buffer_uart+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;GSM_MAIN.c,128 :: 		}
	GOTO       L_leer_buffer23
L_leer_buffer22:
;GSM_MAIN.c,129 :: 		else {return 0;}
	CLRF       R0+0
	GOTO       L_end_leer_buffer
L_leer_buffer23:
;GSM_MAIN.c,132 :: 		}
L_leer_buffer21:
;GSM_MAIN.c,134 :: 		}
L_end_leer_buffer:
	RETURN
; end of _leer_buffer

_main:

;GSM_MAIN.c,136 :: 		void main() {
;GSM_MAIN.c,137 :: 		setup_28a();
	CALL       _setup_28a+0
;GSM_MAIN.c,148 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;GSM_MAIN.c,151 :: 		void interrupt (){
;GSM_MAIN.c,155 :: 		dato =  uart1_read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _dato+0
;GSM_MAIN.c,157 :: 		asignar_flags(dato);
	MOVF       R0+0, 0
	MOVWF      FARG_asignar_flags_dato+0
	CALL       _asignar_flags+0
;GSM_MAIN.c,158 :: 		cargar_buffer(dato);
	MOVF       _dato+0, 0
	MOVWF      FARG_cargar_buffer_dato+0
	CALL       _cargar_buffer+0
;GSM_MAIN.c,159 :: 		leer_buffer();
	CALL       _leer_buffer+0
;GSM_MAIN.c,178 :: 		}
L_end_interrupt:
L__interrupt42:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt
