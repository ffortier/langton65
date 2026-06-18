#ifndef RULESET_H
#define RULESET_H

#include <stdint.h>

typedef struct {
    uint8_t sz;
    uint16_t rules[];
} ruleset_t;

extern ruleset_t r0;
extern ruleset_t r1;
extern ruleset_t r2;
extern ruleset_t r3;
extern ruleset_t r4;
extern ruleset_t r5;
extern ruleset_t r6;
extern ruleset_t r7;
extern uint8_t magic[4];
#endif
