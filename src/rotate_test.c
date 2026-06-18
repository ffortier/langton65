
#include <stdint.h>
#include <assert.h>

uint32_t rotate(uint32_t);

int main() {
    uint32_t original, expected, actual;

    original = ((uint32_t)000000 << 16) | 0;
    expected = ((uint32_t)000000 << 16) | 0;

    actual = rotate(original);

    assert(expected == actual);

    original = ((uint32_t)012340 << 16) | 0;
    expected = ((uint32_t)023410 << 16) | 0;

    actual = rotate(original);

    assert(expected == actual);

    original = ((uint32_t)012340 << 16) | 2;
    expected = ((uint32_t)023410 << 16) | 2;

    actual = rotate(original);

    assert(expected == actual);

    return 0;
}
