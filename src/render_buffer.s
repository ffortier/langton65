.import buf0, buf1

.export _render_buffer

COLOR_MEM = $D800

.proc _render_buffer
    ldx #0
@loop:
    lda buf1, X
    sta COLOR_MEM, X
    sta buf0, X
    lda buf1 + 250, X
    sta COLOR_MEM + 250, X
    sta buf0 + 250, X
    lda buf1 + 500, X
    sta COLOR_MEM + 500, X
    sta buf0 + 500, X
    lda buf1 + 750, X
    sta COLOR_MEM + 750, X
    sta buf0 + 750, X
    inx
    cpx #250
    bne @loop
@end:
    rts
.endproc
