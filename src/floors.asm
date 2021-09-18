;-----------------------------------------------
; this function sets up the grass floor for the two rooms at the beginning of the game
setup_floor_grass:
	call clear_floor
	ld hl,floor_grass_zx0
	ld de,floor_data_buffer
	call dzx0_standard

	; "grass" is made out of two stripes:
	ld hl,room_x
	ld de,buffer1024+1020
	ld bc,4
	ldir

	ld hl,room_height
	ld a,(hl)
	cp 12
	jr z,setup_floor_grass_room1
	ld (hl),12
	ld hl,room_x
	dec (hl)
	dec (hl)
	inc hl
	inc (hl)

setup_floor_grass_room1:

	ld hl,room_width
	ld (hl),4
	call setup_floor_blue_tiles_generic

	ld hl,room_x
	ld a,(hl)
	add a,8
	ld (hl),a
	inc hl
	ld a,(hl)
	add a,4
	ld (hl),a
	call setup_floor_blue_tiles_generic

	ld hl,buffer1024+1020
	ld de,room_x
	ld bc,4
	ldir
	ret


;-----------------------------------------------
setup_floor_wood:
	call clear_floor
	ld hl,floor_wood_zx0
	ld de,floor_data_buffer
	call dzx0_standard
	jr setup_floor_blue_tiles_generic


;-----------------------------------------------
setup_floor_blue_tiles_frame:
	call clear_floor
	ld hl,floor_blue_tiles_border_zx0
	ld de,floor_data_buffer
	call dzx0_standard
; 	jr setup_floor_blue_tiles_generic


;-----------------------------------------------
setup_floor_blue_tiles_generic:
	ld hl,background_tile_ptrs
	ld bc,32+SCREEN_HEIGHT*256

setup_floor_blue_tiles_loop_y:
	push bc
setup_floor_blue_tiles_loop_x:
		push bc
			push hl
;                 int tile = 8-(((j+start_x-1) + ((i+start_y-19)%2)*2)%4);
				ld a,(room_x)
				dec a
				add a,c  ; c+(room_x)-1
				ld e,a
				ld a,(room_y)
				add a, -19
				add a, b
				and #01
				add a, a  ; ((b+(room_y)-19)%2)*2
				add a, e
				and #03
				add a, -8
				neg
				ld ixl,a

;                 int isox = ((32-j)-start_x)+((19-i)-start_y)*2;
				ld a,(room_x)
				add a,c
				add a, -32
				neg
				ld e,a
				ld a,(room_y)
				add a,b
				add a, -SCREEN_HEIGHT
				neg
				add a,a
				add a,e
				ld iyl,a

;                 int isoy = ((19-i)-start_y)*2 - ((32-j)-start_x);
				ld a,(room_x)
				add a,c
				add a, -32
				neg
				ld e,a  ; e = 32 - ()
				ld a,(room_y)
				add a,b
				add a, -SCREEN_HEIGHT
				neg
				add a,a
				sub e
				ld iyh,a

;                 if (isox  < -2) tile = 0;
				ld a,iyl
				cp -2
				jp p,setup_floor_blue_tiles_loop_x_skip1
setup_floor_blue_tiles_loop_x_zero:
			pop hl
			inc hl
			inc hl
			jr setup_floor_blue_tiles_loop_x_post_assign
setup_floor_blue_tiles_loop_x_skip1:
;                 if (isox == -1) tile = 2;
				inc a
				jr nz,setup_floor_blue_tiles_loop_x_skip2
				ld ixl,2
setup_floor_blue_tiles_loop_x_skip2:
;                 if (isox == -2) tile = 1;
				inc a
				jr nz,setup_floor_blue_tiles_loop_x_skip3
				ld ixl,1
setup_floor_blue_tiles_loop_x_skip3:

;                 if (isox >= width*4) tile = 0;
				ld a,(room_width)
				add a,a
				ld e,a
				ld a,iyl
				sub e
				jp p,setup_floor_blue_tiles_loop_x_zero

;                 if (isox == width*4-1) tile = 12;
				inc a
				jr nz,setup_floor_blue_tiles_loop_x_skip5
				ld ixl,12
setup_floor_blue_tiles_loop_x_skip5:

;                 if (isox == width*4-2) tile = 11;
				inc a
				jr nz,setup_floor_blue_tiles_loop_x_skip6
				ld ixl,11
setup_floor_blue_tiles_loop_x_skip6:

;                 if (isoy <  -1) tile = 0;
				ld a,iyh
				cp -1
				jp m,setup_floor_blue_tiles_loop_x_zero
;                 if (isoy ==  0 && tile != 0) tile = 3;
				or a
				jr nz,setup_floor_blue_tiles_loop_x_skip8
				ld ixl,3
setup_floor_blue_tiles_loop_x_skip8:
;                 if (isoy == -1 && tile != 0) tile = 4;
				inc a
				jr nz,setup_floor_blue_tiles_loop_x_skip9
				ld ixl,4
setup_floor_blue_tiles_loop_x_skip9:

;                 if (isoy > height*4) tile = 0;
				ld a,(room_height)
				add a,a
				inc a
				ld e,a
				ld a,iyh
				sub e
				jp p,setup_floor_blue_tiles_loop_x_zero

;                 if (isoy == height*4 && tile != 0) tile = 9;
				inc a
				jr nz,setup_floor_blue_tiles_loop_x_skip11
				ld ixl,9
setup_floor_blue_tiles_loop_x_skip11:

;                 if (isoy == height*4-1 && tile != 0) tile = 10;
				inc a
				jr nz,setup_floor_blue_tiles_loop_x_skip12
				ld ixl,10
setup_floor_blue_tiles_loop_x_skip12:

setup_floor_blue_tiles_loop_x_assign:
;                 map[32-j][19-i] = tile;
				ld a,ixl
				ld h,0
				ld l,a
				add hl,hl
				add hl,hl
				add hl,hl
				add hl,hl
				ld bc,floor_data_buffer
				add hl,bc
				ex de,hl
			pop hl
			ld (hl),e
			inc hl
			ld (hl),d
			inc hl
setup_floor_blue_tiles_loop_x_post_assign:
		pop bc
		dec c
		jp nz,setup_floor_blue_tiles_loop_x
	pop bc
	dec b
	jp nz,setup_floor_blue_tiles_loop_y
	ret



;-----------------------------------------------
clear_floor:
	ld hl,background_tile_ptrs
	ld de,floor_data_buffer
	ld bc,32*SCREEN_HEIGHT
clear_floor_loop:
	ld (hl),e
	inc hl
	ld (hl),d
	inc hl
	dec bc
	ld a,b
	or c
	jr nz,clear_floor_loop
	ret

