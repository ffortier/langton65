#include <stdint.h>
#include <assert.h>
#include <stdio.h>
#include <inttypes.h>
#include "ruleset.h"

uint8_t match(uint32_t);
void init_lookup(void);

#define TEST_RULES(num) do { \
    printf("r" #num ".sz = %d\n", r##num.sz); \
        for (i = 0; i < r##num.sz; i++) { \
            mask = r##num.rules[i] & 0b0111111111111000; \
            expected = r##num.rules[i] & 0b0000000000000111; \
            actual = match(((uint32_t)mask << 16) | num); \
            \
            printf("mask=%05"PRIo16", expected=%"PRIu8", actual=%"PRIu8"\n", mask, expected, actual); \
            assert(expected == actual); \
        } \
    } while(0)

int main() {
    uint8_t i;
    uint16_t mask;
    uint8_t expected;
    uint8_t actual;

    init_lookup();

    TEST_RULES(0);
    TEST_RULES(1);
    TEST_RULES(2);
    TEST_RULES(3);
    TEST_RULES(4);
    TEST_RULES(5);
    TEST_RULES(6);
    TEST_RULES(7);

    assert(match(((uint32_t)033330 <<16 ) | 7) == 7);

    assert(match(((uint32_t)002720 << 16) | 7) == 0);
    assert(match(((uint32_t)027200 << 16) | 7) == 0);
    assert(match(((uint32_t)072020 << 16) | 7) == 0);
    assert(match(((uint32_t)020270 << 16) | 7) == 0);
    assert(match(((uint32_t)000200 << 16) | 0) == 0);

    return 0;
}
