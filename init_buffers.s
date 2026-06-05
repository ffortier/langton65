.importzp ptr1, next_buf, current_buf

.export _init_buffers
.export buf0
.export buf1

row_i = 2
col_i = 2

.macro staddr  addr, ptr
    lda #<addr
    sta ptr + 0
    lda #>addr
    sta ptr + 1
.endmacro

.macro initcell row, col, val
.scope
    staddr buf0, ptr1
    lda ptr1
    ldy #row
    clc
    adc #col
    bcc @loop
    inc ptr1 + 1
@loop:
    clc
    adc #40
    bcc @next
    inc ptr1 + 1
@next:
    dey
    bne @loop
@end:
    sta ptr1
    lda #val
    sta (ptr1), Y
.endscope
.endmacro

.proc _init_buffers
    staddr buf0, current_buf
    staddr buf1, next_buf

.scope
    lda #0
    ldx #0
@loop:
    sta buf0, X
    sta buf0 + 250, X
    sta buf0 + 500, X
    sta buf0 + 750, X
    sta buf1, X
    sta buf1 + 250, X
    sta buf1 + 500, X
    sta buf1 + 750, X
    inx
    cpx #250
    bne @loop
@end:
.endscope

    ; 1st row
    initcell row_i, col_i, 2
    initcell row_i, col_i+1, 2
    initcell row_i, col_i+2, 2
    initcell row_i, col_i+3, 2
    initcell row_i, col_i+4, 2
    initcell row_i, col_i+5, 2
    initcell row_i, col_i+6, 2
    initcell row_i, col_i+7, 2
    ; 2nd row
    initcell row_i+1, col_i-1, 2
    initcell row_i+1, col_i, 1
    initcell row_i+1, col_i+1, 7
    initcell row_i+1, col_i+2, 0
    initcell row_i+1, col_i+3, 1
    initcell row_i+1, col_i+4, 4
    initcell row_i+1, col_i+5, 0
    initcell row_i+1, col_i+6, 1
    initcell row_i+1, col_i+7, 4
    initcell row_i+1, col_i+8, 2
    ; 3rd row
    initcell row_i+2, col_i-1, 2
    initcell row_i+2, col_i, 0
    initcell row_i+2, col_i+1, 2
    initcell row_i+2, col_i+2, 2
    initcell row_i+2, col_i+3, 2
    initcell row_i+2, col_i+4, 2
    initcell row_i+2, col_i+5, 2
    initcell row_i+2, col_i+6, 2
    initcell row_i+2, col_i+7, 0
    initcell row_i+2, col_i+8, 2
    ; 4th row
    initcell row_i+3, col_i-1, 2
    initcell row_i+3, col_i, 7
    initcell row_i+3, col_i+1, 2
    initcell row_i+3, col_i+2, 0
    initcell row_i+3, col_i+3, 0
    initcell row_i+3, col_i+4, 0
    initcell row_i+3, col_i+5, 0
    initcell row_i+3, col_i+6, 2
    initcell row_i+3, col_i+7, 1
    initcell row_i+3, col_i+8, 2
    ; 5th row
    initcell row_i+4, col_i-1, 2
    initcell row_i+4, col_i, 1
    initcell row_i+4, col_i+1, 2
    initcell row_i+4, col_i+2, 0
    initcell row_i+4, col_i+3, 0
    initcell row_i+4, col_i+4, 0
    initcell row_i+4, col_i+5, 0
    initcell row_i+4, col_i+6, 2
    initcell row_i+4, col_i+7, 1
    initcell row_i+4, col_i+8, 2
    ; 6th row
    initcell row_i+5, col_i-1, 2
    initcell row_i+5, col_i, 0
    initcell row_i+5, col_i+1, 2
    initcell row_i+5, col_i+2, 0
    initcell row_i+5, col_i+3, 0
    initcell row_i+5, col_i+4, 0
    initcell row_i+5, col_i+5, 0
    initcell row_i+5, col_i+6, 2
    initcell row_i+5, col_i+7, 1
    initcell row_i+5, col_i+8, 2
    ; 7th row
    initcell row_i+6, col_i-1, 2
    initcell row_i+6, col_i, 7
    initcell row_i+6, col_i+1, 2
    initcell row_i+6, col_i+2, 0
    initcell row_i+6, col_i+3, 0
    initcell row_i+6, col_i+4, 0
    initcell row_i+6, col_i+5, 0
    initcell row_i+6, col_i+6, 2
    initcell row_i+6, col_i+7, 1
    initcell row_i+6, col_i+8, 2
    ; 8th row
    initcell row_i+7, col_i-1, 2
    initcell row_i+7, col_i, 1
    initcell row_i+7, col_i+1, 2
    initcell row_i+7, col_i+2, 2
    initcell row_i+7, col_i+3, 2
    initcell row_i+7, col_i+4, 2
    initcell row_i+7, col_i+5, 2
    initcell row_i+7, col_i+6, 2
    initcell row_i+7, col_i+7, 1
    initcell row_i+7, col_i+8, 2
    initcell row_i+7, col_i+9, 2
    initcell row_i+7, col_i+10, 2
    initcell row_i+7, col_i+11, 2
    initcell row_i+7, col_i+12, 2
    ; 9th row
    initcell row_i+8, col_i-1, 2
    initcell row_i+8, col_i, 0
    initcell row_i+8, col_i+1, 7
    initcell row_i+8, col_i+2, 1
    initcell row_i+8, col_i+3, 0
    initcell row_i+8, col_i+4, 7
    initcell row_i+8, col_i+5, 1
    initcell row_i+8, col_i+6, 0
    initcell row_i+8, col_i+7, 7
    initcell row_i+8, col_i+8, 1
    initcell row_i+8, col_i+9, 1
    initcell row_i+8, col_i+10, 1
    initcell row_i+8, col_i+11, 1
    initcell row_i+8, col_i+12, 1
    initcell row_i+8, col_i+13, 2
    ; 10th row
    initcell row_i+9, col_i, 2
    initcell row_i+9, col_i+1, 2
    initcell row_i+9, col_i+2, 2
    initcell row_i+9, col_i+3, 2
    initcell row_i+9, col_i+4, 2
    initcell row_i+9, col_i+5, 2
    initcell row_i+9, col_i+6, 2
    initcell row_i+9, col_i+7, 2
    initcell row_i+9, col_i+8, 2
    initcell row_i+9, col_i+9, 2
    initcell row_i+9, col_i+10, 2
    initcell row_i+9, col_i+11, 2
    initcell row_i+9, col_i+12, 2

    rts
.endproc

.segment "BSS"

buf0: .res 1024
buf1: .res 1024
