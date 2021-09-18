;-----------------------------------------------
setup_door_nw:
	call find_or_decompress_door
	
	; Calculate top-left ptr of the door:
	; x: room_x - (ix+DOOR_STRUCT_POSITION) - 1
	; y: room_y + (ix+DOOR_STRUCT_POSITION)/2 - (ix+DOOR_STRUCT_HEIGHT) - 7
	; ptr = background_tile_ptrs + (x + y*32)*2
	push de
		ld a,(room_x)
		sub (ix+DOOR_STRUCT_POSITION)
		dec a
		ld c,a
		ld a,(room_y)
		add a,a
		add a,(ix+DOOR_STRUCT_POSITION)
		srl a
		sub (ix+DOOR_STRUCT_HEIGHT)
		sub 7
setup_door_ne_entry_point:
		; sign extend a to hl:
		ld l,a
		add a,a
		sbc a,a
		ld h,a
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl
		ld b,0
		add hl,bc
		add hl,hl
		ld bc,background_tile_ptrs
		add hl,bc
	pop de	

	push de
	pop ix
	ex de,hl
		ld bc,4*8
		add hl,bc
	ex de,hl
	ld bc,4 + 8*256
	jr setup_door_draw_ptrs


;-----------------------------------------------
setup_door_ne:
	call find_or_decompress_door

	; Calculate top-left ptr of the door:
	; x: room_x + (ix+DOOR_STRUCT_POSITION) - 1
	; y: room_y + (ix+DOOR_STRUCT_POSITION)/2 - (ix+DOOR_STRUCT_HEIGHT) - 6
	; ptr = background_tile_ptrs + (x + y*32)*2
	push de
		ld a,(room_x)
		add a,(ix+DOOR_STRUCT_POSITION)
		dec a
		ld c,a
		ld a,(room_y)
		add a,a
		add a,(ix+DOOR_STRUCT_POSITION)
		srl a
		sub (ix+DOOR_STRUCT_HEIGHT)
		sub 6
		jr setup_door_ne_entry_point


;-----------------------------------------------
setup_door_se:
	call find_or_decompress_door

	; Calculate top-left ptr of the door:
	; x: room_x -1 - (ix+DOOR_STRUCT_POSITION) + room_width
	; y: room_y + room_width/2 + (ix+DOOR_STRUCT_POSITION)/2 - (ix+DOOR_STRUCT_HEIGHT) - 7
	; ptr = background_tile_ptrs + (x + y*32)*2
	push de
		ld a,(room_x)
		dec a
		sub (ix+DOOR_STRUCT_POSITION)
		ld hl,room_width
		add (hl)
		ld c,a

		ld a,(room_y)
		add a,a
		add a,(hl)
		add a,(ix+DOOR_STRUCT_POSITION)
		srl a
		sub (ix+DOOR_STRUCT_HEIGHT)
		sub 2
		jr setup_door_se_entry_point


;-----------------------------------------------
setup_door_sw:
	call find_or_decompress_door

	; Calculate top-left ptr of the door:
	; x: room_x + ((ix+DOOR_STRUCT_POSITION) - room_height) - 2
	; y: room_y + room_height/2 + (ix+DOOR_STRUCT_POSITION)/2 - (ix+DOOR_STRUCT_HEIGHT) - 1
	; ptr = background_tile_ptrs + (x + y*32)*2
	push de
		ld a,(room_x)
		add a,(ix+DOOR_STRUCT_POSITION)
		ld hl,room_height
		sub (hl)
		sub 2
		ld c,a

		ld a,(room_y)
		add a,a
		add a,(hl)
		add a,(ix+DOOR_STRUCT_POSITION)
		srl a
		sub (ix+DOOR_STRUCT_HEIGHT)
		dec a

setup_door_se_entry_point:
		; sign extend a to hl:
		ld l,a
		add a,a
		sbc a,a
		ld h,a
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl
		ld b,0
		add hl,bc
		add hl,hl
		ld bc,background_tile_ptrs
		add hl,bc
	pop de	

	push de
	pop ix
	ex de,hl
		ld bc,5*3
		add hl,bc
	ex de,hl
	ld bc,5 + 3*256
; 	jp setup_door_draw_ptrs


;-----------------------------------------------
; input:
; - de: ptr to door pattern data
; - ix: ptr to door nametable
; - hl: ptr to where to draw
; - c, b: width, height in tiles
setup_door_draw_ptrs:
setup_door_draw_ptrs_loop_y:
	push bc
		push hl
			ld b,c
setup_door_draw_ptrs_loop_x:
			push bc
				ld a,(ix)
				inc ix
				or a
				jr z,setup_door_draw_ptrs_loop_skip
				call get_door_tile_ptr

				; check we are within screen bounds (just check if hl >= background_tile_ptrs):
				push hl
				push bc
					ld bc,-background_tile_ptrs
					add hl,bc
					bit 7,h
				pop bc
				pop hl
				jr nz,setup_door_draw_ptrs_loop_skip

				ld (hl),c
				inc hl
				ld (hl),b
				inc hl
setup_door_draw_ptrs_loop_skip2:
			pop bc
			djnz setup_door_draw_ptrs_loop_x
		pop hl
		ld bc,32*2
		add hl,bc  ; next row
	pop bc
	djnz setup_door_draw_ptrs_loop_y
	ret

setup_door_draw_ptrs_loop_skip:
				inc hl
				inc hl
				jr setup_door_draw_ptrs_loop_skip2


;-----------------------------------------------
; input:
; - de: ptr to door data
; - a: tile index
; output:
; - bc: tile ptr
get_door_tile_ptr:
	push hl
		ld b,d
		ld c,e
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
; input:
; - (ix): door type
; - de: ptr to the compressed data in case we need to decompress
; output:
; - de: ptr to the decompressed data
find_or_decompress_door:
	ld hl,door_decompression_buffer
find_or_decompress_door_find_decompressed_loop:
	ld a,(hl)
	or a
	jr z,find_or_decompress_door_not_found
	cp (ix)
	jr z,find_or_decompress_door_found
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	inc hl
	add hl,bc
	jr find_or_decompress_door_find_decompressed_loop

find_or_decompress_door_found:
	ex de,hl
	inc de
	jr find_or_decompress_door_decompressed

find_or_decompress_door_not_found:
	ex de,hl
	ld a,(ix)
	ld (de),a
	inc de
	push de
		call dzx0_standard
	pop de
find_or_decompress_door_decompressed:
	inc de
	inc de  ; skip door size in bytes
	ret
