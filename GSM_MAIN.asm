
_setup_28a:

;GSM_MAIN.c,5 :: 		void setup_28a(void){
;GSM_MAIN.c,7 :: 		CMcon =0x07;             // puertoa como entrada salida digital.... apago los comparadores;
	MOVLW      7
	MOVWF      CMCON+0
;GSM_MAIN.c,8 :: 		TRISB =0b00000010;
	MOVLW      2
	MOVWF      TRISB+0
;GSM_MAIN.c,9 :: 		TRISA =0b00000000;
	CLRF       TRISA+0
;GSM_MAIN.c,10 :: 		PORTA =0X00;
	CLRF       PORTA+0
;GSM_MAIN.c,11 :: 		PORTB = 0X00;
	CLRF       PORTB+0
;GSM_MAIN.c,14 :: 		uart1_init(9600);
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;GSM_MAIN.c,15 :: 		GIE_BIT =1;  // HABILITO LAS INTERRUPCIONES GLOBALES
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;GSM_MAIN.c,16 :: 		PEIE_BIT =1;  // HABILITO LAS INTERRUPCIONES DE LOS PERIFERICOS
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;GSM_MAIN.c,17 :: 		RCIE_BIT =1;    // HABILITO LA INTERRUPCION DE "LLEGO UN DATO"
	BSF        RCIE_bit+0, BitPos(RCIE_bit+0)
;GSM_MAIN.c,24 :: 		}
L_end_setup_28a:
	RETURN
; end of _setup_28a

_oscilar_led:

;GSM_MAIN.c,27 :: 		void oscilar_led (unsigned char dato ){
;GSM_MAIN.c,29 :: 		rb5_bit = dato;
	BTFSC      FARG_oscilar_led_dato+0, 0
	GOTO       L__oscilar_led8
	BCF        RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L__oscilar_led9
L__oscilar_led8:
	BSF        RB5_bit+0, BitPos(RB5_bit+0)
L__oscilar_led9:
;GSM_MAIN.c,33 :: 		}
L_end_oscilar_led:
	RETURN
; end of _oscilar_led

_main:

;GSM_MAIN.c,35 :: 		void main() {
;GSM_MAIN.c,36 :: 		setup_28a();
	CALL       _setup_28a+0
;GSM_MAIN.c,46 :: 		}
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

;GSM_MAIN.c,48 :: 		void interrupt (){
;GSM_MAIN.c,50 :: 		if (RCIF_BIT ==1 && contador_de_caracteres < lengt_buffer){
	BTFSS      RCIF_bit+0, BitPos(RCIF_bit+0)
	GOTO       L_interrupt2
	MOVLW      20
	SUBWF      _contador_de_caracteres+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt2
L__interrupt5:
;GSM_MAIN.c,52 :: 		RCIF_BIT = 0;
	BCF        RCIF_bit+0, BitPos(RCIF_bit+0)
;GSM_MAIN.c,53 :: 		buffer_uart[contador_de_caracteres] = uart1_read();
	MOVF       _contador_de_caracteres+0, 0
	ADDLW      _buffer_uart+0
	MOVWF      FLOC__interrupt+0
	CALL       _UART1_Read+0
	MOVF       FLOC__interrupt+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;GSM_MAIN.c,54 :: 		contador_de_caracteres ++;
	INCF       _contador_de_caracteres+0, 1
;GSM_MAIN.c,57 :: 		}
	GOTO       L_interrupt3
L_interrupt2:
;GSM_MAIN.c,59 :: 		RCIF_BIT = 0;
	BCF        RCIF_bit+0, BitPos(RCIF_bit+0)
;GSM_MAIN.c,60 :: 		contador_de_caracteres = 0;
	CLRF       _contador_de_caracteres+0
;GSM_MAIN.c,61 :: 		indice = memchr (buffer_uart,'y',lengt_buffer);
	MOVLW      _buffer_uart+0
	MOVWF      FARG_memchr_p+0
	MOVLW      121
	MOVWF      FARG_memchr_n+0
	MOVLW      20
	MOVWF      FARG_memchr_v+0
	MOVLW      0
	MOVWF      FARG_memchr_v+1
	CALL       _memchr+0
	MOVF       R0+0, 0
	MOVWF      _indice+0
;GSM_MAIN.c,62 :: 		delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_interrupt4:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt4
	DECFSZ     R12+0, 1
	GOTO       L_interrupt4
	NOP
	NOP
;GSM_MAIN.c,63 :: 		uart1_write_text(indice);
	MOVF       _indice+0, 0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;GSM_MAIN.c,64 :: 		memset (buffer_uart,'x',lengt_buffer);
	MOVLW      _buffer_uart+0
	MOVWF      FARG_memset_p1+0
	MOVLW      120
	MOVWF      FARG_memset_character+0
	MOVLW      20
	MOVWF      FARG_memset_n+0
	MOVLW      0
	MOVWF      FARG_memset_n+1
	CALL       _memset+0
;GSM_MAIN.c,66 :: 		}
L_interrupt3:
;GSM_MAIN.c,67 :: 		}
L_end_interrupt:
L__interrupt12:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt
