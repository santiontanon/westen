;-----------------------------------------------
; a: byte
; hl: target address in the VDP
writeByteToVDP:
    push af
        call SETWRT
        ld a,(VDP.DW)
        ld c,a
    pop af
    out (c),a
    ret
    

;-----------------------------------------------
; clear sprites:
clearAllTheSprites:
    ld hl,SPRATR2
    ld a,224
    ld bc,32*4
    jp fast_FILVRM


;-----------------------------------------------
; Fills the whole screen with the pattern 0
clearScreen:
    xor a
    ld bc,768
    ld hl,NAMTBL2
;     jp fast_FILVRM
    

;-----------------------------------------------
; a: byte
; bc: amount to write
; hl: target address in the VDP
fast_FILVRM:
    push af
    push bc
        call SETWRT
        ld a,(VDP.DW)
        ld c,a
    pop de
    ld a,e
    or a
    jr z,fast_FILVRM_no_inc
    inc d
fast_FILVRM_no_inc:
    pop af
fast_FILVRM_loop2:
fast_FILVRM_loop:
    out (c),a
    dec e
    jp nz,fast_FILVRM_loop
    ;ld e,256
    dec d
    jp nz,fast_FILVRM_loop2
    ret


;-----------------------------------------------
fast_LDIRVM_preserving_ptrs:
    push hl
    push de
        call fast_LDIRVM
    pop de
    pop hl
    ret


;-----------------------------------------------
; hl: source data
; de: target address in the VDP
; bc: amount to copy
fast_LDIRVM:
    ex de,hl    ; this is wasteful, but it's to maintain the order of parameters of the original LDIRVM...
                ; For things that require real speed, this function should not be used anyway, but use specialized loops
    push de
    push bc
        call SETWRT
    pop bc
    pop hl
    ; jp copy_to_VDP

;-----------------------------------------------
; This is like LDIRVM, but faster, and assumes, we have already called "SETWRT" with the right address
; input: 
; - hl: address to copy from
; - bc: amount fo copy
copy_to_VDP:
    ld e,b
    ld a,c
    or a
    jr z,copy_to_VDP_lsb_0
    inc e
copy_to_VDP_lsb_0:
    ld b,c
    ; get the VDP write register:
    ld a,(VDP.DW)
    ld c,a
    ld a,e
copy_to_VDP_loop2:
copy_to_VDP_loop:
    outi
    jp nz,copy_to_VDP_loop
    dec a
    jp nz,copy_to_VDP_loop2
    ret


;-----------------------------------------------
; de: target address in memory
; hl: source address in the VDP
; bc: amount to copy
; fast_LDIRMV:
;     push de
;     push bc
;         call SETRD
;     pop bc
;     pop hl
;     ; jp copy_to_VDP

; ;-----------------------------------------------
; ; This is like LDIRVM, but faster, and assumes, we have already called "SETWRT" with the right address
; ; input: 
; ; - hl: address to copy from
; ; - bc: amount fo copy
; copy_from_VDP:
;     ld e,b
;     ld a,c
;     or a
;     jr z,copy_from_VDP_lsb_0
;     inc e
; copy_from_VDP_lsb_0:
;     ld b,c
;     ; get the VDP write register:
;     ld a,(VDP.DW)
;     ld c,a
;     ld a,e
; copy_from_VDP_loop2:
; copy_from_VDP_loop:
;     ini
;     jp nz,copy_from_VDP_loop
;     dec a
;     jp nz,copy_from_VDP_loop2
;     ret    


;-----------------------------------------------
; This is like copy_to_VDP, but copying less than 256 bytes, amount in "b"
; input: 
; - hl: address to copy from
; - b: amount fo copy
; copy_to_VDP_less_than_256:
;     ; get the VDP write register:
;     ld a,(VDP.DW)
;     ld c,a
; copy_to_VDP_less_than_256_loop:
;     outi
;     jp nz,copy_to_VDP_less_than_256_loop
;     ret


; faster versions, that only work if we are in vblank:
copy_to_VDP_less_than_256_duringvblank:
   ; get the VDP write register:
   ld a,(VDP.DW)
   ld c,a
copy_to_VDP_less_than_256_duringvblank_loop:
   outi
   outi
   outi
   outi
   outi
   outi
   outi
   outi
   jp nz,copy_to_VDP_less_than_256_duringvblank_loop
   ret


copy_to_VDP_duringvblank:
    ld e,b
    ld a,c
    or a
    jr z,copy_to_VDP_duringvblank_lsb_0
    inc e
copy_to_VDP_duringvblank_lsb_0:
    ld b,c
    ; get the VDP write register:
    ld a,(VDP.DW)
    ld c,a
    ld a,e
copy_to_VDP_duringvblank_loop2:
copy_to_VDP_duringvblank_loop:
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    jp nz,copy_to_VDP_duringvblank_loop
    dec a
    jp nz,copy_to_VDP_duringvblank_loop2
    ret   


;-----------------------------------------------
disable_VDP_output:
    ld a,(VDP_REGISTER_1)
    and #bf ; reset the BL bit
    di
    out (#99),a
    ld  a,1+128 ; write to register 1
    ei
    out (#99),a
    ret


;-----------------------------------------------
enable_VDP_output:
    ld a,(VDP_REGISTER_1)
    or #40  ; set the BL bit
    di
    out (#99),a
    ld  a,1+128 ; write to register 1
    ei
    out (#99),a
    ret


;-----------------------------------------------
; Clears the screen left to right
; input:
; - iyl: how many rows to clear
; clearScreenLeftToRight:
;     ld iyl,24
; clearScreenLeftToRight_iyl_rows:
;     call clearAllTheSprites
; clearScreenLeftToRight_iyl_rows_no_sprites:
;     ld a,16
;     ld bc,0
; clearScreenLeftToRightExternalLoop:
;     push af
;     push bc
;         ld a,iyl
;         ld hl,NAMTBL2
;         add hl,bc
; clearScreenLeftToRightLoop:
;         push hl
;         push af
;             xor a
;             ld bc,2
;             call fast_FILVRM
;         pop af
;         pop hl
;         ld bc,32
;         add hl,bc
;         dec a
;         jr nz,clearScreenLeftToRightLoop
;     pop bc
;     pop af
;     inc bc
;     inc bc
;     dec a
;     halt
;     jr nz,clearScreenLeftToRightExternalLoop
;     ret  

