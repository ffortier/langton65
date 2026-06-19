#include <inttypes.h>
#include <stdint.h>
#include <peekpoke.h>
#include <conio.h>
#include <string.h>
#include <c64.h>

void init_lookup(void);
void init_buffers(void);
void render_buffer(void);
void next_gen(void);

int main() {
    int16_t count;

    POKE(53272, 21);  // Enable uppercase + graphics mode
    POKE(53281, 0); // Background
    POKE(53280, 0); // Border

    clrscr();
    memset(1024, 160, 1024);
    init_lookup();

    while(1) {
        init_buffers();

        for(count = 0; count < 300; count++) {
            render_buffer();
            next_gen();
        }
    }

    return 0;
}
