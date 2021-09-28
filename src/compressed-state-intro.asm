;-----------------------------------------------
state_intro:
	call init_game_variables
    call clearAllTheSprites
    call clearScreenLeftToRight_bitmap
    call set_bitmap_mode
    
    ld hl,music_intro_zx0_page1
    ld de,music_buffer
    call decompress_from_page1
    ld a,(song_speeds)
    call PlayMusic

    ld hl,braingames_zx0_page1
    ld de,buffer1024
    call decompress_from_page1

    ld hl,buffer1024
    ld de,CHRTBL2 + (10*32 + 12)*8 
    ld b,2
state_intro_bg_loop1:
    push bc
        ld b,8
state_intro_bg_loop2:
        push bc
            push hl
                push de
                call draw_tile_bitmap_mode
                pop hl
                ld bc,8
                add hl,bc
                ex de,hl
            pop hl
            add hl,bc
            add hl,bc
        pop bc
        djnz state_intro_bg_loop2
        ex de,hl
            ld bc,24*8
            add hl,bc
        ex de,hl
    pop bc
    djnz state_intro_bg_loop1

    ld c,2
    call state_intro_pause_title_if_space
    ld a,TEXT_PRESENTS_IDX
    ld bc,TEXT_PRESENTS_BANK + 8*8*256
    ld de,CHRTBL2 + (13*32 + 13)*8 
    ld iy,COLOR_WHITE*16 + 8*256
    call draw_text_from_bank_iyh_set
    ld c,3
    call state_intro_pause_title_if_space
    call clearScreenLeftToRight_bitmap

    ld c,1
    call state_intro_pause_title_if_space

	; message 1:
    ld a,TEXT_INTRO_MSG1_IDX
    ld bc,TEXT_INTRO_MSG1_BANK + 8*8*256
    ld de,CHRTBL2 + (20*32 + 12)*8 
    ld iyl,COLOR_WHITE*16
    call draw_text_from_bank
    ld c,2
    call state_intro_pause_title_if_space

    ; draw room:
	ld hl,intromap_zx0_page1
	ld de,0
	call teleport_player_to_room
	call init_object_screen_coordinates
	call render_full_room

    ld c,4
    call state_intro_pause_title_if_space

	ld hl,CLRTBL2 + (20*32 + 12)*8 
	ld bc,#0108
	call clear_rectangle_bitmap_mode

    ld c,1
    call state_intro_pause_title_if_space

    ; door rings
    ld a,TEXT_INTRO_MSG2_IDX
    ld bc,TEXT_INTRO_MSG2_BANK + 8*8*256
    ld de,CHRTBL2 + (5*32 + 23)*8 
    ld iyl,COLOR_YELLOW*16
    call intro_draw_text

    ; comming!
    ld a,TEXT_INTRO_MSG3_IDX
    ld bc,TEXT_INTRO_MSG3_BANK + 8*8*256
    ld de,CHRTBL2 + (17*32 + 13)*8 
    ld iyl,COLOR_WHITE*16
    call intro_draw_text

    ; player walks to the door
    call draw_player
    ld hl,cutscene1_keystrokes
    call state_intro_cutscene

    ; door opens
	ld de,OBJECT_STRUCT_SIZE
	ld ix,objects
	ld a,OBJECT_TYPE_DOOR_RIGHT_YELLOW
state_intro_find_door_loop:
	cp (ix)
	jr z,state_intro_find_door_loop_found
	add ix,de
	jr state_intro_find_door_loop
state_intro_find_door_loop_found:
	call remove_room_object
	ld hl,SFX_door_open
	call play_SFX_with_high_priority

    ld c,2
    call state_intro_pause_title_if_space

    ; talk to mail man
    ld a,TEXT_INTRO_MSG4_IDX
    ld bc,TEXT_INTRO_MSG4_BANK + 16*8*256
    ld de,CHRTBL2 + (1*32 + 16)*8 
    ld iyl,COLOR_LIGHT_BLUE*16
    call intro_draw_text

    ld a,TEXT_INTRO_MSG5_IDX
    ld bc,TEXT_INTRO_MSG5_BANK + 12*8*256
    ld de,CHRTBL2 + (17*32 + 12)*8 
    ld iyl,COLOR_WHITE*16
    call intro_draw_text

    ; walk back to room center
    ld hl,cutscene2_keystrokes
    call state_intro_cutscene

    ; wonder who the letter is from
    ld a,TEXT_INTRO_MSG6_IDX
    ld bc,TEXT_INTRO_MSG6_BANK + 16*8*256
    ld de,CHRTBL2 + (17*32 + 12)*8 
    ld iyl,COLOR_WHITE*16
    call intro_draw_text

    ld c,1
    call state_intro_pause_title_if_space

    ; letter 1
    call clearAllTheSprites
    ld a,COLOR_WHITE + COLOR_WHITE*16
    ld hl,CLRTBL2 + (8*32 + 1)*8
    ld bc,#0a1e
    call clear_rectangle_bitmap_mode_color
    ld hl,letter1_lines
    ld b,28*8
    ld de,CHRTBL2+9*32*8+2*8
    ld iyl,COLOR_WHITE
    ld a,8
    call render_letter_text

    ld c,18
    call state_intro_pause_title_if_space
    ld hl,CLRTBL2 + (8*32 + 1)*8
    ld bc,#0a1e
    call clear_rectangle_bitmap_mode
    call draw_player
    call render_full_room
    ld c,1
    call state_intro_pause_title_if_space

    ; letter 2
    call clearAllTheSprites
    ld a,COLOR_YELLOW + COLOR_YELLOW*16
    ld hl,CLRTBL2 + (8*32 + 3)*8
    ld bc,#0e1a
    call clear_rectangle_bitmap_mode_color
    ld hl,letter2_lines
    ld b,24*8
    ld de,CHRTBL2+9*32*8+4*8
    ld iyl,COLOR_YELLOW
    ld a,12
    call render_letter_text

    ld c,20
    call state_intro_pause_title_if_space
    ld hl,CLRTBL2 + (8*32 + 3)*8
    ld bc,#0e1a
    call clear_rectangle_bitmap_mode
    call draw_player
    call render_full_room
    ld c,1
    call state_intro_pause_title_if_space

    ; final text lines
    ld a,TEXT_INTRO_MSG7_IDX
    ld bc,TEXT_INTRO_MSG7_BANK + 12*8*256
    ld de,CHRTBL2 + (17*32 + 12)*8 
    ld iyl,COLOR_WHITE*16
    call intro_draw_text

    ld a,TEXT_INTRO_MSG8_IDX
    ld bc,TEXT_INTRO_MSG8_BANK + 14*8*256
    ld de,CHRTBL2 + (17*32 + 11)*8 
    ld iyl,COLOR_WHITE*16
    call intro_draw_text

    ld a,TEXT_INTRO_MSG9_IDX
    ld bc,TEXT_INTRO_MSG9_BANK + 14*8*256
    ld de,CHRTBL2 + (17*32 + 11)*8 
    ld iyl,COLOR_WHITE*16
    call intro_draw_text

    ld c,2
    call state_intro_pause_title_if_space
    call clearScreenLeftToRight_bitmap
    jp state_title


;-----------------------------------------------
; controls the player based on pre-recorded keystrokes:
; input:
; - hl: keystrokes ptr
state_intro_cutscene:
    ld bc,(key_to_direction_mapping_ptr)
    push bc
        ; set the default direction mapping for the predefined cutscene keystrokes:
        ld bc,key_to_direction_mapping
        ld (key_to_direction_mapping_ptr),bc
    	push hl
    		ld a,#ff
    		ld hl,keyboard_line_state
    		ld de,keyboard_line_state+1
    		ld (hl),a
    		ld bc,5
    		ldir
    		; clicks:
    		xor a
    		ld (keyboard_line_clicks),a
    		ld (keyboard_line_clicks+2),a
    	pop hl
state_intro_cutscene_loop1:
    	ld a,(hl)
    	or a
        jr z,state_intro_cutscene_done
    	inc hl
    	ld b,(hl)
    	inc hl
    	ld (keyboard_line_state),a
state_intro_cutscene_loop2:
    	push bc
    	push hl
            ld c,2
            call wait_for_interrupt

    		call update_player
    		call draw_player
    	pop hl
    	pop bc
    	djnz state_intro_cutscene_loop2
    	jr state_intro_cutscene_loop1
state_intro_cutscene_done:
    pop bc
    ; restore the player selected direction mapping
    ld (key_to_direction_mapping_ptr),bc
    ret


;-----------------------------------------------
; - draws a text message, waits 4 seconds, and clears it
intro_draw_text:
	push de
  		call draw_text_from_bank
    	ld c,3
    	call state_intro_pause_title_if_space
    pop hl
	ld bc,#0110
	jp clear_rectangle_bitmap_mode


;-----------------------------------------------
letter1_lines:
    db TEXT_LETTER1_LINE1_IDX, TEXT_LETTER1_LINE1_BANK
    db #ff, 0
    db TEXT_LETTER1_LINE2_IDX, TEXT_LETTER1_LINE2_BANK
    db TEXT_LETTER1_LINE3_IDX, TEXT_LETTER1_LINE3_BANK
    db TEXT_LETTER1_LINE4_IDX, TEXT_LETTER1_LINE4_BANK
    db TEXT_LETTER1_LINE5_IDX, TEXT_LETTER1_LINE5_BANK
    db TEXT_LETTER1_LINE6_IDX, TEXT_LETTER1_LINE6_BANK
    db TEXT_LETTER1_LINE7_IDX, TEXT_LETTER1_LINE7_BANK

letter2_lines:
    db TEXT_LETTER3_LINE1_IDX, TEXT_LETTER3_LINE1_BANK
    db #ff, 0
    db TEXT_LETTER2_LINE2_IDX, TEXT_LETTER2_LINE2_BANK
    db TEXT_LETTER2_LINE3_IDX, TEXT_LETTER2_LINE3_BANK
    db TEXT_LETTER2_LINE4_IDX, TEXT_LETTER2_LINE4_BANK
    db TEXT_LETTER2_LINE5_IDX, TEXT_LETTER2_LINE5_BANK
    db TEXT_LETTER2_LINE6_IDX, TEXT_LETTER2_LINE6_BANK
    db TEXT_LETTER2_LINE7_IDX, TEXT_LETTER2_LINE7_BANK
    db TEXT_LETTER2_LINE8_IDX, TEXT_LETTER2_LINE8_BANK
    db TEXT_LETTER2_LINE9_IDX, TEXT_LETTER2_LINE9_BANK
    db #ff, 0
    db TEXT_LETTER3_LINE7_IDX, TEXT_LETTER3_LINE7_BANK


;-----------------------------------------------
cutscene1_keystrokes:
    db #3f, 32
    db #5f, 34+8
    db 0

cutscene2_keystrokes:
    db #af, 16
    db #bf, 4
    db #ff, 4
    db 0
