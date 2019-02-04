#include p18f87k22.inc
    global multip
    extern LCD_Send_Byte_D,LCD_delay_x4us,LCD_shift	
	
acs0	udata_acs   ; reserve data space in access ram
multip1	res 1
multip2	res 1
multip3	res 1
multip4	res 1
rem1	res 1
rem2	res 1
rem3	res 1
rem4	res 1
boss1	res 1
boss2	res 1
boss3	res 1
boss4	res 1

	
multipl	code	
multip	
multip_step1	
	; LINE1: ARG1L x ARG2L
	; LINE2: ARG1H x ARG2L
	; LINE3: ARG1L x ARG2H
	; LINE4: ARG1H x ARG2H
	
	movlw	0x8A
	mulwf	ADRESL		;LINE1
	movff	PRODH, multip2
	movff	PRODL, multip1	
	
	movlw	0x41
	mulwf	ADRESH		;LINE4
	movff	PRODH, multip4
	movff	PRODL, multip3	
		
	mulwf	ADRESL		;LINE3
	
	movf	PRODL, W
	addwf	multip2, f
	movf	PRODH, W
	addwfc	multip3, f
	movlw   0
	addwfc	multip4, f

	movlw	0x8A		
	mulwf	ADRESH		;LINE2
	
	movf	PRODL, W
	addwf	multip2, f
	movf	PRODH, W
	addwfc	multip3, f
	movlw   0
	addwfc	multip4, f
	
	movff	multip4, boss4  ;store the highest order digit in big boss register	   
			
multip_step2		
	;step 2
	
	; LINE1: ARG1L x 0A
	; LINE2: ARG1H x 0A
	; LINE3: ARG1HH x 0A

	movlw	0x0A
	mulwf	multip1		;LINE1
	movff	PRODH, rem2
	movff	PRODL, rem1	
	
	
	mulwf	multip3 	;LINE3
	movff	PRODH, rem4
	movff	PRODL, rem3	
	
	
	mulwf	multip2		;LINE2
	
	movf	PRODL, W
	addwf	rem2, f
	movf	PRODH, W
	addwfc	rem3, f
	movlw   0
	addwfc	rem4, f
	
	movff	rem4, boss3  ;store the second highest order digit in big boss register	
	
	
	
multip_step3		
	;step 3
	
	; LINE1: ARG1L x 0A
	; LINE2: ARG1H x 0A
	; LINE3: ARG1HH x 0A
	
	movlw	0x0A
	mulwf	rem1		;LINE1
	movff	PRODH, multip2
	movff	PRODL, multip1	
	
	
	mulwf	rem3		;LINE3
	movff	PRODH, multip4
	movff	PRODL, multip3	
	
	
	mulwf	rem2		;LINE2
	
	movf	PRODL, W
	addwf	multip2, f
	movf	PRODH, W
	addwfc	multip3, f
	movlw   0
	addwfc	multip4, f
	
	movff	multip4, boss2  ;store the third highest order digit in big boss register	
	
multip_step4		
	;step 4
	
	; LINE1: ARG1L x 0A
	; LINE2: ARG1H x 0A
	; LINE3: ARG1HH x 0A

	movlw	0x0A
	mulwf	multip1		;LINE1
	movff	PRODH, rem2
	movff	PRODL, rem1	
	
	
	mulwf	multip3		;LINE3
	movff	PRODH, rem4
	movff	PRODL, rem3	
	
	
	mulwf	multip2		;LINE2
	
	movf	PRODL, W
	addwf	rem2, f
	movf	PRODH, W
	addwfc	rem3, f
	movlw   0
	addwfc	rem4, f
	
	movff	rem4, boss1  ;store the lowest order digit in big boss register
	
	
	;display
	
	movf	boss4,w    ;first digit
	addlw	0x30
	call	LCD_Send_Byte_D	

	movf	boss3,w    ;first digit
	addlw	0x30
	call	LCD_Send_Byte_D

	movf	boss2,w    ;first digit
	addlw	0x30
	call	LCD_Send_Byte_D
	
	movf	boss1,w    ;first digit
	addlw	0x30
	call	LCD_Send_Byte_D
	
	return
	
	end

	


