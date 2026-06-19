.exportzp ruleset_lookup, current_buf, next_buf, rotation_counter, sz

.zeropage
ruleset_lookup: .res 16
current_buf: .res 2
next_buf: .res 2
rotation_counter: .res 1
sz: .res 1
