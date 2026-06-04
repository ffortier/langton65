#include <stdio.h>
#include <stdint.h>
#include <peekpoke.h>
#include <c64.h>
#include <conio.h>
#include <string.h>

#include "ruleset.h"

void init_lookup(void);
void init_buffers(void);
void render_buffer(void);
uint8_t match(uint32_t param);

int main() {
    uint8_t next;

    clrscr();

    POKE(53272, 21);  // Enable uppercase + graphics mode

    init_lookup();
    init_buffers();
    
    memset(1024, 160, 1024);

    while(1) {
        render_buffer();
    }

    return 0;
}