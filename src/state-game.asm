;-----------------------------------------------
state_game:

state_game_roomstart:
    ; init the stack:
    ld sp,#f380

    xor a
    ld (hud_message_timer),a

	call disable_VDP_output
		call set_bitmap_mode
		call init_object_screen_coordinates
		call render_full_room
		call clean_inventory_of_room_objects
		call draw_hud
		call draw_player
		call enter_room_music_change
		call enter_room_events
		call update_keyboard_buffers  ; update keyboard here, to prevent spurious clicks done while loading the new room
	call enable_VDP_output

	xor a
	ld (interrupt_cycle),a

state_game_loop:
	ld c,2
	call wait_for_interrupt
	
	call update_keyboard_buffers
	call update_player
	call update_ui_control
	call draw_player
	call update_objects
	call update_object_drawing_order_n_times
	call update_hud_messages
	call update_vampire

	ld hl,game_cycle
	inc (hl)

	ld hl,state_gun_cooldown
	ld a,(hl)
	or a
	jr z,state_game_loop
	dec (hl)
	jr state_game_loop


;-----------------------------------------------
wait_for_interrupt:
	ld hl,interrupt_cycle
	ld a,(hl)
	cp c
	jr c,wait_for_interrupt
	ld (hl),0
	ret


;-----------------------------------------------
update_vampire:
	ld a,(current_room_vampire_state)
	dec a
	ret nz
	
	; We are in a room with a vampire that is awake and has not seen us yet!
	ld a,(state_current_room)
	cp 35
	jr z,update_vampire_vampire1
	cp 45
	jr z,update_vampire_vampire2
update_vampire_vampire3:
	; safe positions for Vampire 3 (Lucy):
	ld a,(player_iso_y)
	cp 10*8
	ret c  ; player is safe
	ld bc,5 + 13*256  ; bat spawn position
	ld e,56
	jr update_vampire_seen

	ret
update_vampire_vampire1:
	; safe position is behind the wall in Vampire 1 (John):
	ld a,(player_iso_y)
	cp 76
	ret c  ; player is safe
	ld bc,5 + 13*256  ; bat spawn position
	ld e,48
	jr update_vampire_seen

update_vampire_vampire2:
	; safe positions for Vampire 2 (Jonathan):
	ld a,(player_iso_y)
	cp 12*8
	ret nc  ; player is safe
	ld a,(player_iso_x)
	cp 8*8
	ret nc  ; player is safe
	ld bc,8 + 2*256  ; bat spawn position
	ld e,32
; 	jr update_vampire_seen

update_vampire_seen:
	ld a,2
	ld (current_room_vampire_state),a

	; spawn a bat!
	push bc
	push de
		call find_new_object_ptr
	pop de
	pop bc

	ld (ix),OBJECT_TYPE_BAT
	ld (ix+OBJECT_STRUCT_STATE),0
	ld (ix+OBJECT_STRUCT_STATE_TIMER),0
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_X),c
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_Y),b
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_Z),e
	call load_room_init_enemy_spawn_entry_point
	ld hl,SFX_explosion
	jp play_SFX_with_high_priority


;-----------------------------------------------
; input:
; - hl: map decompressing function
; - e: room #
; - d: door #
teleport_player_to_room:
	ld a,e  ; room
	push de
		call load_room
	pop bc
	ld a,b  ; door
	push af
		call teleport_player_to_door
	pop af

	; special case for exiting the house:
	dec a
	ret nz
	ld a,(state_current_room)
	dec a
	ret nz
	ld a,4
	ld (player_iso_z),a
	ret


;-----------------------------------------------
teleport_player_to_door:
	ld ix,doors
	or a
	jr z,teleport_player_to_door_ptr_set
	ld de,DOOR_STRUCT_SIZE
	ld b,a
teleport_player_to_door_loop:
	add ix,de
	djnz teleport_player_to_door_loop
teleport_player_to_door_ptr_set:



	; reset player state and position:
	ld hl,player_state
	xor a
	ld (hl),a  ; player_state
	inc hl
	ld (hl),a  ; player_state_timer
	inc hl

	ld a,(ix)
	and #c0
	jr z,teleport_player_to_door_nw
	cp #40
	jr z,teleport_player_to_door_ne
	cp #c0
	jr z,teleport_player_to_door_sw
teleport_player_to_door_se:
	ld a,(room_width)
	add a,a
	add a,a
	add a,a
	ld (hl),a  ; player_iso_x
	inc hl
	ld a,(ix+DOOR_STRUCT_POSITION)
	add a,a
	add a,a
	add a,a
	add a,4
	ld (hl),a  ; player_iso_y
	inc hl
	ld a,(ix+DOOR_STRUCT_HEIGHT)
	add a,a
	add a,a
	add a,a
	ld (hl),a  ; player_iso_z
	ld hl,player_direction
	ld (hl),7
	ret

teleport_player_to_door_sw:
	ld a,(ix+DOOR_STRUCT_POSITION)
	add a,a
	add a,a
	add a,a
	add a,20
	ld (hl),a  ; player_iso_x
	; if it's an empty (wider) door, put the player in the center:
	ld a,(ix+DOOR_STRUCT_TYPE)
	cp 64*3+1
	jr nz,teleport_player_to_door_sw_not_empty
	ld a,(hl)
	add a,8
	ld (hl),a
teleport_player_to_door_sw_not_empty:	
	inc hl
	ld a,(room_height)
	add a,a
	add a,a
	add a,a
	ld (hl),a  ; player_iso_y
	inc hl
	ld a,(ix+DOOR_STRUCT_HEIGHT)
	add a,a
	add a,a
	add a,a
	ld (hl),a  ; player_iso_z
	ld hl,player_direction
	ld (hl),1
	ret

teleport_player_to_door_ne:
	ld a,(ix+DOOR_STRUCT_POSITION)
	add a,a
	add a,a
	add a,a
	add a,20
	ld (hl),a  ; player_iso_x

	; if it's an empty (wider) door, put the player in the center:
	ld a,(ix+DOOR_STRUCT_TYPE)
	cp 64+1
	jr nz,teleport_player_to_door_ne_not_empty
	ld a,(hl)
	add a,8
	ld (hl),a
teleport_player_to_door_ne_not_empty:

	inc hl
	ld (hl),12  ; player_iso_y
	inc hl
	ld a,(ix+DOOR_STRUCT_HEIGHT)
	add a,a
	add a,a
	add a,a
	ld (hl),a  ; player_iso_z
	ld hl,player_direction
	ld (hl),5
	ret

teleport_player_to_door_nw:
	ld (hl),12  ; player_iso_x
	inc hl
	ld a,(ix+DOOR_STRUCT_POSITION)
	add a,a
	add a,a
	add a,a
	add a,4
	ld (hl),a  ; player_iso_y
	inc hl
	ld a,(ix+DOOR_STRUCT_HEIGHT)
	add a,a
	add a,a
	add a,a
	ld (hl),a  ; player_iso_z
	ld hl,player_direction
	ld (hl),3
	ret


;-----------------------------------------------
enter_room_events:
	ld a,(state_current_room)
	and #f0
	cp #10
	call z,enter_room_events_map2

	ld a,(state_current_room)
	and #f0
	cp #20
	call z,enter_room_events_map3

	ld a,(state_current_room)
	and #f0
	cp #30
	call z,enter_room_events_map4

	ld a,(state_current_room)
	cp #14 ; enter in the writing room
	call z,enter_room_events_writting

	ld a,(state_current_room)
	cp #18 ; enter in the writing room
	call z,enter_room_events_ritual

	ld a,(state_current_room)
	cp 44 ; enter in the feeding room
	call z,enter_room_events_feeding

	ld a,(state_current_room)
	cp 61 ; enter in the lab
	call z,enter_room_events_lab

	ld a,(state_current_room)
	cp 10 ; small room after the stairs to the 2nd floor
	call z,enter_room_check_family_cutscene_preliminary

	ld a,(state_current_room)
	cp 2 ; lobby
	call z,enter_room_check_family_cutscene

	ld a,(state_current_room)
	cp 35 ; vampire1
	call z,enter_room_vampire1

	ld a,(state_current_room)
	cp 45 ; vampire2
	call z,enter_room_vampire2

	ld a,(state_current_room)
	cp 42 ; vampire3
	call z,enter_room_vampire3

	ret


enter_room_events_map2:
	ld c,2
	call update_time_day_if_needed
	ret nc
	; add message if needed:
	ld bc, TEXT_MSG_ABANDONED1_BANK + 256*TEXT_MSG_ABANDONED1_IDX
	call queue_hud_message
	ld bc, TEXT_MSG_ABANDONED2_BANK + 256*TEXT_MSG_ABANDONED2_IDX
	jp queue_hud_message		


enter_room_events_map3:
	ld c,4
	jp update_time_day_if_needed

enter_room_events_map4:
	ld c,6
	jp update_time_day_if_needed


enter_room_events_writting:
	ld a,(state_writing_room_msg)
	or a
	ret nz
	inc a
	ld (state_writing_room_msg),a
	ld bc, TEXT_MSG_BOOKS1_BANK + 256*TEXT_MSG_BOOKS1_IDX
	call queue_hud_message
	ld bc, TEXT_MSG_BOOKS2_BANK + 256*TEXT_MSG_BOOKS2_IDX
	call queue_hud_message
	ld bc, TEXT_MSG_BOOKS3_BANK + 256*TEXT_MSG_BOOKS3_IDX
	jp queue_hud_message


enter_room_events_ritual:
	ld a,(state_ritual_room_state)
	or a
	ret nz
	inc a
	ld (state_ritual_room_state),a
	ld bc, TEXT_MSG_PENTAGRAM1_BANK + 256*TEXT_MSG_PENTAGRAM1_IDX
	call queue_hud_message
	ld bc, TEXT_MSG_PENTAGRAM2_BANK + 256*TEXT_MSG_PENTAGRAM2_IDX
	jp queue_hud_message


enter_room_events_feeding:
	ld c,5
	call update_time_day_if_needed
	ret nc
	; add message if needed:
	ld bc, TEXT_MSG_FEEDING1_BANK + 256*TEXT_MSG_FEEDING1_IDX
	call queue_hud_message
	ld bc, TEXT_MSG_FEEDING2_BANK + 256*TEXT_MSG_FEEDING2_IDX
	call queue_hud_message
	ld bc, TEXT_MSG_FEEDING3_BANK + 256*TEXT_MSG_FEEDING3_IDX
	jp queue_hud_message	

enter_room_events_lab:
	ld c,7
	call update_time_day_if_needed
	ret nc
	; add message if needed:
	ld bc, TEXT_MSG_LAB_BANK + 256*TEXT_MSG_LAB_IDX
	jp queue_hud_message


enter_room_check_family_cutscene_preliminary:
	ld a,(game_time_day)
	cp 8
	ret p
	ld a,(state_lab_notes_taken)
	cp 2
	ret m

	; trigger family cutscene preliminary!
	ld bc, TEXT_MSG_FAMILY_CUTSCENE1_BANK + 256*TEXT_MSG_FAMILY_CUTSCENE1_IDX
	jp queue_hud_message


enter_room_check_family_cutscene:
	ld a,(game_time_day)
	cp 8
	ret p
	ld a,(state_lab_notes_taken)
	cp 2
	ret m

	; start cutscene:
	call Execute_jump_to_cutscene

	ld bc, TEXT_MSG_FAMILY_CUTSCENE9_BANK + 256*TEXT_MSG_FAMILY_CUTSCENE9_IDX
	call queue_hud_message
	ld bc, TEXT_MSG_FAMILY_CUTSCENE10_BANK + 256*TEXT_MSG_FAMILY_CUTSCENE10_IDX
	call queue_hud_message
	ld bc, TEXT_MSG_FAMILY_CUTSCENE11_BANK + 256*TEXT_MSG_FAMILY_CUTSCENE11_IDX
	jp queue_hud_message


enter_room_vampire1:
	ld a,(game_time_day)
	cp 8
	ret m
	ld a,(state_vampire1_state)
	cp 2
	ret z
	ld bc, TEXT_ENTER_VAMPIRE_ROOM1_BANK + 256*TEXT_ENTER_VAMPIRE_ROOM1_IDX
	call queue_hud_message
	ld bc, TEXT_ENTER_VAMPIRE_ROOM2_BANK + 256*TEXT_ENTER_VAMPIRE_ROOM2_IDX
	jp queue_hud_message


enter_room_vampire2:
	ld a,(game_time_day)
	cp 8
	ret m
	ld a,(state_vampire2_state)
	cp 2
	ret z
	ld bc, TEXT_ENTER_VAMPIRE_ROOM1_BANK + 256*TEXT_ENTER_VAMPIRE_ROOM1_IDX
	call queue_hud_message
	ld bc, TEXT_ENTER_VAMPIRE_ROOM2_BANK + 256*TEXT_ENTER_VAMPIRE_ROOM2_IDX
	jp queue_hud_message


enter_room_vampire3:
	ld a,(game_time_day)
	cp 8
	ret m
	ld a,(state_vampire3_state)
	cp 2
	ret z
	ld bc, TEXT_ENTER_VAMPIRE3_ROOM1_BANK + 256*TEXT_ENTER_VAMPIRE3_ROOM1_IDX
	jp queue_hud_message

;-----------------------------------------------
; check for music change:
enter_room_music_change:
	ld a,(state_current_room)
	cp 2  ; lobby
	jr z,enter_room_events_music_ingame1
	cp 23  ; ritual room
	jr z,enter_room_events_music_ingame1
	cp 24  ; re-ritual
	jr z,enter_room_events_music_ingame2
	cp 46  ; access to catacombs from lobby
	jr z,enter_room_events_music_ingame2

	cp 34  ; exit vampire1
	jr z,enter_room_events_music_ingame2
	cp 44  ; exit vampire2
	jr z,enter_room_events_music_ingame2
	cp 41  ; exit vampire3
	jr z,enter_room_events_music_ingame2

	cp 35  ; vampire1
	jr z,enter_room_events_music_ingame3
	cp 45  ; vampire2
	jr z,enter_room_events_music_ingame3
	cp 42  ; vampire3
	jr z,enter_room_events_music_ingame3
	ret


enter_room_events_music_ingame1:
	ld a,(state_current_music)
	cp 1
	ret z
	call StopMusic
    ld hl,music_ingame1_zx0_page1
    ld de,music_buffer
    call decompress_from_page1
    ld a,(song_speeds+1)
    call PlayMusic
    ld a,1
    ld (state_current_music),a
	ret


enter_room_events_music_ingame2:
	ld a,(state_current_music)
	cp 2
	ret z
	call StopMusic
    ld hl,music_ingame2_zx0
    ld de,music_buffer
    call dzx0_standard
    ld a,(song_speeds+2)
    call PlayMusic
    ld a,2
    ld (state_current_music),a
	ret


enter_room_events_music_ingame3:
	ld a,(state_current_music)
	cp 3
	ret z
	call StopMusic
    ld hl,music_ingame3_zx0
    ld de,music_buffer
    call dzx0_standard
    ld a,(song_speeds+3)
    call PlayMusic
    ld a,3
    ld (state_current_music),a
	ret
