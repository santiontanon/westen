;-----------------------------------------------
; updates the 'keyboard_line_state' and 'keyboard_line_state_prev' buffers
update_keyboard_buffers:
    ld de,keyboard_line_state
    ld hl,keyboard_line_state_prev
    ld bc,#0201
update_keyboard_buffers_loop:
        ld a,(de)
        xor (hl)
        and (hl)    ; a now has the value to save in "keyboard_line_clicks" (which is "keyboard_line_state", offset by 1)
        ex de,hl
            ldi
            inc c
        ex de,hl
        ld (de),a   ; save the click in "keyboard_line_clicks"
        inc de
    djnz update_keyboard_buffers_loop

    ld a,#08
    call SNSMAT
    ld (keyboard_line_state),a  ; RIGHT, DOWN, UP, LEFT, DEL, INS, HOME, SPACE

    ld a,#04
    call SNSMAT
    ld (keyboard_line_state+2),a    ; R, Q, P, O, N, M, L, K

;     ld a,#06
;     call SNSMAT
;     ld (keyboard_line_state+4),a    ; F3, F2, F1, CODE, CAPS, GRAPH, CTRL, SHIFT

    ; jp read_joystick


;-----------------------------------------------
; Reads the joystick status, and updates the corresponding keyboard_line_state to treat it as if it was the keyboard
read_joystick:
    ld a,15 ; read the joystick 1 status:
    di
    call RDPSG
    and #bf
    ld e,a
    ld a,15
    call WRTPSG
    dec a
    call RDPSG  ; a = -, -, B, A, right, left, down, up
    ei
    ; convert the joystick input to keyboard input
    ld c,a
    ; arrows/space:
    ld hl,keyboard_line_state
    ld a,(hl)
    
    rr c
    jr c,read_joystick_noUp
    and #df
read_joystick_noUp:

    rr c
    jr c,read_joystick_noDown
    and #bf
read_joystick_noDown:

    rr c
    jr c,read_joystick_noLeft
    and #ef
read_joystick_noLeft:

    rr c
    jr c,read_joystick_noRight
    and #7f
read_joystick_noRight:

    rr c
    jr c,read_joystick_noA
    and #fe
read_joystick_noA:

    ld (hl),a   ; we add the joystick input to the keyboard input

    ; m (button 2):
    inc hl
    inc hl  ; hl = keyboard_line_state+2
    ld a,(hl)
    rr c
    jr c,read_joystick_noB
    and #fb
read_joystick_noB:
    ld (hl),a   ; we add the joystick input to the keyboard input

    ret


;-----------------------------------------------
; Waits until the player presses space
; wait_for_space:
;     call update_keyboard_buffers
;     ld a,(keyboard_line_clicks)
;     bit 0,a
;     ret nz
;     halt
;     jr wait_for_space



;-----------------------------------------------
;; Adapted from the CHGET routine here: https://sourceforge.net/p/cbios/cbios/ci/master/tree/src/main.asm#l289
;; It returns 0 if no key is ready to be read
;; If a key is ready to be read, it checks if it is one of these:
;; - ESC / DELETE / ENTER
;; - 'a' - 'z' (converts it to upper case and returns)
;; - 'Z' - 'Z'
;; - otherwise, it returns 0
; getcharacter_nonwaiting:
;     ld hl,(GETPNT)
;     ld de,(PUTPNT)
;     call DCOMPR
;     jr z,getcharacter_nonwaiting_invalidkey
;     ;; there is a character ready to be read:
;     ld a,(hl)
;     push af
;     inc hl
;     ld a,l
;     cp #00ff & (KEYBUF + 40)
;     jr nz,getcharacter_nonwaiting_nowrap
;     ld hl,KEYBUF
; getcharacter_nonwaiting_nowrap:
;     ld (GETPNT),hl
;     pop af
;     cp 8    ;; DELETE
;     ret z
;     cp 13   ;; ENTER
;     ret z
;     cp 27   ;; ESC
;     ret z
;     cp '0'
;     jp m,getcharacter_nonwaiting_invalidkey
;     cp '9'+1
;     ret m
;     and #df ; make it upper case
;     cp 'Z'+1
;     jp p,getcharacter_nonwaiting_invalidkey
;     cp 'A'
;     ret p
; getcharacter_nonwaiting_invalidkey:
;     xor a
;     ret

; getcharacter_nonwaiting_reset:
;     di
;     ld hl,(PUTPNT)
;     ld (GETPNT),hl
;     ei
;     ret
