;-----------------------------------------------
state_password_lock:
	push ix
		call state_password_lock_internal
	pop ix
	ret


state_password_lock_internal:	
	ld bc, TEXT_USE_VAMPIRE_DOOR_BANK + 256*TEXT_USE_VAMPIRE_DOOR_IDX
	call queue_hud_message

	ld hl,password_lock_zx0
	ld de,buffer1024
	call decompress_from_page1

    xor a
    ld hl,CLRTBL2 + (7*32 + 11)*8
    ld bc,#050a
    call clear_rectangle_bitmap_mode_color

	ld ix,buffer1024
	ld iy,8
	ld de,CHRTBL2+(8*32+12)*8
	ld bc,#0308
	ld hl,buffer1024+8*3
	ld (draw_hud_chunk_tile_ptr),hl
	call draw_hud_chunk

	; set up pointer sprite:
	ld hl,keyword_lock_pointer_sprite	
	ld de,SPRTBL2+7*32
	ld bc,32
	call fast_LDIRVM

	ld hl,buffer1024+900  ; enough to give space for the text data
	ld (hl),56
	inc hl
	ld (hl),13*8-1
	inc hl
	ld (hl),7*4
	inc hl
	ld (hl),COLOR_WHITE
	inc hl
	ld (hl),0  ; current position

	ld b,6
state_password_init_loop:
	inc hl
	ld (hl),0
	djnz state_password_init_loop

	; password starts at: buffer1024+900+5
	call state_password_draw_current_password	
	
state_password_lock_loop:
	halt

	ld a,(interrupt_cycle)
	bit 3,a
	ld a,COLOR_WHITE
	jr z,state_password_lock_loop_blink
	xor a
state_password_lock_loop_blink:
	ld hl,buffer1024+900+3
	ld (hl),a  ; color
	inc hl
	ld a,(hl)
	add a,a
	add a,a
	add a,a
	add a,13*8-1
	ld hl,buffer1024+900+1
	ld (hl),a  ; x
	dec hl
	ld de,SPRATR2+7*4
	ld bc,4
	call fast_LDIRVM

	call update_hud_messages
	call update_keyboard_buffers
    ld a,(keyboard_line_clicks+KEY_BUTTON1_BYTE)
    bit KEY_BUTTON1_BIT,a
    jr nz,state_password_lock_loop_exit
    bit KEY_LEFT_BIT,a
    jr nz,state_password_lock_left
    bit KEY_RIGHT_BIT,a
    jr nz,state_password_lock_right
    bit KEY_UP_BIT,a
    jr nz,state_password_lock_up
    bit KEY_DOWN_BIT,a
    jr nz,state_password_lock_down
	jr state_password_lock_loop

state_password_lock_loop_exit:

	; remove pointer sprite
	ld a,200
	ld hl,SPRATR2+7*4
	call WRTVRM

	; re-render the room:
	ld de,11 + 7*256
	ld bc,10+5*256
	jp render_room_rectangle


state_password_lock_left:
	ld hl,buffer1024+900+4
	ld a,(hl)
	or a
	jr z,state_password_lock_loop
	dec (hl)
	ld hl,SFX_ui_move
	call play_SFX_with_high_priority
	jr state_password_lock_loop


state_password_lock_right:
	ld hl,buffer1024+900+4
	ld a,(hl)
	cp 5
	jr z,state_password_lock_loop
	inc (hl)
	ld hl,SFX_ui_move
	call play_SFX_with_high_priority	
	jr state_password_lock_loop


state_password_lock_up:
	ld a,(buffer1024+900+4)  ; current position
	ld hl,buffer1024+900+5
	ADD_HL_A
	ld a,(hl)
	or a
	jr z,state_password_lock_up_reset
	dec a
	jr state_password_lock_up_continue
state_password_lock_up_reset:
	ld a,26
state_password_lock_up_continue
	ld (hl),a
	call state_password_draw_current_password
	ld hl,SFX_ui_move
	call play_SFX_with_high_priority	
	jp state_password_lock_loop


state_password_lock_down:
	ld a,(buffer1024+900+4)  ; current position
	ld hl,buffer1024+900+5
	ADD_HL_A
	ld a,(hl)
	cp 26
	jr z,state_password_lock_down_reset
	inc a
	jr state_password_lock_down_continue
state_password_lock_down_reset:
	xor a
state_password_lock_down_continue
	ld (hl),a
	call state_password_draw_current_password
	ld hl,SFX_ui_move
	call play_SFX_with_high_priority		
	jp state_password_lock_loop


	; password starts at buffer1024+900+5
	; we use a temporary string buffer in buffer1024+900+5+6
state_password_draw_current_password:
	ld b,6
	ld hl,buffer1024+900+5
	ld de,CHRTBL2+(9*32+13)*8
state_password_draw_current_password_loop:
	push hl
	push bc
		push de
			call state_password_draw_current_password_character
		pop hl
		ld bc,8
		add hl,bc
		ex de,hl
	pop bc
	pop hl
	inc hl
	djnz state_password_draw_current_password_loop
	ret


state_password_draw_current_password_character:
	push de
		ld a,(hl)
		ld hl,combination_lock_letters
		ADD_HL_A
		ld a,(hl)

		push af
		    ld hl,text_draw_buffer
		    ld bc,8
		    ld a,#01
		    call clear_memory_a	
		pop af

		ld hl,buffer1024+900+5+6
		ld (hl),1  ; length of the string = 1
		inc hl
		ld (hl),a
		dec hl
	pop de
	ld iy,COLOR_DARK_RED + #4000
	ld bc,8
	jp draw_sentence
