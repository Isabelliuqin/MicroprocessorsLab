# Microprocessors
Repository for Physics Year 3 microprocessors lab project

A simple assembly program for PIC18 microprocessor, that counts to 100, putting the current count value out onto PORTB

RNG.asm: read counter values (counts from 0 to 12), send ASCII code

Title.asm: displays the title page on the LCD screen at the beginning of the game and interfaces with the keypad input to load the game

Card.asm: displays the user interface, shifts the cursor position following the keypad input and interprets the command of the user

drawcard_dealer_LCDwrite.asm: part of the card module

Command.asm: displays the user interface, shifts the cursor position following the keypad input and interprets the command of the user

cursor.asm: control the movement of the cursor and store the user's choice

Recovery.asm: reads the card points and rewrites the card faces on the LCD screen

Result.asm: determines the outcome of the game and displays the outcome on the LCD screen





---------------------------------------------------------------------------------------------------------------------------------------

LCD.asm: Initialises LCD and writes the message to the LCD

clear_memory.asm: clear memory location for data storage and summation

Change_Ace.asm: Change the card point of Ace depending on hand totals

keypad.asm: detect the user input






 




