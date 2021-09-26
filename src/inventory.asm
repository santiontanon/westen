;-----------------------------------------------
update_ui_control:
	ld a,(keyboard_line_state+KEY_BUTTON2_BYTE)
	bit KEY_BUTTON2_BIT,a
	jr z,update_ui_control_button2_pressed
	bit KEY_BUTTON2_BIT_ALTERNATIVE,a
	jr z,update_ui_control_button2_pressed

update_ui_control_restore_ui_sprite:
	ld hl,inventory_pointer_sprite_attributes+3
	ld a,(hl)
	or a
	ret nz
	ld a,COLOR_WHITE
	ld (hl),a
	ld hl,SPRATR2+6*4+3
	jp WRTVRM

update_ui_control_button2_pressed:
	; flash hud sprite:
	ld hl,inventory_pointer_sprite_attributes+3
	ld a,(game_cycle)
	bit 2,a
	jr z,update_ui_control_sprite_white
update_ui_control_sprite_black:
	xor a
	ld (hl),a
	jr update_ui_control_sprite_set
update_ui_control_sprite_white:
	ld a,COLOR_WHITE
	ld (hl),a
update_ui_control_sprite_set:
	ld hl,SPRATR2+6*4+3
	call WRTVRM


	ld a,(keyboard_line_clicks+KEY_LEFT_BYTE)
	bit KEY_RIGHT_BIT,a
	jr nz,update_ui_input_right
	bit KEY_LEFT_BIT,a
	jr nz,update_ui_input_left
	bit KEY_UP_BIT,a
	jr nz,update_ui_input_up
	bit KEY_DOWN_BIT,a
	jr nz,update_ui_input_down
	bit KEY_BUTTON1_BIT,a
	jr nz,update_ui_input_button
	ret


;-----------------------------------------------
update_ui_input_left:
	ld a,(inventory_selected)
	dec a
	jr update_ui_input_right_entrypoint

update_ui_input_right:
ui_next_inventory_slot:
	ld a,(inventory_selected)
	inc a
update_ui_input_right_entrypoint:
update_ui_input_up_entrypoint:
update_ui_input_down_entrypoint:
	cp INVENTORY_SIZE
	jr c, update_ui_input_no_overflow
	cp INVENTORY_SIZE*2
	jr nc, update_ui_input_negative
	add a,-INVENTORY_SIZE
	jr update_ui_input_down_entrypoint
update_ui_input_negative:
	add a,INVENTORY_SIZE
	jr update_ui_input_down_entrypoint
update_ui_input_no_overflow:
	ld (inventory_selected),a
	ld hl,SFX_ui_move
	call play_SFX_with_high_priority
	jp hud_update_inventory

update_ui_input_up:
	ld a,(inventory_selected)
	add a,-INVENTORY_SIZE/2
	jr update_ui_input_up_entrypoint

update_ui_input_down:
	ld a,(inventory_selected)
	add a,INVENTORY_SIZE/2
	jr update_ui_input_down_entrypoint


update_ui_input_button:
	ld hl,inventory
	ld b,0
	ld a,(inventory_selected)
	ld c,a
	add hl,bc
	ld a,(hl)
	ld ix,inventory_effect_functions  ; we use ix, to preserve hl
	ld c,a
	add ix,bc
	add ix,bc
	ld e,(ix)
	ld d,(ix+1)
	ld ixl,e
	ld ixh,d
	jp ix


;-----------------------------------------------
; input:
; - a: desired item
; output:
; - z: found (slot in hl)
; - nz: not found
inventory_find_slot:
	ld hl,inventory
	ld b,INVENTORY_SIZE
inventory_find_slot_loop:
	cp (hl)
	ret z
	inc hl
	djnz inventory_find_slot_loop
	inc b  ; nz
	ret


;-----------------------------------------------
inventory_fn_jump:
	ld hl,SFX_jump
	call play_SFX_with_high_priority
	ld hl,player_state
	ld (hl),PLAYER_STATE_JUMPING
	inc hl
	ld (hl),0  ; player_state_timer
	jp update_player_no_use_or_jump

;-----------------------------------------------
inventory_fn_use:
	; Check if there is an item to pickup:
	ld de,0
	ld c,-1
	call check_player_collision
	jp nz,inventory_fn_use_nothing_to_pickup

	; Check if we have a free inventory slot:
	xor a
	call inventory_find_slot
	ret nz

	; try to take the object pointed to by "ix":
	ld a,(ix)
	cp OBJECT_TYPE_STOOL
	jp z,inventory_fn_use_pickup_stool
	cp OBJECT_TYPE_YELLOW_KEY
	jp z,inventory_fn_use_pickup_yellow_key
; 	cp OBJECT_TYPE_GUN
; 	jp z,inventory_fn_use_pickup_gun
	cp OBJECT_TYPE_GUN_KEY
	jp z,inventory_fn_use_pickup_gun_key
	cp OBJECT_TYPE_LETTER3
	jp z,inventory_fn_use_pickup_letter3
	cp OBJECT_TYPE_LAMP
	jp z,inventory_fn_use_pickup_lamp
	cp OBJECT_TYPE_OIL
	jp z,inventory_fn_use_pickup_oil
	cp OBJECT_TYPE_HEART1
	jp z,inventory_fn_use_pickup_heart1
	cp OBJECT_TYPE_HEART2
	jp z,inventory_fn_use_pickup_heart2
	cp OBJECT_TYPE_HEART3
	jp z,inventory_fn_use_pickup_heart3
	cp OBJECT_TYPE_BOOK
	jp z,inventory_fn_use_pickup_book
	cp OBJECT_TYPE_CANDLE1
	jp z,inventory_fn_use_pickup_candle1
	cp OBJECT_TYPE_CANDLE2
	jp z,inventory_fn_use_pickup_candle2
	cp OBJECT_TYPE_CANDLE3
	jp z,inventory_fn_use_pickup_candle3
	cp OBJECT_TYPE_GREEN_KEY
	jp z,inventory_fn_use_pickup_green_key
	cp OBJECT_TYPE_DIARY1
	jp z,inventory_fn_use_pickup_diary1
	cp OBJECT_TYPE_DIARY2
	jp z,inventory_fn_use_pickup_diary2
	cp OBJECT_TYPE_DIARY3
	jp z,inventory_fn_use_pickup_diary3
	cp OBJECT_TYPE_LAB_NOTES
	jp z,inventory_fn_use_pickup_lab_notes
	cp OBJECT_TYPE_HAMMER
	jp z,inventory_fn_use_pickup_hammer
	cp OBJECT_TYPE_GARLIC1
	jp z,inventory_fn_use_pickup_garlic1
	cp OBJECT_TYPE_GARLIC2
	jp z,inventory_fn_use_pickup_garlic2
	cp OBJECT_TYPE_GARLIC3
	jp z,inventory_fn_use_pickup_garlic3
	cp OBJECT_TYPE_STAKE1
	jp z,inventory_fn_use_pickup_stake1
	cp OBJECT_TYPE_STAKE2
	jp z,inventory_fn_use_pickup_stake2
	cp OBJECT_TYPE_STAKE3
	jp z,inventory_fn_use_pickup_stake3

inventory_fn_use_nothing_to_pickup:
	; check if there is any item to use nearby:
	ld de,OBJECT_STRUCT_SIZE
	ld ix,objects
	ld a,(n_objects)
	ld b,a
inventory_fn_use_loop:
	; see if the object is nearby:
	call check_if_object_close_by
	jp nz,inventory_fn_use_loop_next
	ld a,(ix)
	cp OBJECT_TYPE_TOMBSTONE
	jp z,inventory_fn_use_tombstone
	cp OBJECT_TYPE_DOOR_LEFT_RED
	jp z,inventory_fn_use_door
	cp OBJECT_TYPE_DOOR_LEFT_YELLOW
	jp z,inventory_fn_use_door
	cp OBJECT_TYPE_DOOR_RIGHT_YELLOW
	jp z,inventory_fn_use_door
	cp OBJECT_TYPE_DOOR_RIGHT_WHITE
	jp z,inventory_fn_use_door
	cp OBJECT_TYPE_PAINTING_RIGHT
	jp z,inventory_fn_use_painting
	cp OBJECT_TYPE_PAINTING_SAFE_RIGHT
	jp z,inventory_fn_use_painting_safe
	cp OBJECT_TYPE_SAFE_RIGHT
	jp z,inventory_fn_use_safe
	cp OBJECT_TYPE_CHEST
	jp z,inventory_fn_use_chest
	cp OBJECT_TYPE_CHEST2
	jp z,inventory_fn_use_chest
	cp OBJECT_TYPE_SINK
	jp z,inventory_fn_use_sink
	cp OBJECT_TYPE_WINDOW_NE
	jp z,inventory_fn_use_window
	cp OBJECT_TYPE_BOOKSTACK
	jp z,inventory_fn_use_bookstack
	cp OBJECT_TYPE_TOILET
	jp z,inventory_fn_use_toilet
	cp OBJECT_TYPE_BATHTUB
	jp z,inventory_fn_use_bathtub
	cp OBJECT_TYPE_GRAMOPHONE
	jp z,inventory_fn_use_gramophone
	cp OBJECT_TYPE_VIOLIN
	jp z,inventory_fn_use_violin
	cp OBJECT_TYPE_COFFIN1
	jp z,inventory_fn_use_coffin
	cp OBJECT_TYPE_COFFIN2
	jp z,inventory_fn_use_coffin
	cp OBJECT_TYPE_BONES1
	jp z,inventory_fn_use_bones
	cp OBJECT_TYPE_BONES2
	jp z,inventory_fn_use_bones
	cp OBJECT_TYPE_BONES3
	jp z,inventory_fn_use_bones
	cp OBJECT_TYPE_CHEST_GUN
	jp z,inventory_fn_use_chest_gun
	cp OBJECT_TYPE_BOOK_WESTENRA
	jp z,inventory_fn_use_book_westenra	
	cp OBJECT_TYPE_DOOR_VAMPIRE1
	jp z,inventory_fn_use_door_vampire1
	cp OBJECT_TYPE_DOOR_VAMPIRE2
	jp z,inventory_fn_use_door_vampire2
	cp OBJECT_TYPE_DOOR_VAMPIRE3
	jp z,inventory_fn_use_door_vampire3
	cp OBJECT_TYPE_DOOR_RIGHT_GREEN
	jp z,inventory_fn_use_door
	cp OBJECT_TYPE_DOOR_RIGHT_BLUE
	jp z,inventory_fn_use_door
	cp OBJECT_TYPE_CRATE_GARLIC1
	jp z,inventory_fn_use_breakable_crate
	cp OBJECT_TYPE_CRATE_GARLIC2
	jp z,inventory_fn_use_breakable_crate
	cp OBJECT_TYPE_CRATE_GARLIC3
	jp z,inventory_fn_use_breakable_crate
	cp OBJECT_TYPE_CRATE_STAKE1
	jp z,inventory_fn_use_breakable_crate
	cp OBJECT_TYPE_CRATE_STAKE2
	jp z,inventory_fn_use_breakable_crate
	cp OBJECT_TYPE_CRATE_STAKE3
	jp z,inventory_fn_use_breakable_crate

inventory_fn_use_loop_next:	
	add ix,de
	dec b
	jp nz,inventory_fn_use_loop
inventory_fn_use_nothing_to_use:
	ld bc, TEXT_USE_ERROR_BANK + 256*TEXT_USE_ERROR_IDX
	jp queue_hud_message

inventory_fn_use_tombstone:
	ld bc, TEXT_USE_TOMBSTONE_BANK + 256*TEXT_USE_TOMBSTONE_IDX
	jp queue_hud_message	

inventory_fn_use_door:
	ld bc, TEXT_USE_DOOR_BANK + 256*TEXT_USE_DOOR_IDX
	jp queue_hud_message	

inventory_fn_use_bookstack:
	ld bc, TEXT_USE_BOOK_STACK_BANK + 256*TEXT_USE_BOOK_STACK_IDX
	jp queue_hud_message	

inventory_fn_use_toilet:
	ld bc, TEXT_USE_TOILET_BANK + 256*TEXT_USE_TOILET_IDX
	jp queue_hud_message	

inventory_fn_use_bathtub:
	ld bc, TEXT_USE_BATHTUB_BANK + 256*TEXT_USE_BATHTUB_IDX
	jp queue_hud_message	

inventory_fn_use_gramophone:
	ld bc, TEXT_USE_GRAMOPHONE_BANK + 256*TEXT_USE_GRAMOPHONE_IDX
	jp queue_hud_message	

inventory_fn_use_violin:
	ld bc, TEXT_USE_VIOLIN_BANK + 256*TEXT_USE_VIOLIN_IDX
	jp queue_hud_message	

inventory_fn_use_painting:
	ld bc, TEXT_USE_PAINTING_BANK + 256*TEXT_USE_PAINTING_IDX
	jp queue_hud_message

inventory_fn_use_chest:
	ld bc, TEXT_USE_CHEST_BANK + 256*TEXT_USE_CHEST_IDX
	jp queue_hud_message

inventory_fn_use_sink:
	ld bc, TEXT_USE_SINK_BANK + 256*TEXT_USE_SINK_IDX
	jp queue_hud_message

inventory_fn_use_window:
	ld bc, TEXT_USE_WINDOW_BANK + 256*TEXT_USE_WINDOW_IDX
	jp queue_hud_message

inventory_fn_use_coffin:
	ld bc, TEXT_USE_COFFIN_BANK + 256*TEXT_USE_COFFIN_IDX
	jp queue_hud_message

inventory_fn_use_bones:
	ld bc, TEXT_USE_BONES_BANK + 256*TEXT_USE_BONES_IDX
	jp queue_hud_message

inventory_fn_use_chest_gun:
	ld a,(state_gun_taken)
	cp 2
	jr z,inventory_fn_use_chest_gun_taken
	ld bc, TEXT_USE_CHEST_GUN1_BANK + 256*TEXT_USE_CHEST_GUN1_IDX
	jp queue_hud_message
inventory_fn_use_chest_gun_taken:
	ld bc, TEXT_USE_CHEST_GUN2_BANK + 256*TEXT_USE_CHEST_GUN2_IDX
	jp queue_hud_message


inventory_fn_use_painting_safe:
	ld bc, TEXT_USE_PAINTING_SAFE_BANK + 256*TEXT_USE_PAINTING_SAFE_IDX
	call queue_hud_message

	; replace the painting with a safe:
	ld a,1
	ld (state_painting_safe),a

	; 1) get the pointer to the painting data:
	; 2) decompress the safe data over it
	; 3) reinitialize the object
	; 4) redraw
	ld l,(ix+OBJECT_STRUCT_PTR)
	ld h,(ix+OBJECT_STRUCT_PTR+1)
	ld bc,-9
	add hl,bc
	ex de,hl
	ld hl,object_safe_right_zx0
	push ix
; 		call dzx0_standard
		call decompress_from_page1
	pop ix
	ld (ix),OBJECT_TYPE_SAFE_RIGHT
	ld e,(ix+OBJECT_STRUCT_SCREEN_TILE_X)
	ld d,(ix+OBJECT_STRUCT_SCREEN_TILE_Y)
	ld bc,#0403
	jp render_room_rectangle

inventory_fn_use_safe:
	ld a,(state_letter3_taken)
	cp 5  ; already taken the key
	jr z,inventory_fn_use_safe_already_open
	cp 4  ; check if we know the code
	jr z,inventory_fn_use_safe_open
	ld bc, TEXT_USE_SAFE_BANK + 256*TEXT_USE_SAFE_IDX
	jp queue_hud_message

inventory_fn_use_safe_already_open:
	ld bc, TEXT_USE_SAFE_OPEN2_BANK + 256*TEXT_USE_SAFE_OPEN2_IDX
	jp queue_hud_message

inventory_fn_use_safe_open:
	; gain second half of the key:
	ld a,INVENTORY_LETTER3
	call inventory_find_slot
	ret nz
	ld (hl),INVENTORY_RED_KEY_H2
	ld a,5
	ld (state_letter3_taken),a
	ld bc, TEXT_USE_SAFE_OPEN1_BANK + 256*TEXT_USE_SAFE_OPEN1_IDX
	call queue_hud_message
	jp hud_update_inventory


inventory_fn_use_book_westenra:
	ld bc, TEXT_USE_BOOK_WESTENRA1_BANK + 256*TEXT_USE_BOOK_WESTENRA1_IDX
	call queue_hud_message
	ld bc, TEXT_USE_BOOK_WESTENRA2_BANK + 256*TEXT_USE_BOOK_WESTENRA2_IDX
	call queue_hud_message
	ld bc, TEXT_USE_BOOK_WESTENRA3_BANK + 256*TEXT_USE_BOOK_WESTENRA3_IDX
	jp queue_hud_message

inventory_fn_use_pickup_stool:
	ld a,INVENTORY_STOOL
	jp inventory_fn_use_pickup_continue

inventory_fn_use_pickup_yellow_key:
	ld a,1
	ld (state_yellow_key_taken),a 
	ld a,INVENTORY_YELLOW_KEY
	jp inventory_fn_use_pickup_continue

; inventory_fn_use_pickup_gun:
; 	ld a,1
; 	ld (state_gun_taken),a 
; 	ld a,INVENTORY_GUN
; 	jr inventory_fn_use_pickup_continue

inventory_fn_use_pickup_gun_key:
	ld a,1
	ld (state_gun_taken),a 
	ld a,INVENTORY_GUN_KEY
	jp inventory_fn_use_pickup_continue

inventory_fn_use_pickup_letter3:
	push hl
	push ix
		ld bc, TEXT_LETTER3_BANK + 256*TEXT_LETTER3_IDX
		call queue_hud_message
	pop ix
	pop hl
	ld a,1
	ld (state_letter3_taken),a 
	ld a,INVENTORY_LETTER3
	jp inventory_fn_use_pickup_continue

inventory_fn_use_pickup_lamp:
	ld a,1
	ld (state_lamp_taken),a 
	ld a,INVENTORY_LAMP
	jp inventory_fn_use_pickup_continue

inventory_fn_use_pickup_oil:
	ld a,1
	ld (state_oil_taken),a 
	ld a,INVENTORY_OIL
	jp inventory_fn_use_pickup_continue

inventory_fn_use_pickup_heart1:
	ld de,state_heart1_taken
inventory_fn_use_pickup_heart1_continue:
	ld a,1
	ld (de),a
	ld a,INVENTORY_HEART
	jp inventory_fn_use_pickup_continue

inventory_fn_use_pickup_heart2:
	ld de,state_heart2_taken
	jr inventory_fn_use_pickup_heart1_continue

inventory_fn_use_pickup_heart3:
	ld de,state_heart3_taken
	jr inventory_fn_use_pickup_heart1_continue

inventory_fn_use_pickup_book:
	ld a,1
	ld (state_book_taken),a 
	ld a,INVENTORY_BOOK
	jp inventory_fn_use_pickup_continue

inventory_fn_use_pickup_candle1:
	ld de,state_candle1_position
inventory_fn_use_pickup_candle1_continue:
	ld a,#ff
	ld (state_candle1_position),a 
	ld a,INVENTORY_CANDLE
	jp inventory_fn_use_pickup_continue

inventory_fn_use_pickup_candle2:
	ld de,state_candle2_position
	jr inventory_fn_use_pickup_candle1_continue

inventory_fn_use_pickup_candle3:
	ld de,state_candle3_position
	jr inventory_fn_use_pickup_candle1_continue

inventory_fn_use_pickup_green_key:
	ld a,1
	ld (state_green_key_taken),a 
	ld a,INVENTORY_GREEN_KEY
	jr inventory_fn_use_pickup_continue

inventory_fn_use_pickup_diary1:
	ld a,1
	ld (state_diary1_taken),a 
	ld a,INVENTORY_DIARY1
	jr inventory_fn_use_pickup_continue

inventory_fn_use_pickup_diary2:
	ld a,1
	ld (state_diary2_taken),a 
	ld a,INVENTORY_DIARY2
	jr inventory_fn_use_pickup_continue

inventory_fn_use_pickup_diary3:
	ld a,1
	ld (state_diary3_taken),a 
	ld a,INVENTORY_DIARY3
	jr inventory_fn_use_pickup_continue

inventory_fn_use_pickup_lab_notes:
	ld a,1
	ld (state_lab_notes_taken),a 
	ld (hl),INVENTORY_LAB_NOTES
	call remove_room_object
	ld hl,SFX_ui_select
	call play_SFX_with_high_priority
	call hud_update_inventory	
	jp inventory_fn_lab_notes

inventory_fn_use_pickup_hammer:
	ld a,1
	ld (state_hammer_taken),a 
	ld a,INVENTORY_HAMMER
	jr inventory_fn_use_pickup_continue

inventory_fn_use_pickup_garlic1:
	ld de,state_crate_garlic1
inventory_fn_use_pickup_garlic1_continue
	ld a,2
	ld (de),a 
	ld a,INVENTORY_GARLIC
	jr inventory_fn_use_pickup_continue

inventory_fn_use_pickup_garlic2:
	ld de,state_crate_garlic2
	jr inventory_fn_use_pickup_garlic1_continue

inventory_fn_use_pickup_garlic3:
	ld de,state_crate_garlic3
	jr inventory_fn_use_pickup_garlic1_continue

inventory_fn_use_pickup_stake1:
	ld de,state_crate_stake1
inventory_fn_use_pickup_stake1_continue:
	ld a,2
	ld (de),a 
	ld a,INVENTORY_STAKE
	jr inventory_fn_use_pickup_continue

inventory_fn_use_pickup_stake2:
	ld de,state_crate_stake2
	jr inventory_fn_use_pickup_stake1_continue

inventory_fn_use_pickup_stake3:
	ld de,state_crate_stake3
	jr inventory_fn_use_pickup_stake1_continue

inventory_fn_use_pickup_continue:
	ld (hl),a
	call remove_room_object
	ld hl,SFX_ui_select
	call play_SFX_with_high_priority
; inventory_fn_use_back_to_jump:
; 	xor a
; 	ld (inventory_selected),a
	jp hud_update_inventory	

inventory_fn_use_breakable_crate:
	ld bc, TEXT_USE_BREAKABLE_CRATE_BANK + 256*TEXT_USE_BREAKABLE_CRATE_IDX
	jp queue_hud_message


inventory_fn_use_door_vampire1:
	push ix
		call state_password_lock
	pop ix
	ld a,(game_time_day)
	cp 8
	ret c  ; if player has not yet seen the cut scene, do not let the doors open

	; check if it has the right password:
	ld iy,state_vampire1_state
	ld de,password_vampire1
	ld c,INVENTORY_DIARY1
inventory_fn_use_door_vampire2_entry_point:
inventory_fn_use_door_vampire3_entry_point:
	ld hl,buffer1024+900+5  ; current password
	ld b,6
inventory_fn_use_door_vampire1_loop:
	ld a,(de)
	cp (hl)
	ret nz
	inc de
	inc hl
	djnz inventory_fn_use_door_vampire1_loop
	; passwords match!

	ld a,1
	ld (iy),a

	push bc
		call remove_room_object
	pop bc

	; remove the corresponding diary:
	ld a,c
	cp INVENTORY_VAMPIRE1_NOTE
	jr z,inventory_fn_use_door_vampire3_lose_items
	call inventory_find_slot
	jr nz,inventory_fn_use_door_vampire1_no_diary
	ld (hl),0
	call hud_update_inventory
	ld bc, TEXT_OPEN_VAMPIRE1_DOOR_BANK + 256*TEXT_OPEN_VAMPIRE1_DOOR_IDX
	call queue_hud_message
	ld bc, TEXT_OPEN_VAMPIRE1_DOOR2_BANK + 256*TEXT_OPEN_VAMPIRE1_DOOR2_IDX
	call queue_hud_message
inventory_fn_use_door_vampire1_no_diary:
inventory_fn_use_door_vampire1_no_note2:	
	ld hl,SFX_door_open
	jp play_SFX_with_high_priority


inventory_fn_use_door_vampire2:
	push ix
		call state_password_lock
	pop ix
	ld iy,state_vampire2_state
	ld de,password_vampire2
	ld c,INVENTORY_DIARY2
	jr inventory_fn_use_door_vampire2_entry_point

inventory_fn_use_door_vampire3:
	push ix
		call state_password_lock
	pop ix
	ld iy,state_vampire3_state
	ld de,password_vampire3
	ld c,INVENTORY_VAMPIRE1_NOTE
	jr inventory_fn_use_door_vampire2_entry_point

inventory_fn_use_door_vampire3_lose_items:
	ld a,INVENTORY_VAMPIRE1_NOTE
	call inventory_find_slot
	jr nz,inventory_fn_use_door_vampire1_no_note1
	ld (hl),0
	call hud_update_inventory
inventory_fn_use_door_vampire1_no_note1:
	ld a,INVENTORY_VAMPIRE2_NOTE
	call inventory_find_slot
	jr nz,inventory_fn_use_door_vampire1_no_note2
	ld (hl),0
	call hud_update_inventory
	jr inventory_fn_use_door_vampire1_no_note2


;-----------------------------------------------
; input:
; - ix:	ptr yo the object struct to use (with object type ID already set)
; - de: ptr to the compressed object data
inventory_spawn_object:
	ld a,(player_iso_x)
	add a,4
	rrca
	rrca
	rrca
	and #1f
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_X),a
	ld a,(player_iso_y)
	add a,4
	rrca
	rrca
	rrca
	and #1f
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_Y),a
	ld a,(player_iso_z)
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_Z),a
	jp load_room_init_object_ptr_set


;-----------------------------------------------
redraw_area_after_dropped_item:
	ld e,(ix+OBJECT_STRUCT_SCREEN_TILE_X)
	ld d,(ix+OBJECT_STRUCT_SCREEN_TILE_Y)
	ld bc,#0302
	push de
	push bc
		call update_object_drawing_order_n_times
	pop bc
	pop de	
	jp render_room_rectangle_safe


;-----------------------------------------------
inventory_fn_stool:
	ld a,(n_objects)
	cp MAX_ROOM_OBJECTS
; 	jr z,inventory_fn_drop_room_full
	ret z

	ld (hl),0  ; lose the stool from inventory

	; spawn a new stool:
	call find_new_object_ptr

	ld (ix),OBJECT_TYPE_STOOL
	ld de,object_stool_zx0
	call inventory_spawn_object

inventory_fn_candle_entrypoint:	
	; redraw area:
	call redraw_area_after_dropped_item

	ld hl,player_iso_z
	ld a,(hl)
	add 8
	ld (hl),a

	ld hl,SFX_drop_item
	call play_SFX_with_high_priority
	jp hud_update_inventory
; 	jr inventory_fn_use_back_to_jump


; inventory_fn_drop_room_full:
	; this should never happen!
; 	ld hl,SFX_ui_wrong
; 	jp play_SFX_with_high_priority
; 	ret


;-----------------------------------------------
; input:
; - ix: object
; output:
; - z: close by
; - nz: fat
check_if_object_close_by:
; 	ld b,20
; 	ld c,-16
	ld a,(player_iso_x)
	sub (ix+OBJECT_STRUCT_PIXEL_ISO_X)
	cp 20
	jp p,check_if_object_close_by_far
	cp -16
	jp m,check_if_object_close_by_far
	ld a,(player_iso_y)
	sub (ix+OBJECT_STRUCT_PIXEL_ISO_Y)
	cp 20
	jp p,check_if_object_close_by_far
	cp -16
	jp m,check_if_object_close_by_far
	xor a
	ret
check_if_object_close_by_far:
	or 1
	ret


;-----------------------------------------------
inventory_fn_white_key:
	; check if the corresponding door is in the room:
	ld a,OBJECT_TYPE_DOOR_RIGHT_WHITE
	ld iy,state_white_key_taken
	jr inventory_fn_white_key_entry_point

inventory_fn_green_key:
	; check if the corresponding door is in the room:
	ld a,OBJECT_TYPE_DOOR_RIGHT_GREEN
	ld iy,state_green_key_taken
	jr inventory_fn_green_key_entry_point

inventory_fn_red_key:
	; check if the corresponding door is in the room:
	ld a,OBJECT_TYPE_DOOR_LEFT_RED
	ld iy,state_red_key_taken
	jr inventory_fn_red_key_entry_point

inventory_fn_yellow_key:
	; check if the corresponding door is in the room:
	ld a,OBJECT_TYPE_DOOR_LEFT_YELLOW
	ld iy,state_yellow_key_taken

inventory_fn_backyard_key_entry_point:
inventory_fn_green_key_entry_point:
inventory_fn_white_key_entry_point:
inventory_fn_red_key_entry_point:
	ld de,OBJECT_STRUCT_SIZE
	ld ix,objects
	push hl
		ld hl,n_objects
		ld b,(hl)
	pop hl
inventory_fn_yellow_key_loop:
	cp (ix)
	jr z,inventory_fn_yellow_key_found
	add ix,de
	djnz inventory_fn_yellow_key_loop
inventory_fn_yellow_key_no_door:
	ld bc, TEXT_ITEM_KEY_BANK + 256*TEXT_ITEM_KEY_IDX
	jp queue_hud_message
inventory_fn_yellow_key_found:
	call check_if_object_close_by
	jr nz, inventory_fn_yellow_key_no_door
	; mark it in the global state:
	ld a,2
	ld (iy),a

	; remove key from inventory:
	ld (hl),0

	; remove door (ix):
	call remove_room_object
	ld hl,SFX_door_open
	call play_SFX_with_high_priority
	jp hud_update_inventory
; 	jp inventory_fn_use_back_to_jump



inventory_fn_gun_key:
	; check if the corresponding chest is in the room:
	ld a,OBJECT_TYPE_CHEST_GUN
	ld de,OBJECT_STRUCT_SIZE
	ld ix,objects
	push hl
		ld hl,n_objects
		ld b,(hl)
	pop hl
inventory_fn_gun_key_loop:
	cp (ix)
	jr z,inventory_fn_gun_key_chest_found
	add ix,de
	djnz inventory_fn_gun_key_loop
inventory_fn_yellow_key_no_chest:
	ld bc, TEXT_ITEM_KEY_GUN_BANK + 256*TEXT_ITEM_KEY_GUN_IDX
	jp queue_hud_message
inventory_fn_gun_key_chest_found:
	call check_if_object_close_by
	jr nz, inventory_fn_yellow_key_no_chest

	; mark it in the global state:
	ld a,2
	ld (state_gun_taken),a

	; switch gun key by gun:
	ld (hl),INVENTORY_GUN

	ld hl,SFX_door_open
	call play_SFX_with_high_priority

	; message:
	ld bc, TEXT_TAKE_GUN1_BANK + 256*TEXT_TAKE_GUN1_IDX
	call queue_hud_message
	ld bc, TEXT_TAKE_GUN2_BANK + 256*TEXT_TAKE_GUN2_IDX
	call queue_hud_message
	jp hud_update_inventory



inventory_fn_gun:
	ld a,(state_gun_cooldown)
	or a
	ret nz
	ld a,GUN_COOLDOWN
	ld (state_gun_cooldown),a

	ld a,(n_objects)
	cp MAX_ROOM_OBJECTS
	ret z

	ld hl,SFX_explosion
	call play_SFX_with_high_priority

	; spawn the bullet:
	call find_new_object_ptr
	ld (ix),OBJECT_TYPE_BULLET
	ld a,(player_iso_x)
; 	add a,4
	srl a
	sra a
	sra a
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_X),a
	ld a,(player_iso_y)
; 	add a,4
	srl a
	sra a
	sra a
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_Y),a
	ld a,(player_iso_z)
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_Z),a
	ld de, bullet_bin
	ld a,(player_direction)
	ld (ix+OBJECT_STRUCT_STATE),a
	jp load_room_init_object_ptr_set_decompressed


inventory_fn_red_key_half:
	ld a,INVENTORY_RED_KEY_H2
	call inventory_find_slot
	jr nz,inventory_fn_red_key_half_missing_one
	ld (hl),0
	ld a,INVENTORY_RED_KEY_H1
	call inventory_find_slot
	ld (hl),INVENTORY_RED_KEY
	ld bc, TEXT_MERGE_RED_KEY_BANK + 256*TEXT_MERGE_RED_KEY_IDX
	call queue_hud_message
	jp hud_update_inventory

inventory_fn_red_key_half_missing_one:
	ld bc, TEXT_ITEM_HALF_KEY_BANK + 256*TEXT_ITEM_HALF_KEY_IDX
	jp queue_hud_message



inventory_fn_letter3:
	; hide player:
	call hide_player

	; draw letter:
    ld a,COLOR_YELLOW + COLOR_YELLOW*16
    ld hl,CLRTBL2 + (4*32 + 4)*8
    ld bc,#0a18
    call clear_rectangle_bitmap_mode_color

	; draw text:
	ld hl,letter3_lines
	ld b,22*8
	ld de,CHRTBL2+5*32*8+5*8
	ld iyl,COLOR_YELLOW
	ld a,8
	call render_letter_text

	ld a,(state_letter3_taken)
	cp 4
	jr z,inventory_fn_letter3_secret_already_revealed
	cp 3
	jr nz,inventory_fn_letter3_no_secret
	; mark the code as seen!
	ld a,4
	ld (state_letter3_taken),a
	ld c,1
	call update_time_day_if_needed
inventory_fn_letter3_secret_already_revealed:
	ld b,12*8
	ld de,CHRTBL2+5*32*8+12*8
	ld iyl,COLOR_YELLOW+COLOR_DARK_RED*16
	ld a,TEXT_LETTER3_LINE1_SECRET_IDX
	ld c,TEXT_LETTER3_LINE1_SECRET_BANK
	call draw_text_from_bank

inventory_fn_letter3_no_secret:

	; wait for button:
	call wait_for_space_updating_messages

	; mark letter as read:
	ld hl,state_letter3_taken
	ld a,(hl)
	cp 2
	jr nc,inventory_fn_letter3_read
	ld (hl),2
inventory_fn_letter3_read:

	; redraw room again:
	ld de,4 + 4*256
	ld bc,12+10*256
	call render_room_rectangle

	ld de,16 + 4*256
	ld bc,12+10*256
	jp render_room_rectangle


inventory_fn_lamp:
	ld a,(state_lamp_taken)
	dec a
	jr z,inventory_fn_lamp_off
	; lamp on, check if we have the letter and have read it:
	ld a,(state_letter3_taken)
	cp 2 ; letter read
	jr nz,inventory_fn_lamp_letter_not_read
	push hl
		ld a,INVENTORY_LAMP
		call inventory_find_slot
		jr z,inventory_fn_lamp_with_letter_read
	pop hl
inventory_fn_lamp_letter_not_read:
	ld bc, TEXT_ITEM_LAMP_ON_BANK + 256*TEXT_ITEM_LAMP_ON_IDX
	jp queue_hud_message
inventory_fn_lamp_with_letter_read:
		ld a,3
		ld (state_letter3_taken),a
	pop hl
	ld (hl),0
	call hud_update_inventory
	ld bc, TEXT_USE_LAMP1_BANK + 256*TEXT_USE_LAMP1_IDX
	call queue_hud_message
	ld bc, TEXT_USE_LAMP2_BANK + 256*TEXT_USE_LAMP2_IDX
	jp queue_hud_message
; 	jp inventory_fn_use_back_to_jump
inventory_fn_lamp_off:
	ld bc, TEXT_ITEM_LAMP_BANK + 256*TEXT_ITEM_LAMP_IDX
	jp queue_hud_message


inventory_fn_oil:
	push hl
		ld a,INVENTORY_LAMP
		call inventory_find_slot
		jr z,inventory_fn_oil_with_lamp
	pop hl
	ld bc, TEXT_ITEM_OIL_BANK + 256*TEXT_ITEM_OIL_IDX
	jp queue_hud_message

inventory_fn_oil_with_lamp:
		ld a,2
		ld (state_lamp_taken),a
	pop hl
	ld (hl),0
	call hud_update_inventory
	ld bc, TEXT_ITEM_OIL_USED_BANK + 256*TEXT_ITEM_OIL_USED_IDX
	jp queue_hud_message
; 	jp inventory_fn_use_back_to_jump


inventory_fn_heart:
	ex de,hl
	ld hl,player_max_health
	ld a,(hl)
	cp 5
	ret z
	xor a
	ld (de),a
	ld a,(hl)
	cp 5
	jr z,inventory_fn_heart_max
	inc (hl)
	ld a,(hl)
inventory_fn_heart_max:
	ld (player_health),a
	ld hl,SFX_ui_select
	call play_SFX_with_high_priority
	call hud_update_health
	jp hud_update_inventory
; 	jp inventory_fn_use_back_to_jump


inventory_fn_book:
	ld bc, TEXT_USE_BOOK_BANK + 256*TEXT_USE_BOOK_IDX
	call queue_hud_message

	ld hl,pentagram_clue_zx0
	ld de,buffer1024
	call dzx0_standard
	call hide_player

	ld ix,buffer1024
	ld iy,5
	ld de,CHRTBL2+(6*32+13)*8
	ld bc,#0605
	ld hl,buffer1024+5*6
	ld (draw_hud_chunk_tile_ptr),hl
	call draw_hud_chunk

	; wait for button:
	call wait_for_space_updating_messages

	ld de,#060d
	ld bc,#0605
	call render_room_rectangle

	ld c,3
	call update_time_day_if_needed
	ret


inventory_fn_candle:
	ld a,(player_iso_z)
	or a
	jr nz,inventory_fn_candle_no_drop
	ld a,(game_time_day)
	cp 3
	jr c,inventory_fn_candle_no_drop  ; if player has not seen the clue yet, do not let them place the candles
	ld a,(state_current_room)
	cp #18
	jr z,inventory_fn_candle_ritual_room

inventory_fn_candle_no_drop:
	ld bc, TEXT_USE_CANDLE_BANK + 256*TEXT_USE_CANDLE_IDX
	jp queue_hud_message

inventory_fn_candle_ritual_room:
	; No need to check for this, this room is never full:
; 	ld a,(n_objects)
; 	cp MAX_ROOM_OBJECTS
; 	jp z,inventory_fn_drop_room_full
; 	ret z

	ld (hl),0  ; lose the item from inventory
	call hud_update_inventory

	; spawn a new candle:
	call find_new_object_ptr

	ld (ix),OBJECT_TYPE_CANDLE1
	ld de,object_candle_zx0
	call inventory_spawn_object

	; mark the position of the candle:
	ld hl,state_candle1_position
	ld a,(hl)
	inc a  ; cp #ff
	jr z,inventory_fn_candle_store_position
	ld (ix),OBJECT_TYPE_CANDLE2
	ld hl,state_candle2_position
	ld a,(hl)
	inc a  ; cp #ff
	jr z,inventory_fn_candle_store_position
	ld (ix),OBJECT_TYPE_CANDLE3
	ld hl,state_candle3_position

inventory_fn_candle_store_position:
	ld a,(state_current_room)
	ld (hl),a
	inc hl
	ld a,(ix+OBJECT_STRUCT_PIXEL_ISO_X)
	rrca
	rrca
	rrca
	and #1f
	ld (hl),a
	inc hl
	ld a,(ix+OBJECT_STRUCT_PIXEL_ISO_Y)
	rrca
	rrca
	rrca
	and #1f
	ld (hl),a
	inc hl
	ld a,(ix+OBJECT_STRUCT_PIXEL_ISO_Z)
	ld (hl),a

	; redraw the area:
	call inventory_fn_candle_entrypoint

	; Check if all candles are in the right position:
	ld hl,state_candle1_position
	call check_candle_position
	ret nz
	ld hl,state_candle2_position
	call check_candle_position
	ret nz
	ld hl,state_candle3_position
	call check_candle_position
	ret nz

	ld a,#ff
	ld (state_candle1_position),a
	ld (state_candle2_position),a
	ld (state_candle3_position),a

	; all candles are in the right position!!
	; visual effect:
	call hide_player
    ld a,COLOR_WHITE + COLOR_WHITE*16
    ld hl,CLRTBL2 + (0*32 + 0)*8
    ld bc,#1320
    call clear_rectangle_bitmap_mode_color

	; play SFX:
	ld hl,SFX_door_open
	call play_SFX_with_high_priority

	halt

	; open door and remove candles:
	ld ix,objects
	ld a,(n_objects)
	ld b,a
inventory_fn_candle_store_position_remove_objects_loop:
	ld a,(ix)
	push bc
		cp OBJECT_TYPE_CANDLE1
		push af
			call z,remove_room_object_no_redraw
		pop af
		jr z,inventory_fn_candle_store_position_remove_objects_loop_skip
		cp OBJECT_TYPE_CANDLE2
		push af
			call z,remove_room_object_no_redraw
		pop af
		jr z,inventory_fn_candle_store_position_remove_objects_loop_skip
		cp OBJECT_TYPE_CANDLE3
		push af
			call z,remove_room_object_no_redraw
		pop af
		jr z,inventory_fn_candle_store_position_remove_objects_loop_skip
		cp OBJECT_TYPE_DOOR_RITUAL
		push af
			call z,remove_room_object_no_redraw
		pop af
		jr z,inventory_fn_candle_store_position_remove_objects_loop_skip
		ld de,OBJECT_STRUCT_SIZE
		add ix,de
inventory_fn_candle_store_position_remove_objects_loop_skip:
	pop bc
	djnz inventory_fn_candle_store_position_remove_objects_loop

	; remove book from inventory:
	ld a,INVENTORY_BOOK
	call inventory_find_slot
	jr nz,inventory_fn_candle_store_position_no_book
	ld (hl),0
	call hud_update_inventory
inventory_fn_candle_store_position_no_book:

	; messages:
	ld bc, TEXT_MSG_PENTAGRAM_SOLVED1_BANK + 256*TEXT_MSG_PENTAGRAM_SOLVED1_IDX
	call queue_hud_message
	ld bc, TEXT_MSG_PENTAGRAM_SOLVED2_BANK + 256*TEXT_MSG_PENTAGRAM_SOLVED2_IDX
	call queue_hud_message
	ld bc, TEXT_MSG_PENTAGRAM_SOLVED3_BANK + 256*TEXT_MSG_PENTAGRAM_SOLVED3_IDX
	call queue_hud_message

	; redraw room:
    xor a
    ld hl,CLRTBL2 + (0*32 + 0)*8
    ld bc,#1320
    call clear_rectangle_bitmap_mode_color
    call render_full_room
    call draw_hud_vit_time

	ld a,2
	ld (state_ritual_room_state),a
	ret


; candle_target_positions:
;     db 24, 7, 10, 0
;     db 24, 9, 9, 0
;     db 24, 9, 8, 0
check_candle_position:
	ld a,(hl)
	cp 24
	ret nz
	inc hl
	ld a,(hl)
	cp 7
	jr z,check_candle_position1
	cp 9
	ret nz
check_candle_position2_or_3:
	inc hl
	ld a,(hl)
	cp 9
	ret z
	cp 8
	ret
check_candle_position1:
	inc hl
	ld a,(hl)
	cp 10
	ret


inventory_fn_diary1:
	call hide_player

	; draw letter:
    ld a,COLOR_YELLOW + COLOR_YELLOW*16
    ld hl,CLRTBL2 + (4*32 + 3)*8
    ld bc,#0a1a
    call clear_rectangle_bitmap_mode_color

	; draw text:
	ld hl,diary1_lines
	ld b,24*8
	ld de,CHRTBL2+5*32*8+4*8
	ld iyl,COLOR_YELLOW
	ld a,8
	call render_letter_text

	; wait for button:
	call wait_for_space_updating_messages

	; redraw room again:
	ld de,3 + 4*256
	ld bc,13+10*256
	call render_room_rectangle
	ld de,16 + 4*256
	ld bc,13+10*256
	jp render_room_rectangle


inventory_fn_diary2:
	call hide_player

	; draw letter:
    ld a,COLOR_YELLOW + COLOR_YELLOW*16
    ld hl,CLRTBL2 + (4*32 + 3)*8
    ld bc,#0b1a
    call clear_rectangle_bitmap_mode_color

	; draw text:
	ld hl,diary2_lines
	ld b,24*8
	ld de,CHRTBL2+5*32*8+4*8
	ld iyl,COLOR_YELLOW
	ld a,9
	call render_letter_text

	; wait for button:
	call wait_for_space_updating_messages

	; redraw room again:
	ld de,3 + 4*256
	ld bc,13+11*256
	call render_room_rectangle
	ld de,16 + 4*256
	ld bc,13+11*256
	jp render_room_rectangle


inventory_fn_diary3:
	ld (hl),INVENTORY_BACKYARD_KEY
	call hud_update_inventory

	ld a,1
	ld (state_backyard_key_taken),a

	ld bc, TEXT_USE_DIARY3_1_BANK + 256*TEXT_USE_DIARY3_1_IDX
	call queue_hud_message
	ld bc, TEXT_USE_DIARY3_2_BANK + 256*TEXT_USE_DIARY3_2_IDX
	call queue_hud_message
	ld bc, TEXT_USE_DIARY3_3_BANK + 256*TEXT_USE_DIARY3_3_IDX
	jp queue_hud_message


inventory_fn_backyard_key:
	; check if the corresponding door is in the room:
	ld a,OBJECT_TYPE_DOOR_RIGHT_BLUE
	ld iy,state_backyard_key_taken
	jp inventory_fn_backyard_key_entry_point


inventory_fn_lab_notes:
	; hide player:
	call hide_player

	; draw letter:
    ld a,COLOR_YELLOW + COLOR_YELLOW*16
    ld hl,CLRTBL2 + (2*32 + 3)*8
    ld bc,#0e1a
    call clear_rectangle_bitmap_mode_color
	; draw text:	
	ld hl,lab_notes_lines
	ld b,24*8
	ld de,CHRTBL2+3*32*8+4*8
	ld iyl,COLOR_YELLOW
	ld a,12
	call render_letter_text
	; wait for button:
	call wait_for_space_updating_messages

	; draw letter:
    ld a,COLOR_YELLOW + COLOR_YELLOW*16
    ld hl,CLRTBL2 + (2*32 + 3)*8
    ld bc,#0e1a
    call clear_rectangle_bitmap_mode_color
	; draw text:
	ld hl,lab_notes_lines2
	ld b,24*8
	ld de,CHRTBL2+3*32*8+4*8
	ld iyl,COLOR_YELLOW
	ld a,10
	call render_letter_text
	; wait for button:
	call wait_for_space_updating_messages

	; redraw room again:
	ld de,3 + 2*256
	ld bc,13+14*256
	call render_room_rectangle
	ld de,16 + 2*256
	ld bc,13+14*256
	call render_room_rectangle

	; draw letter:
    ld a,COLOR_YELLOW + COLOR_YELLOW*16
    ld hl,CLRTBL2 + (4*32 + 3)*8
    ld bc,#0b1a
    call clear_rectangle_bitmap_mode_color
	; draw text:
	ld hl,lab_notes_lines3
	ld b,24*8
	ld de,CHRTBL2+5*32*8+4*8
	ld iyl,COLOR_YELLOW
	ld a,9
	call render_letter_text
	; wait for button:
	call wait_for_space_updating_messages

	; redraw room again:
	ld de,3 + 4*256
	ld bc,13+11*256
	call render_room_rectangle
	ld de,16 + 4*256
	ld bc,13+11*256
	call render_room_rectangle

	; mark letter as read:
	ld hl,state_lab_notes_taken
	ld a,(hl)
	cp 2
	ret z
	ld (hl),2
	ld bc, TEXT_USE_LAB_NOTES_1_BANK + 256*TEXT_USE_LAB_NOTES_1_IDX
	call queue_hud_message
	ld bc, TEXT_USE_LAB_NOTES_2_BANK + 256*TEXT_USE_LAB_NOTES_2_IDX
	call queue_hud_message
	ld bc, TEXT_USE_LAB_NOTES_3_BANK + 256*TEXT_USE_LAB_NOTES_3_IDX
	jp queue_hud_message


inventory_fn_hammer:
	ld de,OBJECT_STRUCT_SIZE
	ld ix,objects
	push hl
		ld hl,n_objects
		ld b,(hl)
	pop hl
inventory_fn_hammer_loop:
	ld a,(ix)
	cp OBJECT_TYPE_CRATE_GARLIC1
	jr z,inventory_fn_hammer_garlic1_crate
	cp OBJECT_TYPE_CRATE_GARLIC2
	jr z,inventory_fn_hammer_garlic2_crate
	cp OBJECT_TYPE_CRATE_GARLIC3
	jr z,inventory_fn_hammer_garlic3_crate
	cp OBJECT_TYPE_CRATE_STAKE1
	jp z,inventory_fn_hammer_stake1_crate
	cp OBJECT_TYPE_CRATE_STAKE2
	jp z,inventory_fn_hammer_stake2_crate
	cp OBJECT_TYPE_CRATE_STAKE3
	jp z,inventory_fn_hammer_stake3_crate
inventory_fn_hammer_loop_next:
	add ix,de
	djnz inventory_fn_hammer_loop
inventory_fn_hammer_no_breakable_crate:
	ld bc, TEXT_USE_HAMMER1_BANK + 256*TEXT_USE_HAMMER1_IDX
	jp queue_hud_message

inventory_fn_hammer_garlic1_crate:
	call check_if_object_close_by
	jr nz, inventory_fn_hammer_loop_next
	ld a,1
	ld (state_crate_garlic1),a
	ld a,OBJECT_TYPE_GARLIC1
	push af
	jr inventory_fn_hammer_garlic_crate_continue

inventory_fn_hammer_garlic2_crate:
	call check_if_object_close_by
	jr nz, inventory_fn_hammer_loop_next
	ld a,1
	ld (state_crate_garlic2),a
	ld a,OBJECT_TYPE_GARLIC2
	push af
	jr inventory_fn_hammer_garlic_crate_continue

inventory_fn_hammer_garlic3_crate:
	call check_if_object_close_by
	jr nz, inventory_fn_hammer_loop_next
	ld a,1
	ld (state_crate_garlic3),a
	ld a,OBJECT_TYPE_GARLIC3
	push af

inventory_fn_hammer_garlic_crate_continue:
	; remove crate (save its position first):
	ld a,(ix+OBJECT_STRUCT_PIXEL_ISO_Z)
	push af
	ld a,(ix+OBJECT_STRUCT_PIXEL_ISO_Y)
	push af
	ld a,(ix+OBJECT_STRUCT_PIXEL_ISO_X)
	push af
	call remove_room_object
	ld hl,SFX_door_open
	call play_SFX_with_high_priority

	; spawn garlic:
	call find_new_object_ptr

	ld de,object_garlic_zx0
inventory_fn_hammer_crate_continue:	
	pop af
	rrca
	rrca
	rrca
	and #1f
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_X),a
	pop af
	rrca
	rrca
	rrca
	and #1f
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_Y),a
	pop af
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_Z),a
	pop af
	ld (ix),a
	call load_room_init_object_ptr_set

	; redraw area:
	call redraw_area_after_dropped_item

	ld bc, TEXT_USE_HAMMER2_BANK + 256*TEXT_USE_HAMMER2_IDX
	jp queue_hud_message


inventory_fn_hammer_stake1_crate:
	call check_if_object_close_by
	jp nz, inventory_fn_hammer_loop_next
	ld a,1
	ld (state_crate_stake1),a
	ld a,OBJECT_TYPE_STAKE1
	push af
	jr inventory_fn_hammer_stake_crate_continue

inventory_fn_hammer_stake2_crate:
	call check_if_object_close_by
	jp nz, inventory_fn_hammer_loop_next
	ld a,1
	ld (state_crate_stake2),a
	ld a,OBJECT_TYPE_STAKE2
	push af
	jr inventory_fn_hammer_stake_crate_continue

inventory_fn_hammer_stake3_crate:
	call check_if_object_close_by
	jp nz, inventory_fn_hammer_loop_next
	ld a,1
	ld (state_crate_stake3),a
	ld a,OBJECT_TYPE_STAKE3
	push af

inventory_fn_hammer_stake_crate_continue:
	; remove crate (save its position first):
	ld a,(ix+OBJECT_STRUCT_PIXEL_ISO_Z)
	push af
	ld a,(ix+OBJECT_STRUCT_PIXEL_ISO_Y)
	push af
	ld a,(ix+OBJECT_STRUCT_PIXEL_ISO_X)
	push af
	call remove_room_object
	ld hl,SFX_door_open
	call play_SFX_with_high_priority

	; spawn stake:
	call find_new_object_ptr

	ld de,object_stake_zx0
	jp inventory_fn_hammer_crate_continue



inventory_fn_garlic:
	ld a,(game_time_day)
	cp 8
	jp m,inventory_fn_garlic_do_not_rub
	push hl
		ld a,INVENTORY_STAKE
		call inventory_find_slot
		jr z,inventory_fn_garlic_with_stake
	pop hl
inventory_fn_garlic_do_not_rub:
	ld bc, TEXT_USE_GARLIC1_BANK + 256*TEXT_USE_GARLIC1_IDX
	jp queue_hud_message
inventory_fn_garlic_with_stake:
		ld (hl),INVENTORY_RUBBED_STAKE
	pop hl
	ld (hl),0
	call hud_update_inventory
	ld bc, TEXT_USE_GARLIC2_BANK + 256*TEXT_USE_GARLIC2_IDX
	jp queue_hud_message


inventory_fn_stake:
	ld bc, TEXT_USE_STAKE_BANK + 256*TEXT_USE_STAKE_IDX
	jp queue_hud_message


inventory_fn_rubbed_stake:
	ld a,(state_current_room)
	cp 35
	jr z,inventory_fn_rubbed_stake_vampire1_room
	cp 45
	jr z,inventory_fn_rubbed_stake_vampire2_room
	cp 42
	jr z,inventory_fn_rubbed_stake_vampire3_room
inventory_fn_rubbed_stake_describe:
	ld bc, TEXT_USE_RUBBED_STAKE_BANK + 256*TEXT_USE_RUBBED_STAKE_IDX
	jp queue_hud_message

inventory_fn_rubbed_stake_vampire1_room:
	ld a,(state_vampire1_state)
	cp 2
	jr z,inventory_fn_rubbed_stake_describe
	jr inventory_fn_rubbed_stake_vampire_room

inventory_fn_rubbed_stake_vampire2_room:
	ld a,(state_vampire2_state)
	cp 2
	jr z,inventory_fn_rubbed_stake_describe
	jr inventory_fn_rubbed_stake_vampire_room

inventory_fn_rubbed_stake_vampire3_room:
	ld a,(state_vampire3_state)
	cp 2
	jr z,inventory_fn_rubbed_stake_describe

inventory_fn_rubbed_stake_vampire_room:
	ld a,(current_room_vampire_state)
	or a
	jr z,inventory_fn_rubbed_stake_vampire_room_sleeping
inventory_fn_rubbed_stake_vampire_room_awake:
	ld bc, TEXT_USE_RUBBED_STAKE_AWAKE_BANK + 256*TEXT_USE_RUBBED_STAKE_AWAKE_IDX
	jp queue_hud_message

inventory_fn_rubbed_stake_vampire_room_sleeping:
	; check if we are near a coffin2:
	ld a,OBJECT_TYPE_COFFIN2
	call find_closeby_room_object
	jr z,inventory_fn_rubbed_stake_vampire_room_sleeping_found
	ld bc, TEXT_USE_RUBBED_STAKE_TOO_FAR_BANK + 256*TEXT_USE_RUBBED_STAKE_TOO_FAR_IDX
	jp queue_hud_message
inventory_fn_rubbed_stake_vampire_room_sleeping_found:

	; kill the vampire!!!
	ld (hl),0  ; lose the stake
	push hl
	    ; swap with a closed coffin:
		ld (ix),#ff ; this will force decompression
		call inventory_object_position_to_tiles
		ld de,object_coffin2_zx0
		call load_room_init_object_ptr_set
		ld (ix),OBJECT_TYPE_COFFIN2

		ld a,OBJECT_TYPE_COFFIN1
		call find_closeby_room_object
		ld (ix),#fe ; this will force decompression
		call inventory_object_position_to_tiles
		ld de,object_coffin1_zx0
		call load_room_init_object_ptr_set
		ld (ix),OBJECT_TYPE_COFFIN1

		ld bc, TEXT_USE_RUBBED_STAKE_KILL_BANK + 256*TEXT_USE_RUBBED_STAKE_KILL_IDX
		call queue_hud_message

		; visual effect:
		call hide_player
	    ld a,COLOR_WHITE + COLOR_WHITE*16
	    ld hl,CLRTBL2 + (0*32 + 0)*8
	    ld bc,#1320
	    call clear_rectangle_bitmap_mode_color

		; play SFX:
		ld hl,SFX_explosion
		call play_SFX_with_high_priority	

		halt

	    call render_full_room
		call draw_hud_vit_time
	    call draw_player
	pop hl

	; mark vampire as dead:
	ld a,(state_current_room)
	cp 35
	jr z,inventory_fn_rubbed_stake_kill_vampire1
	cp 45
	jr z,inventory_fn_rubbed_stake_kill_vampire2
;	cp 42
;	jr z,inventory_fn_rubbed_stake_kill_vampire3
inventory_fn_rubbed_stake_kill_vampire3:
	ld a,2
	ld (state_vampire3_state),a	
	call hud_update_inventory
	jp Execute_jump_to_ending

inventory_fn_rubbed_stake_kill_vampire1:
	ld a,2
	ld (state_vampire1_state),a
	ld (hl),INVENTORY_VAMPIRE1_NOTE
	ld bc, TEXT_FIND_VAMPIRE_NOTE_BANK + 256*TEXT_FIND_VAMPIRE_NOTE_IDX
inventory_fn_rubbed_stake_kill_vampire2_entrypoint:
	call queue_hud_message
	jp hud_update_inventory

inventory_fn_rubbed_stake_kill_vampire2:
	ld a,2
	ld (state_vampire2_state),a
	ld (hl),INVENTORY_VAMPIRE2_NOTE
	ld bc, TEXT_FIND_VAMPIRE_NOTE_BANK + 256*TEXT_FIND_VAMPIRE_NOTE_IDX
	jr inventory_fn_rubbed_stake_kill_vampire2_entrypoint
; 	call queue_hud_message
; 	jp hud_update_inventory


inventory_object_position_to_tiles:
	ld a,(ix+OBJECT_STRUCT_PIXEL_ISO_X)
	rrca
	rrca
	rrca
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_X),a
	ld a,(ix+OBJECT_STRUCT_PIXEL_ISO_Y)
	rrca
	rrca
	rrca
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_Y),a
	ret


inventory_fn_vampire1_note:
	; hide player:
	call hide_player

	; draw letter:
    ld a,COLOR_YELLOW + COLOR_YELLOW*16
    ld hl,CLRTBL2 + (4*32 + 3)*8
    ld bc,#0b1a
    call clear_rectangle_bitmap_mode_color
	; draw text:	
	ld hl,vampire1_note_lines
	ld b,24*8
	ld de,CHRTBL2+5*32*8+4*8
	ld a,9
inventory_fn_vampire2_note_entrypoint:
	ld iyl,COLOR_YELLOW
	call render_letter_text
	; wait for button:
	call wait_for_space_updating_messages

	; redraw room again:
	ld de,3 + 4*256
	ld bc,13+11*256
	call render_room_rectangle
	ld de,16 + 4*256
	ld bc,13+11*256
	jp render_room_rectangle


inventory_fn_vampire2_note:
	; hide player:
	call hide_player

	; draw letter:
    ld a,COLOR_YELLOW + COLOR_YELLOW*16
    ld hl,CLRTBL2 + (5*32 + 4)*8
    ld bc,#0718
    call clear_rectangle_bitmap_mode_color
	; draw text:	
	ld hl,vampire2_note_lines
	ld b,22*8
	ld de,CHRTBL2+6*32*8+5*8
	ld a,5
	jr inventory_fn_vampire2_note_entrypoint
; 	ld iyl,COLOR_YELLOW
; 	call render_letter_text
; 	; wait for button:
; 	call wait_for_space_updating_messages

; 	; redraw room again:
; 	ld de,4 + 5*256
; 	ld bc,12+7*256
; 	call render_room_rectangle
; 	ld de,16 + 5*256
; 	ld bc,12+7*256
; 	jp render_room_rectangle
