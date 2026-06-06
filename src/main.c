#include <stdint.h>
#include <peekpoke.h>
#include <conio.h>
#include <string.h>

#if __C64__
#include <c64.h>
#endif

void init_lookup(void);
void init_buffers(void);
void render_buffer(void);
void next_gen(void);
uint8_t match(uint32_t param);
#include <stdio.h>
int main() {
    #if __C64__
    clrscr();
    #endif

    POKE(53272, 21);  // Enable uppercase + graphics mode
    POKE(53281, 0); // Background
    POKE(53280, 0); // Border

    memset(1024, 160, 1024);

    init_lookup();
    init_buffers();

    while(1) {
        render_buffer();
        next_gen();
    }

    return 0;
}
