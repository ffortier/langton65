#include <stdint.h>
#include <assert.h>
#include <stdio.h>

uint8_t __fastcall__  match(uint32_t);
void init_lookup(void);

int main() {
    init_lookup();

    assert(match(((uint32_t)002220<<16)|7) == 1);
    assert(match(((uint32_t)033330<<16)|7) == 7);

    return 0;
}
