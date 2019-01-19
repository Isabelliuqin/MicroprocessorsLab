	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	movlw 	0x0
	movwf	TRISD, ACCESS	    ; Port D all outputs
	 

control1	movlw	01001110	    ; 0100,CP2OE2CP1OE1,Set OE12 and CP12 to high, OE inverted
	movwf	TRISD, ACCESS
	
	clrf	TRISE		    ; Clear PORTE
	;movlw	0x00
	;movwf	TRISE, ACCESS	     ; Set PORTE to output
	movlw  0x10
	movwf	LATE, A		     ; Port B value
	
	movlw	01001100	      ; lowering CP1
	movwf	TRISD, ACCESS
	
	Call	delay
	
	movlw	01001110	      ; Let CP1 goes upward
	movwf	TRISD, ACCESS          
	
DATA1	setf	TRISE	               ; Set PORTE in TRIS state
	
	goto    Control2	
	
delay	DECFSZ  0x20, F, ACCESS
	BRA     delay
	RETURN  0	

Control2
	
	
	
	
data	movlw	
	
loop	movff 	0x06, PORTD
	incf 	0x06, W, ACCESS
	
test	movwf	0x06, ACCESS	    ; Test for end of loop condition
	movlw 	0x63
	cpfsgt 	0x06, ACCESS
	
	MOVLW   0x10
	MOVWF   0x20, ACCESS
	MOVWF   0x30, ACCESS
	call    delay1
	
count	bra 	loop		    ; Not yet finished goto start of loop again
	goto 	0x0		    ; Re-run program from start
	
delay1	DECFSZ  0x20, F, ACCESS
        CALL    delay2
	BRA     delay1
	RETURN  0
	
delay2  DECFSZ  0x30, F, ACCESS
	BRA     delay2
	RETURN  0
	
	end
