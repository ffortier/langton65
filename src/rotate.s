.importzp tmp2, sreg
.export _rotate

.proc _rotate
    pha

    lda sreg + 1
    and #%01110000
    lsr
    sta tmp2

    asl sreg
    rol sreg + 1
    asl sreg
    rol sreg + 1
    asl sreg
    rol sreg + 1

    lda sreg + 1
    and #$7f
    sta sreg + 1

    lda sreg
    ora tmp2
    sta sreg

    pla
    rts
.endproc
