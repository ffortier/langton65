.import _r0, _r1, _r2, _r3, _r4, _r5, _r6, _r7
.importzp ruleset_lookup

.export _init_lookup

.macro staddr  addr, ptr
    lda #<addr
    sta ptr + 0
    lda #>addr
    sta ptr + 1
.endmacro

.proc _init_lookup
    staddr _r0, ruleset_lookup + 0
    staddr _r1, ruleset_lookup + 2
    staddr _r2, ruleset_lookup + 4
    staddr _r3, ruleset_lookup + 6
    staddr _r4, ruleset_lookup + 8
    staddr _r5, ruleset_lookup + 10
    staddr _r6, ruleset_lookup + 12
    staddr _r7, ruleset_lookup + 14
    rts
.endproc
