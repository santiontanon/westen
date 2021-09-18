;-----------------------------------------------
state_ending:
	ld bc, TEXT_ENTER_VAMPIRE3_ROOM2_BANK + 256*TEXT_ENTER_VAMPIRE3_ROOM2_IDX
	call queue_hud_message

	; wait until the message is played and after that, wait a few seconds, or until player presses space:
state_ending_wait1_loop:
	ld a,(interrupt_cycle)
	cp 2
	jr c,state_ending_wait1_loop
	xor a
	ld (interrupt_cycle),a	
	call update_keyboard_buffers
	call update_hud_messages
	ld a,(hud_message_timer)
	or a
	jr nz,state_ending_wait1_loop
	ld a,(hud_message_queue_size)
	or a
	jr nz,state_ending_wait1_loop

	ld c,4
	call state_intro_pause

    ; init the stack:
    ld sp,#f380

	call disable_VDP_output
	    call clearAllTheSprites
	    call set_bitmap_mode    

		ld hl,ending_scroll_zx0
		ld de,enemy_data_buffer+1024
		call dzx0_standard

		; Draw scroll:
		ld ix,enemy_data_buffer+1024
		ld iy,13
		ld de,CHRTBL2+(1*32+0)*8
		ld bc,#030d
		ld hl,enemy_data_buffer+1024+13*3
		ld (draw_hud_chunk_tile_ptr),hl
		call draw_hud_chunk	

	    ld hl,music_ending_zx0
	    ld de,music_buffer
	    call dzx0_standard

	    ld a,(song_speeds+4)
	    call PlayMusic
	call enable_VDP_output

	; init variables:
	xor a
	ld hl,ending_trigger_map
	ld de,ending_trigger_map+1
	ld (hl),a
	ld bc,4
	ldir

state_ending_loop:
	halt
	call update_keyboard_buffers

	ld a,(ending_trigger_map)
	or a
	jr z,state_ending_load_map1
	cp 2
	jr z,state_ending_load_map2
	cp 4
	jr z,state_ending_load_map3
state_ending_loop_continue1:
	ld hl,ending_roll_step
	ld a,(interrupt_cycle)
	rra
	jr c,state_ending_loop_continue1a
	inc (hl)
state_ending_loop_continue1a:
	ld a,(hl)
	cp 228
	jr z,state_ending_loop_next_map
	cp 3
	jr c,state_ending_loop_continue2
	cp 22
	jr c,state_ending_unroll_scroll_step
	cp 223
	jr nc,state_ending_loop_continue2
	cp 203
	jp nc,state_ending_roll_scroll_step
state_ending_loop_continue2:

	; text:
	ld hl,ending_text_page_line_state
	ld a,(hl)
	inc (hl)
	or a
	jp z,state_ending_next_line
	cp 20*4
	jp c,state_ending_fade_in_line
	ld (hl),0 ; reset state, and next line
	ld hl,ending_text_page_line
	inc (hl)
state_ending_loop_continue3:
	jr state_ending_loop


;-----------------------------------------------
state_ending_load_map1:
	ld hl,ending_map1_zx0_page1
state_ending_load_map1_entry_point:
	ld de,enemy_data_buffer+1024+256 ; leave space for the scroll
	call decompress_from_page1
state_ending_load_map1_entry_point2:
	ld hl,ending_trigger_map
	inc (hl)
	jr state_ending_loop_continue1

state_ending_load_map2:
	ld hl,ending_map2_zx0_page1
	jr state_ending_load_map1_entry_point

state_ending_load_map3:
	ld hl,ending_map3_zx0_page1
	jr state_ending_load_map1_entry_point

state_ending_loop_next_map:
	ld hl,ending_roll_step
	ld (hl),0
	dec hl  ; ending_trigger_map
	inc (hl)
	ld a,(hl)
	cp 6
	jr nz,state_ending_loop_continue2
	ld (hl),0
	jr state_ending_loop_continue2

;-----------------------------------------------
; input:
; - a: next position of the scroll bottom
state_ending_unroll_scroll_step:
	; render the bottom of the scroll at CHRTBL2 + a*32*8
	push af
		ld h,a
		ld l,0  ; hl = a*32*8
		ld bc,CHRTBL2
		add hl,bc
		ex de,hl
		push de
			ld ix,enemy_data_buffer+1024+13
			ld iy,13
			ld bc,#020d
			ld hl,enemy_data_buffer+1024+13*3
			ld (draw_hud_chunk_tile_ptr),hl
			call draw_hud_chunk	
		pop hl

		ld a,(ending_trigger_map)
		dec a  ; map 1
		jr z,state_ending_unroll_scroll_step_map1
		dec a
		dec a  ; map 2
		jr z,state_ending_unroll_scroll_step_map2
state_ending_unroll_scroll_step_map3:
	pop af
	cp a,7
	jp c,state_ending_loop_continue2
	cp a,17
	jp nc,state_ending_loop_continue2
	sub a,7
	; render a map row:
	; - from enemy_data_buffer+1024+256 + 12*(a-6)
	; - to: CHRTBL2 + a*32*8 + 16
	ld bc,16
	add hl,bc
	ex de,hl
	ld ix,enemy_data_buffer+1024+256
	ld bc,11
	or a
	jr z,state_ending_unroll_scroll_step_map3_loop_done
state_ending_unroll_scroll_step_map3_loop:
	add ix,bc
	dec a
	jr nz,state_ending_unroll_scroll_step_map3_loop
state_ending_unroll_scroll_step_map3_loop_done:
	ld iy,11
	ld hl,enemy_data_buffer+1024+256+11*10
	ld bc,#010b
	ld (draw_hud_chunk_tile_ptr),hl
	call draw_hud_chunk	
	jp state_ending_loop_continue2

state_ending_unroll_scroll_step_map2:
	pop af
	cp a,8
	jp c,state_ending_loop_continue2
	cp a,17
	jp nc,state_ending_loop_continue2
	sub a,8
	; render a map row:
	; - from enemy_data_buffer+1024+256 + 12*(a-6)
	; - to: CHRTBL2 + a*32*8 + 24
	ld bc,24
	add hl,bc
	ex de,hl
	ld ix,enemy_data_buffer+1024+256
	ld bc,8
	or a
	jr z,state_ending_unroll_scroll_step_map2_loop_done
state_ending_unroll_scroll_step_map2_loop:
	add ix,bc
	dec a
	jr nz,state_ending_unroll_scroll_step_map2_loop
state_ending_unroll_scroll_step_map2_loop_done:
	ld iy,8
	ld hl,enemy_data_buffer+1024+256+8*9
	ld bc,#0108
	ld (draw_hud_chunk_tile_ptr),hl
	call draw_hud_chunk	
	jp state_ending_loop_continue2


state_ending_unroll_scroll_step_map1:
	pop af

	cp a,6
	jp c,state_ending_loop_continue2
	cp a,18
	jp nc,state_ending_loop_continue2
	sub a,6
	; render a map row:
	; - from enemy_data_buffer+1024+256 + 12*(a-6)
	; - to: CHRTBL2 + a*32*8 + 8
	ld bc,8
	add hl,bc
	ex de,hl
	ld ix,enemy_data_buffer+1024+256
	ld bc,12
	or a
	jr z,state_ending_unroll_scroll_step_map1_loop_done
state_ending_unroll_scroll_step_map1_loop:
	add ix,bc
	dec a
	jr nz,state_ending_unroll_scroll_step_map1_loop
state_ending_unroll_scroll_step_map1_loop_done:
	ld iy,12
	ld hl,enemy_data_buffer+1024+256+12*12
	ld bc,#010c
	ld (draw_hud_chunk_tile_ptr),hl
	call draw_hud_chunk	
	jp state_ending_loop_continue2


;-----------------------------------------------
; input:
; - a: next position of the scroll bottom
state_ending_roll_scroll_step:
	; a = 225 - a
	ld c,a
	ld a,225
	sub c

	; render the bottom of the scroll at CHRTBL2 + a*32*8
	ld h,a
	ld l,0  ; hl = a*32*8
	ld bc,CHRTBL2
	add hl,bc
	ex de,hl
	push de
		ld ix,enemy_data_buffer+1024+13*2
		ld iy,13
		ld bc,#010d
		ld hl,enemy_data_buffer+1024+13*3
		ld (draw_hud_chunk_tile_ptr),hl
		call draw_hud_chunk	
	pop hl
	inc h  ; next row
	ld bc,13*8
	xor a
	call fast_FILVRM
	jp state_ending_loop_continue2


;-----------------------------------------------
state_ending_next_line:
	ld hl,ending_text_page
	ld a,(hl)
	or a
	jr z,state_ending_next_line_page1
	dec a
	jr z,state_ending_next_line_wait_page1
	dec a
	jr z,state_ending_next_line_page2
	dec a
	jr z,state_ending_next_line_wait_page2
	dec a
	jr z,state_ending_page3
	jp state_ending_loop_continue3

state_ending_next_line_wait_page2:
state_ending_next_line_wait_page1:
	ld a,(ending_text_page_line)
	cp 8
	jp nz,state_ending_loop_continue3
	inc (hl)  ; ending_text_page
	inc hl
	ld (hl),0
	; clear the text (both patterns and attributes):
	ld hl,CHRTBL2 + (32+15)*8
	ld bc,20*256+17
	xor a
	push bc
		call clear_rectangle_bitmap_mode
		ld hl,CLRTBL2 + (32+15)*8
	pop bc
	xor a
	call clear_rectangle_bitmap_mode
	jp state_ending_loop_continue3

state_ending_next_line_page1:
	inc hl  ; ending_text_page_line
	ld a,(hl)
	cp 18
	jr nz,state_ending_next_line_page1_not_done
state_ending_next_line_next_page:
	xor a
	ld (hl),a
	dec hl
	inc (hl)  ; next page
	dec hl
	ld (hl),a
	jp state_ending_loop_continue3
state_ending_next_line_page1_not_done:
	ld hl,ending1_lines
state_ending_next_line_page2_entry_point:
	ld e,a
	add a,a
	ADD_HL_A_VIA_BC
	ld a,e

	ld de,CHRTBL2 + (2*32 + 15)*8
    add a,d  ; move lines down
    ld d,a

    ld a,(hl)
    cp #ff
    jp z,state_ending_loop_continue3
    inc hl
    ld c,(hl)
;     ld iyl,COLOR_WHITE*16
	ld iyl,0  ; draw them in black at first
    ld b,17*8
    call draw_text_from_bank
    jp state_ending_loop_continue3


state_ending_next_line_page2:
	inc hl  ; ending_text_page_line
	ld a,(hl)
	cp 10
	jr nz,state_ending_next_line_page2_not_done
	jr state_ending_next_line_next_page
state_ending_next_line_page2_not_done:
	ld hl,ending2_lines
	jr state_ending_next_line_page2_entry_point


state_ending_page3:

	call disable_VDP_output
	    call set_bitmap_mode    

		ld hl,ending_the_end_zx0
		ld de,enemy_data_buffer+1024
		call dzx0_standard

		ld ix,enemy_data_buffer+1024
		ld iy,7
		ld de,CHRTBL2+(8*32+12)*8
		ld bc,#0207
		ld hl,enemy_data_buffer+1024+7*2
		ld (draw_hud_chunk_tile_ptr),hl
		call draw_hud_chunk	
	call enable_VDP_output

	call wait_for_space
	; 2 second blank screen (skippable)
	call clearScreen
	call StopMusic
	ld c,2
	call state_intro_pause
	jp Execute_back_to_intro


state_ending_fade_in_line:
	ld e,a
	ld a,(ending_text_page)
	or a
	jr z,state_ending_fade_in_line_continue
	cp 2
	jr z,state_ending_fade_in_line_continue
	jp state_ending_loop_continue3
state_ending_fade_in_line_continue:
	ld a,(ending_text_page_line)
	ld hl,CLRTBL2 + (2*32 + 15)*8
    add a,h  ; move lines down
    ld h,a
    ld a,e
    and #fc
    ld b,0
    ld c,a
    add hl,bc
    add hl,bc  ; ptr to the character we want to color

    ld a,COLOR_DARK_RED*16
    ld bc,8
    push bc
	    push hl
	    	call fast_FILVRM_only_right_half
		pop hl
		ld bc,-8
		add hl,bc
	    ld a,COLOR_DARK_YELLOW*16
	pop bc
	push bc
	    push hl
		    call fast_FILVRM_only_right_half
		pop hl
		ld bc,-8
		add hl,bc
	    ld a,COLOR_YELLOW*16
	pop bc
	push bc
	    push hl
		    call fast_FILVRM_only_right_half
		pop hl
		ld bc,-8
		add hl,bc
	    ld a,COLOR_WHITE*16
	pop bc
	call fast_FILVRM_only_right_half

	jp state_ending_loop_continue3	


fast_FILVRM_only_right_half:
	ld e,a
	ld a,l
	cp 15*8
	ld a,e
	ret c
	jp fast_FILVRM


;-----------------------------------------------
ending1_lines:
    db TEXT_ENDING_LINE1_IDX, TEXT_ENDING_LINE1_BANK
    db #ff, 0
    db TEXT_ENDING_LINE2_IDX, TEXT_ENDING_LINE2_BANK
    db TEXT_ENDING_LINE3_IDX, TEXT_ENDING_LINE3_BANK
    db TEXT_ENDING_LINE4_IDX, TEXT_ENDING_LINE4_BANK
    db TEXT_ENDING_LINE5_IDX, TEXT_ENDING_LINE5_BANK
    db #ff, 0
    db TEXT_ENDING_LINE6_IDX, TEXT_ENDING_LINE6_BANK
    db TEXT_ENDING_LINE7_IDX, TEXT_ENDING_LINE7_BANK
    db TEXT_ENDING_LINE8_IDX, TEXT_ENDING_LINE8_BANK
    db TEXT_ENDING_LINE9_IDX, TEXT_ENDING_LINE9_BANK
    db TEXT_ENDING_LINE10_IDX, TEXT_ENDING_LINE10_BANK
    db TEXT_ENDING_LINE11_IDX, TEXT_ENDING_LINE11_BANK
    db #ff, 0
    db TEXT_ENDING_LINE12_IDX, TEXT_ENDING_LINE12_BANK
    db TEXT_ENDING_LINE13_IDX, TEXT_ENDING_LINE13_BANK
    db #ff, 0
    db TEXT_ENDING_LINE14_IDX, TEXT_ENDING_LINE14_BANK


ending2_lines:
    db #ff, 0
    db TEXT_ENDING2_LINE1_IDX, TEXT_ENDING2_LINE1_BANK
    db TEXT_ENDING2_LINE2_IDX, TEXT_ENDING2_LINE2_BANK
    db #ff, 0
    db TEXT_ENDING2_LINE3_IDX, TEXT_ENDING2_LINE3_BANK
    db #ff, 0
    db TEXT_ENDING2_LINE4_IDX, TEXT_ENDING2_LINE4_BANK
    db #ff, 0
    db #ff, 0
    db TEXT_ENDING2_LINE5_IDX, TEXT_ENDING2_LINE5_BANK

