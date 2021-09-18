;-----------------------------------------------
; note: we redraw it in two parts (left/right), since, if we draw the whole screen at once
; there are some overflow problems with x coordinates.
render_full_room:
	ld de,0
	ld bc,16+SCREEN_HEIGHT*256
	call render_room_rectangle
	ld de,16
	ld bc,16+SCREEN_HEIGHT*256
	; jp render_room_rectangle


;-----------------------------------------------
; input:
; - e, d: x, y of top-left of the rectangle
; - c, b: width, height of the rectangle
; the "safe" version makes sure the rectangle boundaries are within the screen:
render_room_rectangle_safe:
	; check left edge:
	ld a,e
	or a
render_room_rectangle_safe_loop:
	jp p,render_room_rectangle_safe2
	inc e
	dec c
	ret z
	inc a
	jr render_room_rectangle_safe_loop
render_room_rectangle_safe2:	
	; check top edge:
	ld a,d
	or a
render_room_rectangle_safe_loop2:
	jp p,render_room_rectangle_safe3
	inc d
	dec b
	ret z
	inc a
	jr render_room_rectangle_safe_loop2
render_room_rectangle_safe3:
	; check bottom edge:
	ld a,d
	add a,b
render_room_rectangle_safe3_loop:
	cp SCREEN_HEIGHT+1
	jp m,render_room_rectangle
	dec b
	ret z
	dec a
	jr render_room_rectangle_safe3_loop
render_room_rectangle:
	ld (render_room_rectangle_xy),de  ; (we will be increasing y at each row, to keep track of the current y)
	ld (render_room_rectangle_wh),bc

	; Calculate the pointers to start drawing from (hl: source, de: target):
	ld l,d
	ld h,0
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld d,0
	add hl,de
	add hl,hl  ; hl = (d*32+e)*2
	push hl
		add hl,hl
		add hl,hl  ; hl = (d*32+e)*8
		; No need to add CHRTBL2, since CHRTBL2 = 0
; 		ld de,CHRTBL2
; 		add hl,de
		ex de,hl  ; de = CHRTBL2 + (d*32+e)*8
	pop hl
	push bc
		ld bc,background_tile_ptrs
		add hl,bc  ; hl = background_tile_ptrs + (d*32+e)*2
	pop bc
	
render_room_rectangle_loop_y:
	push bc
		push hl
			push de
				ld de,row_draw_buffer
				ld b,c
render_room_rectangle_loop_x:
				push bc
					ld c,(hl)
					inc hl
					ld b,(hl)
					inc hl
					push hl
						ld h,b
						ld l,c

						; render one tile:
						; pattern:
						ldi
						ldi
						ldi
						ldi
						ldi
						ldi
						ldi
						ldi
						push de
							ex de,hl
								ld bc,31*8
								add hl,bc
							ex de,hl
 							; attributes
							ldi
							ldi
							ldi
							ldi
							ldi
							ldi
							ldi
							ldi
						pop de
					pop hl
				pop bc
				djnz render_room_rectangle_loop_x
			pop de

			; Check objects:
			ld a,(n_objects)
; 			or a
; 			jp z,render_room_rectangle_objects_done
			exx
				ld b,a
				ld iy,objects
render_room_rectangle_objects_loop:
				ld a,(iy)
				or a
				jr z,render_room_rectangle_objects_loop_skip_object
				bit 7,a  ; 0 -> object, 1 -> enemy
				push bc
					push af
						call z,render_room_rectangle_object
					pop af
					call nz,render_room_rectangle_enemy
				pop bc
render_room_rectangle_objects_loop_skip_object:
				ld de,OBJECT_STRUCT_SIZE
				add iy,de
				djnz render_room_rectangle_objects_loop
			exx
render_room_rectangle_objects_done:

			; render to the VDP:
			push de
				ld a,(render_room_rectangle_wh)
				ld l,a
				ld h,0
				add hl,hl
				add hl,hl
				add hl,hl
				ld b,h
				ld c,l
				ld hl,row_draw_buffer
				push bc
				push de
					call fast_LDIRVM
				pop de
				pop bc
				ld a,#20
				add a,d
				ld d,a  ; this is equivalent to de += CLRTBL2 - CHRTBL2
				ld hl,row_draw_buffer+32*8
				call fast_LDIRVM
			pop de
			inc d  ; de += 256 (go to the next line in the screen)
		pop hl
		ld bc,32*2
		add hl,bc  ; go to the next line in the pointer buffer
	pop bc
	ld a,(render_room_rectangle_xy+1)
	inc a
	ld (render_room_rectangle_xy+1),a
	dec b
	jp nz, render_room_rectangle_loop_y
	ret


;-----------------------------------------------
render_room_rectangle_object:
	ld a,(render_room_rectangle_xy+1)  ; y coordinate of the row we are rendering
	add a,a
	add a,a
	add a,a
	ld e,a

	; check for y coordinate overlap:
	; (pixel) y coordinate of the object in row coordinates:
	ld a,(iy+OBJECT_STRUCT_SCREEN_PIXEL_Y)
	sub e  ; row_pixel_y

	ld c,a
	ld a,(iy+OBJECT_STRUCT_SCREEN_TILE_H)
	add a,a
	add a,a
	add a,a
	ld (render_room_object_screen_pixel_h),a
	dec a
	neg
	ld b,a
	ld a,c

	cp 8
	ret p
	cp b
	ret m

	ld a,(render_room_rectangle_xy)  ; x coordinate of the row we are rendering
	ld d,a

	; check for x coordinate overlap:
	; (tile) x coordinate of the object in row coordinates:
	; (pixel) x offset (0, 2, 4 or 6)

	ld a,(iy+OBJECT_STRUCT_SCREEN_TILE_X)
	sub d  ; row_tile_x
	ld ixh,a

	; Here:
	; - iy points to the current object
	; - b: how many objects are left
	; - c: has the y pixel coordinate in row coordinates
	; - ixh (and a) has the x tile coordinate in row coordinates

	add a,a
	add a,a
	add a,a
	ld l,a  ; ixh * 8
	; sign extend a to hl:
	add a,a
	sbc a,a
	ld h,a
	ld de,row_draw_buffer
	add hl,de
	ex de,hl

	ld hl,render_room_object_screen_pixel_h
	ld a,(hl)
	add a,(hl)
	add a,(hl)
	ld ixl,a  ; ixl has the column size: (render_room_object_screen_pixel_h)*3

	ld l,(iy+OBJECT_STRUCT_PTR)
	ld h,(iy+OBJECT_STRUCT_PTR+1)

; 	push bc
		; calculate the y offset, and how many pixels to copy per row:
		; if c < 0: hl -= c*3;  c = min(8, OBJECT_STRUCT_SCREEN_TILE_H*8+c) (copy c pixels per row)
		; if c >= 0 (at most 7): de += c;  c = 8 - c
		ld a,c
		or a
		jp p,render_room_rectangle_object_loop_positive_offset
render_room_rectangle_object_loop_negative_offset:
		push bc
			xor a
			sub c		
			ld b,0
			ld c,a
			add hl,bc
			add hl,bc
			add hl,bc
		pop bc
		ld a,(render_room_object_screen_pixel_h)
		add a,c
		ld c,a
		cp 8
		jp m,render_room_rectangle_object_loop_offset_set
		ld c,8
		jp render_room_rectangle_object_loop_offset_set

render_room_rectangle_object_loop_positive_offset:
		ld a,e
		add a,c
		ld e,a  ; de is 256-aligned, so, we can just add c to e
		ld a,8
		sub c
		ld c,a

render_room_rectangle_object_loop_offset_set:
		ld b,(iy+OBJECT_STRUCT_SCREEN_TILE_W)
render_room_rectangle_object_loop_column_loop:
		push bc
			ld a,ixh
			or a
			jp m,render_room_rectangle_object_loop_next_column
			ld a,(render_room_rectangle_wh)
			dec a
			cp ixh
			jp m, render_room_rectangle_object_loop_next_column

			; draw one column from hl to de
			push de
			push hl
				ld b,c  ; c: # of pixels to draw per column
render_room_rectangle_object_loop_column_loop_internal:
				ld a,(de)
				and (hl)
				inc hl
				or (hl)
				inc hl
				ld (de),a

				; attributes:
				ld a,(hl)
				or a
				jp z,render_room_rectangle_object_loop_column_loop_internal_skip
				inc d
				ld (de),a  ; attribute
				dec d
render_room_rectangle_object_loop_column_loop_internal_skip:
				inc hl
				inc e  ; de is 256-aligned

				djnz render_room_rectangle_object_loop_column_loop_internal
			pop hl
			pop de

render_room_rectangle_object_loop_next_column:
			ld bc,8
			ex de,hl
				add hl,bc
			ex de,hl
			ld c,ixl  ; column size
			add hl,bc
		pop bc
		inc ixh
		djnz render_room_rectangle_object_loop_column_loop
; 	pop bc
	ret


;-----------------------------------------------
render_room_rectangle_enemy:
	ld a,(render_room_rectangle_xy+1)  ; y coordinate of the row we are rendering
	add a,a
	add a,a
	add a,a
	ld e,a

	; check for y coordinate overlap:
	; (pixel) y coordinate of the object in row coordinates:
	; y: room_y*8 + iso_y/2 + iso_x/2 - iso_z - 8  -  row_y
	ld a,(iy+OBJECT_STRUCT_SCREEN_PIXEL_Y)
	sub e  ; row_pixel_y

	cp 8
	ret p
	cp -15  ; HARDCODED: 1 - (iy+OBJECT_STRUCT_SCREEN_TILE_H)*8
	ret m
	ld c,a

	ld a,(render_room_rectangle_xy)  ; x coordinate of the row we are rendering
	add a,a
	add a,a
	add a,a
	ld d,a

	; check for x coordinate overlap:
	; (tile) x coordinate of the object in row coordinates:
	; (pixel) x offset (0, 2, 4 or 6)

	; x: room_x*8 + iso_x - iso_y - 8  -  row_x			
	ld a,(iy+OBJECT_STRUCT_SCREEN_PIXEL_X)
	sub d  ; row_pixel_x
	ld d,a
	and #06
	ld ixl,a
	ld a,d
	sra a
	sra a
	sra a
	ld ixh,a

	; Here:
	; - iy points to the current enemy
	; - b: how many objects/enemies are left
	; - c: has the y pixel coordinate in row coordinates
	; - ixl has the x pixel offset: 0, 2, 4, 6
	; - ixh has the x tile coordinate

	ld a,d
	and #f8  ; tile coordinate * 8
	ld l,a  ; ixh * 8
	; sign extend a to hl:
	add a,a
	sbc a,a
	ld h,a
	ld de,row_draw_buffer
	add hl,de
	ex de,hl
	ld l,(iy+OBJECT_STRUCT_PTR)
	ld h,(iy+OBJECT_STRUCT_PTR+1)
	; here:
	; - de: ptr to the raw_draw_buffer where to draw
	; - hl: object data ptr

; 	push bc
		; calculate the y offset, and how many pixels to copy per row:
		; if c < 0: hl -= c*2;  c = min(8, OBJECT_STRUCT_SCREEN_TILE_H+c) (copy c pixels per row)
		; if c >= 0: de += c;  c = 8 - c
		ld a,c
		or a
		jp p,render_room_rectangle_enemies_loop_positive_offset
render_room_rectangle_enemies_loop_negative_offset:
		push bc
			xor a
			sub c		
			add a,a
			ld b,0
			ld c,a
			add hl,bc
		pop bc
		ld a,c
		cp -8
		jp m,render_room_rectangle_enemies_loop_negative_offset_m
render_room_rectangle_enemies_loop_negative_offset_p:
		ld c,8
		jp render_room_rectangle_enemies_loop_offset_set
render_room_rectangle_enemies_loop_negative_offset_m:
		add 16  ; HARDCODED: (iy+OBJECT_STRUCT_SCREEN_TILE_H)*8
		ld c,a
		jp render_room_rectangle_enemies_loop_offset_set

render_room_rectangle_enemies_loop_positive_offset:
		ld a,e
		add a,c
		ld e,a  ; de is 256-aligned, so, we can just add c to e
		ld a,8
		sub c
		ld c,a


render_room_rectangle_enemies_loop_offset_set:
		ld b,(iy+OBJECT_STRUCT_SCREEN_TILE_W)
render_room_rectangle_enemies_loop_draw_enemy_column_loop:
		push bc
			ld a,ixh
			or a
			jp m,render_room_rectangle_enemies_loop_draw_enemy_next_column
			ld a,(render_room_rectangle_wh)
			dec a
			cp ixh
			jp m, render_room_rectangle_enemies_loop_draw_enemy_next_column

			; draw one column from ix to hl
			push de
			push hl
				ld b,c  ; c: # of pixels to draw per column
render_room_rectangle_enemies_loop_draw_enemy_column_loop_internal:
				ld a,(de)
				and (hl)
				inc hl
				or (hl)
				inc hl
				ld (de),a
				inc e  ; de is 256-aligned
				djnz render_room_rectangle_enemies_loop_draw_enemy_column_loop_internal
			pop hl
			pop de

render_room_rectangle_enemies_loop_draw_enemy_next_column:
			ld bc,8
			ex de,hl
				add hl,bc
			ex de,hl
			ld c,32  ; HARDCODED: (iy+OBJECT_STRUCT_SCREEN_TILE_H)*16
			add hl,bc
		pop bc
		inc ixh
		djnz render_room_rectangle_enemies_loop_draw_enemy_column_loop
; 	pop bc
	ret
