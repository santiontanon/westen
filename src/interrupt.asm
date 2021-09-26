;-----------------------------------------------
; Loads the interrupt hook for playing music:
setup_custom_interrupt:
    ld  a,JP_OPCODE    ;NEW HOOK SET
    di
        ld  (TIMI),a
        ld  hl,interrupt_callback
        ld  (TIMI+1),hl
    ei
    ret


; ------------------------------------------------
; My interrupt handler:
interrupt_callback:
;     push af
    push hl
        ;ld hl,vsyncs_since_last_frame
        ;ld a,(hl)
        ;cp 4
        ;jp p,interrupt_callback_do_not_increment_vsyncs
        ;inc a
        ;ld (hl),a
;interrupt_callback_do_not_increment_vsyncs:
        ;inc hl
;         ld a,(deterministic)
;         or a
;         call z,randomSeedUpdate
        ld hl,interrupt_cycle
        inc (hl)
;         out (#2c),a
        call update_sound
;         out (#2d),a
    pop hl
;     pop af
    ei
    ret
