
;-----------------------------------------------
; sets the name table of the banks to: 0, 1, 2, 3, ..., 255
; and clears all patterns and attributes to 0
set_bitmap_mode:
    xor a
set_bitmap_mode_a_color:
    ld bc,8*256*3
    push bc
        ld hl,CLRTBL2
        call fast_FILVRM
        xor a
    pop bc
    ld hl,CHRTBL2
    call fast_FILVRM
    ; jp set_bitmap_name_table_all_banks


;-----------------------------------------------
; sets the name table of the banks to: 0, 1, 2, 3, ..., 255
set_bitmap_name_table_all_banks:
    ld hl,NAMTBL2
    call set_bitmap_name_table
    ld hl,NAMTBL2+256
    call set_bitmap_name_table
set_bitmap_name_table_bank3:
    ld hl,NAMTBL2+512

set_bitmap_name_table:
    call SETWRT
    ld a,(VDP.DW)
    ld c,a
    xor a
    ld b,a
set_bitmap_name_table_bank3_loop:
    out (c),a
    inc a
    djnz set_bitmap_name_table_bank3_loop
    ret


;-----------------------------------------------
; 0,8,16, ...
; 1,9,17, ...
; ...
; 7,15,23, ...
; set_vertical_bitmap_name_table_bank1:
;    ld hl,NAMTBL2+256
; set_vertical_bitmap_name_table:
;     call SETWRT
;     ld a,(VDP.DW)
;     ld c,a
;     xor a
;     ld b,a
; set_vertical_bitmap_name_table_bank3_loop:
;     out (c),a
;     add a,8
;     jr nc,set_vertical_bitmap_name_table_bank3_loop_continue
;     inc a
; set_vertical_bitmap_name_table_bank3_loop_continue:
;     djnz set_vertical_bitmap_name_table_bank3_loop
;     ret



;-----------------------------------------------
; - a: tile index
; - bc: buffer where tile data is decompressed
; - de: ptr to the tile to draw: 8 bytes for pattern + 8 bytes for attributes
; draw_tile_bitmap_mode_by_index:
;     ld h,0
;     ld l,a
;     add hl,hl
;     add hl,hl
;     add hl,hl
;     add hl,hl
;     add hl,bc
;     jp draw_tile_bitmap_mode


;-----------------------------------------------
; assuming the screen is in screen 2 bitmap mode, it draws a tile+attributes
; - hl: source ptr to the tile to draw: 8 bytes for pattern + 8 bytes for attributes
; - de: target ptr to the pattern table to draw to
draw_tile_bitmap_mode:
    push hl
        push de
            ld bc,8
            call fast_LDIRVM
        pop hl
        ld bc,CLRTBL2-CHRTBL2
        add hl,bc
        ex de,hl
    pop hl
    ld bc,8
    add hl,bc
    jp fast_LDIRVM


;-----------------------------------------------
; assuming the screen is in screen 2 bitmap mode, it draws a tile with fixed attribute value for all 8 bytes
; - hl: source ptr to the tile to draw: 8 bytes for pattern
; - de: target ptr to the pattern table to draw to
; - a: attribute
; draw_tile_bitmap_mode_fixed_attribute:
;     push af
;         push de
;             ld bc,8
;             call fast_LDIRVM
;         pop hl
;         ld bc,CLRTBL2-CHRTBL2
;         add hl,bc
;     pop af
;     ld bc,8
;     jp fast_FILVRM


;-----------------------------------------------
; input:
; - hl: ptr to clear (CLRTBL2, as we only clear the attributes)
; - b: height in tiles
; - c: width in tiles
; - a: color to clear with
clear_rectangle_bitmap_mode:
    xor a
clear_rectangle_bitmap_mode_color:
    push bc
        push hl
            ld b,0
            sla c
            sla c
            sla c
            rl b    ; we only need to do rl b in the 3rd shift, as the other two can never carry a bit
            push af
                call fast_FILVRM
            pop af
        pop hl
        ld bc,32*8
        add hl,bc
    pop bc
    djnz clear_rectangle_bitmap_mode_color
    ret


;-----------------------------------------------
clearScreenLeftToRight_bitmap:
    ld b,32
    ld hl,CLRTBL2
clearScreenLeftToRight_bitmap_loop:
    halt
    push bc
        push hl
            ld bc,#1801
            call clear_rectangle_bitmap_mode
        pop hl
        ld bc,8
        add hl,bc
    pop bc
    djnz clearScreenLeftToRight_bitmap_loop
    ret
