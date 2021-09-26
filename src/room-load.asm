;-----------------------------------------------
; input:
; - hl: map
; - a: room # within the map
load_room:
	; clear the buffers:
	push hl
		ld hl,object_decompression_buffer
		ld (hl),0
		ld de,object_decompression_buffer+1
		ld bc,OBJECT_DECOMPRESSION_BUFFER_SIZE+DOOR_DECOMPRESSION_BUFFER_SIZE-1
		ldir
	pop hl

	push af
		ld de,buffer1024
		call decompress_from_page1
	pop af
	ld hl,buffer1024
	or a
	jr z,load_room_found
load_room_loop:
	ld c,(hl)
	inc hl
	ld b,(hl)
	inc hl
	add hl,bc
	dec a
	jr nz,load_room_loop
load_room_found:
	inc hl  ; skip the room size
	inc hl
	ld de,room_x
	ldi
	ldi
	ldi
	ldi
	ld a,(hl)  ; floor type
	inc hl
	push hl
		call load_room_floor
	pop hl

	ld a,(hl)  ; wall type
	inc hl
	push hl
		call load_room_wall
	pop hl

	ld a,(hl)
	ld (n_doors),a
	inc hl
	or a
	jr z, load_room_door_loop_done
	ld de,doors
	ld b,a
load_room_door_loop:
	push bc
		push de
			ld bc,DOOR_STRUCT_SIZE
			ldir
		pop ix
		push de
		push hl
			call load_room_door
		pop hl
		pop de
	pop bc
	djnz load_room_door_loop
load_room_door_loop_done:

	; shoft the room_y upward to make walls have width:
	push hl
		ld hl,room_y
		dec (hl)
		dec (hl)
		inc hl
		inc (hl)
		inc (hl)
		inc hl
		inc (hl)
		inc (hl)
	pop hl

	; load objects:
	xor a
	ld (room_enemy_type),a
	ld (object_decompression_buffer),a
	ld a,(hl)
	ld (n_objects),a
	inc hl
	or a
	jr z, load_room_object_loop_done  ; no objects
	ld b,a
	ld ix,objects
load_room_object_loop:
	push bc
		push ix
		pop de
		ld bc,4
		ldir
		bit 7,(ix)
		push af
			call z,load_room_init_object
		pop af
		call nz,load_room_init_enemy
		ld de,OBJECT_STRUCT_SIZE
		add ix,de
load_room_object_loop_skip:
	pop bc
	djnz load_room_object_loop
load_room_object_loop_done:

	; clear vampire state:
	xor a
	ld (current_room_vampire_state),a

	; assuming we only have one type of enemy per room, decompress the enemy type:
	ld a,(room_enemy_type)
	dec a
	jp z,decompress_enemy_rat
	add a,-2
	jp z,decompress_enemy_spider
	dec a
	jp z,decompress_enemy_slime
	dec a
	jp z,decompress_enemy_bat

load_room_enemy_loop_done:
	; Fill in derived variables:
	ld a,(room_width)
	inc a
	add a,a
	add a,a
	add a,a
	ld (room_width_pixels),a
	ld a,(room_height)
	inc a
	add a,a
	add a,a
	add a,a
	ld (room_height_pixels),a
	call spawn_global_items
	jp create_wall_colliders


load_room_floor:
; 	or a
; 	jp z,setup_floor_blue_tiles
	dec a
	jp z,setup_floor_blue_tiles_frame
	dec a
	jp z,setup_floor_grass
	dec a
	jp z,setup_floor_wood
	ret


load_room_wall:
	or a
	ret z
	dec a
	jp z,setup_wall_bookshelves
	dec a
	jp z,setup_wall_bluebricks
	dec a
	jp z,setup_wall_entrance
	dec a
	jp z,setup_wall_victorian
	dec a
	jp z,setup_wall_victorian_tiles
	dec a
	jp z,setup_wall_victorian_blue
	dec a
	jp z,setup_wall_bricks_bookshelves
	ret


load_room_door:
	ld a,(ix+0)
	cp 1
	ret z
	cp 2
	jr z,load_door_left_brick
	cp 3
	jr z,load_door_left_brick_stairs
	cp 4
	jr z,load_door_left_bookshelf
	cp 5
	jr z,load_door_wood_nw
	cp 6
	jr z,load_door_victorian_tiles_nw

	cp 64+1
	ret z
	cp 64+2
	jr z,load_door_right_brick
	cp 64+3
	jr z,load_door_right_brick_stairs
	cp 64+4
	jr z,load_door_right_bookshelf
	cp 64+5
	jr z,load_door_right_entrance
	cp 64+6
	jr z,load_door_wood_ne
	cp 64+7
	jr z,load_door_victorian_tiles_ne

	cp 64*2+1
	ret z
	cp 64*2+2
	jr z,load_door_se
	cp 64*2+3
	jr z,load_door_wood_se

	cp 64*3+1
	ret z
	cp 64*3+2
	jr z,load_door_sw
	cp 64*3+3
	jr z,load_door_wood_sw
	ret

load_door_left_brick:
	ld de,door_left_brick_zx0
	jp setup_door_nw

load_door_left_brick_stairs:
	ld de,door_left_brick_stairs_zx0
	jp setup_door_nw

load_door_left_bookshelf:
	ld de,door_left_bookshelf_zx0
	jp setup_door_nw

load_door_wood_nw:
	ld de,door_wood_nw_zx0
	jp setup_door_nw

load_door_right_brick:
	ld de,door_right_brick_zx0
	jp setup_door_ne

load_door_right_brick_stairs:
	ld de,door_right_brick_stairs_zx0
	jp setup_door_ne

load_door_right_bookshelf:
	ld de,door_right_bookshelf_zx0
	jp setup_door_ne

load_door_right_entrance:
	ld de,door_right_entrance_zx0
	jp setup_door_ne

load_door_victorian_tiles_nw:
	ld de,door_victorian_tiles_nw_zx0
	jp setup_door_nw

load_door_wood_ne:
	ld de,door_wood_ne_zx0
	jp setup_door_ne

load_door_victorian_tiles_ne:
	ld de,door_victorian_tiles_ne_zx0
	jp setup_door_ne

load_door_sw:
	ld de,door_sw_zx0
	jp setup_door_sw

load_door_se:
	ld de,door_se_zx0
	jp setup_door_se


load_door_wood_sw:
	ld de,door_wood_sw_zx0
	jp setup_door_sw

load_door_wood_se:
	ld de,door_wood_se_zx0
	jp setup_door_se

;-----------------------------------------------
; Populates the object ptr, and the screen coordinates of the object. 
; input:
; - ix: object ptr
load_room_init_object:
	ld a,(ix)
	push hl
		ld hl,object_data_ptrs - 4 ; first object ID is 2
		ld b,0
		ld c,a
		add hl,bc
		add hl,bc
		ld e,(hl)
		inc hl
		ld d,(hl)
	pop hl
	cp OBJECT_TYPE_YELLOW_KEY
	jp z,load_room_init_object_yellow_key
	cp OBJECT_TYPE_DOOR_LEFT_RED
	jp z,load_room_init_object_door_left_red
	cp OBJECT_TYPE_DOOR_RIGHT_YELLOW
	jp z,load_room_init_object_door_right_yellow
; 	cp OBJECT_TYPE_GUN
; 	jp z,load_room_init_object_gun
	cp OBJECT_TYPE_GUN_KEY
	jp z,load_room_init_object_gun_key
	cp OBJECT_TYPE_DOOR_RIGHT_WHITE
	jp z,load_room_init_object_door_right_white
	cp OBJECT_TYPE_LETTER3
	jp z,load_room_init_object_letter3
	cp OBJECT_TYPE_LAMP
	jp z,load_room_init_object_lamp
	cp OBJECT_TYPE_OIL
	jp z,load_room_init_object_oil
	cp OBJECT_TYPE_PAINTING_SAFE_RIGHT
	jp z,load_room_init_painting_safe_right
	cp OBJECT_TYPE_HEART1
	jp z,load_room_init_object_heart1
	cp OBJECT_TYPE_HEART2
	jp z,load_room_init_object_heart2
	cp OBJECT_TYPE_HEART3
	jp z,load_room_init_object_heart3
	cp OBJECT_TYPE_BOOK
	jp z,load_room_init_object_book
	cp OBJECT_TYPE_DOOR_RITUAL
	jp z,load_room_init_object_ritual_door
	cp OBJECT_TYPE_DOOR_LEFT_YELLOW
	jp z,load_room_init_object_door_left_yellow
	cp OBJECT_TYPE_GREEN_KEY
	jp z,load_room_init_object_green_key
	cp OBJECT_TYPE_DOOR_RIGHT_GREEN
	jp z,load_room_init_object_door_right_green
	cp OBJECT_TYPE_DIARY1
	jp z,load_room_init_object_diary1
	cp OBJECT_TYPE_DIARY2
	jp z,load_room_init_object_diary2
	cp OBJECT_TYPE_DIARY3
	jp z,load_room_init_object_diary3
	cp OBJECT_TYPE_LAB_NOTES
	jp z,load_room_init_object_lab_notes
	cp OBJECT_TYPE_HAMMER
	jp z,load_room_init_object_hammer
	cp OBJECT_TYPE_DOOR_RIGHT_BLUE
	jp z,load_room_init_object_door_right_blue
	cp OBJECT_TYPE_CRATE_GARLIC1
	jp z,load_room_init_object_crate_garlic1
	cp OBJECT_TYPE_CRATE_GARLIC2
	jp z,load_room_init_object_crate_garlic2
	cp OBJECT_TYPE_CRATE_GARLIC3
	jp z,load_room_init_object_crate_garlic3
	cp OBJECT_TYPE_CRATE_STAKE1
	jp z,load_room_init_object_crate_stake1
	cp OBJECT_TYPE_CRATE_STAKE2
	jp z,load_room_init_object_crate_stake2
	cp OBJECT_TYPE_CRATE_STAKE3
	jp z,load_room_init_object_crate_stake3
	cp OBJECT_TYPE_DOOR_VAMPIRE1
	jp z,load_room_init_object_door_vampire1
	cp OBJECT_TYPE_DOOR_VAMPIRE2
	jp z,load_room_init_object_door_vampire2
	cp OBJECT_TYPE_DOOR_VAMPIRE3
	jp z,load_room_init_object_door_vampire3
	cp OBJECT_TYPE_COFFIN1
	jp z,load_room_init_object_coffin1
	cp OBJECT_TYPE_COFFIN2
	jp z,load_room_init_object_coffin2

load_room_init_object_ptr_set:
	; see if we have the object already recompressed:
	push hl
		ld hl,object_decompression_buffer
load_room_init_object_find_decompressed_loop:
		ld a,(hl)
		or a
		jr z,load_room_init_object_not_found
		cp (ix)
		jr z,load_room_init_object_found
		inc hl
		ld c,(hl)
		inc hl
		ld b,(hl)
		inc hl
		add hl,bc
		jr load_room_init_object_find_decompressed_loop

load_room_init_object_found:
		ex de,hl
		inc de
		jr load_room_init_object_decompressed

load_room_init_object_not_found:
		ex de,hl
		ld a,(ix)
		ld (de),a
		inc de
		push de
		push ix
; 			call dzx0_standard
			call decompress_from_page1
		pop ix
		pop de
load_room_init_object_decompressed:
		inc de
		inc de  ; skip object size in bytes
	pop hl

load_room_init_object_ptr_set_decompressed:
	ld a,(de)  ; object width
	ld (ix+OBJECT_STRUCT_SCREEN_TILE_W),a	
	inc de
	ld a,(de)  ; object height
	ld (ix+OBJECT_STRUCT_SCREEN_TILE_H),a	

	inc de
	ld a,(de)  ; object width
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_W),a
	inc de
	ld a,(de)  ; object height
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_H),a

	inc de
	ld a,(de)  ; object z height
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_Z_H),a	
	inc de
	ld a,(de)  ; object x offset
	ld (ix+OBJECT_STRUCT_TILE_X_OFFSET),a	
	inc de
	ld a,(de)  ; object y offset
	ld (ix+OBJECT_STRUCT_TILE_Y_OFFSET),a	
	inc de

	; screen_x = room_x + x - y
	; screen_y = room_y + x/2 + y/2
	ld a,(room_x)
	add a,(ix+OBJECT_STRUCT_PIXEL_ISO_X)  ; note: at this point, coordinates are still in "tiles", we have not yet converted them to pixels
	sub (ix+OBJECT_STRUCT_PIXEL_ISO_Y)
	sub (ix+OBJECT_STRUCT_TILE_X_OFFSET)
	ld (ix+OBJECT_STRUCT_SCREEN_TILE_X),a
	add a,a
	add a,a
	add a,a
	ld (ix+OBJECT_STRUCT_SCREEN_PIXEL_X),a	

	; convert the coordinates to pixels (multiply first by 4, and by 2 more below):
	sla (ix+OBJECT_STRUCT_PIXEL_ISO_X)
	sla (ix+OBJECT_STRUCT_PIXEL_ISO_X)
	sla (ix+OBJECT_STRUCT_PIXEL_ISO_Y)
	sla (ix+OBJECT_STRUCT_PIXEL_ISO_Y)
 
	ld a,(room_y)
	add a,a
	add a,a
	add a,a
	add a,(ix+OBJECT_STRUCT_PIXEL_ISO_X)
	add a,(ix+OBJECT_STRUCT_PIXEL_ISO_Y)
	ld b,a
	ld a,(ix+OBJECT_STRUCT_TILE_Y_OFFSET)
	add a,a
	add a,a
	add a,a
	ld c,a
	ld a,b
	sub c
	sub (ix+OBJECT_STRUCT_PIXEL_ISO_Z)
	ld (ix+OBJECT_STRUCT_SCREEN_PIXEL_Y),a
	rrca
	rrca
	rrca
	and #1f
	ld (ix+OBJECT_STRUCT_SCREEN_TILE_Y),a

	sla (ix+OBJECT_STRUCT_PIXEL_ISO_X)
	sla (ix+OBJECT_STRUCT_PIXEL_ISO_Y)

	; we store the pointer to the object, skipping the w, h data
	ld (ix+OBJECT_STRUCT_PTR),e
	ld (ix+OBJECT_STRUCT_PTR+1),d	
	ret

load_room_init_object_yellow_key:
	ld a,(state_yellow_key_taken)
	or a
	jp nz, load_room_init_object_already_taken
	jp load_room_init_object_ptr_set

load_room_init_object_door_right_yellow:
	ld a,(state_yellow_key_taken)
	cp 2
	jp z, load_room_init_object_already_taken
	jp load_room_init_object_ptr_set

load_room_init_object_door_left_yellow:
	ld a,(state_yellow_key_taken)
	cp 2
	jp z, load_room_init_object_already_taken
	jp load_room_init_object_ptr_set

load_room_init_object_door_left_red:
	ld a,(state_red_key_taken)
	cp 2
	jp z, load_room_init_object_already_taken
	jp load_room_init_object_ptr_set

load_room_init_object_door_right_white:
	ld a,(state_white_key_taken)
	cp 2
	jp z, load_room_init_object_already_taken
	jp load_room_init_object_ptr_set

load_room_init_object_door_right_green:
	ld a,(state_green_key_taken)
	cp 2
	jp z, load_room_init_object_already_taken
	jp load_room_init_object_ptr_set

load_room_init_object_door_right_blue:
	ld a,(state_backyard_key_taken)
	cp 2
	jp z, load_room_init_object_already_taken
	jp load_room_init_object_ptr_set

load_room_init_object_door_vampire1:
	ld a,(state_vampire1_state)
	or a
	jp nz, load_room_init_object_already_taken
	jp load_room_init_object_ptr_set

load_room_init_object_door_vampire2:
	ld a,(state_vampire2_state)
	or a
	jp nz, load_room_init_object_already_taken
	jp load_room_init_object_ptr_set

load_room_init_object_door_vampire3:
	ld a,(state_vampire3_state)
	or a
	jp nz, load_room_init_object_already_taken
	jp load_room_init_object_ptr_set

; load_room_init_object_gun:
; 	ld a,(state_gun_taken)
; load_room_init_object_takeable:
; 	or a
; 	jr nz, load_room_init_object_already_taken
; 	jp load_room_init_object_ptr_set

load_room_init_object_gun_key:
	ld a,(state_gun_taken)
load_room_init_object_takeable:
	or a
	jp nz, load_room_init_object_already_taken
	jp load_room_init_object_ptr_set

load_room_init_object_green_key:
	ld a,(state_green_key_taken)
	or a
	jp nz, load_room_init_object_already_taken
	jp load_room_init_object_ptr_set

load_room_init_object_letter3:
	ld a,(state_letter3_taken)
	jr load_room_init_object_takeable

load_room_init_object_lamp:
	ld a,(state_lamp_taken)
	jr load_room_init_object_takeable

load_room_init_object_oil:
	ld a,(state_oil_taken)
	jr load_room_init_object_takeable

load_room_init_object_heart1:
	ld a,(state_heart1_taken)
	jr load_room_init_object_takeable

load_room_init_object_heart2:
	ld a,(state_heart2_taken)
	jr load_room_init_object_takeable

load_room_init_object_heart3:
	ld a,(state_heart3_taken)
	jr load_room_init_object_takeable

load_room_init_object_book:
	ld a,(state_book_taken)
	jr load_room_init_object_takeable

load_room_init_painting_safe_right:
	ld a,(state_painting_safe)
	or a
	jp z,load_room_init_object_ptr_set
	; replace the painting by a safe:
	ld (ix),OBJECT_TYPE_SAFE_RIGHT
	ld de,object_safe_right_zx0
	jp load_room_init_object_ptr_set

load_room_init_object_ritual_door:
	ld a,(state_ritual_room_state)
	cp 2
	jp z, load_room_init_object_already_taken
	jp load_room_init_object_ptr_set

load_room_init_object_diary1:
	ld a,(state_diary1_taken)
	jr load_room_init_object_takeable

load_room_init_object_diary2:
	ld a,(state_diary2_taken)
	jr load_room_init_object_takeable

load_room_init_object_diary3:
	ld a,(state_diary3_taken)
	jr load_room_init_object_takeable

load_room_init_object_lab_notes:
	ld a,(state_lab_notes_taken)
	jr load_room_init_object_takeable

load_room_init_object_hammer:
	ld a,(state_hammer_taken)
	jr load_room_init_object_takeable


load_room_init_object_crate_garlic1:
	ld a,(state_crate_garlic1)
	or a
	jp z,load_room_init_object_ptr_set
	dec a
	jr nz,load_room_init_object_already_taken
	ld (ix),OBJECT_TYPE_GARLIC1
	ld de,object_garlic_zx0
	jp load_room_init_object_ptr_set

load_room_init_object_crate_garlic2:
	ld a,(state_crate_garlic2)
	or a
	jp z,load_room_init_object_ptr_set
	dec a
	jr nz,load_room_init_object_already_taken
	ld (ix),OBJECT_TYPE_GARLIC2
	ld de,object_garlic_zx0
	jp load_room_init_object_ptr_set

load_room_init_object_crate_garlic3:
	ld a,(state_crate_garlic3)
	or a
	jp z,load_room_init_object_ptr_set
	dec a
	jr nz,load_room_init_object_already_taken
	ld (ix),OBJECT_TYPE_GARLIC3
	ld de,object_garlic_zx0
	jp load_room_init_object_ptr_set

load_room_init_object_crate_stake1:
	ld a,(state_crate_stake1)
	or a
	jp z,load_room_init_object_ptr_set
	dec a
	jr nz,load_room_init_object_already_taken
	ld (ix),OBJECT_TYPE_STAKE1
	ld de,object_stake_zx0
	jp load_room_init_object_ptr_set

load_room_init_object_crate_stake2:
	ld a,(state_crate_stake2)
	or a
	jp z,load_room_init_object_ptr_set
	dec a
	jr nz,load_room_init_object_already_taken
	ld (ix),OBJECT_TYPE_STAKE2
	ld de,object_stake_zx0
	jp load_room_init_object_ptr_set

load_room_init_object_crate_stake3:
	ld a,(state_crate_stake3)
	or a
	jp z,load_room_init_object_ptr_set
	dec a
	jr nz,load_room_init_object_already_taken
	ld (ix),OBJECT_TYPE_STAKE3
	ld de,object_stake_zx0
	jp load_room_init_object_ptr_set


load_room_init_object_already_taken:
	push hl
		ld hl,n_objects
		dec (hl)
	pop hl
	pop af ; restore the stack
	pop af
	jp load_room_object_loop_skip


load_room_init_object_coffin1:
	ld a,(game_time_day)
	cp 8
	jp m,load_room_init_object_ptr_set
	ld a,(state_current_room)
	cp 35  ; vampire 1
	jr z,load_room_init_object_coffin1_vampire1
	cp 45  ; vampire 2
	jr z,load_room_init_object_coffin1_vampire2
	; vampire 3
	ld a,(state_vampire3_state)
	cp 2  ; vampire dead
	jp z, load_room_init_object_ptr_set
	ld de,coffin_vampire_1_zx0
	jp load_room_init_object_ptr_set
load_room_init_object_coffin1_vampire1:
	ld a,(state_vampire1_state)
	cp 2  ; vampire dead
	jp z, load_room_init_object_ptr_set
	ld de,coffin_vampire_1_zx0
	jp load_room_init_object_ptr_set
load_room_init_object_coffin1_vampire2:
	ld a,(state_vampire2_state)
	cp 2  ; vampire dead
	jp z, load_room_init_object_ptr_set
	ld de,coffin_vampire_1_zx0
	jp load_room_init_object_ptr_set


load_room_init_object_coffin2:
	ld a,5
	ld (room_enemy_type),a
	ld a,(game_time_day)
	cp 8
	jp m,load_room_init_object_ptr_set
	ld a,(state_current_room)
	cp 35  ; vampire 1
	jr z,load_room_init_object_coffin2_vampire1
	cp 45  ; vampire 2
	jr z,load_room_init_object_coffin2_vampire2
	; vampire 3
	ld a,(state_vampire3_state)
	cp 2  ; vampire dead
	jp z, load_room_init_object_ptr_set
	ld de,coffin_vampire_2_zx0
	jp load_room_init_object_ptr_set
load_room_init_object_coffin2_vampire1:
	ld a,(state_vampire1_state)
	cp 2  ; vampire dead
	jp z, load_room_init_object_ptr_set
	ld de,coffin_vampire_2_zx0
	jp load_room_init_object_ptr_set
load_room_init_object_coffin2_vampire2:
	ld a,(state_vampire2_state)
	cp 2  ; vampire dead
	jp z, load_room_init_object_ptr_set
	ld de,coffin_vampire_2_zx0
	jp load_room_init_object_ptr_set


;-----------------------------------------------
; input:
; - ix: object ptr
load_room_init_enemy:
	; store the enemy type:
	ld a,(ix)
	and #7f
	ld (room_enemy_type),a

	; load the additional enemy data:
	ld a,(hl)
	inc hl
	ld (ix+OBJECT_STRUCT_STATE),a
	ld a,(hl)
	inc hl
	ld (ix+OBJECT_STRUCT_STATE_TIMER),a  ; state timer

load_room_init_enemy_spawn_entry_point:
	; screen_x = room_x + x*2 - y*2 - 1
	; screen_y = room_y + x + y - z - 1
	ld a,(room_x)
	add a,(ix+OBJECT_STRUCT_PIXEL_ISO_X)  ; note: at this point, coordinates are still in "tiles", we have not yet converted them to pixels
	add a,(ix+OBJECT_STRUCT_PIXEL_ISO_X)
	sub (ix+OBJECT_STRUCT_PIXEL_ISO_Y)
	sub (ix+OBJECT_STRUCT_PIXEL_ISO_Y)
	dec a
	ld (ix+OBJECT_STRUCT_SCREEN_TILE_X),a
	ld a,(room_y)
	add a,(ix+OBJECT_STRUCT_PIXEL_ISO_X)
	add a,(ix+OBJECT_STRUCT_PIXEL_ISO_Y)
	ld b,a
	ld a,(ix+OBJECT_STRUCT_PIXEL_ISO_Z)
	rrca
	rrca
	rrca
	and #1f
	neg
	add a,b
	dec a
	ld (ix+OBJECT_STRUCT_SCREEN_TILE_Y),a

	ld (ix+OBJECT_STRUCT_PIXEL_ISO_W),8
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_H),8
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_Z_H),8
	ld (ix+OBJECT_STRUCT_SCREEN_TILE_W),3
	ld (ix+OBJECT_STRUCT_SCREEN_TILE_H),2
	ld (ix+OBJECT_STRUCT_FRAME),0

	ld (ix+OBJECT_STRUCT_PTR),enemy_data_buffer%256
	ld (ix+OBJECT_STRUCT_PTR+1),enemy_data_buffer/256

	// Convert coordinates from tiles to pixels:
	ld a,(ix+OBJECT_STRUCT_PIXEL_ISO_X)
	add a,a
	add a,a
	add a,a
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_X),a
	ld a,(ix+OBJECT_STRUCT_PIXEL_ISO_Y)
	add a,a
	add a,a
	add a,a
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_Y),a
	ret


;-----------------------------------------------
create_wall_colliders:
	xor a
	ld (n_collision_objects),a
	ld iy,collision_objects

	; NW doors:
	ld (door_collider_generation_position_x),a
	ld (door_collider_generation_position_y),a
	ld (door_collider_generation_door_type),a
	call create_wall_colliders_x

	; SE doors:
	ld a,(room_width)
	add a,a
	add a,a
	add a,a
	ld (door_collider_generation_position_x),a
	xor a
	ld (door_collider_generation_position_y),a
	ld a,#80
	ld (door_collider_generation_door_type),a
	call create_wall_colliders_x

	; NE doors:
	xor a
	ld (door_collider_generation_position_x),a
	ld (door_collider_generation_position_y),a
	ld a,#40
	ld (door_collider_generation_door_type),a
	call create_wall_colliders_y

	; SW doors:
	xor a
	ld (door_collider_generation_position_x),a
	ld a,(room_height)
	add a,a
	add a,a
	add a,a
	ld (door_collider_generation_position_y),a
	ld a,#c0
	ld (door_collider_generation_door_type),a
	jp create_wall_colliders_y


create_wall_colliders_x:
	xor a
	ld (door_collider_generation_collided_door_type),a
	ld hl,n_collision_objects
	inc (hl)
	ld (iy), OBJECT_TYPE_COLLIDER
	ld a,(door_collider_generation_position_x)
	ld (iy+OBJECT_STRUCT_PIXEL_ISO_X), a
	ld a,(door_collider_generation_position_y)
	ld (iy+OBJECT_STRUCT_PIXEL_ISO_Y), a
	ld (iy+OBJECT_STRUCT_PIXEL_ISO_Z), 0
	ld (iy+OBJECT_STRUCT_PIXEL_ISO_W), 16
	ld a,MAX_COORDINATE
	sub (iy+OBJECT_STRUCT_PIXEL_ISO_Y)
	ld (iy+OBJECT_STRUCT_PIXEL_ISO_H), a
	ld (iy+OBJECT_STRUCT_PIXEL_ISO_Z_H), 64

	ld a,(n_doors)
	or a
	jr z,create_wall_colliders_x_done
	ld ix,doors
	ld b,a
create_wall_colliders_x_loop:
	ld a,(ix)
	and #c0
	ld hl,door_collider_generation_door_type
	cp (hl)
	jr nz,create_wall_colliders_x_loop_skip
	; check if we need to shorten the collider:
	ld a,(ix+DOOR_STRUCT_POSITION)
	add a,a
	add a,a
	add a,a
	sub (iy+OBJECT_STRUCT_PIXEL_ISO_Y)
	jr c,create_wall_colliders_x_loop_skip

	cp (iy+OBJECT_STRUCT_PIXEL_ISO_H)
	jr nc,create_wall_colliders_x_loop_skip
	ld (iy+OBJECT_STRUCT_PIXEL_ISO_H), a
	ld a,(ix)
	ld (door_collider_generation_collided_door_type),a

create_wall_colliders_x_loop_skip:
	ld de,DOOR_STRUCT_SIZE
	add ix,de
	djnz create_wall_colliders_x_loop
create_wall_colliders_x_done:

	ld a,(door_collider_generation_collided_door_type)
	and #3f
	dec a
	jr z,create_wall_colliders_x_done_wide_door
	ld a,16 ; door width
	jr create_wall_colliders_x_done_door_width_set
create_wall_colliders_x_done_wide_door:
	ld a,32 ; door width
create_wall_colliders_x_done_door_width_set:
	add a,(iy+OBJECT_STRUCT_PIXEL_ISO_Y)
	add a,(iy+OBJECT_STRUCT_PIXEL_ISO_H)
	ld (door_collider_generation_position_y),a

	ld de,OBJECT_STRUCT_SIZE
	add iy,de

	cp 20*8
	jp c,create_wall_colliders_x
	ret


create_wall_colliders_y:
	xor a
	ld (door_collider_generation_collided_door_type),a
	ld hl,n_collision_objects
	inc (hl)
	ld (iy), OBJECT_TYPE_COLLIDER
	ld a,(door_collider_generation_position_x)
	ld (iy+OBJECT_STRUCT_PIXEL_ISO_X), a
	ld a,(door_collider_generation_position_y)
	ld (iy+OBJECT_STRUCT_PIXEL_ISO_Y), a
	ld (iy+OBJECT_STRUCT_PIXEL_ISO_Z), 0
	ld a,MAX_COORDINATE
	sub (iy+OBJECT_STRUCT_PIXEL_ISO_X)
	ld (iy+OBJECT_STRUCT_PIXEL_ISO_W), a
	ld (iy+OBJECT_STRUCT_PIXEL_ISO_H), 16
	ld (iy+OBJECT_STRUCT_PIXEL_ISO_Z_H), 64

	ld a,(n_doors)
	or a
	jr z,create_wall_colliders_y_done
	ld ix,doors
	ld b,a
create_wall_colliders_y_loop:
	ld a,(ix)
	and #c0
	ld hl,door_collider_generation_door_type
	cp (hl)
	jr nz,create_wall_colliders_y_loop_skip
	; check if we need to shorten the collider:
	ld a,(ix+DOOR_STRUCT_POSITION)
	add a,a
	add a,a
	add a,a
	add 16
	sub (iy+OBJECT_STRUCT_PIXEL_ISO_X)
	jr c,create_wall_colliders_y_loop_skip

	cp (iy+OBJECT_STRUCT_PIXEL_ISO_W)
	jr nc,create_wall_colliders_y_loop_skip
	ld (iy+OBJECT_STRUCT_PIXEL_ISO_W), a
	ld a,(ix)
	ld (door_collider_generation_collided_door_type),a

create_wall_colliders_y_loop_skip:
	ld de,DOOR_STRUCT_SIZE
	add ix,de
	djnz create_wall_colliders_y_loop
create_wall_colliders_y_done:

	ld a,(door_collider_generation_collided_door_type)
	and #3f
	dec a
	jr z,create_wall_colliders_y_done_wide_door
	ld a,16 ; door width
	jr create_wall_colliders_y_done_door_width_set
create_wall_colliders_y_done_wide_door:
	ld a,32 ; door width
create_wall_colliders_y_done_door_width_set:
	add a,(iy+OBJECT_STRUCT_PIXEL_ISO_X)
	add a,(iy+OBJECT_STRUCT_PIXEL_ISO_W)
	ld (door_collider_generation_position_x),a

	ld de,OBJECT_STRUCT_SIZE
	add iy,de

	cp 20*8
	jp c,create_wall_colliders_y
	ret


;-----------------------------------------------
decompress_enemy_rat:
	push hl
		ld hl,enemy_rat_zx0
		jr create_enemy_frames

decompress_enemy_spider:
	push hl
		ld hl,enemy_spider_zx0
		jr create_enemy_frames

decompress_enemy_slime:
	push hl
		ld hl,enemy_slime_zx0
		jr create_enemy_frames

decompress_enemy_bat:
	push hl
		ld hl,enemy_bat_zx0
; 		jr create_enemy_frames


;-----------------------------------------------
create_enemy_frames:
		ld de,buffer1024
		call dzx0_standard

		; north east (frame 1):
		ld hl,buffer1024+96*2
		ld de,enemy_data_buffer
		call create_enemy_frames_flip
		ld hl,enemy_data_buffer
		ld de,enemy_data_buffer+96
		call create_enemy_frames_shift ; this creates the +2, +4 and +6 sprites
		; north east (frame 2):
		ld hl,buffer1024+96*3
		ld de,enemy_data_buffer+96*4
		call create_enemy_frames_flip
		ld hl,enemy_data_buffer+96*4
		ld de,enemy_data_buffer+96*5
		call create_enemy_frames_shift ; this creates the +2, +4 and +6 sprites

		; south east (frame 1):
		ld hl,buffer1024
		ld de,enemy_data_buffer+96*8
		ld bc,96
		ldir
		ld hl,enemy_data_buffer+96*8
		ld de,enemy_data_buffer+96*9
		call create_enemy_frames_shift ; this creates the +2, +4 and +6 sprites
		; south east (frame 2):
		ld hl,buffer1024+96
		ld de,enemy_data_buffer+96*12
		ld bc,96
		ldir
		ld hl,enemy_data_buffer+96*12
		ld de,enemy_data_buffer+96*13
		call create_enemy_frames_shift ; this creates the +2, +4 and +6 sprites

		; south west (frame 1):
		ld hl,buffer1024
		ld de,enemy_data_buffer+96*16
		call create_enemy_frames_flip
		ld hl,enemy_data_buffer+96*16
		ld de,enemy_data_buffer+96*17
		call create_enemy_frames_shift ; this creates the +2, +4 and +6 sprites
		; south west (frame 2):
		ld hl,buffer1024+96
		ld de,enemy_data_buffer+96*20
		call create_enemy_frames_flip
		ld hl,enemy_data_buffer+96*20
		ld de,enemy_data_buffer+96*21
		call create_enemy_frames_shift ; this creates the +2, +4 and +6 sprites

		; north west (frame 1):
		ld hl,buffer1024+96*2
		ld de,enemy_data_buffer+96*24
		ld bc,96
		ldir
		ld hl,enemy_data_buffer+96*24
		ld de,enemy_data_buffer+96*25
		call create_enemy_frames_shift ; this creates the +2, +4 and +6 sprites
		; north west (frame 2):
		ld hl,buffer1024+96*3
		ld de,enemy_data_buffer+96*28
		ld bc,96
		ldir
		ld hl,enemy_data_buffer+96*28
		ld de,enemy_data_buffer+96*29
		call create_enemy_frames_shift ; this creates the +2, +4 and +6 sprites
	pop hl
	jp load_room_enemy_loop_done


create_enemy_frames_flip_c_into_a:
	push bc
		ld b,8
		xor a
create_enemy_frames_flip_c_into_a_loop:
		rr c
		rla
		djnz create_enemy_frames_flip_c_into_a_loop
	pop bc
	ret


; hl: source
; de: target
create_enemy_frames_flip:
	push hl
		; column 1 is column 2 flipped:
		ld bc,32
		add hl,bc
		ld b,c  ; b = 32
create_enemy_frames_flip_column1_loop:
		ld c,(hl)
		call create_enemy_frames_flip_c_into_a
		ld (de),a
		inc hl
		inc de
		djnz create_enemy_frames_flip_column1_loop
	pop hl

	; column 2 is column 1 flipped:
	ld b,32
create_enemy_frames_flip_column2_loop:
	ld c,(hl)
	call create_enemy_frames_flip_c_into_a
	ld (de),a
	inc hl
	inc de
	djnz create_enemy_frames_flip_column2_loop

	; column 3 is empty:
	ld b,16
	ex de,hl
create_enemy_frames_flip_column3_loop:
	ld (hl),#ff
	inc hl
	ld (hl),0
	inc hl
	djnz create_enemy_frames_flip_column3_loop
	ret


create_enemy_frames_shift:
	; Call the function 3 times to create the 3 shifted versions:
	call create_enemy_frames_shift_internal
	call create_enemy_frames_shift_internal
create_enemy_frames_shift_internal:
	ld b,16
create_enemy_frames_shift_internal_loop:
	push bc
		; mask:
		push hl
		push de
			push de
				ld de,32
				ld a,(hl)
				add hl,de
				ld b,(hl)
				add hl,de
				ld c,(hl)
				srl a
				rr b
				rr c
				or #80
				srl a
				rr b
				rr c
				or #80
			pop hl
			ld (hl),a
			add hl,de
			ld (hl),b
			add hl,de
			ld (hl),c
		pop de
		pop hl
		inc de
		inc hl
		; pattern:
		push hl
		push de
			push de
				ld de,32
				ld a,(hl)
				add hl,de
				ld b,(hl)
				add hl,de
				ld c,(hl)
				srl a
				rr b
				rr c
				srl a
				rr b
				rr c
			pop hl
			ld (hl),a
			add hl,de
			ld (hl),b
			add hl,de
			ld (hl),c
		pop de
		pop hl
		inc de
		inc hl
	pop bc
	djnz create_enemy_frames_shift_internal_loop
 	ld bc,64
 	add hl,bc
 	ex de,hl
 		add hl,bc
 	ex de,hl
	ret


;-----------------------------------------------
spawn_global_items:
	ld hl,state_candle1_position
	ld a,(state_current_room)
	cp (hl)
	call z,spawn_global_items_candle1
	ld hl,state_candle2_position
	ld a,(state_current_room)
	cp (hl)
	call z,spawn_global_items_candle2
	ld hl,state_candle3_position
	ld a,(state_current_room)
	cp (hl)
	call z,spawn_global_items_candle3
	ret


spawn_global_items_candle1:
	push hl
		call find_new_object_ptr
		ld hl,n_objects
		inc (hl)
		ld (ix),OBJECT_TYPE_CANDLE1
spawn_global_items_candle_entry_point:
		ld de,object_candle_zx0
	pop hl
	inc hl
	ld a,(hl)
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_X),a
	inc hl
	ld a,(hl)
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_Y),a
	inc hl
	ld a,(hl)
	ld (ix+OBJECT_STRUCT_PIXEL_ISO_Z),a
	jp load_room_init_object_ptr_set


spawn_global_items_candle2:
	push hl
		call find_new_object_ptr
		ld hl,n_objects
		inc (hl)
		ld (ix),OBJECT_TYPE_CANDLE2
		jr spawn_global_items_candle_entry_point


spawn_global_items_candle3:
	push hl
		call find_new_object_ptr
		ld hl,n_objects
		inc (hl)
		ld (ix),OBJECT_TYPE_CANDLE3
		jr spawn_global_items_candle_entry_point
