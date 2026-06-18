#include <stdint.h>
#include <stdio.h>
#include <inttypes.h>
#include <assert.h>

uint32_t computemask_test_top();
uint32_t computemask_test_right();
uint32_t computemask_test_bottom();
uint32_t computemask_test_left();
uint32_t computemask_match_test();
void init_lookup();

int main() {
    uint32_t actual;
    uint16_t mask;
    uint8_t res;

    init_lookup();

    actual = computemask_test_top();
    assert((actual >> 16) == 050000);
    actual = computemask_test_right();
    assert((actual >> 16) == 005000);
    actual = computemask_test_bottom();
    assert((actual >> 16) == 000500);
    actual = computemask_test_left();
    assert((actual >> 16) == 000050);

    actual = computemask_match_test();
    mask = actual >> 16;
    res = actual & 0xff;

    printf("res=%"PRIo8", mask=%05"PRIo16"\n", res, mask);
    assert(res == 5);

    return 0;
}
