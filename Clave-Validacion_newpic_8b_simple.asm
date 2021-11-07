#include "p16F887.inc"   ; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR
 	__CONFIG	_CONFIG1,	_INTRC_OSC_NOCLKOUT & _WDT_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOR_OFF & _IESO_ON & _FCMEN_ON & _LVP_OFF 
 	__CONFIG	_CONFIG2,	_BOR40V & _WRT_OFF

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

MAIN_PROG CODE                      ; let linker place main program

i EQU 0x20
x EQU 0x21
y EQU 0x22
z EQU 0x23
j EQU 0x24
c1 EQU 0x25
c2 EQU 0x26
c3 EQU 0x27
c4 EQU 0x28
c5 EQU 0x29
c6 EQU 0x30
c7 EQU 0x31
c8 EQU 0x32
v1 EQU 0x33
v2 EQU 0x34
v3 EQU 0x35
v4 EQU 0x36
v5 EQU 0x37
v6 EQU 0x38
v7 EQU 0x39
v8 EQU 0x40
aux EQU 0x41
band EQU 0x42
apunt EQU 0x43
bandv EQU 0x44
 
START

    BANKSEL PORTA ;
    CLRF PORTA ;Init PORTA
    BANKSEL ANSEL ;
    CLRF ANSEL ;digital I/O
    CLRF ANSELH
    BANKSEL TRISA ;
    CLRF TRISA
    CLRF TRISB
    CLRF TRISC
    CLRF TRISD
    CLRF TRISE
    MOVLW b'00000000' 
    MOVWF TRISC
    MOVLW b'11111111' 
    MOVWF TRISD
    BCF STATUS,RP1
    BCF STATUS,RP0
    CLRF PORTA
    CLRF PORTB
    CLRF PORTC
    CLRF PORTD
    CLRF PORTE
    
    CLRF band
    CLRF apunt
    CLRF bandv
    GOTO INICIO
    
INITLCD:
    BCF PORTA,0 ;reset
    MOVLW 0x01
    MOVWF PORTB

    BSF PORTA,1 ;exec
    CALL time
    BCF PORTA,1
    CALL time

    MOVLW 0x0C ;first line
    MOVWF PORTB

    BSF PORTA,1 ;exec
    CALL time
    BCF PORTA,1
    CALL time

    MOVLW 0x3C ;cursor mode
    MOVWF PORTB

    BSF PORTA,1 ;exec
    CALL time
    BCF PORTA,1
    CALL time
    
    RETURN
    
INICIO  
    CALL INITLCD
    CALL CLAVE;Imprimo mensaje 
    CALL VALIDACION; Imprimo mensaje 
    BSF bandv,0
    CALL LCDPOS ;Me muevo al segundo renglón    
    CALL REGISTROCLAVE; Registro de la clave 
    BCF bandv,0
    CALL LCDPOSVAL ;Me muevo al cuarto renglón 
    CALL REGISTROVALIDACION; Registro la validación
    CALL COMPARACION ;Ve si son iguales o no e imprime el mensaje correspondiente   
    GOTO INICIO
    
REGISTROCLAVE:
    CALL SCAN
    BTFSS band, 0
    GOTO $-2
    MOVFW aux
    MOVWF c1    
    CALL SCAN
    BTFSS band, 0
    GOTO $-2
    MOVFW aux
    MOVWF c2    
    CALL SCAN
    BTFSS band, 0
    GOTO $-2
    MOVFW aux
    MOVWF c3
    CALL SCAN
    BTFSS band, 0
    GOTO $-2
    MOVFW aux
    MOVWF c4
    CALL SCAN
    BTFSS band, 0
    GOTO $-2
    MOVFW aux
    MOVWF c5
    CALL SCAN
    BTFSS band, 0
    GOTO $-2
    MOVFW aux
    MOVWF c6
    CALL SCAN
    BTFSS band, 0
    GOTO $-2
    MOVFW aux
    MOVWF c7
    CALL SCAN
    BTFSS band, 0
    GOTO $-2
    MOVFW aux
    MOVWF c8
    RETURN

REGISTROVALIDACION: 
    CALL SCAN
    BTFSS band, 0
    GOTO $-2
    MOVFW aux
    MOVWF v1    
    CALL SCAN
    BTFSS band, 0
    GOTO $-2
    MOVFW aux
    MOVWF v2    
    CALL SCAN
    BTFSS band, 0
    GOTO $-2
    MOVFW aux
    MOVWF v3
    CALL SCAN
    BTFSS band, 0
    GOTO $-2
    MOVFW aux
    MOVWF v4
    CALL SCAN
    BTFSS band, 0
    GOTO $-2
    MOVFW aux
    MOVWF v5
    CALL SCAN
    BTFSS band, 0
    GOTO $-2
    MOVFW aux
    MOVWF v6
    CALL SCAN
    BTFSS band, 0
    GOTO $-2
    MOVFW aux
    MOVWF v7
    CALL SCAN
    BTFSS band, 0
    GOTO $-2
    MOVFW aux
    MOVWF v8
    RETURN

SCAN:
    BCF band, 0
    
    BSF PORTC, 0     
    BTFSC PORTD, 0
    CALL UNO ;Se oprimió 1
    BTFSC PORTD, 1
    CALL CUATRO ;Se oprimió 4
    BTFSC PORTD, 2
    CALL SIETE ;Se oprimió 7
    BTFSC PORTD, 3
    CALL ASTERISCO ;Se oprimió asterisco
    BCF PORTC, 0 
    
    BSF PORTC, 1     
    BTFSC PORTD, 0
    CALL DOS ;Se oprimió 2
    BTFSC PORTD, 1
    CALL CINCO ;Se oprimió 5 
    BTFSC PORTD, 2
    CALL OCHO ;Se oprimió 8
    BTFSC PORTD, 3
    CALL CERO ;Se oprimió cero
    BCF PORTC, 1
    
    BSF PORTC, 2     
    BTFSC PORTD, 0
    CALL TRES ;Se oprimió 3
    BTFSC PORTD, 1
    CALL SEIS ;Se oprimió 6
    BTFSC PORTD, 2
    CALL NUEVE ;Se oprimió 9 
    BTFSC PORTD, 3
    CALL GATO ;No hace nada
    BCF PORTC, 2
    RETURN

UNO:    
    MOVLW '1'
    MOVWF aux    
    MOVLW '1'
    MOVWF PORTB
    CALL time2
    CALL exec
    CALL time2 
    
    BTFSS bandv, 0 ;¿Ya es la validación?
    GOTO $+15
    
    CALL DELAY    
    BCF PORTA,0		;command mode
    CALL time    
    MOVFW apunt
    MOVWF PORTB
    INCF apunt
    CALL exec    
    BSF PORTA,0		;data mode
    CALL time
    MOVLW '*'
    MOVWF PORTB
    CALL time2
    CALL exec
    CALL time2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BSF band, 0   
    BTFSC PORTD, 0
    GOTO $-1    
    RETURN 
    
DOS:MOVLW '2'
    MOVWF aux    
    MOVLW '2'
    MOVWF PORTB
    CALL time2
    CALL exec
    CALL time2 
    
    BTFSS bandv, 0 ;¿Ya es la validación?
    GOTO $+15
    
    CALL DELAY    
    BCF PORTA,0		;command mode
    CALL time    
    MOVFW apunt
    MOVWF PORTB
    INCF apunt
    CALL exec    
    BSF PORTA,0		;data mode
    CALL time
    MOVLW '*'
    MOVWF PORTB
    CALL time2
    CALL exec
    CALL time2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BSF band, 0   
    BTFSC PORTD, 0
    GOTO $-1 
    RETURN
 
TRES:
    MOVLW '3'
    MOVWF aux    
    MOVLW '3'
    MOVWF PORTB
    CALL time2
    CALL exec
    CALL time2 
    
    BTFSS bandv, 0 ;¿Ya es la validación?
    GOTO $+15
    
    CALL DELAY    
    BCF PORTA,0		;command mode
    CALL time    
    MOVFW apunt
    MOVWF PORTB
    INCF apunt
    CALL exec    
    BSF PORTA,0		;data mode
    CALL time
    MOVLW '*'
    MOVWF PORTB
    CALL time2
    CALL exec
    CALL time2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BSF band, 0   
    BTFSC PORTD, 0
    GOTO $-1 
    RETURN
    
CUATRO:
    MOVLW '4'
    MOVWF aux    
    MOVLW '4'
    MOVWF PORTB
    CALL time2
    CALL exec
    CALL time2 
    
    BTFSS bandv, 0 ;¿Ya es la validación?
    GOTO $+15
    
    CALL DELAY    
    BCF PORTA,0		;command mode
    CALL time    
    MOVFW apunt
    MOVWF PORTB
    INCF apunt
    CALL exec    
    BSF PORTA,0		;data mode
    CALL time
    MOVLW '*'
    MOVWF PORTB
    CALL time2
    CALL exec
    CALL time2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BSF band, 0   
    BTFSC PORTD, 0
    GOTO $-1 
    RETURN

    
CINCO:
    MOVLW '5'
    MOVWF aux    
    MOVLW '5'
    MOVWF PORTB
    CALL time2
    CALL exec
    CALL time2 
    
    BTFSS bandv, 0 ;¿Ya es la validación?
    GOTO $+15
    
    CALL DELAY    
    BCF PORTA,0		;command mode
    CALL time    
    MOVFW apunt
    MOVWF PORTB
    INCF apunt
    CALL exec    
    BSF PORTA,0		;data mode
    CALL time
    MOVLW '*'
    MOVWF PORTB
    CALL time2
    CALL exec
    CALL time2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BSF band, 0   
    BTFSC PORTD, 0
    GOTO $-1 
    RETURN

SEIS:
    MOVLW '6'
    MOVWF aux    
    MOVLW '6'
    MOVWF PORTB
    CALL time2
    CALL exec
    CALL time2 
    
    BTFSS bandv, 0 ;¿Ya es la validación?
    GOTO $+15
    
    CALL DELAY    
    BCF PORTA,0		;command mode
    CALL time    
    MOVFW apunt
    MOVWF PORTB
    INCF apunt
    CALL exec    
    BSF PORTA,0		;data mode
    CALL time
    MOVLW '*'
    MOVWF PORTB
    CALL time2
    CALL exec
    CALL time2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BSF band, 0   
    BTFSC PORTD, 0
    GOTO $-1 
    RETURN

SIETE:
    MOVLW '7'
    MOVWF aux    
    MOVLW '7'
    MOVWF PORTB
    CALL time2
    CALL exec
    CALL time2 
    
    BTFSS bandv, 0 ;¿Ya es la validación?
    GOTO $+15
    
    CALL DELAY    
    BCF PORTA,0		;command mode
    CALL time    
    MOVFW apunt
    MOVWF PORTB
    INCF apunt
    CALL exec    
    BSF PORTA,0		;data mode
    CALL time
    MOVLW '*'
    MOVWF PORTB
    CALL time2
    CALL exec
    CALL time2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BSF band, 0   
    BTFSC PORTD, 0
    GOTO $-1 
    RETURN
  
OCHO:
    MOVLW '8'
    MOVWF aux    
    MOVLW '8'
    MOVWF PORTB
    CALL time2
    CALL exec
    CALL time2 
    
    BTFSS bandv, 0 ;¿Ya es la validación?
    GOTO $+15
    
    CALL DELAY    
    BCF PORTA,0		;command mode
    CALL time    
    MOVFW apunt
    MOVWF PORTB
    INCF apunt
    CALL exec    
    BSF PORTA,0		;data mode
    CALL time
    MOVLW '*'
    MOVWF PORTB
    CALL time2
    CALL exec
    CALL time2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BSF band, 0   
    BTFSC PORTD, 0
    GOTO $-1 
    RETURN
    
NUEVE:
    MOVLW '9'
    MOVWF aux    
    MOVLW '9'
    MOVWF PORTB
    CALL time2
    CALL exec
    CALL time2 
    
    BTFSS bandv, 0 ;¿Ya es la validación?
    GOTO $+15
    
    CALL DELAY    
    BCF PORTA,0		;command mode
    CALL time    
    MOVFW apunt
    MOVWF PORTB
    INCF apunt
    CALL exec    
    BSF PORTA,0		;data mode
    CALL time
    MOVLW '*'
    MOVWF PORTB
    CALL time2
    CALL exec
    CALL time2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BSF band, 0   
    BTFSC PORTD, 0
    GOTO $-1 
    RETURN
        
CERO:
    MOVLW '0'
    MOVWF aux    
    MOVLW '0'
    MOVWF PORTB
    CALL time2
    CALL exec
    CALL time2 
    
    BTFSS bandv, 0 ;¿Ya es la validación?
    GOTO $+15
    
    CALL DELAY    
    BCF PORTA,0		;command mode
    CALL time    
    MOVFW apunt
    MOVWF PORTB
    INCF apunt
    CALL exec    
    BSF PORTA,0		;data mode
    CALL time
    MOVLW '*'
    MOVWF PORTB
    CALL time2
    CALL exec
    CALL time2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BSF band, 0   
    BTFSC PORTD, 0
    GOTO $-1 
    RETURN
    
ASTERISCO: ;No hace nada
    RETURN
    
GATO: ;No hace nada
    RETURN
    
COMPARACION:
    MOVFW c1
    MOVWF aux
    MOVFW v1 
    XORWF aux,1
    BTFSS aux, 0
    BTFSC aux,0
    CALL FALLA
    
    MOVFW c2
    MOVWF aux
    MOVFW v2    
    XORWF aux,1
    BTFSS aux, 0
    BTFSC aux,0
    CALL FALLA
    
    MOVFW c3
    MOVWF aux
    MOVFW v3    
    XORWF aux,1
    BTFSS aux, 0
    BTFSC aux,0
    CALL FALLA
    
    MOVFW c4
    MOVWF aux
    MOVFW v4    
    XORWF aux,1
    BTFSS aux, 0
    BTFSC aux,0
    CALL FALLA
    
    MOVFW c5
    MOVWF aux
    MOVFW v5    
    XORWF aux,1
    BTFSS aux, 0
    BTFSC aux,0
    CALL FALLA
    
    MOVFW c6
    MOVWF aux
    MOVFW v6    
    XORWF aux,1
    BTFSS aux, 0
    BTFSC aux,0
    CALL FALLA

    MOVFW c7
    MOVWF aux
    MOVFW v7    
    XORWF aux,1
    BTFSS aux, 0
    BTFSC aux,0
    CALL FALLA
    
    MOVFW c8
    MOVWF aux
    MOVFW v8    
    XORWF aux,1
    BTFSS aux, 0
    BTFSC aux,0
    CALL FALLA
    BTFSS aux,0
    CALL EXITO
    
    RETURN

CLAVE:
    BCF PORTA,0		;command mode
    CALL time
    
    MOVLW 0x80		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW 'C'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'L'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'A'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'V'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'E'
    MOVWF PORTB
    CALL exec
    
    MOVLW ':'
    MOVWF PORTB
    CALL exec
    
    MOVLW ' '
    MOVWF PORTB
    CALL exec
    
    MOVLW ' '
    MOVWF PORTB
    CALL exec
    
    MOVLW ' '
    MOVWF PORTB
    CALL exec
    RETURN
    
VALIDACION:
    BCF PORTA,0		;command mode
    CALL time
    
    MOVLW 0x90		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW 'V'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'A'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'L'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'I'
    MOVWF PORTB
    CALL exec
   
    MOVLW 'D'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'A'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'C'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'I'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'O'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'N'
    MOVWF PORTB
    CALL exec
    
    MOVLW ':'
    MOVWF PORTB
    CALL exec
    
    MOVLW ' '
    MOVWF PORTB
    CALL exec
    RETURN 
  
FALLA:
    CALL INITLCD
    BCF PORTA,0		;command mode
    CALL time
    
    MOVLW 0xC3		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW 'I'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'N'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'C'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'O'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'R'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'R'
    MOVWF PORTB
    CALL exec
   
    MOVLW 'E'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'C'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'T'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'O'
    MOVWF PORTB
    CALL exec
    RETURN
    
EXITO:
    CALL INITLCD
    BCF PORTA,0		;command mode
    CALL time
    
    MOVLW 0xC3		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    MOVLW 'C'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'O'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'R'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'R'
    MOVWF PORTB
    CALL exec
   
    MOVLW 'E'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'C'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'T'
    MOVWF PORTB
    CALL exec
    
    MOVLW 'O'
    MOVWF PORTB
    CALL exec
    RETURN    
   
LCDPOS:
    BCF PORTA,0		;command mode
    CALL time
    
    MOVLW 0xC0           ;LCD position
    MOVWF apunt
    MOVFW apunt
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time    
    RETURN
    
LCDPOSVAL:
   
    BCF PORTA,0		;command mode
    CALL time
    
    MOVLW 0xD0		;LCD position
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time    
    RETURN
    
DELAY:
    MOVLW d'30' 
    MOVWF x
loopy:    
    MOVLW d'54'
    MOVWF y
loopz:    
    MOVLW d'50'
    MOVWF z 
    DECFSZ z
    GOTO $-1
    DECFSZ y
    GOTO loopz
    DECFSZ x
    GOTO loopy
    RETURN
    
time2:
    CLRF i
    MOVLW d'255'
    MOVWF j
    RETURN
    
CLEAR:
    BCF PORTA,0		;command mode
    CALL time
    
    MOVLW 0x01		;reset
    MOVWF PORTB
    CALL exec
    
    BSF PORTA,0		;data mode
    CALL time
    
    RETURN
   
exec
    BSF PORTA,1		;exec
    CALL time
    BCF PORTA,1
    CALL time
    RETURN
    
time
    CLRF i
    MOVLW d'10'
    MOVWF j
ciclo    
    MOVLW d'80'
    MOVWF i
    DECFSZ i
    GOTO $-1
    DECFSZ j
    GOTO ciclo
    RETURN
       
    END