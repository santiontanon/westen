;-----------------------------------------------
state_gamestart:
	call init_game_variables

	ld hl,state_white_key_taken
	ld (hl),1

	; Regular game start:
	ld hl,map1_zx0_page1
	ld de,0 + 0*256  ; c: room, b: door
	xor a
	ld (state_current_room),a
	call teleport_player_to_room	
	ld hl,player_iso_x
	ld (hl),8*8
	inc hl
	ld (hl),12*8
	ld hl,player_direction
	ld (hl),1

	; initial objects:
	ld hl,inventory
	ld (hl),INVENTORY_WHITE_KEY
	inc hl
	ld (hl),INVENTORY_RED_KEY_H1
; 	inc hl
; 	ld (hl),INVENTORY_HEART
; 	inc hl
; 	ld (hl),INVENTORY_HEART
; 	inc hl
; 	ld (hl),INVENTORY_HEART
; 	inc hl
; 	ld (hl),INVENTORY_GREEN_KEY
; 	inc hl
; 	ld (hl),INVENTORY_HAMMER
; 	inc hl
; 	ld (hl),INVENTORY_RUBBED_STAKE
; 	ld hl,state_vampire2_state
; 	ld (hl),1
; 	ld (hl),INVENTORY_HEART
; 	inc hl

	; Debug game start:
; 	ld hl,state_ritual_room_state
; 	ld (hl),3
; 	ld hl,game_time_day
; 	ld (hl),8
; 	ld hl,state_lab_notes_taken
; 	ld (hl),2
; 	ld hl,map3_zx0_page1
; 	ld de,9 + 0*256  ; c: room, b: door
; 	ld a,16*2 + 9
; 	ld (state_current_room),a
; 	call teleport_player_to_room

	; copy inventory sprite pattern
	ld hl,inventory_pointer_sprite
	ld de,SPRTBL2+6*32
	ld bc,32
	call fast_LDIRVM

	ld bc, TEXT_GAME_START_MESSSAGE1_BANK + 256*TEXT_GAME_START_MESSSAGE1_IDX
	call queue_hud_message
	ld bc, TEXT_GAME_START_MESSSAGE2_BANK + 256*TEXT_GAME_START_MESSSAGE2_IDX
	call queue_hud_message


    call clearScreenLeftToRight_bitmap

    ld hl,music_ingame1_zx0_page1
    ld de,music_buffer
    call decompress_from_page1
    ld a,(song_speeds+1)
    call PlayMusic
    ld a,1
    ld (state_current_music),a

	jp state_game


;-----------------------------------------------
init_game_variables:
	ld hl,player_sprite_attributes_ROM
	ld de,player_sprite_attributes
	ld bc,4*6+4
	ldir

	; clear variables before game start:
	ld hl,ram_to_clear_at_game_start
	ld (hl),0
	ld de,ram_to_clear_at_game_start+1
	ld bc,(ram_to_clear_at_game_start_end - ram_to_clear_at_game_start) - 1
	ldir

	xor a
	ld (player_invulnerability),a
	ld a,INITIAL_HEALTH
	ld (player_health),a
	ld (player_max_health),a

	ld hl,candle_initial_positions
	ld de,state_candle1_position
	ld bc,12
	ldir

	; set player dimensions:
	ld hl,player_iso_w
	ld (hl),8
	inc hl
	ld (hl),8
	inc hl
	ld (hl),16	
	ret