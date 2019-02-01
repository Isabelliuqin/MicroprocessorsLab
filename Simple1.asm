	#include p18f87k22.inc

	extern	UART_Setup, UART_Transmit_Message  ; external UART subroutines
	extern  LCD_Setup, LCD_Write_Message,LCD_Send_Byte_D, LCD_delay_x4us	    ; external LCD subroutines
	extern	ini_TABLE, KEYPAD_Setup, Input
	



rst	code	0    ; reset vector
	goto	setup

pdata	code    ; a section of programme memory for storing data
	; ******* myTable, data in programme memory, and its length *****
	
main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	CALL	ini_TABLE
	call	KEYPAD_Setup
	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup LCD
	
	goto	start
	
	; ******* Main programme ****************************************
start 	call	Input
	call	LCD_Send_Byte_D ;output w on LCD
	movlw   .1000		; wait 0.4s
	call    LCD_delay_x4us
;	movlw	

	goto	start		; goto current line in code

	end