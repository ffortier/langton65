.importzp tmp4, sreg
.import buf0, buf1, _match
.export _next_gen

.macro computemask offset
    lda #0
    sta sreg
    sta sreg + 1

    lda buf0 + offset - 40, X
    asl
    asl
    asl
    sta sreg + 1

    lda buf0 + offset + 1, X
    ora sreg + 1
    asl
    sta sreg + 1

    lda buf0 + offset + 40, X
    lsr
    lsr
    ora sreg + 1
    sta sreg + 1

    lda buf0 + offset + 40, X
    and #3
    asl
    asl
    asl
    sta sreg

    lda buf0 + offset - 1, X
    ora sreg
    asl
    asl
    asl
    sta sreg

    lda buf0 + offset, X
.endmacro

.macro updatecell offset
    computemask offset
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

.ifdef TESTING
.export _computemask_test_top
.export _computemask_test_right
.export _computemask_test_bottom
.export _computemask_test_left
.export _computemask_match_test

.macro computemask_test test_offset
    ldx #250
    lda #0

@loop:
    sta buf0, X
    dex
    bne @loop
@end:

    ldx #test_offset
    lda #5
    sta buf0, X

    ldx #41
    stx tmp4
    computemask 0
.endmacro

.proc _computemask_test_top
    computemask_test 1
    rts
.endproc

.proc _computemask_test_right
    computemask_test 42
    rts
.endproc

.proc _computemask_test_bottom
    computemask_test 81
    rts
.endproc

.proc _computemask_test_left
    computemask_test 40
    rts
.endproc

.proc _computemask_match_test
    ldx #250
    lda #0

@loop:
    sta buf0, X
    dex
    bne @loop
@end:
    ; 002525
    ldx #1
    lda #0
    sta buf0, X

    ldx #42
    lda #2
    sta buf0, X

    ldx #81
    lda #5
    sta buf0, X

    ldx #40
    lda #2
    sta buf0, X

    ldx #41
    lda #7
    sta buf0, X
    stx tmp4

    computemask 0
    jsr _match

    rts
.endproc

.endif
