	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start

Init_PORTD
	clrf	TRISD, ACCESS	    ; Port D all outputs
	movlw	0x0F;00001111	      ;Setting CP1, cp2, high and OE*1 OE*2 HIGH
	movwf	PORTD, ACCESS
	
Init_PORTE
	setf	TRISE, A	
Init_PORTH
	clrf	TRISH, A	
	
Init_delay	
	movlw	0x2		    ; for delay
	movwf	0x20,ACCESS	 

main
	movlw	0xA5
	call	Write_Mem1
	call	Read_Mem1
	
	goto	0x0	

Write_Mem1 ;write data to memory flipflop
	clrf	TRISE
	movwf	PORTE		    ;Initiate DATA in PORTE
	movlw	0X0D;00001101	      ; lowering CP1	
	movwf	PORTD, ACCESS	
	Call	delay	
 	movlw	0x0F;00001111	      ; rising CP1
	movwf	PORTD, ACCESS          
	setf	TRISE
	return
	
Read_Mem1 ;Read data from memery flipflop
	setf	TRISE ; Set PORTE in TRIS state		
	movlw	0x0E;00001110	    ; 0100,CP2OE2CP1OE1,Set OE*1 to low and CP1 to high
	movwf	PORTD, ACCESS	    ; output M1
	movf	PORTE, W		    ; reads data back into W
	movwf	PORTH
	MOVLW	0x0F;00001111	    ; 0100,CP2OE2CP1OE1; Set OE*1 high and CP1 to high, set two flipflops back to output
	movwf	PORTD, ACCESS 
	RETURN  
	
delay	DECFSZ  0x20, F, ACCESS
	BRA     delay
	RETURN  	

	end
