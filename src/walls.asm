;-----------------------------------------------
; Note: this method assumes that we will not draw outside of the background_tile_ptrs area!
setup_wall_bookshelves:
	ld hl,wall_bookshelves_zx0
	ld de,wall_data_buffer
	call dzx0_standard

	call setup_wall_left_most_corner_ptr

	; top of the column to draw
	ld de,wall_data_buffer
	call draw_wall_column_ptrs

	ld a,(room_height)
; 	add a,a  ; number of columns to draw:
	ld b,a
	xor a
	jr setup_wall_bookshelves_left_loop_no_reset  ; do not reset in the first loop
setup_wall_bookshelves_left_loop:
	; check if we need to reset the shelves loop:
	and #03
	jr nz,setup_wall_bookshelves_left_loop_no_reset
	ld de,wall_data_buffer
	push bc
		ld bc,-32*2
		add hl,bc
		ld a,(wall_data_buffer + 10)
		call get_wall_tile_ptr  ; draw the top-left corner of a shelf (which is not drawn by the regular loop)
		ld (hl),c
		inc hl
		ld (hl),b
		ld bc,-(32*2+1)
		add hl,bc
	pop bc
setup_wall_bookshelves_left_loop_no_reset:
	push af
	push bc
		inc de
		inc hl
		inc hl
		call draw_wall_column_ptrs
	pop bc
	pop af
	inc a	
	djnz setup_wall_bookshelves_left_loop

	ld de,wall_data_buffer+4
	ld a,(room_width)
; 	add a,a  ; number of columns to draw:
	ld b,a
	xor a
	jr setup_wall_bookshelves_right_loop_no_reset
setup_wall_bookshelves_right_loop:
	; check if we need to reset the shelves loop:
	and #03
	jr nz,setup_wall_bookshelves_right_loop_no_reset
	ld de,wall_data_buffer+4
	push bc
		ld bc,32*2+2
		add hl,bc
		ld a,(wall_data_buffer + 10 + 9)
		call get_wall_tile_ptr  ; draw the top-right corner of a shelf (which is not drawn by the regular loop)
		ld (hl),c
		inc hl
		ld (hl),b
		ld bc,32*2-3
		add hl,bc
	pop bc
setup_wall_bookshelves_right_loop_no_reset:

	push af
	push bc
		inc de
		inc hl
		inc hl
		call draw_wall_column_ptrs
	pop bc
	pop af
	inc a	
	djnz setup_wall_bookshelves_right_loop

	; final column:
	inc de
	inc hl
	inc hl
	jp draw_wall_column_ptrs


;-----------------------------------------------
setup_wall_bluebricks:
	ld hl,wall_bluebricks_zx0
	ld de,wall_data_buffer
	call dzx0_standard

	call setup_wall_left_most_corner_ptr

	; left-most bricks:
	inc hl
	inc hl
	ld de,wall_data_buffer+1
	call draw_wall_column_ptrs

	ld a,(room_height)
	srl a
setup_wall_bluebricks_left_loop:
	ld bc,(2-32)*2
	add hl,bc

	cp 2
	jp m,setup_wall_bluebricks_left_loop_no_wall
	push af
	push hl
		and #03
		jr nz,setup_wall_bluebricks_left_loop_no_wall2
		ld de,wall_data_buffer+2
		ld bc,32*2
		add hl,bc
		call draw_wall_column_ptrs
		inc de
		inc hl
		inc hl
		call draw_wall_column_ptrs
setup_wall_bluebricks_left_loop_no_wall2:
	pop hl
	pop af
setup_wall_bluebricks_left_loop_no_wall:

	dec a
	jr nz,setup_wall_bluebricks_left_loop

	ld bc,(32*2-1)*2
	add hl,bc
	ld de,wall_data_buffer+4
	call draw_wall_column_ptrs

	inc hl
	inc hl
	inc de
	call draw_wall_column_ptrs

	ld a,(room_width)
	srl a
setup_wall_bluebricks_right_loop:
	ld bc,(2+32)*2
	add hl,bc

	cp 2
	jp m,setup_wall_bluebricks_right_loop_no_wall
	push af
	push hl
		and #03
		jr nz,setup_wall_bluebricks_right_loop_no_wall2
		ld de,wall_data_buffer+6
		call draw_wall_column_ptrs
		inc de
		inc hl
		inc hl
		call draw_wall_column_ptrs
setup_wall_bluebricks_right_loop_no_wall2:
	pop hl
	pop af
setup_wall_bluebricks_right_loop_no_wall:

	dec a
	jr nz,setup_wall_bluebricks_right_loop

	ld bc,-(64+1)*2
	add hl,bc
	ld de,wall_data_buffer+8
	jp draw_wall_column_ptrs


;-----------------------------------------------
setup_wall_bricks_bookshelves:
	ld hl,wall_bricks_bookshelves_zx0
	ld de,wall_data_buffer
	call dzx0_standard

	call setup_wall_left_most_corner_ptr

	; left-most bricks:
	inc hl
	inc hl
	ld de,wall_data_buffer+1
	call draw_wall_column_ptrs

	ld a,(room_height)
	srl a
setup_wall_bricks_bookshelves_left_loop:
	ld bc,(2-32)*2
	add hl,bc

	cp 2
	jp m,setup_wall_bricks_bookshelves_left_loop_no_wall
	push af
	push hl
		and #03
		jr nz,setup_wall_bricks_bookshelves_left_loop_no_wall2
		ld de,wall_data_buffer+2
		ld bc,32*2
		add hl,bc
		call draw_wall_column_ptrs
		inc de
		inc hl
		inc hl
		call draw_wall_column_ptrs
setup_wall_bricks_bookshelves_left_loop_no_wall2:
	pop hl
	pop af
setup_wall_bricks_bookshelves_left_loop_no_wall:

	dec a
	jr nz,setup_wall_bricks_bookshelves_left_loop

	ld bc,(32*2-1)*2
	add hl,bc
	ld de,wall_data_buffer+4
	call draw_wall_column_ptrs

	ld de,wall_data_buffer+4
	ld a,(room_width)
; 	add a,a  ; number of columns to draw:
	ld b,a
	xor a
	jr setup_wall_bricks_bookshelves_right_loop_no_reset
setup_wall_bricks_bookshelves_right_loop:
	; check if we need to reset the shelves loop:
	and #03
	jr nz,setup_wall_bricks_bookshelves_right_loop_no_reset
	ld de,wall_data_buffer+4
	push bc
		ld bc,32*2+2
		add hl,bc
		ld a,(wall_data_buffer + 10 + 9)
		call get_wall_tile_ptr  ; draw the top-right corner of a shelf (which is not drawn by the regular loop)
		ld (hl),c
		inc hl
		ld (hl),b
		ld bc,32*2-3
		add hl,bc
	pop bc
setup_wall_bricks_bookshelves_right_loop_no_reset:

	push af
	push bc
		inc de
		inc hl
		inc hl
		call draw_wall_column_ptrs
	pop bc
	pop af
	inc a	
	djnz setup_wall_bricks_bookshelves_right_loop

	; final column:
	inc de
	inc hl
	inc hl
	jp draw_wall_column_ptrs






;-----------------------------------------------
setup_wall_left_most_corner_ptr:
	; x: room_x - room_height
	; y: room_y + room_height/2
	ld a,(room_height)
	ld d,a
	ld a,(room_x)
	sub d
	dec a
	ld e,a  ; e = room_x - room_height - 1

	ld a,(room_y)
	srl d
	add a,d
	add a,-6
	ld l,a  ; l = room_y + room_height/2 - 6
	; ptr = (l*32+e)*2
	ld h,0
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl

	; sign extend e to ed, before adding to hl (since e could be negative)
	ld a,e
	add a,a
	sbc a,a
	ld d,a
	add hl,de
	add hl,hl
	ld de,background_tile_ptrs
	add hl,de  ; hl = background_tile_ptrs + (d*32+e)*2
	ret


;-----------------------------------------------
; input:
; - a: tile index
; output:
; - bc: tile ptr
get_wall_tile_ptr:
	push hl
		ld bc,wall_data_buffer+10*6
		dec a
		add a,a
		add a,a
		ld h,0
		ld l,a
		add hl,hl
		add hl,hl
		add hl,bc  ; hl = ptr of the tile to draw
		ld b,h
		ld c,l
	pop hl
	ret



;-----------------------------------------------
setup_wall_entrance:
	ld hl,wall_entrance_zx0
	ld de,wall_data_buffer
	call dzx0_standard

	ld de,wall_data_buffer
	ld hl,background_tile_ptrs+(15 - 2*32)*2
	call draw_wall_column_ptrs

	ld de,wall_data_buffer+1
	ld hl,background_tile_ptrs+(16 - 2*32)*2
	call draw_wall_column_ptrs

	ld de,wall_data_buffer+2
	ld hl,background_tile_ptrs+(17 - 32)*2
	call draw_wall_column_ptrs

	ld de,wall_data_buffer+3
	ld hl,background_tile_ptrs+(18 - 32)*2
	call draw_wall_column_ptrs

	ld de,wall_data_buffer+2
	ld hl,background_tile_ptrs+(19 + 0*32)*2
	call draw_wall_column_ptrs

; 	ld de,wall_data_buffer+4
; 	ld hl,background_tile_ptrs+(20 + 0*32)*2
; 	call draw_wall_column_ptrs

; 	ld de,wall_data_buffer+5
; 	ld hl,background_tile_ptrs+(21 + 0*32)*2
; 	call draw_wall_column_ptrs

; 	ld de,wall_data_buffer+6
; 	ld hl,background_tile_ptrs+(22 + 32)*2
; 	call draw_wall_column_ptrs

; 	ld de,wall_data_buffer+7
; 	ld hl,background_tile_ptrs+(23 + 32*2)*2
; 	call draw_wall_column_ptrs

	ld de,wall_data_buffer+3
	ld hl,background_tile_ptrs+(24 + 32*2)*2
	call draw_wall_column_ptrs

	ld de,wall_data_buffer+2
	ld hl,background_tile_ptrs+(25 + 32*3)*2
	call draw_wall_column_ptrs

	ld de,wall_data_buffer+3
	ld hl,background_tile_ptrs+(26 + 32*3)*2
	call draw_wall_column_ptrs

	ld de,wall_data_buffer
	ld hl,background_tile_ptrs+(27 + 32*4)*2
	call draw_wall_column_ptrs

	ld de,wall_data_buffer+1
	ld hl,background_tile_ptrs+(28 + 32*4)*2
; 	jp draw_wall_column_ptrs


;-----------------------------------------------
; input:
; - de: ptr to the nametable of the wall containing the column to draw
; - hl: ptr to the background tile pointers position to start drawing at
draw_wall_column_ptrs:
	push hl
	push de
		ld b,6
draw_wall_column_ptrs_loop:
		push bc
			ld a,(de)
			or a
			jr z,draw_wall_column_ptrs_skip

			; check we are within screen bounds (just check if hl >= background_tile_ptrs):
			push hl
				ld bc,-background_tile_ptrs
				add hl,bc
				bit 7,h
			pop hl
			jr nz,draw_wall_column_ptrs_skip

			call get_wall_tile_ptr
			ld (hl),c
			inc hl
			ld (hl),b
			dec hl
draw_wall_column_ptrs_skip:
			ld bc,32*2
			add hl,bc
			ex de,hl
				ld c,10
				add hl,bc
			ex de,hl
		pop bc
		djnz draw_wall_column_ptrs_loop
	pop de
	pop hl
	ret


;-----------------------------------------------
setup_wall_victorian:
	ld hl,wall_victorian_zx0
	ld de,wall_data_buffer
	call dzx0_standard

setup_wall_victorian_tiles_entrypoint:
setup_wall_victorian_blue_entrypoint:
	call setup_wall_left_most_corner_ptr
	ld de,wall_data_buffer

	ld a,(room_height)
	ld b,a
	xor a
	jr setup_wall_victorian_left_loop_no_reset
setup_wall_victorian_left_loop:
	; check if we need to reset the shelves loop:
	and #01
	jr nz,setup_wall_victorian_left_loop_no_reset
	ld de,wall_data_buffer
	push bc
		ld bc,-32*2
		add hl,bc
	pop bc
setup_wall_victorian_left_loop_no_reset:
	push af
	push bc
		inc de
		inc hl
		inc hl
		call draw_wall_column_ptrs
	pop bc
	pop af
	inc a	
	djnz setup_wall_victorian_left_loop

	ld de,wall_data_buffer+2
	ld a,(room_width)
	ld b,a
	xor a
	jr setup_wall_victorian_right_loop_no_reset
setup_wall_victorian_right_loop:
	; check if we need to reset the shelves loop:
	and #01
	jr nz,setup_wall_victorian_right_loop_no_reset
	ld de,wall_data_buffer+2
	push bc
		ld bc,32*2
		add hl,bc
	pop bc
setup_wall_victorian_right_loop_no_reset:
	push af
	push bc
		inc de
		inc hl
		inc hl
		call draw_wall_column_ptrs
	pop bc
	pop af
	inc a	
	djnz setup_wall_victorian_right_loop
	ret



;-----------------------------------------------
setup_wall_victorian_tiles:
	ld hl,wall_victorian_zx0
	ld de,wall_data_buffer
	call dzx0_standard

	; change the wood color to tile color:
	ld hl,wall_data_buffer+10*6  ; beginning of the tile data
	ld bc,18*16  ; # tiles to change
setup_wall_victorian_tiles_loop:
	ld a,(hl)
	cp COLOR_DARK_RED*16
	jr nz,setup_wall_victorian_tiles_loop_skip
	ld (hl),COLOR_DARK_BLUE*16
setup_wall_victorian_tiles_loop_skip:
	cpi
	jp pe,setup_wall_victorian_tiles_loop	
	jr setup_wall_victorian_tiles_entrypoint



;-----------------------------------------------
setup_wall_victorian_blue:
	ld hl,wall_victorian_zx0
	ld de,wall_data_buffer
	call dzx0_standard

	; change the wall color to blue:
	ld hl,wall_data_buffer+10*6  ; beginning of the tile data
	ld bc,18*16  ; # tiles to change
setup_wall_victorian_blue_loop:
	ld a,(hl)
	cp COLOR_GREY*16
	jr nz,setup_wall_victorian_blue_loop_skip
	ld (hl),COLOR_DARK_BLUE*16
setup_wall_victorian_blue_loop_skip:
	cpi
	jp pe,setup_wall_victorian_blue_loop

	jp setup_wall_victorian_blue_entrypoint

