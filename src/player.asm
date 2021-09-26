;-----------------------------------------------
hide_player:
	xor a
	ld hl,SPRATR2
	ld bc,6*4
	jp fast_FILVRM


;-----------------------------------------------
update_player:
	; check if player wants to change control scheme:
	ld a,(keyboard_line_clicks+2)
	bit 6,a  ; letter "Q"
	jr z,update_player_continue

	; toggle control mapping:
	ld hl,(key_to_direction_mapping_ptr)
	ld a,l
	cp key_to_direction_mapping & 0xff
	jr z,update_player_mapping_alt
update_player_mapping_default:
	ld hl,key_to_direction_mapping
	jr update_player_mapping_continue
update_player_mapping_alt:
	ld hl,key_to_direction_mapping_alt
update_player_mapping_continue:
	ld (key_to_direction_mapping_ptr),hl
	ld hl,SFX_ui_select
	call play_SFX_with_high_priority

update_player_continue:
	ld hl,player_invulnerability
	ld a,(hl)
	or a
	jp z,update_player_no_invulnerability
	dec (hl)
	ld a,(player_state)
	cp PLAYER_STATE_DEAD
	jp z,update_player_check_gameover
update_player_no_invulnerability:
	ld a,(keyboard_line_state+KEY_BUTTON2_BYTE)
	bit KEY_BUTTON2_BIT,a
	jr z, update_player_no_use_or_jump
	bit KEY_BUTTON2_BIT_ALTERNATIVE,a
	jr z, update_player_no_use_or_jump
	ld a,(player_state)
	cp PLAYER_STATE_JUMPING
	jp p,update_player_no_use_or_jump
	ld a,(keyboard_line_clicks+KEY_BUTTON1_BYTE)
	bit KEY_BUTTON1_BIT,a
	jp nz,inventory_fn_jump
update_player_no_use_or_jump:

	ld a,(player_state)
	cp PLAYER_STATE_JUMPING
	jp z,update_player_jump
	cp PLAYER_STATE_FALLING
	jp z,update_player_fall

	ld a,(keyboard_line_state+KEY_BUTTON2_BYTE)
	bit KEY_BUTTON2_BIT,a
	jr z, update_player_idle
	bit KEY_BUTTON2_BIT_ALTERNATIVE,a
	jr z, update_player_idle

	ld a,(keyboard_line_state)
	and #f0
	ld hl,(key_to_direction_mapping_ptr)
	cp (hl)
	jp z,update_player_north
	inc hl
	cp (hl)
	jp z,update_player_northeast
	inc hl
	cp (hl)
	jp z,update_player_east
	inc hl
	cp (hl)
	jp z,update_player_southeast
	inc hl
	cp (hl)
	jp z,update_player_south
	inc hl
	cp (hl)
	jp z,update_player_southwest
	inc hl
	cp (hl)
	jp z,update_player_west
	inc hl
	cp (hl)
	jp z,update_player_northwest


update_player_idle:
	; idle:
	ld hl,player_state
	xor a
	ld (hl),a  ; = PLAYER_STATE_IDLE
	inc hl
	ld (hl),a  ; player_state_timer

update_player_check_if_we_need_to_fall:
	ld a,(player_state)
	cp PLAYER_STATE_JUMPING
	ret p
	ld a,(player_iso_z)
	or a
	ret z
	ld de,0
	ld c,#ff
	call check_player_collision
	ret z
	ld hl,player_state
	ld (hl),PLAYER_STATE_FALLING
	inc hl
	ld (hl),0
	ret

update_player_check_gameover:
	ld a,(player_invulnerability)
	or a
	jp z,state_game_over
	ret

update_player_jump_not_done:
	ld a,(hl)
	or a
	jr z,update_player_air_movement
	ld b,a
update_player_jump_not_done_loop:
	push bc
		call move_player_inc_z
	pop bc
	jr z,update_player_jump_done  ; collision
	djnz update_player_jump_not_done_loop
	jr update_player_air_movement


update_player_jump:
	ld hl,jump_arc
	ld a,(player_state_timer)
	ADD_HL_A
	ld a,(hl)
	inc a  ; cp #ff
	jr nz,update_player_jump_not_done
update_player_jump_done:
	ld hl,player_state
	ld a,(hl)
	cp PLAYER_STATE_DEAD
	ret z	
	ld (hl),PLAYER_STATE_FALLING
	inc hl
	ld (hl),0
update_player_fall:
	ld hl,fall_arc
	ld a,(player_state_timer)
	ADD_HL_A
	ld a,(hl)
	inc a  ; cp #ff
	jr nz,update_player_fall_not_done
	dec hl
	ex de,hl
		ld hl,player_state_timer
		dec (hl)
	ex de,hl
update_player_fall_not_done:
	ld a,(hl)
	or a
	jr z,update_player_air_movement
	ld b,a
update_player_fall_not_done_loop:
	push bc
		call move_player_dec_z
	pop bc
	jr z,update_player_fall_landed  ; collision
	djnz update_player_fall_not_done_loop
	jr update_player_air_movement
update_player_fall_landed:
	ld hl,player_state
	ld a,(hl)
	cp PLAYER_STATE_DEAD
	ret z
	xor a
	ld (hl),a
	inc hl
	ld (hl),a

update_player_air_movement:
	ld hl,player_state_timer
	inc (hl)
	ld a,(keyboard_line_state)
	and #f0
; 	xor #f0
; 	cp #20
; 	jp z,update_player_north_movement
; 	cp #a0
; 	jp z,update_player_northeast_movement
; 	cp #80
; 	jp z,update_player_east_movement
; 	cp #c0
; 	jp z,update_player_southeast_movement
; 	cp #40
; 	jp z,update_player_south_movement
; 	cp #50
; 	jp z,update_player_southwest_movement
; 	cp #10
; 	jp z,update_player_west_movement
; 	cp #30
; 	jp z,update_player_northwest_movement
	ld hl,(key_to_direction_mapping_ptr)
	cp (hl)
	jp z,update_player_north_movement
	inc hl
	cp (hl)
	jp z,update_player_northeast_movement
	inc hl
	cp (hl)
	jp z,update_player_east_movement
	inc hl
	cp (hl)
	jp z,update_player_southeast_movement
	inc hl
	cp (hl)
	jp z,update_player_south_movement
	inc hl
	cp (hl)
	jp z,update_player_southwest_movement
	inc hl
	cp (hl)
	jp z,update_player_west_movement
	inc hl
	cp (hl)
	jp z,update_player_northwest_movement
	ret


update_player_north:
	ld hl,player_state
	ld a,(hl)  ; player_state
	cp PLAYER_STATE_JUMPING
	jp p,update_player_north_movement
	ld (hl),PLAYER_STATE_WALKING
	inc hl
	inc (hl)  ; player_state_timer
update_player_north_movement:
	ld hl,player_direction
	ld (hl),0
	call move_player_dec_x
	call move_player_dec_y
	jp update_player_check_if_we_need_to_fall


update_player_northeast:
	ld hl,player_state
	ld a,(hl)  ; player_state
	cp PLAYER_STATE_JUMPING
	jp p,update_player_northeast_movement	
	ld (hl),PLAYER_STATE_WALKING
	inc hl
	inc (hl)  ; player_state_timer
update_player_northeast_movement:
	ld hl,player_direction
	ld (hl),1
	call move_player_dec_y
	jp update_player_check_if_we_need_to_fall


update_player_east:
	ld hl,player_state
	ld a,(hl)  ; player_state
	cp PLAYER_STATE_JUMPING
	jp p,update_player_east_movement
	ld (hl),PLAYER_STATE_WALKING
	inc hl
	inc (hl)  ; player_state_timer
update_player_east_movement:
	ld hl,player_direction
	ld (hl),2
	; if x+y add to an odd number, we need to decrement y first, to prevent wobbly behavior
	ld hl,player_iso_x
	ld a,(hl)
	inc hl
	add a,(hl)
	and #01
	jp nz,update_player_east_movement_a
update_player_east_movement_b:
	; try one direction, and if there is collision, then default to the other:
	call move_player_inc_x
	jp nz,update_player_check_if_we_need_to_fall
	call move_player_dec_y
	jp update_player_check_if_we_need_to_fall	
update_player_east_movement_a:
	; try one direction, and if there is collision, then default to the other:
	call move_player_dec_y
	jp nz,update_player_check_if_we_need_to_fall
	call move_player_inc_x
	jp update_player_check_if_we_need_to_fall


update_player_southeast:
	ld hl,player_state
	ld a,(hl)  ; player_state
	cp PLAYER_STATE_JUMPING
	jp p,update_player_southeast_movement	
	ld (hl),PLAYER_STATE_WALKING
	inc hl
	inc (hl)  ; player_state_timer
update_player_southeast_movement:
	ld hl,player_direction
	ld (hl),3
	call move_player_inc_x
	jp update_player_check_if_we_need_to_fall

update_player_south:
	ld hl,player_state
	ld a,(hl)  ; player_state
	cp PLAYER_STATE_JUMPING
	jp p,update_player_south_movement
	ld (hl),PLAYER_STATE_WALKING
	inc hl
	inc (hl)  ; player_state_timer
update_player_south_movement:
	ld hl,player_direction
	ld (hl),4
	call move_player_inc_x
	call move_player_inc_y
	jp update_player_check_if_we_need_to_fall


update_player_southwest:
	ld hl,player_state
	ld a,(hl)  ; player_state
	cp PLAYER_STATE_JUMPING
	jp p,update_player_southwest_movement
	ld (hl),PLAYER_STATE_WALKING
	inc hl
	inc (hl)  ; player_state_timer
update_player_southwest_movement:
	ld hl,player_direction
	ld (hl),5
	call move_player_inc_y
	jp update_player_check_if_we_need_to_fall


update_player_west:
	ld hl,player_state
	ld a,(hl)  ; player_state
	cp PLAYER_STATE_JUMPING
	jp p,update_player_west_movement
	ld (hl),PLAYER_STATE_WALKING
	inc hl
	inc (hl)  ; player_state_timer
update_player_west_movement:
	ld hl,player_direction
	ld (hl),6
	; if x+y add to an odd number, we need to decrement x first, to prevent wobbly behavior
	ld hl,player_iso_x
	ld a,(hl)
	inc hl
	add a,(hl)
	and #01
	jp z,update_player_west_movement_a
update_player_west_movement_b:
	; try one direction, and if there is collision, then default to the other:
	call move_player_dec_x
	jp nz,update_player_check_if_we_need_to_fall
	call move_player_inc_y
	jp update_player_check_if_we_need_to_fall
update_player_west_movement_a:
	call move_player_inc_y
	jp nz,update_player_check_if_we_need_to_fall
	call move_player_dec_x
	jp update_player_check_if_we_need_to_fall


update_player_northwest:
	ld hl,player_state
	ld a,(hl)  ; player_state
	cp PLAYER_STATE_JUMPING
	jp p,update_player_northwest_movement
	ld (hl),PLAYER_STATE_WALKING
	inc hl
	inc (hl)  ; player_state_timer
update_player_northwest_movement:
	ld hl,player_direction
	ld (hl),7
	call move_player_dec_x
	jp update_player_check_if_we_need_to_fall


;-----------------------------------------------
player_hit:
	ld hl,player_invulnerability
	ld a,(hl)
	or a
	ret nz
	ld (hl),INVULNERABILITY_TIME
	
	ld hl,player_health
	dec (hl)
	call hud_update_health
	ld a,(player_health)
	or a
	jp nz,player_hit_continue
	ld a,PLAYER_STATE_DEAD
	ld (player_state),a
player_hit_continue:
	ld hl,SFX_playerhit
	jp play_SFX_with_high_priority


;-----------------------------------------------
; These functions move the player in the desired direction
; return:
; - nz: successful move:
; - z: collision
move_player_inc_x:
	ld hl,player_iso_x
	ld a,(room_width_pixels)
	sub 8
	cp (hl)
	jr z, enter_door_se

	ld de,#0001
	ld c,d
	call check_player_collision
	ret z

	ld hl,player_iso_x
	inc (hl)
	or 1  ; indicate successful move
	ret


move_player_dec_x:
	ld hl,player_iso_x
	ld a,(hl)
	cp 9
	jr z, enter_door_nw

	ld de,#00ff
	ld c,d
	call check_player_collision
	ret z

move_player_dec_x_move:
	ld hl,player_iso_x
	dec (hl)
	or 1  ; indicate successful move
	ret


move_player_inc_y:
	ld hl,player_iso_y
	ld a,(room_height_pixels)
	sub 8
	cp (hl)
	jp z, enter_door_sw

	ld de,#0100
	ld c,e
	call check_player_collision
	ret z
	
	ld hl,player_iso_y
	inc (hl)
	or 1  ; indicate successful move
	ret


move_player_dec_y:
	ld hl,player_iso_y
	ld a,(hl)
	cp 9
	jp z, enter_door_ne

	ld de,#ff00
	ld c,e
	call check_player_collision
	ret z
	
	ld hl,player_iso_y
	dec (hl)
	or 1  ; indicate successful move
	ret


move_player_inc_z:
	ld de,0	
	ld c,1
	call check_player_collision
	ret z

	ld hl,player_iso_z
	inc (hl)
	or 1  ; indicate successful move
	ret


move_player_dec_z:
	ld hl,player_iso_z
	ld a,(hl)
	or a
	ret z

	ld de,0
	ld c,#ff
	call check_player_collision
	ret z	
	
	ld hl,player_iso_z
	dec (hl)
	or 1  ; indicate successful move
	ret


;-----------------------------------------------
enter_door_nw:	
enter_door_ne:
enter_door_sw:
enter_door_se:
	call get_nearest_door
	ld a,(ix+DOOR_STRUCT_DESTINATION_ROOM)
	cp #ff
	ret z  ; since this is "z", it also indicates collision
	ld (state_current_room),a
	ld e,a
	and #f0
	jr z,enter_door_map1
	cp #10
	jr z,enter_door_map2
	cp #20
	jr z,enter_door_map3
; 	cp #30
; 	jr z,enter_door_map4
enter_door_map4:
	ld hl,map4_zx0_page1
; 	ld bc,map4_zx0_page1_size
	jr enter_door_ptr_set
enter_door_map3:
	ld hl,map3_zx0_page1
; 	ld bc,map3_zx0_page1_size
	jr enter_door_ptr_set
enter_door_map2:
	ld hl,map2_zx0_page1
; 	ld bc,map2_zx0_page1_size
	jr enter_door_ptr_set
enter_door_map1:
	; check for music change:
	ld hl,map1_zx0_page1
; 	ld bc,map1_zx0_page1_size

enter_door_ptr_set:
	ld a,e
	and #0f
	ld e,a
	ld d,(ix+DOOR_STRUCT_DESTINATION_DOOR)
	call teleport_player_to_room
	jp state_game_roomstart


;-----------------------------------------------
; returns the nearest door in ix
get_nearest_door:
	ld iy,doors
	ld de,DOOR_STRUCT_SIZE
	ld a,(n_doors)
	or a
	jr z,get_nearest_door_found
	ld b,a
get_nearest_door_loop:
	ld a,(iy)
	and #c0
	jr z,get_nearest_door_nw
	cp #40
	jr z,get_nearest_door_ne
	cp #80
	jr z,get_nearest_door_se
	cp #c0
	jr z,get_nearest_door_sw
get_nearest_door_loop_next:
	add iy,de
	djnz get_nearest_door_loop

get_nearest_door_found:
	push iy
	pop ix
	ret

get_nearest_door_nw:
	ld a,(player_iso_x)
	cp 10
	jr nc,get_nearest_door_loop_next
	ld a,(iy+DOOR_STRUCT_POSITION)
	add a,a
	add a,a
	add a,a
	ld c,a
	ld a,(player_iso_y)
	sub c
	cp 16
	jp p,get_nearest_door_loop_next
	cp -16
	jp m,get_nearest_door_loop_next
	jr get_nearest_door_found

get_nearest_door_ne:
	ld a,(player_iso_y)
	cp 10
	jr nc,get_nearest_door_loop_next
	ld a,(iy+DOOR_STRUCT_POSITION)
	add a,a
	add a,a
	add a,a
	add a,32
	ld c,a
	ld a,(player_iso_x)
	sub c
	cp 16
	jp p,get_nearest_door_loop_next
	cp -16
	jp m,get_nearest_door_loop_next
	jr get_nearest_door_found

get_nearest_door_sw:
	ld a,(room_height_pixels)
	sub 10
	ld c,a
	ld a,(player_iso_y)
	cp c
	jr c,get_nearest_door_loop_next
	ld a,(iy+DOOR_STRUCT_POSITION)
	add a,a
	add a,a
	add a,a
	add a,32
	ld c,a
	ld a,(player_iso_x)
	sub c
	cp 16
	jp p,get_nearest_door_loop_next
	cp -16
	jp m,get_nearest_door_loop_next
	jr get_nearest_door_found

get_nearest_door_se:
	ld a,(room_width_pixels)
	sub 10
	ld c,a
	ld a,(player_iso_x)
	cp c
	jr c,get_nearest_door_loop_next
	ld a,(iy+DOOR_STRUCT_POSITION)
	add a,a
	add a,a
	add a,a
	ld c,a
	ld a,(player_iso_y)
	sub c
	cp 16
	jp p,get_nearest_door_loop_next
	cp -16
	jp m,get_nearest_door_loop_next
	jp get_nearest_door_found


;-----------------------------------------------
draw_player:
	ld a,(player_invulnerability)
	bit 1,a
	jp nz,draw_player_blink

	; x: room_x*8 + player_iso_x - player_iso_y
	ld a,(room_x)
	dec a
	add a,a
	add a,a
	add a,a
	ld hl,player_iso_x
	add a,(hl)  ; player_iso_x
	inc hl
	sub (hl)  ; player_iso_y

	ld b,a
	ld (player_screen_x),a

	; y: room_y*8 + player_iso_y/2 + player_iso_x/2 - isoz
	ld a,(room_y)
	add a,a
	add a,a
	add a,a
	ld c,a
	ld hl,player_iso_x
	ld a,(hl)  ; player_iso_x
	inc hl
	add a,(hl)  ; player_iso_y
	jr c,draw_player_y_overflow
	srl a
draw_player_y_overflow_continue:
	add a,c
	inc hl
	sub (hl)  ; player_iso_z
	sub 26
	ld c,a
	ld (player_screen_y),a

	ld a,(player_direction)
	ld e,a
	add a,a
	add a,e
	ld e,a

	ld a,(player_state)
	or a
	jr z,draw_player_frame_set
	dec a ; walking
	jr z,draw_player_walking
	; jumping/falling:
	inc e
	jp draw_player_frame_set

draw_player_y_overflow:
	srl a
	or #80
	jp draw_player_y_overflow_continue

draw_player_walking:
	ld a,(player_state_timer)
	srl a
	srl a
	and #03
	ld hl,walk_animation_sequence
	ADD_HL_A
	ld a,(hl)
	add a,e
	ld e,a

draw_player_frame_set:
	ld a,e
	; jp draw_player_frame


;-----------------------------------------------
; input:
; - c: y coordinate to draw the top sprite
; - b: x coordinate to draw the top sprite
; - a: frame to draw
draw_player_frame:
	; calculate occlusion mask:
	push af
	push bc
		push bc
			ld hl,player_sprite_occlusion_buffer
			ld (hl),#ff
			ld de,player_sprite_occlusion_buffer+1
			ld bc,2*OCCLUSION_MASK_HEIGHT-1
			ldir
		pop bc	
		call calculate_player_occlusion_mask
	pop bc
	pop af

	; hl = player_sprites_bin + a*6*32   (a*6*32 = a*3*64)
	add a,a
	add a,a
	ld l,a
	ld h,0
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld d,h
	ld e,l
	add hl,hl
	add hl,de
	ld de,player_sprites_bin
	add hl,de
	; jp draw_player_internal


;-----------------------------------------------
; input:
; - c: y coordinate to draw the top sprite
; - b: x coordinate to draw the top sprite
; - hl: pointer to the sprite patterns
draw_player_internal:
	ld (player_sprite_attributes),bc
	ld a,4
	add a,c
	ld c,a
	ld (player_sprite_attributes+8),bc
	ld (player_sprite_attributes+12),bc
	ld a,12
	add a,c
	ld c,a
	ld (player_sprite_attributes+4),bc
	ld (player_sprite_attributes+16),bc
	ld a,4
	add a,c
	ld c,a	
	ld (player_sprite_attributes+20),bc

	push hl
		ld bc,player_sprite_occlusion_buffer
		ld de,SPRTBL2
		call copy_masked_sprite_to_vdp
	pop hl
	ld bc,32
	add hl,bc
	push hl
		ex de,hl
		ld hl,player_sprite_occlusion_buffer+16
		call copy_masked_sprite_to_vdp_setwrt_set
	pop hl
	ld bc,32
	add hl,bc
	push hl
		ex de,hl
		ld hl,player_sprite_occlusion_buffer+4
		call copy_masked_sprite_to_vdp_setwrt_set
	pop hl
	ld bc,32
	add hl,bc
	push hl
		ex de,hl
		ld hl,player_sprite_occlusion_buffer+4
		call copy_masked_sprite_to_vdp_setwrt_set
	pop hl
	ld bc,32
	add hl,bc
	push hl
		ex de,hl
		ld hl,player_sprite_occlusion_buffer+16
		call copy_masked_sprite_to_vdp_setwrt_set
	pop hl
	ld bc,32
	add hl,bc
	ex de,hl
	ld hl,player_sprite_occlusion_buffer+20
	call copy_masked_sprite_to_vdp_setwrt_set

	ld hl,player_sprite_attributes
	ld de,SPRATR2
	ld bc,6*4
	jp fast_LDIRVM


draw_player_blink:
	xor a
	ld hl,SPRATR2
	ld bc,6*4
	jp fast_FILVRM


;-----------------------------------------------
; hl: sprite
; de: VDP address to copy
; bc: ptr to the mask
copy_masked_sprite_to_vdp:
	push hl
	push bc
		ex de,hl
		call SETWRT
	pop hl
	pop de
copy_masked_sprite_to_vdp_setwrt_set:
    ld a,(VDP.DW)
    ld c,a
    ld b,16
copy_masked_sprite_to_vdp_loop1:
	ld a,(de)
	and (hl)
	inc de
	inc hl
	out (c),a
	djnz copy_masked_sprite_to_vdp_loop1
	ld bc,OCCLUSION_MASK_HEIGHT - 16
	add hl,bc
    ld a,(VDP.DW)
    ld c,a
    ld b,16
copy_masked_sprite_to_vdp_loop2:
	ld a,(de)
	and (hl)
	inc de
	inc hl
	out (c),a
	djnz copy_masked_sprite_to_vdp_loop2
	ret


;-----------------------------------------------
; - c: y coordinate to draw the top sprite
; - b: x coordinate to draw the top sprite
calculate_player_occlusion_mask:
	ld a,(n_objects)
	or a
	ret z
	ld e,b  ; we free up bc, and transfer the coordinates to de
	ld d,c
	inc d
	ld ix,objects
	ld b,a
calculate_player_occlusion_mask_loop:
	push bc
		ld a,(ix)
		or a
		jr z,calculate_player_occlusion_mask_loop_skip

		; Check if the object is in front, or behind the player:
		; check 1: z_height
		ld a,(ix+OBJECT_STRUCT_PIXEL_ISO_Z)
		add a,(ix+OBJECT_STRUCT_PIXEL_ISO_Z_H)
		dec a
		ld hl,player_iso_z
		cp (hl)
		jp m,calculate_player_occlusion_mask_loop_skip

		; check 2: sort by screen x and y, otherwise:
		ld a,(player_iso_y)
		sub (ix+OBJECT_STRUCT_PIXEL_ISO_Y)
		cp (ix+OBJECT_STRUCT_PIXEL_ISO_H)
		jp p,calculate_player_occlusion_mask_loop_skip
		ld a,(player_iso_x)
		sub (ix+OBJECT_STRUCT_PIXEL_ISO_X)
		cp (ix+OBJECT_STRUCT_PIXEL_ISO_W)
		jp p,calculate_player_occlusion_mask_loop_skip

		bit 7,(ix)  ; 0 -> object, 1 -> enemy
		push af
			call z,add_object_to_player_occlusion_mask
		pop af
		call nz,add_enemy_to_player_occlusion_mask
calculate_player_occlusion_mask_loop_skip:
		ld bc,OBJECT_STRUCT_SIZE
		add ix,bc
	pop bc
	djnz calculate_player_occlusion_mask_loop
	ret


;-----------------------------------------------
; - e: y coordinate to draw the top sprite
; - d: x coordinate to draw the top sprite
; - ix: object to add to the mask
add_object_to_player_occlusion_mask:
	; Check vertical overlap
	ld a,(ix+OBJECT_STRUCT_SCREEN_PIXEL_Y)
	sub d  ; a = y pixel of the row wrt occlusion mask

	cp 32
	ret p  ; object is to low

	ld c,a
	ld a,(ix+OBJECT_STRUCT_SCREEN_TILE_H)
	add a,a
	add a,a
	add a,a
	ld (render_room_object_screen_pixel_h),a
	dec a
	neg
	ld b,a
	ld a,c

	cp b
	ret m  ; object is too high

	ld iyh,a

	; Check horizontal overlap:
	ld a,(ix+OBJECT_STRUCT_SCREEN_TILE_X)
	add a,a
	add a,a
	add a,a
	sub e  ; a = x pixel of the row wrt occlusion mask

	cp -(6+32)  ; object should never be wider than 32 pixels
	ret m
	cp 15
	ret p

	ld b,(ix+OBJECT_STRUCT_SCREEN_TILE_W)
	ld l,(ix+OBJECT_STRUCT_PTR)
	ld h,(ix+OBJECT_STRUCT_PTR+1)

add_object_to_player_occlusion_mask_loop:
	push bc
		cp -6
		jp m,add_object_to_player_occlusion_mask_loop_next_column
		cp 15
		jp p,add_object_to_player_occlusion_mask_loop_end_pop

		ld iyl,a
		push hl
		push de
		push iy
			call add_object_column_to_player_occlusion_mask
		pop iy
		pop de
		pop hl
		ld a,iyl

add_object_to_player_occlusion_mask_loop_next_column
		add a,8
		push af
			ld a,(render_room_object_screen_pixel_h)
			ld b,0
			ld c,a
			add hl,bc
			add hl,bc
			add hl,bc  ; next column
		pop af
	pop bc
	djnz add_object_to_player_occlusion_mask_loop
	ret
add_object_to_player_occlusion_mask_loop_end_pop:
	pop bc
	ret


;-----------------------------------------------
; - hl: ptr to the column data
; - ix: object to add to the mask
; - iyl: column pixel x coordinate in occlusion mask coordinates
; - iyh: column pixel y coordinate in occlusion mask coordinates
add_object_column_to_player_occlusion_mask:
	ex de,hl

	; get the ptr to the top-left byte in the occlusion mask to start writing to:

	; hl = player_sprite_occlusion_buffer + iyh
	; sign extend iyh to bc, before adding to hl (since iyh could be negative)
	ld a,iyh
	add a,a
	sbc a,a
	ld b,a
	ld c,iyh
	ld hl,player_sprite_occlusion_buffer
	add hl,bc

	; update the mask (first column):
	; if iyl > 0: shift right "iyl" pixels
	; if iyl < 0: shift left "-iyl" pixels
	ld a,iyl
	or a
	jp z,add_object_column_to_player_occlusion_mask_loop1_z
	jp p,add_object_column_to_player_occlusion_mask_loop1_p
add_object_column_to_player_occlusion_mask_loop1_m:
	ld a,(render_room_object_screen_pixel_h)
	ld b,a
	ld c,iyh
add_object_column_to_player_occlusion_mask_loop1_m_loop:
	ld a,c
	cp 5  ; there is nothing on the top 5 rows of player sprites
	jp m,add_object_column_to_player_occlusion_mask_loop1_m_loop_skip
	cp 32 ; there is nothing past pixel 32
	jp p,add_object_column_to_player_occlusion_mask_loop1_m_loop_skip2

	; get the mask:
	push bc
		; shift the mask left/right:
		ld b,iyl
		ld a,(de)
		cp #ff
		jr z,add_object_column_to_player_occlusion_mask_loop1_shift_left_done2

add_object_column_to_player_occlusion_mask_loop1_shift_left:
		sli a
		inc b
		jp nz,add_object_column_to_player_occlusion_mask_loop1_shift_left
		; apply mask:
		and (hl)
		ld (hl),a
add_object_column_to_player_occlusion_mask_loop1_shift_left_done2:
	pop bc
add_object_column_to_player_occlusion_mask_loop1_m_loop_skip:
	inc hl
	inc c
	inc de
	inc de
	inc de
	djnz add_object_column_to_player_occlusion_mask_loop1_m_loop
add_object_column_to_player_occlusion_mask_loop1_m_loop_skip2:
	ret


add_object_column_to_player_occlusion_mask_loop1_z:
	ld a,(render_room_object_screen_pixel_h)
	ld b,a
	ld c,iyh
add_object_column_to_player_occlusion_mask_loop1_z_loop:
	ld a,c
	cp 5  ; there is nothing on the top 5 rows of player sprites
	jp m,add_object_column_to_player_occlusion_mask_loop1_z_loop_skip
	cp 32 ; there is nothing past pixel 32
	jp p,add_object_column_to_player_occlusion_mask_loop1_z_loop_skip2

	; get the mask:
	; shift the mask left/right:
	ld a,(de)
	; apply mask:
	and (hl)
	ld (hl),a
add_object_column_to_player_occlusion_mask_loop1_z_loop_skip:
	inc hl
	inc c
	inc de
	inc de
	inc de
	djnz add_object_column_to_player_occlusion_mask_loop1_z_loop
add_object_column_to_player_occlusion_mask_loop1_z_loop_skip2:
	ret


add_object_column_to_player_occlusion_mask_loop1_p:
	push de
	push hl
	push ix
		push hl
		pop ix
		ld bc,OCCLUSION_MASK_HEIGHT
		add ix,bc
		ld a,(render_room_object_screen_pixel_h)
		ld b,a
		ld c,iyh
add_object_column_to_player_occlusion_mask_loop1_p_loop:
		ld a,c
		cp 5  ; there is nothing on the top 5 rows of player sprites
		jp m,add_object_column_to_player_occlusion_mask_loop1_p_loop_skip
		cp 32 ; there is nothing past pixel 32
		jp p,add_object_column_to_player_occlusion_mask_loop1_p_loop_skip2

		; get the mask:
		push bc
			; shift the mask left/right:
			ld b,iyl
			ld a,(de)
			cp #ff
			jr z,add_object_column_to_player_occlusion_mask_loop1_shift_right_done2

			ld c,#ff

			srl a
			rr c
			or #80
			dec b
			jr z,add_object_column_to_player_occlusion_mask_loop1_shift_right_done
add_object_column_to_player_occlusion_mask_loop1_shift_right:
			sra a
			rr c
			djnz add_object_column_to_player_occlusion_mask_loop1_shift_right
add_object_column_to_player_occlusion_mask_loop1_shift_right_done:
			; apply mask:
			and (hl)
			ld (hl),a
			ld a,c
			and (ix)
			ld (ix),a
add_object_column_to_player_occlusion_mask_loop1_shift_right_done2:
		pop bc
add_object_column_to_player_occlusion_mask_loop1_p_loop_skip:
		inc hl
		inc ix
		inc c
		inc de
		inc de
		inc de
		djnz add_object_column_to_player_occlusion_mask_loop1_p_loop
add_object_column_to_player_occlusion_mask_loop1_p_loop_skip2:
	pop ix
	pop hl
	pop de
	ret



add_object_column_to_player_occlusion_mask_loop1_done:
	ld bc,OCCLUSION_MASK_HEIGHT
	add hl,bc

	; update the mask (second column):
	; if iyl > 0: shift right "iyl" pixels
	; if iyl < 0: shift left "-iyl" pixels
	sub 8
	jp z,add_object_column_to_player_occlusion_mask_loop2_z
	jp m,add_object_column_to_player_occlusion_mask_loop2_m
add_object_column_to_player_occlusion_mask_loop2_p:
	ld a,(render_room_object_screen_pixel_h)
	ld b,a
	ld c,iyh
add_object_column_to_player_occlusion_mask_loop2_p_loop:
	ld a,c
	cp 5  ; there is nothing on the top 5 rows of player sprites
	jp m,add_object_column_to_player_occlusion_mask_loop2_p_loop_skip
	cp 32 ; there is nothing past pixel 32
	ret p

	; get the mask:
	push bc
		; shift the mask left/right:
		ld a,iyl
		sub 8
		ld b,a
		ld a,(de)
		cp #ff
		jr z,add_object_column_to_player_occlusion_mask_loop2_shift_right_done2

		srl a
		or #80
		dec b
		jr z,add_object_column_to_player_occlusion_mask_loop2_shift_right_done
add_object_column_to_player_occlusion_mask_loop2_shift_right:
		sra a
		djnz add_object_column_to_player_occlusion_mask_loop2_shift_right
add_object_column_to_player_occlusion_mask_loop2_shift_right_done:
		; apply mask:
		and (hl)
		ld (hl),a
add_object_column_to_player_occlusion_mask_loop2_shift_right_done2:
	pop bc
add_object_column_to_player_occlusion_mask_loop2_p_loop_skip:
	inc hl
	inc c
	inc de
	inc de
	inc de
	djnz add_object_column_to_player_occlusion_mask_loop2_p_loop
add_object_column_to_player_occlusion_mask_loop2_p_loop_skip2:
	ret

add_object_column_to_player_occlusion_mask_loop2_m:
	ld a,(render_room_object_screen_pixel_h)
	ld b,a
add_object_column_to_player_occlusion_mask_loop2_m_loop:
	ld a,iyh
	cp 5  ; there is nothing on the top 5 rows of player sprites
	jp m,add_object_column_to_player_occlusion_mask_loop2_m_loop_skip
	cp 32 ; there is nothing past pixel 32
	ret p

	; get the mask:
	; shift the mask left/right:
	ld a,iyl
	sub 8
	ld c,a
	ld a,(de)
	cp #ff
	jr z,add_object_column_to_player_occlusion_mask_loop2_m_loop_skip	
add_object_column_to_player_occlusion_mask_loop2_shift_left:
	sli a
	inc c
	jp nz,add_object_column_to_player_occlusion_mask_loop2_shift_left
	; apply mask:
	and (hl)
	ld (hl),a
add_object_column_to_player_occlusion_mask_loop2_m_loop_skip:
	inc hl
	inc iyh
	inc de
	inc de
	inc de
	djnz add_object_column_to_player_occlusion_mask_loop2_m_loop
	ret


add_object_column_to_player_occlusion_mask_loop2_z:
	ld a,(render_room_object_screen_pixel_h)
	ld b,a
	ld c,iyh
add_object_column_to_player_occlusion_mask_loop2_z_loop:
	ld a,c
	cp 5  ; there is nothing on the top 5 rows of player sprites
	jp m,add_object_column_to_player_occlusion_mask_loop2_z_loop_skip
	cp 32 ; there is nothing past pixel 32
	ret p

	; get the mask:
	ld a,(de)
	; apply mask:
	and (hl)
	ld (hl),a
add_object_column_to_player_occlusion_mask_loop2_z_loop_skip:
	inc hl
	inc c
	inc de
	inc de
	inc de
	djnz add_object_column_to_player_occlusion_mask_loop2_z_loop
	ret


;-----------------------------------------------
; - e: y coordinate to draw the top sprite
; - d: x coordinate to draw the top sprite
; - ix: object to add to the mask
add_enemy_to_player_occlusion_mask:
	; Check vertical overlap
	ld a,(ix+OBJECT_STRUCT_SCREEN_PIXEL_Y)
	sub d  ; a = y pixel of the row wrt occlusion mask

	cp 32
	ret p  ; enemy is to low
	cp -16
	ret m  ; enemy is too high

	ld iyh,a

	; Check horizontal overlap:
	ld a,(ix+OBJECT_STRUCT_SCREEN_TILE_X)
	add a,a
	add a,a
	add a,a
	sub e  ; a = x pixel of the row wrt occlusion mask

	cp -(6+24)  ; enemies should never be wider than 24 pixels
	ret m
	cp 15
	ret p

	ld b,(ix+OBJECT_STRUCT_SCREEN_TILE_W)
	ld l,(ix+OBJECT_STRUCT_PTR)
	ld h,(ix+OBJECT_STRUCT_PTR+1)

add_enemy_to_player_occlusion_mask_loop:
	push bc
		cp -6
		jp m,add_enemy_to_player_occlusion_mask_loop_next_column
		cp 15
		jp p,add_enemy_to_player_occlusion_mask_loop_end_pop

		ld iyl,a
		push hl
		push de
		push iy
			call add_enemy_column_to_player_occlusion_mask
		pop iy
		pop de
		pop hl
		ld a,iyl

add_enemy_to_player_occlusion_mask_loop_next_column
		add a,8
		ld bc,16*2
		add hl,bc  ; next column
	pop bc
	djnz add_enemy_to_player_occlusion_mask_loop
	ret
add_enemy_to_player_occlusion_mask_loop_end_pop:
	pop bc
	ret


;-----------------------------------------------
; - e: y coordinate to draw the top sprite
; - d: x coordinate to draw the top sprite
; - hl: ptr to the column data
; - ix: enemy to add to the mask
; - iyl: column pixel x coordinate in occlusion mask coordinates
; - iyh: column pixel y coordinate in occlusion mask coordinates
add_enemy_column_to_player_occlusion_mask:
	ex de,hl

	; get the ptr to the top-left byte in the occlusion mask to start writing to:

	; hl = player_sprite_occlusion_buffer + iyh
	; sign extend iyh to bc, before adding to hl (since iyh could be negative)
	ld a,iyh
	add a,a
	sbc a,a
	ld b,a
	ld c,iyh
	ld hl,player_sprite_occlusion_buffer
	add hl,bc

	; update the mask (first column):
	; if iyl > 0: shift right "iyl" pixels
	; if iyl < 0: shift left "-iyl" pixels
	ld a,iyl
	or a
	jp z,add_enemy_column_to_player_occlusion_mask_loop1_z
	jp p,add_enemy_column_to_player_occlusion_mask_loop1_p
add_enemy_column_to_player_occlusion_mask_loop1_m:
	ld b,16  ; enemy height in pixels
	ld c,iyh
add_enemy_column_to_player_occlusion_mask_loop1_m_loop:
	ld a,c
	cp 5  ; there is nothing on the top 5 rows of player sprites
	jp m,add_enemy_column_to_player_occlusion_mask_loop1_m_loop_skip
	cp 32 ; there is nothing past pixel 32
	jp p,add_enemy_column_to_player_occlusion_mask_loop1_m_loop_skip2

	; get the mask:
	push bc
		; shift the mask left/right:
		ld b,iyl
		ld a,(de)
		cp #ff
		jr z,add_enemy_column_to_player_occlusion_mask_loop1_shift_left_done2

add_enemy_column_to_player_occlusion_mask_loop1_shift_left:
		sli a
		inc b
		jp nz,add_enemy_column_to_player_occlusion_mask_loop1_shift_left
		; apply mask:
		and (hl)
		ld (hl),a
add_enemy_column_to_player_occlusion_mask_loop1_shift_left_done2:
	pop bc
add_enemy_column_to_player_occlusion_mask_loop1_m_loop_skip:
	inc hl
	inc c
	inc de
	inc de
	djnz add_enemy_column_to_player_occlusion_mask_loop1_m_loop
add_enemy_column_to_player_occlusion_mask_loop1_m_loop_skip2:
	ret


add_enemy_column_to_player_occlusion_mask_loop1_z:
	ld b,16  ; enemy height in pixels
	ld c,iyh
add_enemy_column_to_player_occlusion_mask_loop1_z_loop:
	ld a,c
	cp 5  ; there is nothing on the top 5 rows of player sprites
	jp m,add_enemy_column_to_player_occlusion_mask_loop1_z_loop_skip
	cp 32 ; there is nothing past pixel 32
	jp p,add_enemy_column_to_player_occlusion_mask_loop1_z_loop_skip2

	; get the mask:
	; shift the mask left/right:
	ld a,(de)
	; apply mask:
	and (hl)
	ld (hl),a
add_enemy_column_to_player_occlusion_mask_loop1_z_loop_skip:
	inc hl
	inc c
	inc de
	inc de
	djnz add_enemy_column_to_player_occlusion_mask_loop1_z_loop
add_enemy_column_to_player_occlusion_mask_loop1_z_loop_skip2:
	ret


add_enemy_column_to_player_occlusion_mask_loop1_p:
	push de
	push hl
	push ix
		push hl
		pop ix
		ld bc,OCCLUSION_MASK_HEIGHT
		add ix,bc
		ld b,16  ; enemy height in pixels
		ld c,iyh
add_enemy_column_to_player_occlusion_mask_loop1_p_loop:
		ld a,c
		cp 5  ; there is nothing on the top 5 rows of player sprites
		jp m,add_enemy_column_to_player_occlusion_mask_loop1_p_loop_skip
		cp 32 ; there is nothing past pixel 32
		jp p,add_enemy_column_to_player_occlusion_mask_loop1_p_loop_skip2

		; get the mask:
		push bc
			; shift the mask left/right:
			ld b,iyl
			ld a,(de)
			cp #ff
			jr z,add_enemy_column_to_player_occlusion_mask_loop1_shift_right_done2

			ld c,#ff

			srl a
			rr c
			or #80
			dec b
			jr z,add_enemy_column_to_player_occlusion_mask_loop1_shift_right_done
add_enemy_column_to_player_occlusion_mask_loop1_shift_right:
			sra a
			rr c
			djnz add_enemy_column_to_player_occlusion_mask_loop1_shift_right
add_enemy_column_to_player_occlusion_mask_loop1_shift_right_done:
			; apply mask:
			and (hl)
			ld (hl),a
			ld a,c
			and (ix)
			ld (ix),a
add_enemy_column_to_player_occlusion_mask_loop1_shift_right_done2:
		pop bc
add_enemy_column_to_player_occlusion_mask_loop1_p_loop_skip:
		inc hl
		inc ix
		inc c
		inc de
		inc de
		djnz add_enemy_column_to_player_occlusion_mask_loop1_p_loop
add_enemy_column_to_player_occlusion_mask_loop1_p_loop_skip2:
	pop ix
	pop hl
	pop de
	ret



add_enemy_column_to_player_occlusion_mask_loop1_done:
	ld bc,OCCLUSION_MASK_HEIGHT
	add hl,bc

	; update the mask (second column):
	; if iyl > 0: shift right "iyl" pixels
	; if iyl < 0: shift left "-iyl" pixels
	sub 8
	jp z,add_enemy_column_to_player_occlusion_mask_loop2_z
	jp m,add_enemy_column_to_player_occlusion_mask_loop2_m
add_enemy_column_to_player_occlusion_mask_loop2_p:
	ld b,16  ; enemy height in pixels
	ld c,iyh
add_enemy_column_to_player_occlusion_mask_loop2_p_loop:
	ld a,c
	cp 5  ; there is nothing on the top 5 rows of player sprites
	jp m,add_enemy_column_to_player_occlusion_mask_loop2_p_loop_skip
	cp 32 ; there is nothing past pixel 32
	ret p

	; get the mask:
	push bc
		; shift the mask left/right:
		ld a,iyl
		sub 8
		ld b,a
		ld a,(de)
		cp #ff
		jr z,add_enemy_column_to_player_occlusion_mask_loop2_shift_right_done2

		srl a
		or #80
		dec b
		jr z,add_enemy_column_to_player_occlusion_mask_loop2_shift_right_done
add_enemy_column_to_player_occlusion_mask_loop2_shift_right:
		sra a
		djnz add_enemy_column_to_player_occlusion_mask_loop2_shift_right
add_enemy_column_to_player_occlusion_mask_loop2_shift_right_done:
		; apply mask:
		and (hl)
		ld (hl),a
add_enemy_column_to_player_occlusion_mask_loop2_shift_right_done2:
	pop bc
add_enemy_column_to_player_occlusion_mask_loop2_p_loop_skip:
	inc hl
	inc c
	inc de
	inc de
	djnz add_enemy_column_to_player_occlusion_mask_loop2_p_loop
add_enemy_column_to_player_occlusion_mask_loop2_p_loop_skip2:
	ret

add_enemy_column_to_player_occlusion_mask_loop2_m:
	ld b,16  ; enemy height in pixels
add_enemy_column_to_player_occlusion_mask_loop2_m_loop:
	ld a,iyh
	cp 5  ; there is nothing on the top 5 rows of player sprites
	jp m,add_enemy_column_to_player_occlusion_mask_loop2_m_loop_skip
	cp 32 ; there is nothing past pixel 32
	ret p

	; get the mask:
	; shift the mask left/right:
	ld a,iyl
	sub 8
	ld c,a
	ld a,(de)
	cp #ff
	jr z,add_enemy_column_to_player_occlusion_mask_loop2_m_loop_skip	
add_enemy_column_to_player_occlusion_mask_loop2_shift_left:
	sli a
	inc c
	jp nz,add_enemy_column_to_player_occlusion_mask_loop2_shift_left
	; apply mask:
	and (hl)
	ld (hl),a
add_enemy_column_to_player_occlusion_mask_loop2_m_loop_skip:
	inc hl
	inc iyh
	inc de
	inc de
	djnz add_enemy_column_to_player_occlusion_mask_loop2_m_loop
	ret


add_enemy_column_to_player_occlusion_mask_loop2_z:
	ld b,16  ; enemy height in pixels
	ld c,iyh
add_enemy_column_to_player_occlusion_mask_loop2_z_loop:
	ld a,c
	cp 5  ; there is nothing on the top 5 rows of player sprites
	jp m,add_enemy_column_to_player_occlusion_mask_loop2_z_loop_skip
	cp 32 ; there is nothing past pixel 32
	ret p

	; get the mask:
	ld a,(de)
	; apply mask:
	and (hl)
	ld (hl),a
add_enemy_column_to_player_occlusion_mask_loop2_z_loop_skip:
	inc hl
	inc c
	inc de
	inc de
	djnz add_enemy_column_to_player_occlusion_mask_loop2_z_loop
	ret
