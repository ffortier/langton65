
.importzp tmp1, ptr1, sreg
.importzp ruleset_lookup

.export _match

; Loads the size of a ruleset
; Params
;   A ruleset number
; Returns
;   X ruleset size
;   Y rules offset
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

; match the current state to the next
; Params
;   A current cell value
;   sreg lo byte of the neighbour mask
;   sreg hi byte of th neighbour mask
; Returns
;   A next cell value
.proc _match
    sta tmp1
    ldsz

@loop:
    lda (ptr1), Y
    and sreg + 0
    cmp sreg + 0
    bne @next
    jmp @found
@next:
    iny
@next1:
    iny
    dex
    bne @loop
@end:
    lda tmp1
    rts
@found:
    iny
    lda (ptr1), Y
    cmp sreg + 1
    bne @next1
    dey
    lda (ptr1), Y
    and #7
    rts
.endproc
