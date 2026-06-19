
.importzp tmp1, tmp3, ptr1, sreg
.importzp ruleset_lookup
.import _rotate, _dump
.export _match

.macro ldsz
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
.endmacro

.proc _match
    sta tmp1
    lda #4
    sta tmp3
    lda tmp1

@again:
    ldsz

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
    dec tmp3
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
