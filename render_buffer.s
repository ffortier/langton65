.import buf0

.export _render_buffer

COLOR_MEM = $D800

.proc _render_buffer
    ldx #0
@loop:
    lda buf0, X
    sta COLOR_MEM, X
    lda buf0 + 250, X
    sta COLOR_MEM + 250, X
    lda buf0 + 500, X
    sta COLOR_MEM + 500, X
    lda buf0 + 750, X
    sta COLOR_MEM + 750, X
    inx
    cpx #250
    bne @loop
@end:
    rts
.endproc
