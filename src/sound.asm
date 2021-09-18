;-----------------------------------------------
instrument_profiles:
SquareWave_instrument_profile:
    db 12
Piano_instrument_profile:
    db 13,13,12,11,10,10,9,9,8,8,7,7,6,#ff
Soft_Piano_instrument_profile:
    db 12,11,10,9,8,8,7,7,6,6,5,5,4,#ff
Pad_instrument_profile:
    db 2,6,8,12,12,12,12,12,12,11,10,9,8,7,7,6,6,6,6,5,5,5,5,5,5,5,5,4,4,4,4,4,4,4,4,3, #ff

; This is a complete note table of 5 octaves:
;note_period_table:
;  db 7,119,  7,12,  6,167,  6,71,  5,237,  5,152,  5,71,  4,252,  4,180,  4,112,  4,49,  3,244
;  db 3,188,  3,134,  3,83,  3,36,  2,246,  2,204,  2,164,  2,126,  2,90,  2,56,  2,24,  1,250  
;  db 1,222,  1,195,  1,170,  1,146,  1,123,  1,102,  1,82,  1,63,  1,45,  1,28,  1,12,  0,253
;  db 0,239,  0,225,  0,213,  0,201,  0,190,  0,179,  0,169,  0,159,  0,150,  0,142,  0,134,  0,127
;  db 0,119,  0,113,  0,106,  0,100,  0,95,  0,89,  0,84,  0,80,  0,75,  0,71,  0,67,  0,63

; 9 12 13 15 16 17 18 19 20 21 22 23 24 26 27 28 29 30 32 33 35 36 37 39 40 41 42 44 45 46 47 48 50 51 52 53 54 56 57 58 59 61 63 64 69 
note_period_table:
  db 15,228,  13,93,  12,156,  11,60,  10,155,  10,2,  9,115,  8,235
  db 8,107,  7,242,  7,128,  7,20,  6,174,  5,244,  5,158,  5,77
  db 5,1,  4,185,  4,53,  3,249,  3,138,  3,87,  3,39,  2,207
  db 2,167,  2,129,  2,93,  2,27,  1,252,  1,224,  1,197,  1,172
  db 1,125,  1,104,  1,83,  1,64,  1,46,  1,13,  0,254,  0,240
  db 0,226,  0,202,  0,180,  0,170,  0,127


;-----------------------------------------------
; starts playing a song 
; arguments: 
; - a: MUSIC_tempo
PlayMusic:
    ld (MUSIC_tempo),a
    call StopMusic
    di
    ld a,1
    ld hl,music_buffer
    ld (MUSIC_play),a
    ld (MUSIC_pointer),hl
    ld (MUSIC_start_pointer),hl
    ld hl,MUSIC_repeat_stack
    ld (MUSIC_repeat_stack_ptr),hl
    ei
    ret


;-----------------------------------------------
StopMusic:
    di
    ld hl,beginning_of_sound_variables_except_tempo
    ld b,end_of_sound_variables - beginning_of_sound_variables_except_tempo
    xor a
StopMusic_loop:
    ld (hl),a
    inc hl
    djnz StopMusic_loop
    call clear_PSG_volume
    ei
    ret


;-----------------------------------------------
ResumeMusic:
    ld a,1
    ld (MUSIC_play),a
    ret


;-----------------------------------------------
PauseMusic:
    xor a
    ld (MUSIC_play),a
    ; jp clear_PSG_volume


;-----------------------------------------------
; silences all 3 channels of the PSG
clear_PSG_volume:
    ld a,8
    ld e,0
    call WRTPSG
    ld a,9
    ld e,0
    call WRTPSG
    ld a,10
    ld e,0
    jp WRTPSG


;-----------------------------------------------
; Music player update routine
; We do not need to push "af", since this is called from within the custom_interrupt, which already pushed af and bc
update_sound:     ; This routine sould be called 50 or 60 times / sec 
    ld a,(MUSIC_play)
    or a
    jr z,update_sound_no_music_no_pop_bc_de
    push de
        call update_sound_handle_instruments

        ld a,(MUSIC_tempo_counter)
        or a
        jr nz,update_sound_skip
        push ix
        push hl
            ld ix,(MUSIC_repeat_stack_ptr)
;             xor a  ; unnecessary, a must be 0 here
            ld (MUSIC_time_step_required),a
            ld hl,(MUSIC_pointer)
            call update_sound_internal
            ld (MUSIC_pointer),hl
            ld (MUSIC_repeat_stack_ptr),ix
            pop hl
        pop ix
        ld a,(MUSIC_tempo)
        ld (MUSIC_tempo_counter),a
        jr update_sound_music_done

update_sound_skip:
        dec a
        ld (MUSIC_tempo_counter),a
update_sound_music_done:
    pop de
update_sound_no_music_no_pop_bc_de:
    ld a,(SFX_priority)
    or a
    jr z,update_sound_no_sfx
    push hl
    push de
        xor a
        ld (MUSIC_time_step_required),a
        ld hl,(SFX_pointer)
        call update_sound_internal
        ld (SFX_pointer),hl
    pop de
    pop hl
update_sound_no_sfx:
    ret


;-----------------------------------------------
; Starts playing an SFX
; arguments: 
; - a: SFX priority
; - hl: pointer to the SFX to play
play_SFX_with_high_priority:
    ld a,SFX_PRIORITY_HIGH
play_SFX_with_priority:
    push hl
        ld hl,SFX_priority
        cp (hl)
    pop hl
    jp m,play_SFX_with_priority_ignore
    di
    ld (SFX_pointer),hl
    ld (SFX_priority),a
    xor a
    ld (MUSIC_instruments+2),a  ;; reset the instrument in channel 3 to Square wave, so it does not interfere with the SFX
    ei
play_SFX_with_priority_ignore:
    ret


;-----------------------------------------------
; handle the different curves of the music instruments
update_sound_handle_instruments:
    ld a,(MUSIC_instruments)
    or a  ; MUSIC_INSTRUMENT_SQUARE_WAVE
    jr z,update_sound_handle_instruments_CH2
    ld de,(MUSIC_instrument_envelope_ptr)
    ld a,(de)
    cp #ff
    jr z,update_sound_handle_instruments_CH2
    inc de
    ld (MUSIC_instrument_envelope_ptr),de
    ld e,a
    ld a,8
    call WRTPSG
update_sound_handle_instruments_CH2:
    ld a,(MUSIC_instruments+1)
    or a  ; MUSIC_INSTRUMENT_SQUARE_WAVE
    jr z,update_sound_handle_instruments_CH3
    ld de,(MUSIC_instrument_envelope_ptr+2)
    ld a,(de)
    cp #ff
    jr z,update_sound_handle_instruments_CH3
    inc de
    ld (MUSIC_instrument_envelope_ptr+2),de
    ld e,a
    ld a,9
    call WRTPSG
update_sound_handle_instruments_CH3:
    ld a,(SFX_priority)
    or a
    ret nz  ; if there is an SFX playing, then do not update the instruments in channel 3!
    ld a,(MUSIC_instruments+2)
    or a  ; MUSIC_INSTRUMENT_SQUARE_WAVE 
    ret z
    ld de,(MUSIC_instrument_envelope_ptr+4)
    ld a,(de)
    cp #ff
    ret z
    inc de
    ld (MUSIC_instrument_envelope_ptr+4),de
    ld e,a
    ld a,10
    jp WRTPSG


update_sound_SET_INSTRUMENT:
    ld d,(hl)   ; instrument
    inc hl
    ld a,(hl)   ; channel
    inc hl
    push hl
        cp 2
        jr nz,update_sound_SET_INSTRUMENT_not_third_channel
        ld hl,MUSIC_channel3_instrument_buffer
        ld (hl),d
update_sound_SET_INSTRUMENT_not_third_channel:
        ld hl,MUSIC_instruments
        ADD_HL_A
        ld (hl),d
    pop hl
    jr update_sound_internal_loop


update_sound_GOTO:
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld hl,(MUSIC_start_pointer)
    add hl,de
    ; we also need to silence channels 1 and 2, just in case
    ld a,8
    ld e,0
    call WRTPSG
    ld a,9
    ld e,0
    call WRTPSG    
    xor a
    ld (MUSIC_instruments),a
    ld (MUSIC_instruments+1),a
    jr update_sound_internal_loop


update_sound_REPEAT:
    ld a,(hl)
    inc hl
    ld (ix),a
    ld (ix+1),l
    ld (ix+2),h
    inc ix
    inc ix
    inc ix
    jr update_sound_internal_loop


update_sound_END_REPEAT:
    ;; decrease the top value of the repeat stack
    ;; if it is 0, pop
    ;; if it is not 0, goto the repeat point
    ld a,(ix-3)
    dec a
    jr z,update_sound_END_REPEAT_POP
    ld (ix-3),a
    ld l,(ix-2)
    ld h,(ix-1)
    jr update_sound_internal_loop
update_sound_END_REPEAT_POP:
    dec ix
    dec ix
    dec ix
    jr update_sound_internal_loop


update_sound_command_time_step:
    push af
        ld a,1
        ld (MUSIC_time_step_required),a
    pop af
    ret


update_sound_WRTPSG:
    and #0f ; clear all the flags that the command might have
    ld e,(hl)
    inc hl
    call WRTPSG                ;; send command to PSG
;     jr update_sound_internal_loop     


update_sound_internal_loop:
    ; check if there is a time step required on the last command
    ld a,(MUSIC_time_step_required)
    or a
    ret nz
update_sound_internal:
    ld a,(hl)
    inc hl 
    ; check if it's a special command:
    bit 6,a
    call nz,update_sound_command_time_step
    bit 7,a
    jp z,update_sound_WRTPSG
    and #3f ; clear all the flags the command might have
    ret z   ; MUSIC_CMD_SKIP command
    dec a   ; MUSIC_CMD_SET_INSTRUMENT
    jp z,update_sound_SET_INSTRUMENT
    dec a   ; MUSIC_CMD_PLAY_INSTRUMENT_CH1
    jr z,update_sound_PLAY_INSTRUMENT_CH1
    dec a   ; MUSIC_CMD_PLAY_INSTRUMENT_CH2
    jr z,update_sound_PLAY_INSTRUMENT_CH2
    dec a   ; MUSIC_CMD_PLAY_INSTRUMENT_CH3
    jr z,update_sound_PLAY_INSTRUMENT_CH3
    dec a   ; MUSIC_CMD_PLAY_SFX_OPEN_HIHAT
    jr z,update_sound_PLAY_SFX_OPEN_HIHAT
    dec a   ; MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
    jr z,update_sound_PLAY_SFX_SHORT_HIHAT
    dec a   ; MUSIC_CMD_PLAY_SFX_DRUM_SHORT_RE
    jr z,update_sound_PLAY_SFX_DRUM_SHORT_RE
    dec a   ; MUSIC_CMD_PLAY_SFX_DRUM_SHORTER_RE
    jr z,update_sound_PLAY_SFX_DRUM_SHORTER_RE
    dec a   ; MUSIC_CMD_GOTO
    jp z,update_sound_GOTO
    dec a   ; MUSIC_CMD_REPEAT
    jr z,update_sound_REPEAT
    dec a   ; MUSIC_CMD_END_REPEAT
    jr z,update_sound_END_REPEAT
;    dec a   ; MUSIC_CMD_TRANSPOSE_UP
;    jr z,update_sound_TRANSPOSE_UP
;    dec a   ; MUSIC_CMD_CLEAR_TRANSPOSE
;    jr z,update_sound_CLEAR_TRANSPOSE
    ; SFX_CMD_END
;    jp update_sound_SFX_END       ;; if the SFX sound is over, we are done


update_sound_SFX_END:
    xor a
    ld (SFX_priority),a
    ld a,7
    ld e,#b8  ;; SFX should reset all channels to tone
    jp WRTPSG


update_sound_PLAY_SFX_OPEN_HIHAT:
    push hl
        ld hl,SFX_open_hi_hat
update_sound_PLAY_SFX_OPEN_HIHAT_entry:
        ld a,SFX_PRIORITY_MUSIC
        call play_SFX_with_priority
    pop hl
    jp update_sound_internal_loop

update_sound_PLAY_SFX_SHORT_HIHAT:
    push hl
        ld hl,SFX_short_hi_hat
        jr update_sound_PLAY_SFX_OPEN_HIHAT_entry

; update_sound_PLAY_SFX_PEDAL_HIHAT:
;     push hl
;     ld hl,SFX_pedal_hi_hat
;     jr update_sound_PLAY_SFX_OPEN_HIHAT_entry

update_sound_PLAY_SFX_DRUM_SHORT_RE:
    push hl
        ld hl,SFX_drum_short_re
        jr update_sound_PLAY_SFX_OPEN_HIHAT_entry

update_sound_PLAY_SFX_DRUM_SHORTER_RE:
    push hl
        ld hl,SFX_drum_shorter_re
        jr update_sound_PLAY_SFX_OPEN_HIHAT_entry


;update_sound_TRANSPOSE_UP:
;    ld a,(MUSIC_transpose)
;    inc a
;update_sound_TRANSPOSE_UP_entry:
;    ld (MUSIC_transpose),a
;    jp update_sound_internal_loop


;update_sound_CLEAR_TRANSPOSE:
;    xor a
;    jr update_sound_TRANSPOSE_UP_entry


update_sound_PLAY_INSTRUMENT_CH1:
    ld a,1
    jr update_sound_PLAY_INSTRUMENT
update_sound_PLAY_INSTRUMENT_CH2:
    ld a,3
    jr update_sound_PLAY_INSTRUMENT
update_sound_PLAY_INSTRUMENT_CH3:
    ld a,(SFX_priority)
    cp SFX_PRIORITY_LOW
    jp p,update_sound_PLAY_INSTRUMENT_IGNORE
    ld a,(MUSIC_channel3_instrument_buffer)
    ld (MUSIC_instruments+2),a
    ld a,5
update_sound_PLAY_INSTRUMENT:
    push hl
;         push af
            ld b,0  ; for later use
            ld c,(hl)   ; note to play
;            ld hl,MUSIC_transpose
;            ld a,(hl)
;            add a,c
;            ld c,a
            ld hl,note_period_table
            add hl,bc
            add hl,bc
            ld e,(hl)   ; MSB of the period    
            inc hl
;         pop af
        push af
            call WRTPSG
        pop af
        ld e,(hl)   ; LSB of the period    
        dec a
        push af
            call WRTPSG
        pop af

        ld hl,MUSIC_instruments
        ld c,a      ; here  a == 0, 2 or 4 depending on which channel we are playing
        srl a       ; divide by 2
        ADD_HL_A    ; HL = MUSIC_instruments + channel
        ld a,(hl)   ; we get the instrument
        ld de,instrument_profiles
        ADD_DE_A    ; we calculate pointer to the instrument envelope
        ld hl,MUSIC_instrument_envelope_ptr
        add hl,bc   ; b should still be 0 here, so, we are just adding c
        ld (hl),e
        inc hl
        ld (hl),d
    pop hl
    ld a,c  ; calculate the volume port: (c/2)+8
    sra a
    add a,8
    ld c,a
    ld a,(de)
    ld e,a
    ld a,c
    call WRTPSG
update_sound_PLAY_INSTRUMENT_IGNORE:
    inc hl
    jp update_sound_internal_loop
