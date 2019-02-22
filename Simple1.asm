	#include p18f87k22.inc

	
	extern	KEYPAD_Setup, KEYPAD_ini_TABLE, Keypad_Input,Keypad_button_ini
	extern  LCD_Setup, LCD_Write_Message	    ; external LCD subroutines
	extern	LCD_Write_Hex, LCD_row_shift,LCD_delay_x4us,LCD_delay_ms,LCD_row_return,LCD_sq,LCD_rightcorner,LCD_cursoroff,LCD_leftshift4; external LCD subroutines
	extern	LCD_cursoron
	extern	Write_ten
	
	extern	counter_setup, table_setup, counter_pickvalue
	extern	clear_memory400_420, clear_memory450_460,clear_sum
	extern	ini_carddealer,ini_cardplayer
	extern	title_setup, Title_press_to_start
	extern	Command_setup, Command_make_choice,command_start
	extern	Result_setup,Result_before_dealerdrawcards,Result_after_dealerdrawcards
	
	global	Simple_player_yes,Simple_player_no

	
rst	code	0    ; reset vector
	goto	setup


main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	;call	Write_ten
	call	counter_setup
	call	KEYPAD_Setup
	call	KEYPAD_ini_TABLE
	call	LCD_Setup	; setup LCD
	
	
	;call	LCD_cursoroff	; turn the cursor of LCD display off
	call	table_setup

	call	clear_memory400_420
	call	clear_memory450_460
	call	clear_sum
	call	Result_setup
	call	title_setup
	call	Keypad_button_ini
	
	call	Command_setup
	goto	main

	
	; ******* Main programme ****************************************
main
	call	LCD_cursoroff
	
	call	Title_press_to_start
	
	call	ini_carddealer
	call	LCD_cursoron
	call	ini_cardplayer

Simple_player_yes				    ;after player's first two cards, run through result section; called by command make choice
	call	Result_before_dealerdrawcards	    ;check the result: Win Lose, or return to choice page to continue the game
	call	command_start			    ;LCD display the choice page
	call	Command_make_choice		    ;loop back to command module			
Simple_player_no
    	call	Result_after_dealerdrawcards
	;call	drawcard_dealer_after_player
	goto    $

    

    
    



    

    

    end