
_setup_28a:

;GSM_MAIN.c,4 :: 		void setup_28a(void){
;GSM_MAIN.c,6 :: 		CMcon =0x07;             // puertoa como entrada salida digital.... apago los comparadores;
	MOVLW      7
	MOVWF      CMCON+0
;GSM_MAIN.c,7 :: 		TRISB =0b00000000;
	CLRF       TRISB+0
;GSM_MAIN.c,8 :: 		TRISA =0b00000000;
	CLRF       TRISA+0
;GSM_MAIN.c,9 :: 		PORTA =0X00;
	CLRF       PORTA+0
;GSM_MAIN.c,10 :: 		PORTB = 0X00;
	CLRF       PORTB+0
;GSM_MAIN.c,23 :: 		}
L_end_setup_28a:
	RETURN
; end of _setup_28a

_oscilar_led:

;GSM_MAIN.c,25 :: 		void oscilar_led (unsigned char dato ){
;GSM_MAIN.c,27 :: 		rb5_bit = dato;
	BTFSC      FARG_oscilar_led_dato+0, 0
	GOTO       L__oscilar_led2
	BCF        RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L__oscilar_led3
L__oscilar_led2:
	BSF        RB5_bit+0, BitPos(RB5_bit+0)
L__oscilar_led3:
;GSM_MAIN.c,31 :: 		}
L_end_oscilar_led:
	RETURN
; end of _oscilar_led

_main:

;GSM_MAIN.c,33 :: 		void main() {
;GSM_MAIN.c,35 :: 		puntero_funcion = oscilar_led;
	MOVLW      _oscilar_led+0
	MOVWF      main_puntero_funcion_L0+0
	MOVLW      hi_addr(_oscilar_led+0)
	MOVWF      main_puntero_funcion_L0+1
	MOVLW      FARG_oscilar_led_dato+0
	MOVWF      main_puntero_funcion_L0+2
	MOVLW      hi_addr(FARG_oscilar_led_dato+0)
;GSM_MAIN.c,36 :: 		setup_28a();
	CALL       _setup_28a+0
;GSM_MAIN.c,37 :: 		puntero_funcion(1);
	MOVF       main_puntero_funcion_L0+2, 0
	MOVWF      FSR
	MOVLW      1
	MOVWF      INDF+0
	INCF       FSR, 1
	MOVF       main_puntero_funcion_L0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       main_puntero_funcion_L0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoIFC+0
;GSM_MAIN.c,39 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
