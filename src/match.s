
.importzp tmp1, tmp3, ptr1, sreg, rotation_counter, sz
.importzp ruleset_lookup
.import _rotate, _dump
.export _match

SMCPTR = $d000

.ifndef SMC
.proc _match
    sta tmp1
    lda #4          ; Init rotation counter in tmp3
    sta rotation_counter
    lda tmp1

    asl             ; Lookup ruleset address and modify the code
    tax
    lda ruleset_lookup, X
    sta @smc1 + 1
    sta @smc2 + 1
    sta @smc3 + 1
    sta @smc4 + 1
    lda ruleset_lookup + 1, X
    sta @smc1 + 2
    sta @smc2 + 2
    sta @smc3 + 2
    sta @smc4 + 2
    ldy #0
@smc1:
    ldx SMCPTR, Y
    stx sz

@again:
    ldx sz
    ldy #1

@loop:
@smc2:
    lda SMCPTR, Y
    and #$f8
    cmp sreg
    bne @next
    jmp @found
@next:
    iny
@next1:
    iny
    dex
    bne @loop
@end:
    dec rotation_counter
    bne @retry
    lda tmp1
    rts
@retry:
    lda tmp1
    jsr _rotate
    jmp @again
@found:
    iny
@smc3:
    lda SMCPTR, Y
    cmp sreg + 1
    bne @next1
    dey
@smc4:
    lda SMCPTR, Y
    and #$07
    rts

.endproc

.else

.proc _match
    sta tmp1
    lda #4
    sta rotation_counter
    lda tmp1

    asl
    tax
    lda ruleset_lookup, X
    sta ptr1
    lda ruleset_lookup + 1, X
    sta ptr1 + 1
    ldy #0
    lda (ptr1), Y
    iny
    tax
    stx sz

@again:
    ldx sz
    ldy #1

@loop:
    lda (ptr1), Y
    and #$f8
    cmp sreg
    bne @next
    jmp @found
@next:
    iny
@next1:
    iny
    dex
    bne @loop
@end:
    dec rotation_counter
    bne @retry
    lda tmp1
    rts
@retry:
    lda tmp1
    jsr _rotate
    jmp @again
@found:
    iny
    lda (ptr1), Y
    cmp sreg + 1
    bne @next1
    dey
    lda (ptr1), Y
    and #$07
    rts
.endproc
.endif
