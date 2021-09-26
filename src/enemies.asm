;-----------------------------------------------
init_object_screen_coordinates:
	ld a,(n_objects)
	or a
	ret z
	ld iy,objects
	ld b,a
init_object_screen_coordinates_loop:
	push bc
		ld a,(iy)
		bit 7,a  ; enemies are marked with the msb = 1
		jr z,init_object_screen_coordinates_loop_skip
		call update_enemy_screen_coordinates
init_object_screen_coordinates_loop_skip:
		ld bc,OBJECT_STRUCT_SIZE
		add iy,bc
	pop bc
	djnz init_object_screen_coordinates_loop
	ret	


update_enemy_screen_coordinates:
	; screen_x = room_x + (x*2 - y*2)/16 - 1
	ld a,(room_x)
	add a,a
	add a,a
	add a,a
	add a,(iy+OBJECT_STRUCT_PIXEL_ISO_X)
	sub (iy+OBJECT_STRUCT_PIXEL_ISO_Y)
	sub 8
	ld (iy+OBJECT_STRUCT_SCREEN_PIXEL_X),a
	rrca
	rrca
	rrca
	and #1f
	ld (iy+OBJECT_STRUCT_SCREEN_TILE_X),a

	ld a,(iy)
	cp OBJECT_TYPE_STOOL
	jr z,update_enemy_screen_coordinates_skip_ptr_update
	cp OBJECT_TYPE_CHAIR_RIGHT
	jr z,update_enemy_screen_coordinates_skip_ptr_update
	cp OBJECT_TYPE_CHAIR_LEFT
	jr z,update_enemy_screen_coordinates_skip_ptr_update
	cp OBJECT_TYPE_BULLET
	jr z,update_enemy_screen_coordinates_skip_ptr_update
	cp OBJECT_TYPE_TALL_STOOL
	jr z,update_enemy_screen_coordinates_skip_ptr_update

	ld a,(iy+OBJECT_STRUCT_SCREEN_PIXEL_X)
	and #06
	ld d,a
	ld a,(iy+OBJECT_STRUCT_FRAME)
	; += (a * 4 + d/2) * 16 * 3 * 2  ->  += (8*a + d) * 16 * 3
	add a,a
	add a,a
	add a,a
	add a,d
	ld h,0
	ld l,a
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld b,h
	ld c,l	
	ld hl,enemy_data_buffer
	add hl,bc
	add hl,bc
	add hl,bc  ; hl = pointer of the sprite to draw
	ld (iy+OBJECT_STRUCT_PTR),l
	ld (iy+OBJECT_STRUCT_PTR+1),h
update_enemy_screen_coordinates_skip_ptr_update:

	; screen_y = room_y + (x + y)/16 - z/8 - 1
	ld a,(room_y)
	add a,a
	add a,a
	add a,a
	ld c,a
	ld a,(iy+OBJECT_STRUCT_PIXEL_ISO_Y)
	add a,(iy+OBJECT_STRUCT_PIXEL_ISO_X)
	jr nc,update_enemy_screen_coordinates_ncy
	srl a
	or #80
	jr update_enemy_screen_coordinates_continuey
update_enemy_screen_coordinates_ncy:
	srl a
update_enemy_screen_coordinates_continuey:
	sub (iy+OBJECT_STRUCT_PIXEL_ISO_Z)
	add c
	sub (iy+OBJECT_STRUCT_PIXEL_ISO_Z_H)
	ld (iy+OBJECT_STRUCT_SCREEN_PIXEL_Y),a
	rrca
	rrca
	rrca
	and #1f
	ld (iy+OBJECT_STRUCT_SCREEN_TILE_Y),a
	ret


;-----------------------------------------------
update_enemies_rat:
	bit 7,(iy+OBJECT_STRUCT_STATE)
	jp nz,update_enemies_hit

	inc (iy+OBJECT_STRUCT_STATE_TIMER)
	ld a,(iy+OBJECT_STRUCT_STATE_TIMER)
	and #03
	jp nz,update_objects_loop_skip
	ld a,(iy+OBJECT_STRUCT_STATE_TIMER)
	rrca
	rrca
	rrca
	and #01
	add a,(iy+OBJECT_STRUCT_STATE)
	add a,(iy+OBJECT_STRUCT_STATE)
	ld (iy+OBJECT_STRUCT_FRAME),a

	ld a,(iy+OBJECT_STRUCT_STATE)
	or a
	jr z,update_enemies_rat_ne
	dec a
	jr z,update_enemies_rat_se
	dec a
	jr z,update_enemies_rat_sw
update_enemies_rat_nw:
	ld a,(iy+OBJECT_STRUCT_PIXEL_ISO_X)
	or a
	jr z,update_enemies_rat_ne_collision
	ld de,#00fe
	ld c,d
	call check_enemy_collision
	jr z,update_enemies_rat_nw_collision
	dec (iy+OBJECT_STRUCT_PIXEL_ISO_X)
	dec (iy+OBJECT_STRUCT_PIXEL_ISO_X)
	jp update_enemies_redraw
update_enemies_rat_nw_collision:
	ld (iy+OBJECT_STRUCT_STATE),1
	jp update_enemies_redraw


update_enemies_rat_ne:
	ld a,(iy+OBJECT_STRUCT_PIXEL_ISO_Y)
	or a
	jr z,update_enemies_rat_ne_collision
	ld de,#fe00
	ld c,e
	call check_enemy_collision
	jr z,update_enemies_rat_ne_collision
	dec (iy+OBJECT_STRUCT_PIXEL_ISO_Y)
	dec (iy+OBJECT_STRUCT_PIXEL_ISO_Y)
	jp update_enemies_redraw


update_enemies_rat_ne_collision:
	ld (iy+OBJECT_STRUCT_STATE),2
	jp update_enemies_redraw


update_enemies_rat_sw:
	ld de,#0200
	ld c,e
	call check_enemy_collision
	jr z,update_enemies_rat_sw_collision
	inc (iy+OBJECT_STRUCT_PIXEL_ISO_Y)
	inc (iy+OBJECT_STRUCT_PIXEL_ISO_Y)
	jp update_enemies_redraw
update_enemies_rat_sw_collision:
	ld (iy+OBJECT_STRUCT_STATE),0
	jp update_enemies_redraw


update_enemies_rat_se:
	ld de,#0002
	ld c,d
	call check_enemy_collision
	jr z,update_enemies_rat_se_collision
	inc (iy+OBJECT_STRUCT_PIXEL_ISO_X)
	inc (iy+OBJECT_STRUCT_PIXEL_ISO_X)
	jp update_enemies_redraw
update_enemies_rat_se_collision:
	ld (iy+OBJECT_STRUCT_STATE),3
	jp update_enemies_redraw



;-----------------------------------------------
update_enemies_spider:
	bit 7,(iy+OBJECT_STRUCT_STATE)
	jp nz,update_enemies_hit

	inc (iy+OBJECT_STRUCT_STATE_TIMER)
	ld a,(iy+OBJECT_STRUCT_STATE_TIMER)
	and #01
	jp nz,update_objects_loop_skip

	ld a,(iy+OBJECT_STRUCT_STATE)
	or a
	jr z,update_enemies_spider_waiting
	dec a
	jr z,update_enemies_spider_attack
update_enemies_spider_rest:
	ld a,(iy+OBJECT_STRUCT_STATE_TIMER)
	cp 32
	jp nz,update_objects_loop_skip
	ld (iy+OBJECT_STRUCT_STATE),0
	jp update_objects_loop_skip


update_enemies_spider_waiting:
	; Check the player position:
	ld a,(player_iso_x)
	sub (iy+OBJECT_STRUCT_PIXEL_ISO_X)
	cp 48
	jp p,update_objects_loop_skip
	cp -48
	jp m,update_objects_loop_skip
	ld a,(player_iso_y)
	sub (iy+OBJECT_STRUCT_PIXEL_ISO_Y)
	cp 48
	jp p,update_objects_loop_skip
	cp -48
	jp m,update_objects_loop_skip

	; player near! attack!
	ld (iy+OBJECT_STRUCT_STATE),1
	ld a,(iy+OBJECT_STRUCT_STATE_TIMER)
	; keep the lowest bit, which determines whether the spider is updated in odd or even frames:
	and #01
	ld (iy+OBJECT_STRUCT_STATE_TIMER),a
	jp update_objects_loop_skip


update_enemies_spider_attack:
	ld a,(iy+OBJECT_STRUCT_STATE_TIMER)
	cp 40
	jr nz,update_enemies_spider_attack_not_done
	ld (iy+OBJECT_STRUCT_STATE),2
	ld a,(iy+OBJECT_STRUCT_STATE_TIMER)
	; keep the lowest bit, which determines whether the spider is updated in odd or even frames:
	and #01
	ld (iy+OBJECT_STRUCT_STATE_TIMER),a
	jp update_enemies_redraw

update_enemies_spider_attack_not_done:
	ld a,(player_iso_x)
	sub (iy+OBJECT_STRUCT_PIXEL_ISO_X)
	jr z,update_enemies_spider_attack_x_done
	jp p,update_enemies_spider_attack_x_positive
update_enemies_spider_attack_x_negative:
	call update_enemy_dec_x
	ld c,6
	jr update_enemies_spider_attack_x_movement_continue
; 	ld a,(iy+OBJECT_STRUCT_STATE_TIMER)
; 	srl a
; 	and #01
; 	add a,c
; 	ld (iy+OBJECT_STRUCT_FRAME),a
; 	jr update_enemies_spider_attack_x_done

update_enemies_spider_attack_x_positive:
	call update_enemy_inc_x
	ld c,2
update_enemies_spider_attack_x_movement_continue:
	ld a,(iy+OBJECT_STRUCT_STATE_TIMER)
	srl a
	and #01
	add a,c
	ld (iy+OBJECT_STRUCT_FRAME),a

update_enemies_spider_attack_x_done:
	ld a,(player_iso_y)
	sub (iy+OBJECT_STRUCT_PIXEL_ISO_Y)
	jr z,update_enemies_spider_attack_y_done
	jp p,update_enemies_spider_attack_y_positive
update_enemies_spider_attack_y_negative:
	call update_enemy_dec_y
	ld c,0
	jr update_enemies_spider_attack_y_movement_continue
; 	ld a,(iy+OBJECT_STRUCT_STATE_TIMER)
; 	srl a
; 	and #01
; 	ld (iy+OBJECT_STRUCT_FRAME),a
; 	jr update_enemies_spider_attack_y_done

update_enemies_spider_attack_y_positive:
	call update_enemy_inc_y
	ld c,4
update_enemies_spider_attack_y_movement_continue:	
	ld a,(iy+OBJECT_STRUCT_STATE_TIMER)
	srl a
	and #01
	add a,c
	ld (iy+OBJECT_STRUCT_FRAME),a
update_enemies_spider_attack_y_done:
	jp update_enemies_redraw


;-----------------------------------------------
update_enemies_slime:
	bit 7,(iy+OBJECT_STRUCT_STATE)
	jp nz,update_enemies_hit

	inc (iy+OBJECT_STRUCT_STATE_TIMER)
	ld a,(iy+OBJECT_STRUCT_STATE_TIMER)
	and #03
	jp nz,update_objects_loop_skip

	; follow player:
	ld a,(player_iso_x)
	sub (iy+OBJECT_STRUCT_PIXEL_ISO_X)
	jr z,update_enemies_slime_attack_x_done
	jp p,update_enemies_slime_attack_x_positive
update_enemies_slime_attack_x_negative:
	call update_enemy_dec_x
	jr update_enemies_slime_attack_x_done
update_enemies_slime_attack_x_positive:
	call update_enemy_inc_x
update_enemies_slime_attack_x_done:

	ld a,(player_iso_y)
	sub (iy+OBJECT_STRUCT_PIXEL_ISO_Y)
	jr z,update_enemies_slime_attack_y_done
	jp p,update_enemies_slime_attack_y_positive
update_enemies_slime_attack_y_negative:
	call update_enemy_dec_y
	jr update_enemies_slime_attack_y_done
update_enemies_slime_attack_y_positive:
	call update_enemy_inc_y
update_enemies_slime_attack_y_done:
	ld a,(iy+OBJECT_STRUCT_STATE_TIMER)
	srl a
	srl a
	and #01
	ld (iy+OBJECT_STRUCT_FRAME),a
	jr update_enemies_redraw


;-----------------------------------------------
update_enemies_bat:
	; bats cannot be killed:
; 	bit 7,(iy+OBJECT_STRUCT_STATE)
; 	jp nz,update_enemies_hit

	inc (iy+OBJECT_STRUCT_STATE_TIMER)
	ld a,(iy+OBJECT_STRUCT_STATE_TIMER)
	and #01
	jp nz,update_objects_loop_skip

	ld a,(iy+OBJECT_STRUCT_PIXEL_ISO_Z)
	cp 12
	jp z,update_enemies_spider_attack_not_done

	ld de,#0000
	ld c,1
	call check_enemy_collision
	jp z,update_enemies_spider_attack_not_done
	dec (iy+OBJECT_STRUCT_PIXEL_ISO_Z)
	jp update_enemies_spider_attack_not_done


;-----------------------------------------------
update_enemies_redraw:
	call update_enemy_screen_coordinates

	; redraw:
;     out (#2c),a  
	; Timing: (measured in room 34)
    ; min: 57952, max: 110812
	push iy
		ld e,(iy+OBJECT_STRUCT_SCREEN_TILE_X)
		ld d,(iy+OBJECT_STRUCT_SCREEN_TILE_Y)
		dec e
		dec d
		ld bc,#0404
		call render_room_rectangle_safe
	pop iy
; 	out (#2d),a
	jp update_objects_loop_skip


;-----------------------------------------------
update_enemies_hit:
	; delete the enemy:
	push iy
	pop ix
	push iy
		call remove_room_object
	pop iy
	ld de,-OBJECT_STRUCT_SIZE  ; since we are deleting the object, decrement iy, so the update loop can continue
	add iy,de
	jp update_objects_loop_skip


;-----------------------------------------------
update_enemy_dec_x:
	ld de,#00ff
	ld c,d
	call check_enemy_collision
	ret z
	dec (iy+OBJECT_STRUCT_PIXEL_ISO_X)
	ret

update_enemy_inc_x:
	ld de,#0001
	ld c,d
	call check_enemy_collision
	ret z
	inc (iy+OBJECT_STRUCT_PIXEL_ISO_X)
	ret

update_enemy_dec_y:
	ld de,#ff00
	ld c,e
	call check_enemy_collision
	ret z
	dec (iy+OBJECT_STRUCT_PIXEL_ISO_Y)
	ret

update_enemy_inc_y:
	ld de,#0100
	ld c,e
	call check_enemy_collision
	ret z
	inc (iy+OBJECT_STRUCT_PIXEL_ISO_Y)
	ret
