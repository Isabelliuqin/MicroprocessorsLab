#include p18f87k22.inc

setup
	setf	PORTE
	; ******* Programme FLASH read Setup Code ***********************
	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory