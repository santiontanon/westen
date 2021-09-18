;-----------------------------------------------
draw_hud:
    ld hl,hud_zx0_page1
    ld de,buffer1024
    call decompress_from_page1

	; draw base hud background:
	ld ix, buffer1024 + 32*2  ; start of the name table of the hud
	ld de, CHRTBL2 + 32*8 * 19
	ld bc,32+5*256
	call draw_hud_chunk_from_hud

	call draw_hud_vit_time_already_decompressed

	call hud_draw_messages
	jp hud_update_inventory


;-----------------------------------------------
draw_hud_vit_time:
    ld hl,hud_zx0_page1
    ld de,buffer1024
    call decompress_from_page1
draw_hud_vit_time_already_decompressed:
	; draw current time/day:
	; day:
	ld ix, buffer1024  ; start of the name table of the hud
	ld de, CHRTBL2 + 32*8 * 17 + 25*8
	ld bc,2+2*256
	call draw_hud_chunk_from_hud

	; comma:
	ld ix, buffer1024 + 2  ; start of the name table of the hud
	ld de, CHRTBL2 + 32*8 * 17 + 29*8
	ld bc,1+2*256
	call draw_hud_chunk_from_hud

	call draw_hud_time_day

	; draw vitality base tiles:
	; draw vitality:
	ld ix, buffer1024 + 17 ; start of the name table of the hud
	ld de, CHRTBL2 + 32*8 * 17 + 0*8
	ld bc,2+2*256
	call draw_hud_chunk_from_hud

	ld b, MAX_HEALTH
	ld ix, buffer1024 + 19 ; start of the name table of the hud
	ld de, CHRTBL2 + 32*8 * 17 + 3*8
draw_hud_health_loop:
	push ix
	push bc
		push de
			ld bc,1+2*256
			call draw_hud_chunk_from_hud
		pop hl
		ld bc,8
		add hl,bc
		ex de,hl
	pop bc
	pop ix
	djnz draw_hud_health_loop

	; hide all the health tiles:
	xor a
	ld hl,CLRTBL2 + 32*8 * 17 + 3*8
	ld bc,MAX_HEALTH*8
	call fast_FILVRM

	xor a
	ld hl,CLRTBL2 + 32*8 * 18 + 3*8
	ld bc,MAX_HEALTH*8
	call fast_FILVRM

	jp hud_update_health


;-----------------------------------------------
; input:
; - c: desired time_day
; output:
; - nc: already updated
; - c: updated
update_time_day_if_needed:
	ld a,(game_time_day)
	cp c
	ret nc
	ld a,c
	ld (game_time_day),a

    ld hl,hud_zx0_page1
    ld de,buffer1024
    call decompress_from_page1
 	call draw_hud_time_day
 	scf
 	ret


;-----------------------------------------------
draw_hud_time_day:
	; #
	ld a,(game_time_day)
	srl a
	ld ix, buffer1024 + 7  ; start of the name table of the hud
	ld b,0
	ld c,a
	add ix,bc
	ld de, CHRTBL2 + 32*8 * 17 + 28*8
	ld bc,1+2*256
	call draw_hud_chunk_from_hud

	; am/pm:
	ld a,(game_time_day)
	and #01
	jr nz,draw_hud_pm
draw_hud_am:
	ld ix, buffer1024 + 5  ; start of the name table of the hud
	jr draw_hud_am_pm_set
draw_hud_pm:
	ld ix, buffer1024 + 3  ; start of the name table of the hud
draw_hud_am_pm_set:
	ld de, CHRTBL2 + 32*8 * 17 + 30*8
	ld bc,2+2*256
	jp draw_hud_chunk_from_hud


;-----------------------------------------------
hud_update_health:
	ld hl, CLRTBL2 + 32*8 * 17 + 3*8
	ld a,(player_health)
	or a
	jr z,hud_update_health_zero_health1
	ld b,a
hud_update_health_loop1:
	push bc
		push hl
			ld a,COLOR_DARK_RED*16
			ld bc,8
			call fast_FILVRM
		pop hl
		ld bc,32*8
		add hl,bc
		push hl
			ld a,COLOR_DARK_RED*16
			ld bc,8
			call fast_FILVRM
		pop hl
		ld bc,-31*8
		add hl,bc
	pop bc
	djnz hud_update_health_loop1
hud_update_health_zero_health1:

	ld a,(player_max_health)
	push hl
		ld hl,player_health
		sub (hl)
	pop hl
	ret z
	ld b,a
hud_update_health_loop2:
	push bc
		push hl
			ld a,COLOR_DARK_BLUE*16
			ld bc,8
			call fast_FILVRM
		pop hl
		ld bc,32*8
		add hl,bc
		push hl
			ld a,COLOR_DARK_BLUE*16
			ld bc,8
			call fast_FILVRM
		pop hl
		ld bc,-31*8
		add hl,bc
	pop bc
	djnz hud_update_health_loop2
	ret


;-----------------------------------------------
update_hud_messages_appear:
	ld hl,hud_message_timer
	dec (hl)

	; hl = CLRTBL2 + (23*32 + 32 - (hud_message_timer))*8
	ld a,32
	sub (hl)
	ld h,0
	ld l,a
	add hl,hl
	add hl,hl
	add hl,hl
	ld bc, 23*32*8 + CLRTBL2
	add hl,bc
	; draw red cursor:
	ld a,(hud_message_timer)
	or a
	jr z,update_hud_messages_appear_no_red
	ld a,COLOR_BLACK*16 + COLOR_RED
	ld bc,8
	push hl
		call fast_FILVRM
	pop hl

update_hud_messages_appear_no_red:
	; turn it to yellow:
	ld a,(hud_message_timer)
	cp 19
	ret z
	ld bc,-8
	add hl,bc
	ld a,COLOR_BLACK*16 + COLOR_DARK_YELLOW
	ld bc,8
	jp fast_FILVRM


;-----------------------------------------------
update_hud_messages:
	ld a,(hud_message_timer)
	or a
	jr nz,update_hud_messages_appear

	ld hl,hud_message_queue_size
	ld a,(hl)
	or a
	ret z

	dec (hl)
	ld hl,hud_message_queue
	ld c,(hl)
	inc hl
	ld b,(hl)
	push bc
		inc hl
		ld de,hud_message_queue
		ld bc,(HUD_MESSAGE_QUEUE_SIZE - 1) * 2
		ldir
	pop bc
	; jp hud_add_message


;-----------------------------------------------
; input:
; - bc: text bank and text idx
hud_add_message:
	ld hl,hud_message_timer
	ld (hl),20
	push bc
		ld hl,hud_messages+2
		ld de,hud_messages
		ld bc,(MAX_HUD_MESSAGES-1)*2
		ldir
	pop bc
	inc c
	ld (hud_messages+(MAX_HUD_MESSAGES-1)*2),bc
	; jp hud_draw_messages


;-----------------------------------------------
hud_draw_messages:
	ld hl,hud_messages
	ld b,MAX_HUD_MESSAGES
	ld de,CHRTBL2+(20*32+13)*8
hud_draw_messages_loop:
	push bc
		ld a,(hl)
		or a
		jr z,hud_draw_messages_empty
		ld c,a
		dec c
		inc hl
		push hl
		push de
			ld a,b
			dec a
			jr z,hud_draw_messages_loop_last
hud_draw_messages_loop_not_last:
			ld iyl, COLOR_BLACK*16 + COLOR_DARK_YELLOW + #8000
			jr hud_draw_messages_loop_color_set
hud_draw_messages_loop_last:
			ld a,(hud_message_timer)
			or a
			jr z,hud_draw_messages_loop_not_last
			ld iyl, COLOR_DARK_YELLOW*16 + COLOR_DARK_YELLOW + #8000
hud_draw_messages_loop_color_set:
			ld b,19*8
			ld a,(hl)
			call draw_text_from_bank
		pop de
		pop hl
hud_draw_messages_loop_continue:		
		inc hl
		ex de,hl
			ld bc,32*8
			add hl,bc
		ex de,hl		
	pop bc
	djnz hud_draw_messages_loop
	ret

hud_draw_messages_empty:
	push hl
	push de
		push de
			call clear_text_rendering_buffer
		pop de
		ld a, COLOR_BLACK*16 + COLOR_DARK_YELLOW + #8000
		ld bc,18*8
		call render_text_draw_buffer
	pop de
	pop hl
	inc hl
	jr hud_draw_messages_loop_continue


;-----------------------------------------------
hud_update_inventory:
	ld a,#ff
	ld (last_decompressed_inventory_bank),a

	; draw inventory:
	ld hl,inventory
	ld b,INVENTORY_SIZE
	ld de,CHRTBL2 + (19*32)*8
hud_update_inventory_loop:
	push bc
		ld a,(hl)
		inc hl
		push hl
			or a
			jr z,hud_update_inventory_empty
			dec a

			; decompress the correct bank:
			ld c,a
			rrca
			rrca
			rrca
			rrca
			and #0f
			ld hl,last_decompressed_inventory_bank
			cp (hl)
			jr z,hud_update_inventory_loop_bank_decompressed
			; decompress the bank:
			push de
			push bc
				ld (hl),a
				add a,a
				ld hl,inventory_tiles_ptrs
				ADD_HL_A
				ld e,(hl)
				inc hl
				ld d,(hl)
				ex de,hl
				ld de,buffer1024
				call dzx0_standard
			pop bc
			pop de
hud_update_inventory_loop_bank_decompressed:
			ld a,c
			and #0f  ; there are only 16 inventory gfx per bank
			ld h,0
			ld l,a
			add hl,hl
			add hl,hl
			add hl,hl
			add hl,hl
			add hl,hl
			add hl,hl
			ld bc,buffer1024
			add hl,bc
			call hud_update_inventory_draw_item
hud_update_inventory_drawn:
		pop hl

		; next position to draw:
		ex de,hl
			ld bc,INVENTORY_SLOT_WIDTH
			add hl,bc
		ex de,hl
	pop bc
	ld a,b
	cp (INVENTORY_SIZE/2)+1
	jr nz,hud_update_inventory_loop_continue
	; next inventory line:
	push bc
		ex de,hl
			ld bc,(20 + 64)*8
			add hl,bc
		ex de,hl
	pop bc
hud_update_inventory_loop_continue:
	djnz hud_update_inventory_loop

hud_update_inventory_only_sprite:
	; pointer position:
	; x: (inventory_selected)*24
	ld a,(inventory_selected)
	add a,a
	add a,a
	add a,a  ; *8
; 	ld b,a
	add a,a  ; *16
; 	add a,b  ; *24
	ld (inventory_pointer_sprite_attributes+1),a

	; y: 19*8-1 or 22*8-1
	ld a,(inventory_selected)
	cp INVENTORY_SIZE/2
	jr nc,hud_update_inventory_row2
	ld a,19*8-1
	jr hud_update_inventory_continue
hud_update_inventory_row2:
	ld hl,inventory_pointer_sprite_attributes + 1
	ld a,(hl)
	add a, -INVENTORY_SLOT_WIDTH * (INVENTORY_SIZE/2)
	ld (hl),a 
	ld a,22*8-1
hud_update_inventory_continue:
	ld (inventory_pointer_sprite_attributes),a

	ld hl,inventory_pointer_sprite_attributes
	ld de,SPRATR2+6*4
	ld bc,4
	jp fast_LDIRVM	


hud_update_inventory_empty:
	push hl
	push de
		ex de,hl
		push hl
			ld bc,16
			xor a
			call fast_FILVRM
		pop hl
		ld bc,32*8
		add hl,bc
		ld bc,16
		xor a
		call fast_FILVRM
	pop de
	pop hl
	jr hud_update_inventory_drawn


hud_update_inventory_draw_item:
	push hl
	push de
		push hl
			push de
				call draw_tile_bitmap_mode
			pop hl
			ld bc,8
			add hl,bc
			ex de,hl
		pop hl
		ld c,16
		add hl,bc

		push hl
			push de
				call draw_tile_bitmap_mode
			pop hl
			ld bc,31*8
			add hl,bc
			ex de,hl
		pop hl
		ld c,16
		add hl,bc

		push hl
			push de
				call draw_tile_bitmap_mode
			pop hl
			ld bc,8
			add hl,bc
			ex de,hl
		pop hl
		ld c,16
		add hl,bc

		call draw_tile_bitmap_mode
	pop de
	pop hl
	ret


;-----------------------------------------------
; input:
; - ix: name table
; - iy: name table width
; - de: ptr to draw to 
; - c: width
; - b: height
; - (draw_hud_chunk_tile_ptr) ptr where the tile data starts
draw_hud_chunk_from_hud:
	ld iy,32
	ld hl,buffer1024+32*7
	ld (draw_hud_chunk_tile_ptr),hl
draw_hud_chunk:
draw_hud_loop_y:
	push bc
		ld b,c
		push ix
			push de
draw_hud_loop_x:
			push bc
				ld a,(ix)
				inc ix

				; hl = (buffer1024+32*7) + a*16
				add a,a
				ld h,0
				ld l,a
				add hl,hl
				add hl,hl
				add hl,hl
				ld bc,(draw_hud_chunk_tile_ptr)
				add hl,bc

				push de
					call draw_tile_bitmap_mode
				pop hl
				ld bc,8
				add hl,bc
				ex de,hl
			pop bc
			djnz draw_hud_loop_x
			pop hl
			ld bc,32*8
			add hl,bc
			ex de,hl
		pop ix
		push iy
		pop bc
		add ix,bc
	pop bc
	djnz draw_hud_loop_y
	ret


;-----------------------------------------------
clean_inventory_of_room_objects_stool:
	ld (hl),0
	ld c,1
	jr clean_inventory_of_room_objects_loop_continue


;-----------------------------------------------
clean_inventory_of_room_objects:
	ld hl,inventory
	ld bc,INVENTORY_SIZE*256
clean_inventory_of_room_objects_loop:
	ld a,(hl)
	dec a  ; cp INVENTORY_STOOL
	jr z,clean_inventory_of_room_objects_stool
clean_inventory_of_room_objects_loop_continue:
	inc hl
	djnz clean_inventory_of_room_objects_loop
	ld a,c
	or a
	ret z
	; add message about leaving stools behind:
	ld bc,TEXT_DROP_STOOLS_BANK + 256*TEXT_DROP_STOOLS_IDX
; 	jp queue_hud_message


;-----------------------------------------------
; input:
; - bc: text bank and text idx
queue_hud_message:
	ld a,(hud_message_queue_size)
	cp HUD_MESSAGE_QUEUE_SIZE
	ret z

	ld hl,hud_message_queue
	ld d,0
	ld e,a
	add hl,de
	add hl,de
	ld (hl),c
	inc hl
	ld (hl),b
	ld hl,hud_message_queue_size
	inc (hl)
	ret


;-----------------------------------------------
wait_for_space_updating_messages:
	halt
	call update_hud_messages
	call update_keyboard_buffers
	ld a,(keyboard_line_clicks+KEY_BUTTON1_BYTE)
	bit KEY_BUTTON1_BIT,a
	jr z,wait_for_space_updating_messages
	ret


;-----------------------------------------------
wait_for_space:
	halt
	call update_keyboard_buffers
	ld a,(keyboard_line_clicks+KEY_BUTTON1_BYTE)
	bit KEY_BUTTON1_BIT,a
	jr z,wait_for_space
	ret


;-----------------------------------------------
render_letter_text:
render_letter_text_loop:
    push af
        ld a,(hl)
        inc hl
        ld c,(hl)
        inc hl
        push bc
        push hl
            push de
                cp #ff
                call nz,draw_text_from_bank
            pop hl
            ld bc,32*8
            add hl,bc
            ex de,hl
        pop hl
        pop bc
    pop af
    dec a
    jr nz,render_letter_text_loop
    ret


;-----------------------------------------------
; waits for "c" seconds, or for pressing space
; input:
; - c: # seconds to wait
; return:
; - z: exit by timeout
; - nz: exit by pressing space/button1
state_intro_pause:
state_intro_pause_loop1:
	ld b,50
state_intro_pause_loop2:
	halt
	push bc
    	call update_keyboard_buffers
    pop bc
    ld a,(keyboard_line_clicks+KEY_BUTTON1_BYTE)
    bit KEY_BUTTON1_BIT,a
    ret nz
    djnz state_intro_pause_loop2
    dec c
    jr nz,state_intro_pause_loop1
    ret


