;
; Debounce en asm.asm
;
; Created: 14/07/2018 10:01:09 p. m.
; Author : dx_ch
;
;Ejemplo de un pulsador activando un led (Debounce).
;
.def temp = r16 
.device atmega328p
.def Pulsador = r17 
.def temp1 = r18

        sbi     PORTD,PD2 ;Habilita pull up donde está el pulsador.
        sbi     DDRB, PB0	 ;Habilita salida en el pin 0 del puerto B.
		sbi     DDRB, PB5

lazo_infinito:   

        rcall   Debounce
        brcc    else
        tst     Pulsador
        brne    lazo_infinito
        in      temp,PORTB
        ldi     temp1,(1<<PB5)|(1<<PB0)		//(1 << PB0)
        eor     temp,temp1
        out     PORTB,temp
        ldi     Pulsador,1

   rjmp    lazo_infinito

else:
        ldi     Pulsador,0
        rjmp    lazo_infinito

;--- Subrutinas ---

Debounce:

.equ Retardo = 1000
        sbic    PIND,PD2        ; Bit limpio = pulsador presionado.
        rjmp    bit_posicion
        ldi     r25,high(Retardo)
        ldi     r24,low(Retardo) 
delay:  sbiw    r25:r24,1
        brne    delay
        sbic    PIND,PD2        ;¿El pulsador se mantiene presionado?
        rjmp    bit_posicion
        sec 
        ret 
bit_posicion:
        clc 
        ret