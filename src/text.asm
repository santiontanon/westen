;-----------------------------------------------
; Decompresses a specific text sentence from a text bank
; input:
; - de: target destination of decompression
; - c: bank #
; - a: text # within the bank
; output:
; - de: pointer to copy the decompressed text to (ignored, hardcoded to text_buffer)
get_text_from_bank_reusing_bank:
	ld hl,last_decompressed_text_bank
	push af
		ld a,c
		cp (hl)
		jr z,get_text_from_bank_reusing_bank_reuse
	pop af
	jr get_text_from_bank_entry_point1

get_text_from_bank_reusing_bank_reuse:
	pop af
	jr get_text_from_bank_entry_point2


get_text_from_bank:
	; save the bank we are decompressing:
	ld hl,last_decompressed_text_bank
get_text_from_bank_entry_point1:	
	ld (hl),c

	ld hl,textBankPointers
	ld b,0
	add hl,bc
	add hl,bc
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl	; hl has the pointer of the text bank
	push af
		ld de,text_decompression_buffer
; 		call pletter_unpack
; 		call unpack_compressed
		call dzx0_standard
	pop af
get_text_from_bank_entry_point2:
	ld hl,text_decompression_buffer
get_text_from_bank_loop:
	or a
	jr z,get_text_from_bank_found
	ld b,0
	ld c,(hl)
	inc hl
	add hl,bc
	dec a
	jr get_text_from_bank_loop
get_text_from_bank_found:
	; copy the desired string to "text_buffer":
	ld de,text_buffer
	ld b,e	; text_buffer is 256-aligned, so, e == 0
	ld c,(hl)
    inc bc
	ldir
	ret


; ------------------------------------------------
; same as "draw_text_from_bank", but checks if we already have the text bank we want
; decompressed, to prevent decompressing again.
draw_text_from_bank_reusing:
	push bc
    push de
    push iy
;         ld de,text_buffer
        call get_text_from_bank_reusing_bank
        jr draw_text_from_bank_entry_point


; ------------------------------------------------
; draw_text_from_bank_slow:
; 	push bc
;     push de
;     push iy
; ;         ld de,text_buffer
;         call get_text_from_bank
;         call clear_text_rendering_buffer
;     pop iy
;     pop de
;     pop bc
;     ld hl,text_buffer
;     ld c,b
;     ld b,l  ; l == 0 here as text_buffer is 256 aligned
;     jr draw_sentence_slow


; ------------------------------------------------
clear_text_rendering_buffer:
    ld hl,text_draw_buffer
    ld bc,32*8-1
    jp clear_memory


; ------------------------------------------------
; Draws a sentence to video memory (right-to-left)
; Arguments:
; - hl: sentence to draw (first byte is the length)
; - de: target VRAM address
; - iyl: color (attribute byte)
; - iyh: pixel to start from (128 to start in pixel 0)
; - bc: expected length in bytes
; draw_sentence_reverse:
; 	push de
; 	push iy
; 	push bc
; 		ld de,text_draw_buffer
; 	    ld b,(hl)   ; get the sentence length
; 	    ld a,b
; 	    ADD_HL_A  ; move to the end of the string
; 	    ld c,iyh
; draw_sentence_reversee_loop:
; 	    push bc
; 	    push hl
; 	        ld a,(hl)
; 	        call draw_font_character
; 	        ld a,c	; we save the pixel mask
; 	    pop hl
; 	    pop bc
; 	    ld c,a

; 	    ; next character
; 	    dec hl  
; 	    djnz draw_sentence_reversee_loop
; 	pop bc
; 	pop iy
; 	pop de
; 	ld a,iyl   
; 	jp render_text_draw_buffer


; ------------------------------------------------
; input:
; - a,c: text ID (bank, idx)
; - de: address to render
; - iyl: color
; - iyh: pixel to start from (128 for starting on pixel 0)
; - b: expected length in bytes
draw_text_from_bank:
	ld iyh,128  ; start in pixel 0
draw_text_from_bank_iyh_set:
	push bc
    push de
    push iy
        call get_text_from_bank
draw_text_from_bank_entry_point:
        call clear_text_rendering_buffer
    pop iy
    pop de
    pop bc
    ld hl,text_buffer
    ld c,b
    ld b,l  ; l == 0 here as text_buffer is 256 aligned
;     jp draw_sentence
    

; ------------------------------------------------
; Draws a sentence to video memory
; Arguments:
; - hl: sentence to draw (first byte is the length)
; - de: target VRAM address
; - iyl: color (attribute byte)
; - iyh: pixel to start from (128 to start in pixel 0)
; - bc: expected length in bytes
draw_sentence:
	push de
	push iy
	push bc
		ld de,text_draw_buffer
	    ld b,(hl)   ; get the sentence length
	    inc hl
	    ld c,iyh
draw_sentence_loop:
	    push bc
	    push hl
	        ld a,(hl)
	        call draw_font_character
	        ld a,c	; we save the pixel mask
	    pop hl
	    pop bc
	    ld c,a

	    ; next character
	    inc hl  
	    djnz draw_sentence_loop
	pop bc
	pop iy
	pop de
	ld a,iyl
; 	jp render_text_draw_buffer


; ------------------------------------------------
; - de: VRAM address where to start drawing
; - a: attribute (color)
; - bc: expected length in bytes
render_text_draw_buffer:
	ld hl,text_draw_buffer
	push af
	push bc
		push de
			call fast_LDIRVM
		pop hl
		ld bc,CLRTBL2-CHRTBL2
		add hl,bc
	pop bc
	pop af
	or a
	ret z	; when the attribute is 0, it means we do not want to render color yet
	jp fast_FILVRM


; ; ------------------------------------------------
; ; - de: VRAM address where to start drawing
; ; - a: attribute (color)
; ; - bc: expected length in bytes
; render_text_draw_buffer_slow:
; 	; copy color attribute first:
; 	push de
; 	push bc
; 		ex de,hl
; 		ld de,CLRTBL2-CHRTBL2
; 		add hl,de
; 		call fast_FILVRM
; 	pop bc
; 	pop de

; 	ld hl,text_draw_buffer

; 	; we divide the # of bytes by 8:
;     srl b
;     rr c
;     srl b
;     rr c
;     srl b
;     rr c
;     ld a,c
;     push af
;     	ld bc,8
; 		call fast_LDIRVM
; 	pop af
; 	dec a
; 	ret z
; render_text_draw_buffer_slow_loop:	
; 	push af
; 		ld a,(text_skip)
; 		or a
; 		jr nz,render_text_draw_buffer_slow_loop_skip
; 		halt
; 		halt
; render_text_draw_buffer_slow_loop_skip:
; 		push hl
; 	    	call update_keyboard_buffers
; 	    pop hl
; 		; wait a few seconds and skip to the menu:
; 	    ld a,(keyboard_line_clicks)
; 		rra
; 		jp nc,render_text_draw_buffer_slow_loop_no_skip
; 	    ld a,1
; 	    ld (text_skip),a
; render_text_draw_buffer_slow_loop_no_skip:
; 		ld bc,8
; 		call copy_to_VDP
; 	pop af
; 	dec a
; 	jr nz,render_text_draw_buffer_slow_loop
; 	ret


; ------------------------------------------------
; Draws a character to video memory
; Arguments:
; - a: character to draw
; - de: memory address to draw
; - c: pixel offset (to determine whether we start in pixel 0, 1, 2, 3, 4, 5, 6, or 7 in the current tile)
;	- This is a a "mask": 1, 2, 4, 8, 16, 32, ...
draw_font_character:
    ; get the pointer to the character:
    push de
        ; for variable size fonts:
        ld d,0
        ld e,a
        ld hl,font
        add hl,de
        add hl,de
        add hl,de	; index of the letter is a*3
    pop de

    ld b,(hl)	; character size
    inc hl
draw_font_character_loop:
	push bc
	    ld b,(hl)	; column bitmap
	    inc hl

	    ; render one column of the character:
	    ld ixl,8
	    push de
draw_font_character_loop2:
		    ld a,(de)
		    sra b
		    jr nc,draw_font_character_loop_no_pixel
		    or c
		    ld (de),a
draw_font_character_loop_no_pixel:
			inc de
			dec ixl
			jr nz,draw_font_character_loop2
		pop de
    pop bc
    rrc c
    jr nc,draw_font_character_loop_no_next_tile
    push hl
    	ld hl,8
    	add hl,de
    	ex de,hl
    pop hl
draw_font_character_loop_no_next_tile:
    djnz draw_font_character_loop
    ret


; ------------------------------------------------
; input:
; - hl: name table address to start rendering
; - b: length of the text to render
; - a: first tile index to render
; draw_text_name_table_ingame:
; 	push af
; 		push bc
; 			call SETWRT
; 		pop bc
; 	    ld a,(VDP.DW)
; 	    ld c,a
; 	pop af
; draw_text_name_table_ingame_loop:
;     out (c),a
;     inc a
;     djnz draw_text_name_table_ingame_loop
; 	ret


; ------------------------------------------------
; copies an 8 byte color gradient to all the characters of
; a block of text:
text_copy_color_pattern:
	push bc
	push hl
		push de
			ld bc,8
			call fast_LDIRVM
		pop hl
		ld bc,8
		add hl,bc
		ex de,hl
	pop hl
	pop bc
	djnz text_copy_color_pattern
	ret
