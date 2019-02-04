	#include p18f87k22.inc

	extern	UART_Setup, UART_Transmit_Message   ; external UART subroutines
	extern  LCD_Setup, LCD_Write_Message	    ; external LCD subroutines
	extern	LCD_Write_Hex, LCD_row_shift,LCD_clear,LCD_delay_x4us,LCD_delay_ms,LCD_row_return; external LCD subroutines
	extern  ADC_Setup, ADC_Read		    ; external ADC routines
	extern	multip
	
rst	code	0    ; reset vector
	goto	setup


main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup LCD
	call	ADC_Setup	; setup ADC
	
	goto	start
	
	; ******* Main programme ****************************************
start 		
measure_loop
	call	ADC_Read
	movf	ADRESH,W
	call	LCD_Write_Hex
	movf	ADRESL,W
	call	LCD_Write_Hex
		
	call	LCD_delay_ms
	
conversion
	call	LCD_row_shift
	call	multip
	
	call	LCD_delay_ms
	call	LCD_clear
	
	goto	measure_loop		; goto current line in code

	end