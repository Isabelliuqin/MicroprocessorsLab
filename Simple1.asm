	#include p18f87k22.inc

	extern	UART_Setup, UART_Transmit_Message   ; external UART subroutines
	extern	KEYPAD_Setup, KEYPAD_ini_TABLE, Keypad_Input,Keypad_button_ini
	extern  LCD_Setup, LCD_Write_Message	    ; external LCD subroutines
	extern	LCD_Write_Hex, LCD_row_shift,LCD_clear,LCD_delay_x4us,LCD_delay_ms,LCD_row_return,LCD_sq,LCD_rightcorner,LCD_cursoroff,LCD_leftshift4; external LCD subroutines
	extern  ADC_Setup, ADC_Read		    ; external ADC routines
	extern	multip
	extern	counter_setup, table_setup, counter_pickvalue
	extern	clear_memory400_420, clear_memory450_460
	extern	ini_carddealer,ini_cardplayer
	extern	title_setup, Title_press_to_start
	

	
rst	code	0    ; reset vector
	goto	setup


main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	call	counter_setup
	call	KEYPAD_Setup
	call	KEYPAD_ini_TABLE
	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup LCD
	call	ADC_Setup	; setup ADC
	;call	LCD_cursoroff	; turn the cursor of LCD display off
	call	table_setup
	
	call	clear_memory400_420
	call	clear_memory450_460
	
	call	title_setup
	call	Keypad_button_ini
	
	call	hit_setup
	goto	main

	
	; ******* Main programme ****************************************
main
	call	Title_press_to_start
	
	call	ini_carddealer
	call	ini_cardplayer

    

    
    



    

    

    end