#include <stdio.h>
#include "samv71q21b.h"
#include "core_cm7.h"


int main(void) {
    NVIC_EnableIRQ( UART0_IRQn );


    while(1) {
    
        NVIC_SetPendingIRQ( UART0_IRQn );

        for(uint32_t i = 0; i < 64000000; i++) {
            
        }
    }
    return 0;
}

void UART_Callback( void ) {
    uint32_t i = 0;
    for(uint32_t e = 0; e < 64000; e++ ) {
        i++;
    }
}