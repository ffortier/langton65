#include <stdint.h>
#include <stdio.h>
#include <assert.h>

uint32_t computemask_test_top();
uint32_t computemask_test_right();
uint32_t computemask_test_bottom();
uint32_t computemask_test_left();

int main() {
    uint32_t mask;

    mask = computemask_test_top();
    assert((mask >> 16) == 050000);
    mask = computemask_test_right();
    assert((mask >> 16) == 005000);
    mask = computemask_test_bottom();
    assert((mask >> 16) == 000500);
    mask = computemask_test_left();
    assert((mask >> 16) == 000050);

    return 0;
}
