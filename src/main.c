#include "ruleset.h"
#include <inttypes.h>
#include <stdint.h>
#include <peekpoke.h>
#include <stdio.h>
#include <conio.h>
#include <string.h>
#include <c64.h>
#include <stdlib.h>

void init_lookup(void);
void init_buffers(void);
void render_buffer(void);
void next_gen(void);

int main() {
    clrscr();

    POKE(53272, 21);  // Enable uppercase + graphics mode
    POKE(53281, 0); // Background
    POKE(53280, 0); // Border

    memset(1024, 160, 1024);

    init_buffers();
    init_lookup();

   while(1) {
        render_buffer();
        next_gen();
    }

    return 0;
}

void dump(uint32_t regs) {
    uint16_t sreg;
    uint8_t x;
    uint8_t a;

    sreg = regs>>16;
    x = (regs >> 8) & 0xff;
    a = regs & 0xff;

    printf("sreg = %05"PRIo16", x=%"PRIu8", y=%"PRIu8"\n", sreg, x, a);

    exit(1);
}
