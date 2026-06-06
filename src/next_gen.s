.importzp tmp4, sreg
.import buf0, buf1, _match
.export _next_gen

;top right bottom left

.macro updatecell offset
    lda #0
    sta sreg
    sta sreg + 1

    lda buf0 + offset - 40, X
    lsr
    lsr
    lsr
    sta sreg

    lda buf0 + offset + 1, X
    ora sreg
    lsr

    lda buf0 + offset + 40, X
    ror
    ror
    ora sreg
    sta sreg
    lda buf0 + offset + 40, X
    ror
    lsr
    lsr
    lsr
    sta sreg + 1

    lda buf0 + offset - 1, X
    ora sreg + 1
    lsr
    lsr
    lsr
    sta sreg + 1

    jsr _match
    ldx tmp4
    sta buf1 + offset, X
.endmacro

.proc _next_gen
    ldx #0
@loop:
    stx tmp4

    updatecell 0
    updatecell 250
    updatecell 500
    updatecell 750

    inx
    cpx #250
    beq @end
    jmp @loop
@end:
    rts
.endproc
