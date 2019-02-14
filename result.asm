#include p18f87k22.inc

    global  result
    
result	
smaller_than_21
    movwf   sum
    movlw   0x15
    cpfslt  sum
    goto    equal_to_21
    goto    Choice_hit_or_stand
    return

equal_to_21

    cpfseq  sum
    goto    larger_than_21
    goto    win
    return

larger_than_21
    
    goto    lose
    return