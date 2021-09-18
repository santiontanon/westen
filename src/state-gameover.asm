;-----------------------------------------------
state_game_over:
    ; init the stack:
    ld sp,#f380

    call StopMusic    

    call disable_VDP_output
        call clearAllTheSprites
        call set_bitmap_mode

        ld a,TEXT_GAME_OVER_IDX
        ld bc,TEXT_GAME_OVER_BANK + 8*8*256
        ld de,CHRTBL2 + (10*32 + 13)*8 
        ld iyl,COLOR_WHITE*16
        call draw_text_from_bank
    call enable_VDP_output

    ; wait for button:
    ld c,10
    call state_intro_pause
    call clearScreenLeftToRight_bitmap
    jp Execute_back_to_intro