
_control_luz:

;GSM_MAIN.c,81 :: 		void control_luz(unsigned char valor_luz){
;GSM_MAIN.c,83 :: 		rb5_bit = valor_luz;
	BTFSC      FARG_control_luz_valor_luz+0, 0
	GOTO       L__control_luz68
	BCF        RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L__control_luz69
L__control_luz68:
	BSF        RB5_bit+0, BitPos(RB5_bit+0)
L__control_luz69:
;GSM_MAIN.c,85 :: 		}
L_end_control_luz:
	RETURN
; end of _control_luz

_control_alarma:

;GSM_MAIN.c,86 :: 		void control_alarma(unsigned char valor_alarma){
;GSM_MAIN.c,88 :: 		rb4_bit = valor_alarma;
	BTFSC      FARG_control_alarma_valor_alarma+0, 0
	GOTO       L__control_alarma71
	BCF        RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L__control_alarma72
L__control_alarma71:
	BSF        RB4_bit+0, BitPos(RB4_bit+0)
L__control_alarma72:
;GSM_MAIN.c,90 :: 		}
L_end_control_alarma:
	RETURN
; end of _control_alarma

_buscar_prefijo:

;GSM_MAIN.c,92 :: 		unsigned char buscar_prefijo (unsigned char *buffer ,unsigned char caracter){
;GSM_MAIN.c,110 :: 		unsigned char contador_de_letras = 0;
	CLRF       buscar_prefijo_contador_de_letras_L0+0
;GSM_MAIN.c,112 :: 		while (buffer[contador_de_letras+1] != caracter){
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
;GSM_MAIN.c,113 :: 		contador_de_letras ++;
	INCF       buscar_prefijo_contador_de_letras_L0+0, 1
;GSM_MAIN.c,114 :: 		}
	GOTO       L_buscar_prefijo0
L_buscar_prefijo1:
;GSM_MAIN.c,115 :: 		return contador_de_letras;
	MOVF       buscar_prefijo_contador_de_letras_L0+0, 0
	MOVWF      R0+0
;GSM_MAIN.c,117 :: 		}
L_end_buscar_prefijo:
	RETURN
; end of _buscar_prefijo

_setup_28a:

;GSM_MAIN.c,120 :: 		void setup_28a(void){
;GSM_MAIN.c,121 :: 		uart1_init(9600);
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;GSM_MAIN.c,122 :: 		CMcon =0x07;             // puertoa como entrada salida digital.... apago los comparadores;
	MOVLW      7
	MOVWF      CMCON+0
;GSM_MAIN.c,123 :: 		TRISB =0b00000010;
	MOVLW      2
	MOVWF      TRISB+0
;GSM_MAIN.c,124 :: 		TRISA =0b00000000;
	CLRF       TRISA+0
;GSM_MAIN.c,125 :: 		PORTA =0X00;
	CLRF       PORTA+0
;GSM_MAIN.c,126 :: 		PORTB = 0X00;
	CLRF       PORTB+0
;GSM_MAIN.c,128 :: 		GIE_BIT =1;  // HABILITO LAS INTERRUPCIONES GLOBALES
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;GSM_MAIN.c,129 :: 		PEIE_BIT =1;  // HABILITO LAS INTERRUPCIONES DE LOS PERIFERICOS
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;GSM_MAIN.c,130 :: 		RCIE_BIT =1;    // HABILITO LA INTERRUPCION DE "LLEGO UN DATO"
	BSF        RCIE_bit+0, BitPos(RCIE_bit+0)
;GSM_MAIN.c,132 :: 		PIR1.TMR1IF = 0;
	BCF        PIR1+0, 0
;GSM_MAIN.c,133 :: 		TMR1H = 0x00;
	CLRF       TMR1H+0
;GSM_MAIN.c,134 :: 		TMR1L = 0x00;
	CLRF       TMR1L+0
;GSM_MAIN.c,135 :: 		T1CON.TMR1CS = 0;
	BCF        T1CON+0, 1
;GSM_MAIN.c,136 :: 		T1CON.T1CKPS0 = 1;
	BSF        T1CON+0, 4
;GSM_MAIN.c,137 :: 		T1CON.T1CKPS1 = 1;
	BSF        T1CON+0, 5
;GSM_MAIN.c,138 :: 		PIE1.TMR1IE = 1 ;
	BSF        PIE1+0, 0
;GSM_MAIN.c,139 :: 		T1CON.TMR1ON = 1 ;
	BSF        T1CON+0, 0
;GSM_MAIN.c,146 :: 		}
L_end_setup_28a:
	RETURN
; end of _setup_28a

_asignar_flags:

;GSM_MAIN.c,148 :: 		void asignar_flags (unsigned char dato){
;GSM_MAIN.c,168 :: 		if (contador_de_caracteres == 0 && (dato == '@' || dato == ',')){flag_inicio = 1; flag_fin =0;  }
	MOVF       _contador_de_caracteres+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_asignar_flags6
	MOVF       FARG_asignar_flags_dato+0, 0
	XORLW      64
	BTFSC      STATUS+0, 2
	GOTO       L__asignar_flags64
	MOVF       FARG_asignar_flags_dato+0, 0
	XORLW      44
	BTFSC      STATUS+0, 2
	GOTO       L__asignar_flags64
	GOTO       L_asignar_flags6
L__asignar_flags64:
L__asignar_flags63:
	MOVLW      1
	MOVWF      _flag_inicio+0
	CLRF       _flag_fin+0
L_asignar_flags6:
;GSM_MAIN.c,169 :: 		if (contador_de_caracteres >=3 && (dato == '*' || dato == '-') ){flag_fin =1; flag_inicio = 0; }
	MOVLW      3
	SUBWF      _contador_de_caracteres+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_asignar_flags11
	MOVF       FARG_asignar_flags_dato+0, 0
	XORLW      42
	BTFSC      STATUS+0, 2
	GOTO       L__asignar_flags62
	MOVF       FARG_asignar_flags_dato+0, 0
	XORLW      45
	BTFSC      STATUS+0, 2
	GOTO       L__asignar_flags62
	GOTO       L_asignar_flags11
L__asignar_flags62:
L__asignar_flags61:
	MOVLW      1
	MOVWF      _flag_fin+0
	CLRF       _flag_inicio+0
L_asignar_flags11:
;GSM_MAIN.c,172 :: 		}
L_end_asignar_flags:
	RETURN
; end of _asignar_flags

_convertir_string_a_numero:

;GSM_MAIN.c,174 :: 		unsigned char convertir_string_a_numero (unsigned char caracter){
;GSM_MAIN.c,186 :: 		if (caracter == 49)return 1;
	MOVF       FARG_convertir_string_a_numero_caracter+0, 0
	XORLW      49
	BTFSS      STATUS+0, 2
	GOTO       L_convertir_string_a_numero12
	MOVLW      1
	MOVWF      R0+0
	GOTO       L_end_convertir_string_a_numero
L_convertir_string_a_numero12:
;GSM_MAIN.c,187 :: 		if (caracter == 48) return 0;
	MOVF       FARG_convertir_string_a_numero_caracter+0, 0
	XORLW      48
	BTFSS      STATUS+0, 2
	GOTO       L_convertir_string_a_numero13
	CLRF       R0+0
	GOTO       L_end_convertir_string_a_numero
L_convertir_string_a_numero13:
;GSM_MAIN.c,188 :: 		}
L_end_convertir_string_a_numero:
	RETURN
; end of _convertir_string_a_numero

_cargar_buffer:

;GSM_MAIN.c,190 :: 		void cargar_buffer (unsigned char dato){
;GSM_MAIN.c,204 :: 		if ( contador_de_caracteres < lengt_buffer && flag_inicio == 1 ){
	MOVLW      21
	SUBWF      _contador_de_caracteres+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_cargar_buffer16
	MOVF       _flag_inicio+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_cargar_buffer16
L__cargar_buffer65:
;GSM_MAIN.c,206 :: 		RCIF_BIT = 0;
	BCF        RCIF_bit+0, BitPos(RCIF_bit+0)
;GSM_MAIN.c,207 :: 		buffer_uart[contador_de_caracteres] = dato ;
	MOVF       _contador_de_caracteres+0, 0
	ADDLW      _buffer_uart+0
	MOVWF      FSR
	MOVF       FARG_cargar_buffer_dato+0, 0
	MOVWF      INDF+0
;GSM_MAIN.c,208 :: 		contador_de_caracteres ++;
	INCF       _contador_de_caracteres+0, 1
;GSM_MAIN.c,213 :: 		}
L_cargar_buffer16:
;GSM_MAIN.c,215 :: 		}
L_end_cargar_buffer:
	RETURN
; end of _cargar_buffer

_mapear_caracteres:

;GSM_MAIN.c,224 :: 		unsigned char  mapear_caracteres (unsigned char valor, unsigned char *indice){
;GSM_MAIN.c,239 :: 		for (i = 0 ; i < sizeof (puntero_comando); i++){
	CLRF       _i+0
L_mapear_caracteres17:
	MOVLW      3
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_mapear_caracteres18
;GSM_MAIN.c,241 :: 		for (x=0 ; x <valor ; x++){
	CLRF       _x+0
L_mapear_caracteres20:
	MOVF       FARG_mapear_caracteres_valor+0, 0
	SUBWF      _x+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_mapear_caracteres21
;GSM_MAIN.c,244 :: 		if (puntero_comando[i][x] == indice[x+1]){
	MOVF       _i+0, 0
	ADDLW      _puntero_comando+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       _x+0, 0
	ADDWF      R0+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R2+0
	MOVF       _x+0, 0
	ADDLW      1
	MOVWF      R0+0
	CLRF       R0+1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       R0+0, 0
	ADDWF      FARG_mapear_caracteres_indice+0, 0
	MOVWF      FSR
	MOVF       R2+0, 0
	XORWF      INDF+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_mapear_caracteres23
;GSM_MAIN.c,245 :: 		cont2++;
	INCF       _cont2+0, 1
;GSM_MAIN.c,246 :: 		if (cont2== valor){
	MOVF       _cont2+0, 0
	XORWF      FARG_mapear_caracteres_valor+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_mapear_caracteres24
;GSM_MAIN.c,247 :: 		cont2=0;
	CLRF       _cont2+0
;GSM_MAIN.c,248 :: 		parametro = indice[valor +2];
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
;GSM_MAIN.c,249 :: 		parametro = convertir_string_a_numero(parametro);
	MOVF       R0+0, 0
	MOVWF      FARG_convertir_string_a_numero_caracter+0
	CALL       _convertir_string_a_numero+0
	MOVF       R0+0, 0
	MOVWF      _parametro+0
;GSM_MAIN.c,250 :: 		eeprom_write(i,parametro);
	MOVF       _i+0, 0
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       R0+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;GSM_MAIN.c,251 :: 		ptr_funcion[i](parametro);
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
	MOVF       _parametro+0, 0
	MOVWF      INDF+0
	INCF       FSR, 1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoIFC+0
;GSM_MAIN.c,252 :: 		memset (buffer_uart,'0',lengt_buffer);
	MOVLW      _buffer_uart+0
	MOVWF      FARG_memset_p1+0
	MOVLW      48
	MOVWF      FARG_memset_character+0
	MOVLW      21
	MOVWF      FARG_memset_n+0
	MOVLW      0
	MOVWF      FARG_memset_n+1
	CALL       _memset+0
;GSM_MAIN.c,253 :: 		flag_fin = 0;
	CLRF       _flag_fin+0
;GSM_MAIN.c,254 :: 		return 1;
	MOVLW      1
	MOVWF      R0+0
	GOTO       L_end_mapear_caracteres
;GSM_MAIN.c,255 :: 		}
L_mapear_caracteres24:
;GSM_MAIN.c,256 :: 		}
L_mapear_caracteres23:
;GSM_MAIN.c,241 :: 		for (x=0 ; x <valor ; x++){
	INCF       _x+0, 1
;GSM_MAIN.c,257 :: 		}
	GOTO       L_mapear_caracteres20
L_mapear_caracteres21:
;GSM_MAIN.c,239 :: 		for (i = 0 ; i < sizeof (puntero_comando); i++){
	INCF       _i+0, 1
;GSM_MAIN.c,258 :: 		}
	GOTO       L_mapear_caracteres17
L_mapear_caracteres18:
;GSM_MAIN.c,260 :: 		return 0;
	CLRF       R0+0
;GSM_MAIN.c,261 :: 		}
L_end_mapear_caracteres:
	RETURN
; end of _mapear_caracteres

_validar_hora:

;GSM_MAIN.c,264 :: 		void validar_hora (unsigned char *buffer){
;GSM_MAIN.c,266 :: 		unsigned char conversion_array [5] ={"xxxx"};
	MOVLW      120
	MOVWF      validar_hora_conversion_array_L0+0
	MOVLW      120
	MOVWF      validar_hora_conversion_array_L0+1
	MOVLW      120
	MOVWF      validar_hora_conversion_array_L0+2
	MOVLW      120
	MOVWF      validar_hora_conversion_array_L0+3
	CLRF       validar_hora_conversion_array_L0+4
	CLRF       validar_hora_i_L0+0
	CLRF       validar_hora_contador_L0+0
	CLRF       validar_hora_conversion_2_L0+0
	CLRF       validar_hora_conversion_2_L0+1
	CLRF       validar_hora_contador_2_L0+0
;GSM_MAIN.c,277 :: 		for   (i =1 ; i <6 ; i++){
	MOVLW      1
	MOVWF      validar_hora_i_L0+0
L_validar_hora25:
	MOVLW      6
	SUBWF      validar_hora_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_validar_hora26
;GSM_MAIN.c,279 :: 		if (isdigit(buffer[i])){
	MOVF       validar_hora_i_L0+0, 0
	ADDWF      FARG_validar_hora_buffer+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_isdigit_character+0
	CALL       _isdigit+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_validar_hora28
;GSM_MAIN.c,280 :: 		conversion_array[contador]=buffer[i];
	MOVF       validar_hora_contador_L0+0, 0
	ADDLW      validar_hora_conversion_array_L0+0
	MOVWF      R1+0
	MOVF       validar_hora_i_L0+0, 0
	ADDWF      FARG_validar_hora_buffer+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R1+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;GSM_MAIN.c,281 :: 		contador++;
	INCF       validar_hora_contador_L0+0, 1
;GSM_MAIN.c,286 :: 		}
L_validar_hora28:
;GSM_MAIN.c,277 :: 		for   (i =1 ; i <6 ; i++){
	INCF       validar_hora_i_L0+0, 1
;GSM_MAIN.c,287 :: 		}
	GOTO       L_validar_hora25
L_validar_hora26:
;GSM_MAIN.c,288 :: 		uart1_write_text(conversion_array);
	MOVLW      validar_hora_conversion_array_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;GSM_MAIN.c,289 :: 		delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_validar_hora29:
	DECFSZ     R13+0, 1
	GOTO       L_validar_hora29
	DECFSZ     R12+0, 1
	GOTO       L_validar_hora29
	NOP
	NOP
;GSM_MAIN.c,290 :: 		aux_conversion[0] = conversion_array[0];
	MOVF       validar_hora_conversion_array_L0+0, 0
	MOVWF      validar_hora_aux_conversion_L0+0
;GSM_MAIN.c,291 :: 		aux_conversion[1] = conversion_array [1];
	MOVF       validar_hora_conversion_array_L0+1, 0
	MOVWF      validar_hora_aux_conversion_L0+1
;GSM_MAIN.c,292 :: 		conversion_2 = atoi (&conversion_array[2]);
	MOVLW      validar_hora_conversion_array_L0+2
	MOVWF      FARG_atoi_s+0
	CALL       _atoi+0
	MOVF       R0+0, 0
	MOVWF      validar_hora_conversion_2_L0+0
	MOVF       R0+1, 0
	MOVWF      validar_hora_conversion_2_L0+1
;GSM_MAIN.c,293 :: 		conversion_1 = atoi (aux_conversion);
	MOVLW      validar_hora_aux_conversion_L0+0
	MOVWF      FARG_atoi_s+0
	CALL       _atoi+0
;GSM_MAIN.c,294 :: 		almacen[0] = conversion_1;
	MOVF       R0+0, 0
	MOVWF      validar_hora_almacen_L0+0
	MOVF       R0+1, 0
	MOVWF      validar_hora_almacen_L0+1
;GSM_MAIN.c,295 :: 		almacen[1] = conversion_2;
	MOVF       validar_hora_conversion_2_L0+0, 0
	MOVWF      validar_hora_almacen_L0+2
	MOVF       validar_hora_conversion_2_L0+1, 0
	MOVWF      validar_hora_almacen_L0+3
;GSM_MAIN.c,296 :: 		uart1_write(almacen[0]);
	MOVF       validar_hora_almacen_L0+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;GSM_MAIN.c,297 :: 		delay_ms(50);
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_validar_hora30:
	DECFSZ     R13+0, 1
	GOTO       L_validar_hora30
	DECFSZ     R12+0, 1
	GOTO       L_validar_hora30
	NOP
;GSM_MAIN.c,298 :: 		uart1_write(almacen[1]);
	MOVF       validar_hora_almacen_L0+2, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;GSM_MAIN.c,299 :: 		delay_ms(50);
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_validar_hora31:
	DECFSZ     R13+0, 1
	GOTO       L_validar_hora31
	DECFSZ     R12+0, 1
	GOTO       L_validar_hora31
	NOP
;GSM_MAIN.c,301 :: 		for (i = 0 ; i<2 ; i++){
	CLRF       validar_hora_i_L0+0
L_validar_hora32:
	MOVLW      2
	SUBWF      validar_hora_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_validar_hora33
;GSM_MAIN.c,303 :: 		if (almacen[i] == eeprom_read(i)) {
	MOVF       validar_hora_i_L0+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      validar_hora_almacen_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FLOC__validar_hora+0
	INCF       FSR, 1
	MOVF       INDF+0, 0
	MOVWF      FLOC__validar_hora+1
	MOVF       validar_hora_i_L0+0, 0
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVLW      0
	XORWF      FLOC__validar_hora+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__validar_hora80
	MOVF       R0+0, 0
	XORWF      FLOC__validar_hora+0, 0
L__validar_hora80:
	BTFSS      STATUS+0, 2
	GOTO       L_validar_hora35
;GSM_MAIN.c,304 :: 		delay_ms(50);
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_validar_hora36:
	DECFSZ     R13+0, 1
	GOTO       L_validar_hora36
	DECFSZ     R12+0, 1
	GOTO       L_validar_hora36
	NOP
;GSM_MAIN.c,305 :: 		contador_2++;
	INCF       validar_hora_contador_2_L0+0, 1
;GSM_MAIN.c,307 :: 		}
L_validar_hora35:
;GSM_MAIN.c,308 :: 		uart1_write(contador_2);
	MOVF       validar_hora_contador_2_L0+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;GSM_MAIN.c,309 :: 		if (contador_2 == 1){rb5_bit = 1 ; memset (buffer_uart,'0',lengt_buffer); contador_2 =0;}
	MOVF       validar_hora_contador_2_L0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_validar_hora37
	BSF        RB5_bit+0, BitPos(RB5_bit+0)
	MOVLW      _buffer_uart+0
	MOVWF      FARG_memset_p1+0
	MOVLW      48
	MOVWF      FARG_memset_character+0
	MOVLW      21
	MOVWF      FARG_memset_n+0
	MOVLW      0
	MOVWF      FARG_memset_n+1
	CALL       _memset+0
	CLRF       validar_hora_contador_2_L0+0
L_validar_hora37:
;GSM_MAIN.c,301 :: 		for (i = 0 ; i<2 ; i++){
	INCF       validar_hora_i_L0+0, 1
;GSM_MAIN.c,310 :: 		}
	GOTO       L_validar_hora32
L_validar_hora33:
;GSM_MAIN.c,311 :: 		contador_2=0;
	CLRF       validar_hora_contador_2_L0+0
;GSM_MAIN.c,312 :: 		for (i = 0 ; i<2 ; i++){
	CLRF       validar_hora_i_L0+0
L_validar_hora38:
	MOVLW      2
	SUBWF      validar_hora_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_validar_hora39
;GSM_MAIN.c,314 :: 		if (almacen[i] == eeprom_read(2+i)) {
	MOVF       validar_hora_i_L0+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      validar_hora_almacen_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FLOC__validar_hora+0
	INCF       FSR, 1
	MOVF       INDF+0, 0
	MOVWF      FLOC__validar_hora+1
	MOVF       validar_hora_i_L0+0, 0
	ADDLW      2
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVLW      0
	XORWF      FLOC__validar_hora+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__validar_hora81
	MOVF       R0+0, 0
	XORWF      FLOC__validar_hora+0, 0
L__validar_hora81:
	BTFSS      STATUS+0, 2
	GOTO       L_validar_hora41
;GSM_MAIN.c,315 :: 		delay_ms(50);
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_validar_hora42:
	DECFSZ     R13+0, 1
	GOTO       L_validar_hora42
	DECFSZ     R12+0, 1
	GOTO       L_validar_hora42
	NOP
;GSM_MAIN.c,316 :: 		contador_2++;
	INCF       validar_hora_contador_2_L0+0, 1
;GSM_MAIN.c,318 :: 		}
L_validar_hora41:
;GSM_MAIN.c,319 :: 		uart1_write(contador_2);
	MOVF       validar_hora_contador_2_L0+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;GSM_MAIN.c,320 :: 		if (contador_2 == 1){rb5_bit = 0 ; memset (buffer_uart,'0',lengt_buffer); contador_2 =0;}
	MOVF       validar_hora_contador_2_L0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_validar_hora43
	BCF        RB5_bit+0, BitPos(RB5_bit+0)
	MOVLW      _buffer_uart+0
	MOVWF      FARG_memset_p1+0
	MOVLW      48
	MOVWF      FARG_memset_character+0
	MOVLW      21
	MOVWF      FARG_memset_n+0
	MOVLW      0
	MOVWF      FARG_memset_n+1
	CALL       _memset+0
	CLRF       validar_hora_contador_2_L0+0
L_validar_hora43:
;GSM_MAIN.c,312 :: 		for (i = 0 ; i<2 ; i++){
	INCF       validar_hora_i_L0+0, 1
;GSM_MAIN.c,321 :: 		}
	GOTO       L_validar_hora38
L_validar_hora39:
;GSM_MAIN.c,338 :: 		}
L_end_validar_hora:
	RETURN
; end of _validar_hora

_guardar_datos_en_eeprom:

;GSM_MAIN.c,340 :: 		void guardar_datos_en_eeprom(unsigned char *indice){
;GSM_MAIN.c,342 :: 		unsigned char cont_buff=0;
	CLRF       guardar_datos_en_eeprom_cont_buff_L0+0
	CLRF       guardar_datos_en_eeprom_cont_eeprom_L0+0
;GSM_MAIN.c,346 :: 		for (i=1 ; i < 13 ; i++) {
	MOVLW      1
	MOVWF      guardar_datos_en_eeprom_i_L0+0
L_guardar_datos_en_eeprom44:
	MOVLW      13
	SUBWF      guardar_datos_en_eeprom_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_guardar_datos_en_eeprom45
;GSM_MAIN.c,347 :: 		if (isdigit(indice [i]) && cont_buff <2 ){
	MOVF       guardar_datos_en_eeprom_i_L0+0, 0
	ADDWF      FARG_guardar_datos_en_eeprom_indice+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_isdigit_character+0
	CALL       _isdigit+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_guardar_datos_en_eeprom49
	MOVLW      2
	SUBWF      guardar_datos_en_eeprom_cont_buff_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_guardar_datos_en_eeprom49
L__guardar_datos_en_eeprom66:
;GSM_MAIN.c,348 :: 		buffer_conversion[cont_buff]=indice[i];
	MOVF       guardar_datos_en_eeprom_cont_buff_L0+0, 0
	ADDLW      _buffer_conversion+0
	MOVWF      R1+0
	MOVF       guardar_datos_en_eeprom_i_L0+0, 0
	ADDWF      FARG_guardar_datos_en_eeprom_indice+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R1+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;GSM_MAIN.c,349 :: 		cont_buff++;
	INCF       guardar_datos_en_eeprom_cont_buff_L0+0, 1
;GSM_MAIN.c,350 :: 		}
L_guardar_datos_en_eeprom49:
;GSM_MAIN.c,351 :: 		if (cont_buff ==2){
	MOVF       guardar_datos_en_eeprom_cont_buff_L0+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_guardar_datos_en_eeprom50
;GSM_MAIN.c,352 :: 		conversion = atoi(buffer_conversion);
	MOVLW      _buffer_conversion+0
	MOVWF      FARG_atoi_s+0
	CALL       _atoi+0
	MOVF       R0+0, 0
	MOVWF      _conversion+0
	MOVF       R0+1, 0
	MOVWF      _conversion+1
;GSM_MAIN.c,353 :: 		eeprom_write(cont_eeprom,conversion);
	MOVF       guardar_datos_en_eeprom_cont_eeprom_L0+0, 0
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       R0+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;GSM_MAIN.c,354 :: 		delay_ms(30);
	MOVLW      39
	MOVWF      R12+0
	MOVLW      245
	MOVWF      R13+0
L_guardar_datos_en_eeprom51:
	DECFSZ     R13+0, 1
	GOTO       L_guardar_datos_en_eeprom51
	DECFSZ     R12+0, 1
	GOTO       L_guardar_datos_en_eeprom51
;GSM_MAIN.c,355 :: 		memset(buffer_conversion,'0',2);
	MOVLW      _buffer_conversion+0
	MOVWF      FARG_memset_p1+0
	MOVLW      48
	MOVWF      FARG_memset_character+0
	MOVLW      2
	MOVWF      FARG_memset_n+0
	MOVLW      0
	MOVWF      FARG_memset_n+1
	CALL       _memset+0
;GSM_MAIN.c,356 :: 		cont_eeprom ++;
	INCF       guardar_datos_en_eeprom_cont_eeprom_L0+0, 1
;GSM_MAIN.c,357 :: 		cont_buff =0;
	CLRF       guardar_datos_en_eeprom_cont_buff_L0+0
;GSM_MAIN.c,358 :: 		}
L_guardar_datos_en_eeprom50:
;GSM_MAIN.c,359 :: 		if (cont_eeprom == 4){
	MOVF       guardar_datos_en_eeprom_cont_eeprom_L0+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_guardar_datos_en_eeprom52
;GSM_MAIN.c,360 :: 		cont_eeprom =10;
	MOVLW      10
	MOVWF      guardar_datos_en_eeprom_cont_eeprom_L0+0
;GSM_MAIN.c,362 :: 		}
L_guardar_datos_en_eeprom52:
;GSM_MAIN.c,346 :: 		for (i=1 ; i < 13 ; i++) {
	INCF       guardar_datos_en_eeprom_i_L0+0, 1
;GSM_MAIN.c,363 :: 		}
	GOTO       L_guardar_datos_en_eeprom44
L_guardar_datos_en_eeprom45:
;GSM_MAIN.c,364 :: 		memset (buffer_uart,'0',lengt_buffer);
	MOVLW      _buffer_uart+0
	MOVWF      FARG_memset_p1+0
	MOVLW      48
	MOVWF      FARG_memset_character+0
	MOVLW      21
	MOVWF      FARG_memset_n+0
	MOVLW      0
	MOVWF      FARG_memset_n+1
	CALL       _memset+0
;GSM_MAIN.c,365 :: 		flag_fin = 0;
	CLRF       _flag_fin+0
;GSM_MAIN.c,368 :: 		}
L_end_guardar_datos_en_eeprom:
	RETURN
; end of _guardar_datos_en_eeprom

_buscar_comandos:

;GSM_MAIN.c,370 :: 		void buscar_comandos (){
;GSM_MAIN.c,374 :: 		indice = memchr (buffer_uart,':',lengt_buffer);  // el prefijo espacio viene asociado al comando @time 22,15,22,30*
	MOVLW      _buffer_uart+0
	MOVWF      FARG_memchr_p+0
	MOVLW      58
	MOVWF      FARG_memchr_n+0
	MOVLW      21
	MOVWF      FARG_memchr_v+0
	MOVLW      0
	MOVWF      FARG_memchr_v+1
	CALL       _memchr+0
	MOVF       R0+0, 0
	MOVWF      _indice+0
;GSM_MAIN.c,375 :: 		if (indice != 0){
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_buscar_comandos53
;GSM_MAIN.c,376 :: 		guardar_datos_en_eeprom(indice);
	MOVF       _indice+0, 0
	MOVWF      FARG_guardar_datos_en_eeprom_indice+0
	CALL       _guardar_datos_en_eeprom+0
;GSM_MAIN.c,377 :: 		}
	GOTO       L_buscar_comandos54
L_buscar_comandos53:
;GSM_MAIN.c,379 :: 		valor = buscar_prefijo (buffer_uart,'_');  // busca el prefijo asociado a uno de los comandos @luz_1* , @alarma_1*
	MOVLW      _buffer_uart+0
	MOVWF      FARG_buscar_prefijo_buffer+0
	MOVLW      95
	MOVWF      FARG_buscar_prefijo_caracter+0
	CALL       _buscar_prefijo+0
	MOVF       R0+0, 0
	MOVWF      _valor+0
;GSM_MAIN.c,380 :: 		mapear_caracteres (valor,buffer_uart);
	MOVF       R0+0, 0
	MOVWF      FARG_mapear_caracteres_valor+0
	MOVLW      _buffer_uart+0
	MOVWF      FARG_mapear_caracteres_indice+0
	CALL       _mapear_caracteres+0
;GSM_MAIN.c,381 :: 		}
L_buscar_comandos54:
;GSM_MAIN.c,385 :: 		}
L_end_buscar_comandos:
	RETURN
; end of _buscar_comandos

_leer_buffer:

;GSM_MAIN.c,386 :: 		unsigned char leer_buffer () {
;GSM_MAIN.c,400 :: 		if (flag_fin ) {
	MOVF       _flag_fin+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_leer_buffer55
;GSM_MAIN.c,401 :: 		RCIF_BIT = 0;
	BCF        RCIF_bit+0, BitPos(RCIF_bit+0)
;GSM_MAIN.c,402 :: 		contador_de_caracteres = 0;
	CLRF       _contador_de_caracteres+0
;GSM_MAIN.c,404 :: 		if (buffer_uart[0]== ','){ validar_hora(buffer_uart); flag_fin =0;}
	MOVF       _buffer_uart+0, 0
	XORLW      44
	BTFSS      STATUS+0, 2
	GOTO       L_leer_buffer56
	MOVLW      _buffer_uart+0
	MOVWF      FARG_validar_hora_buffer+0
	CALL       _validar_hora+0
	CLRF       _flag_fin+0
	GOTO       L_leer_buffer57
L_leer_buffer56:
;GSM_MAIN.c,406 :: 		else{ buscar_comandos();}
	CALL       _buscar_comandos+0
L_leer_buffer57:
;GSM_MAIN.c,407 :: 		}
L_leer_buffer55:
;GSM_MAIN.c,409 :: 		}
L_end_leer_buffer:
	RETURN
; end of _leer_buffer

_main:

;GSM_MAIN.c,411 :: 		void main() {
;GSM_MAIN.c,412 :: 		setup_28a();
	CALL       _setup_28a+0
;GSM_MAIN.c,414 :: 		}
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

;GSM_MAIN.c,416 :: 		void interrupt (){
;GSM_MAIN.c,418 :: 		if (uart1_data_ready()){
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt58
;GSM_MAIN.c,419 :: 		dato =  uart1_read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _dato+0
;GSM_MAIN.c,420 :: 		asignar_flags(dato);
	MOVF       R0+0, 0
	MOVWF      FARG_asignar_flags_dato+0
	CALL       _asignar_flags+0
;GSM_MAIN.c,421 :: 		cargar_buffer(dato);
	MOVF       _dato+0, 0
	MOVWF      FARG_cargar_buffer_dato+0
	CALL       _cargar_buffer+0
;GSM_MAIN.c,422 :: 		leer_buffer();
	CALL       _leer_buffer+0
;GSM_MAIN.c,424 :: 		}
L_interrupt58:
;GSM_MAIN.c,426 :: 		if (tmr1if_bit){
	BTFSS      TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
	GOTO       L_interrupt59
;GSM_MAIN.c,427 :: 		tmr1if_bit =0;
	BCF        TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
;GSM_MAIN.c,428 :: 		TMR1H = 0x00;
	CLRF       TMR1H+0
;GSM_MAIN.c,429 :: 		TMR1L = 0x00;
	CLRF       TMR1L+0
;GSM_MAIN.c,430 :: 		contador_timer++;
	INCF       _contador_timer+0, 1
;GSM_MAIN.c,431 :: 		tmr1on_bit =1;
	BSF        TMR1ON_bit+0, BitPos(TMR1ON_bit+0)
;GSM_MAIN.c,432 :: 		if (contador_timer == 20){
	MOVF       _contador_timer+0, 0
	XORLW      20
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt60
;GSM_MAIN.c,433 :: 		contador_timer =0;
	CLRF       _contador_timer+0
;GSM_MAIN.c,434 :: 		rb6_bit ^=1;
	MOVLW
	XORWF      RB6_bit+0, 1
;GSM_MAIN.c,435 :: 		uart1_write_text ("AT+CCLK?\r\n");
	MOVLW      ?lstr1_GSM_MAIN+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;GSM_MAIN.c,439 :: 		}
L_interrupt60:
;GSM_MAIN.c,443 :: 		}
L_interrupt59:
;GSM_MAIN.c,444 :: 		}
L_end_interrupt:
L__interrupt87:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt
