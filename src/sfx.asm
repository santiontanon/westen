;-----------------------------------------------
; User interface sound effects

SFX_ui_move:
    db  7,#b8    ;; SFX all channels to tone
    db 10,#0b    ;; volume
    db 4,0, 5+MUSIC_CMD_TIME_STEP_FLAG,#02 ;; frequency
    db MUSIC_CMD_SKIP
    db MUSIC_CMD_SKIP
    db 10,#00    ;; silence
    db SFX_CMD_END 

SFX_ui_select:
    db  7,#b8    ;; SFX all channels to tone
    db 10,#0b    ;; volume
    db 4,#80, 5+MUSIC_CMD_TIME_STEP_FLAG,#01 ;; frequency
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#09    ;; volume

    db 10,#0b    ;; volume
    db 4,#40, 5+MUSIC_CMD_TIME_STEP_FLAG,#01 ;; frequency
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#09    ;; volume

    db 10,#0b    ;; volume
    db 4,#00, 5+MUSIC_CMD_TIME_STEP_FLAG,#01 ;; frequency
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#09    ;; volume

    db 10,#0b    ;; volume
    db 4,#80, 5+MUSIC_CMD_TIME_STEP_FLAG,#00 ;; frequency
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#09    ;; volume
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#08    ;; volume
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#06    ;; volume
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#05    ;; volume
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#03    ;; volume
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#02    ;; volume
    db MUSIC_CMD_SKIP
    db 10,#00    ;; silence
    db SFX_CMD_END    

; SFX_ui_wrong:
;     db  7,#b8    ;; SFX all channels to tone
;     db 10,#0b    ;; volume
;     db 4,0, 5+MUSIC_CMD_TIME_STEP_FLAG,#01 ;; frequency
;     db MUSIC_CMD_SKIP
;     db MUSIC_CMD_SKIP
;     db 5+MUSIC_CMD_TIME_STEP_FLAG,#04 ;; frequency
;     db MUSIC_CMD_SKIP
;     db MUSIC_CMD_SKIP
;     db MUSIC_CMD_SKIP
;     db MUSIC_CMD_SKIP
;     db 10,#00    ;; silence
;     db SFX_CMD_END 


;-----------------------------------------------
; in-game sound effects

SFX_jump:
  db 7,#b8    ;; SFX all channels to tone
  db 10,#0c    ;; volume
  db 4,#00, 5,#02 ;; frequency
  db MUSIC_CMD_SKIP
  db 4,#08, 5,#01 ;; frequency
  db MUSIC_CMD_SKIP
  db 4,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db 4,#c0, 5,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db 10,#00    ;; silence
  db SFX_CMD_END   


SFX_playerhit:
  db 7,#b8    ;; SFX all channels to tone
  db 10,#0f    ;; volume
  db 4,#00, 5,#08 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 5,#04 ;; frequency
  db MUSIC_CMD_SKIP
  db 5,#02 ;; frequency
  db MUSIC_CMD_SKIP
  db 5,#01 ;; frequency
  db MUSIC_CMD_SKIP
  db 4,#80, 5, #00 ;; frequency
  db MUSIC_CMD_SKIP
  db 4,#40 ;; frequency
  db MUSIC_CMD_SKIP
  db 4,#20 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#00    ;; silence
  db SFX_CMD_END   


SFX_door_open:
  db  7,#b8    ;; SFX all channels to tone
  db 10,#0f    ;; volume
  db 4,#00, 5,#06 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#0e    ;; volume
  db 4,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#0d    ;; volume
  db 4,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#0c    ;; volume
  db 4,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#0b    ;; volume
  db 4,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#0a    ;; volume
  db 4,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#08    ;; volume
  db 4,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#07    ;; volume
  db 4,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#06    ;; volume
  db 4,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#05    ;; volume
  db 4,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#04    ;; volume
  db 4,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db 10,#00    ;; silence
  db SFX_CMD_END  


SFX_explosion:   
  db  7,#9c    ;; noise in channel C, and tone in channels B and A
  db 10,#0f    ;; volume
  db  6+MUSIC_CMD_TIME_STEP_FLAG,#10    ;; noise frequency
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db  6,#14    ;; noise frequency
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#0c    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db  6,#18    ;; noise frequency
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#09    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db  6,#1c    ;; noise frequency
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#06    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db  6,#1f    ;; noise frequency
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#03    ;; volume
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db 10,#00    ;; silence
  db 7, #b8   ;; tone in all three channels
  db SFX_CMD_END   


; SFX_weapon_bullet:
;   db 7, #b8   ;; tone in all three channels
;   db 10,#08   ;; volume
;   db 5, #03, 4+MUSIC_CMD_TIME_STEP_FLAG, #00
;   db 5, #02
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#0b    ;; volume
;   db 5, #01
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#09    ;; volume
;   db 5, #00, 4, #c0
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#07    ;; volume
;   db MUSIC_CMD_SKIP
;   db 4, #a0
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#05    ;; volume
;   db MUSIC_CMD_SKIP
;   db 4, #80
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#03    ;; volume
;   db MUSIC_CMD_SKIP
;   db 10,#00    ;; silence
;   db SFX_CMD_END


; SFX_weapon_flame_bullet:
;   db  7,#9c    ;; noise in channel C, and tone in channels B and A
;   db 10,#04    ;; volume
;   db  6+MUSIC_CMD_TIME_STEP_FLAG,#10    ;; noise frequency
;   db MUSIC_CMD_SKIP
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#08    ;; volume
;   db MUSIC_CMD_SKIP
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#0a    ;; volume
;   db MUSIC_CMD_SKIP
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#0c    ;; volume
;   db MUSIC_CMD_SKIP
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#0a    ;; volume
;   db MUSIC_CMD_SKIP
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#08    ;; volume
;   db MUSIC_CMD_SKIP
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#04    ;; volume
;   db MUSIC_CMD_SKIP
;   db 10,#00    ;; silence
;   db 7, #b8   ;; tone in all three channels
;   db SFX_CMD_END


; SFX_weapon_flame:
;   db  7,#9c    ;; noise in channel C, and tone in channels B and A
;   db 10,#0a    ;; volume
;   db  6+MUSIC_CMD_TIME_STEP_FLAG,#10    ;; noise frequency
;   db MUSIC_CMD_SKIP
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#0c    ;; volume
;   db MUSIC_CMD_SKIP
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#0a    ;; volume
;   db MUSIC_CMD_SKIP
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#08    ;; volume
;   db MUSIC_CMD_SKIP
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#04    ;; volume
;   db MUSIC_CMD_SKIP
;   db 10,#00    ;; silence
;   db 7, #b8   ;; tone in all three channels
;   db SFX_CMD_END


; SFX_weapon_laser_bullet:
;   db 7, #b8   ;; tone in all three channels
;   db 10,#1f   ;; volume set to modulation
;   db 11, #08, 12, #00 ; envelope period
;   db 13, #0a  ; envelope shape
;   db 5, #00
;   db 4, #20
;   db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
;   db 4, #40
;   db 11+MUSIC_CMD_TIME_STEP_FLAG, #0a
;   db MUSIC_CMD_SKIP
;   db 4, #60
;   db 11+MUSIC_CMD_TIME_STEP_FLAG, #0c
;   db MUSIC_CMD_SKIP
;   db 4, #80
;   db 11+MUSIC_CMD_TIME_STEP_FLAG, #10
;   db MUSIC_CMD_SKIP
; ;   db 4, #c0
; ;   db 11+MUSIC_CMD_TIME_STEP_FLAG, #14
; ;   db MUSIC_CMD_SKIP
; ;   db 5, #01
; ;   db 11+MUSIC_CMD_TIME_STEP_FLAG, #18
; ;   db MUSIC_CMD_SKIP
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#0a   ;; volume 
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#08   ;; volume 
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#06   ;; volume 
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#00   ;; silence
;   db SFX_CMD_END


; SFX_weapon_laser:
;   db 7, #b8   ;; tone in all three channels
;   db 10,#1f   ;; volume set to modulation
;   db 11, #08, 12, #00 ; envelope period
;   db 13, #0a  ; envelope shape
;   db 5, #03, 4, #20
;   db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
;   db 4, #40
;   db 11+MUSIC_CMD_TIME_STEP_FLAG, #0a
;   db MUSIC_CMD_SKIP
;   db 4, #60
;   db 11+MUSIC_CMD_TIME_STEP_FLAG, #0c
;   db MUSIC_CMD_SKIP
;   db 4, #c0
;   db 11+MUSIC_CMD_TIME_STEP_FLAG, #10
;   db MUSIC_CMD_SKIP
;   db 5, #04, 4, #00
;   db 11+MUSIC_CMD_TIME_STEP_FLAG, #14
;   db MUSIC_CMD_SKIP
;   db MUSIC_CMD_SKIP
;   db MUSIC_CMD_SKIP
;   db MUSIC_CMD_SKIP
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#0a   ;; volume 
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#08   ;; volume 
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#06   ;; volume 
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#00   ;; silence
;   db SFX_CMD_END


SFX_enemy_hit:
  db 7, #b8   ;; tone in all three channels
  db 10,#0d   ;; volume
  db 5, #01, 4+MUSIC_CMD_TIME_STEP_FLAG, #b0
  db 5+MUSIC_CMD_TIME_STEP_FLAG, #02
  db 5+MUSIC_CMD_TIME_STEP_FLAG, #03
  db 5+MUSIC_CMD_TIME_STEP_FLAG, #04
  db 5+MUSIC_CMD_TIME_STEP_FLAG, #05
  db 5+MUSIC_CMD_TIME_STEP_FLAG, #06
  db 10,#0a   ;; volume
  db 5+MUSIC_CMD_TIME_STEP_FLAG, #01
  db 5+MUSIC_CMD_TIME_STEP_FLAG, #02
  db 5+MUSIC_CMD_TIME_STEP_FLAG, #03
  db 5+MUSIC_CMD_TIME_STEP_FLAG, #04
  db 5+MUSIC_CMD_TIME_STEP_FLAG, #05
  db 5+MUSIC_CMD_TIME_STEP_FLAG, #06
  db 10,#06   ;; volume
  db 5+MUSIC_CMD_TIME_STEP_FLAG, #01
  db 5+MUSIC_CMD_TIME_STEP_FLAG, #02
  db 5+MUSIC_CMD_TIME_STEP_FLAG, #03
  db 5+MUSIC_CMD_TIME_STEP_FLAG, #04
  db 5+MUSIC_CMD_TIME_STEP_FLAG, #05
  db 5+MUSIC_CMD_TIME_STEP_FLAG, #06
  db 10,#00    ;; silence
  db SFX_CMD_END


; SFX_power_capsule:
;   db 7, #b8   ;; tone in all three channels
;   db 10,#0d   ;; volume
;   db 5, #04, 4+MUSIC_CMD_TIME_STEP_FLAG, #00
;   db MUSIC_CMD_SKIP
;   db MUSIC_CMD_SKIP
;   db MUSIC_CMD_SKIP
;   db 4,#80,5+MUSIC_CMD_TIME_STEP_FLAG, #03
;   db 4+MUSIC_CMD_TIME_STEP_FLAG, #00
;   db 4,#80,5+MUSIC_CMD_TIME_STEP_FLAG, #02
;   db 4+MUSIC_CMD_TIME_STEP_FLAG, #00
;   db 4,#80,5+MUSIC_CMD_TIME_STEP_FLAG, #01
;   db 4+MUSIC_CMD_TIME_STEP_FLAG, #00
;   db 10,#00    ;; silence
;   db SFX_CMD_END


; SFX_weapon_select:
;   db 7, #b8   ;; tone in all three channels
;   db 10,#0d   ;; volume
;   db 5, #02, 4+MUSIC_CMD_TIME_STEP_FLAG, #00
;   db MUSIC_CMD_SKIP
;   db MUSIC_CMD_SKIP
;   db 4,#c0,5+MUSIC_CMD_TIME_STEP_FLAG, #01
;   db 4+MUSIC_CMD_TIME_STEP_FLAG, #80
;   db 4+MUSIC_CMD_TIME_STEP_FLAG, #40
;   db 4+MUSIC_CMD_TIME_STEP_FLAG, #00
;   db 4,#c0,5+MUSIC_CMD_TIME_STEP_FLAG, #00
;   db 4+MUSIC_CMD_TIME_STEP_FLAG, #80
;   db 4+MUSIC_CMD_TIME_STEP_FLAG, #40
;   db 10,#00    ;; silence
;   db SFX_CMD_END


; SFX_moai_laser:
;   db 7, #b8   ;; tone in all three channels
;   db 10,#1f   ;; volume set to modulation
;   db 11, #08, 12, #00 ; envelope period
;   db 13, #0a  ; envelope shape
;   db 5, #00, 4, #40
;   db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
;   db 4, #60
;   db 11+MUSIC_CMD_TIME_STEP_FLAG, #0a
;   db MUSIC_CMD_SKIP
;   db 4, #80
;   db 11+MUSIC_CMD_TIME_STEP_FLAG, #0c
;   db MUSIC_CMD_SKIP
;   db 5, #01, 4, #00
;   db 11+MUSIC_CMD_TIME_STEP_FLAG, #10
;   db MUSIC_CMD_SKIP
;   db 4, #80
;   db 11+MUSIC_CMD_TIME_STEP_FLAG, #14
;   db MUSIC_CMD_SKIP
;   db 5, #01, 4, #00
;   db 11+MUSIC_CMD_TIME_STEP_FLAG, #18
;   db MUSIC_CMD_SKIP
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#0a   ;; volume 
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#08   ;; volume 
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#06   ;; volume 
;   db 10+MUSIC_CMD_TIME_STEP_FLAG,#00   ;; silence
;   db SFX_CMD_END


; SFX_destroyable_wall:
;   db 7, #b8   ;; tone in all three channels
;   db 10,#0d   ;; volume
;   db 5, #00, 4+MUSIC_CMD_TIME_STEP_FLAG, #b0
;   db 5+MUSIC_CMD_TIME_STEP_FLAG, #01
;   db 5+MUSIC_CMD_TIME_STEP_FLAG, #02
;   db 5+MUSIC_CMD_TIME_STEP_FLAG, #03
;   db 5+MUSIC_CMD_TIME_STEP_FLAG, #04
;   db 5+MUSIC_CMD_TIME_STEP_FLAG, #05
;   db 10,#0a   ;; volume
;   db 5+MUSIC_CMD_TIME_STEP_FLAG, #00
;   db 5+MUSIC_CMD_TIME_STEP_FLAG, #01
;   db 5+MUSIC_CMD_TIME_STEP_FLAG, #02
;   db 5+MUSIC_CMD_TIME_STEP_FLAG, #03
;   db 5+MUSIC_CMD_TIME_STEP_FLAG, #04
;   db 5+MUSIC_CMD_TIME_STEP_FLAG, #05
;   db 10,#06   ;; volume
;   db 5+MUSIC_CMD_TIME_STEP_FLAG, #00
;   db 5+MUSIC_CMD_TIME_STEP_FLAG, #01
;   db 5+MUSIC_CMD_TIME_STEP_FLAG, #02
;   db 5+MUSIC_CMD_TIME_STEP_FLAG, #03
;   db 5+MUSIC_CMD_TIME_STEP_FLAG, #04
;   db 5+MUSIC_CMD_TIME_STEP_FLAG, #05
;   db 10,#00    ;; silence
;   db SFX_CMD_END


;-----------------------------------------------
; Sound effects used for the percussion in the songs
SFX_drum_shorter_re:
    db  7,#98    ;; noise in channel C, and tone in channels B and A
    db 10,#0a    ;; volume
    db 5, 2, 4, #fa ;; RE3
    db  6+MUSIC_CMD_TIME_STEP_FLAG,#18    ;; noise frequency
    db 5, #03, 4, #20
    db  7+MUSIC_CMD_TIME_STEP_FLAG,#b8
    db 10,#06
    db 4+MUSIC_CMD_TIME_STEP_FLAG,#40
    db 4+MUSIC_CMD_TIME_STEP_FLAG,#60
    db 10,#04
    db 4+MUSIC_CMD_TIME_STEP_FLAG,#80
    db 4+MUSIC_CMD_TIME_STEP_FLAG,#a0
    db 10,#00         ;; channel 3 volume to silence
    db 7,#b8          ;; SFX all channels to tone
    db SFX_CMD_END  

;-----------------------------------------------
; Sound effects used for the percussion in the songs
SFX_drum_short_re:
    db  7,#98    ;; noise in channel C, and tone in channels B and A
    db 10,#0b    ;; volume
    db 5, 2, 4, #fa ;; RE3
    db  6+MUSIC_CMD_TIME_STEP_FLAG,#18    ;; noise frequency
    ;db MUSIC_CMD_SKIP
    db 5, #03, 4, #20
    db  7+MUSIC_CMD_TIME_STEP_FLAG,#b8
    db 10,#09
    db 4+MUSIC_CMD_TIME_STEP_FLAG,#40
    db 4+MUSIC_CMD_TIME_STEP_FLAG,#60
    db 10,#07
    db 4+MUSIC_CMD_TIME_STEP_FLAG,#80
    db 4+MUSIC_CMD_TIME_STEP_FLAG,#a0
    db 10,#05
    db 4+MUSIC_CMD_TIME_STEP_FLAG,#c0
    db 4+MUSIC_CMD_TIME_STEP_FLAG,#e0
    db 10,#00         ;; channel 3 volume to silence
    db 7,#b8          ;; SFX all channels to tone
    db SFX_CMD_END 

; SFX_drum_long_re:
;     db  7,#98    ;; noise in channel C, and tone in channels B and A
;     db 10,#0c    ;; volume to envelope
; ;    db 5, 5, 4, 244 ;; RE2
;     db 5, 2, 4, 259 ;; RE3
; ;    db 10,#10    ;; volume to envelope
; ;    db 11,#08, 12, #00
; ;    db 13, #0e
;     db  6+MUSIC_CMD_TIME_STEP_FLAG,#1f    ;; noise frequency
;     db MUSIC_CMD_SKIP
;     db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
;     db 10+MUSIC_CMD_TIME_STEP_FLAG,#0a    ;; volume to envelope
;     db MUSIC_CMD_SKIP
;     db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
;     db 10+MUSIC_CMD_TIME_STEP_FLAG,#08    ;; volume to envelope
;     db MUSIC_CMD_SKIP
;     db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
;     db 10+MUSIC_CMD_TIME_STEP_FLAG,#06    ;; volume to envelope
;     db MUSIC_CMD_SKIP
;     db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
;     db  7,#b8    ;; SFX all channels to tone
;     db 10,#00         ;; channel 3 volume to silence
;     db SFX_CMD_END     

SFX_open_hi_hat:
    db  7,#9c    ;; noise in channel C, and tone in channels B and A
    db 10,#0c    ;; volume
    db  6+MUSIC_CMD_TIME_STEP_FLAG,#01    ;; noise frequency
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#09    ;; volume
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#07    ;; volume
    db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
    db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
    db  7,#b8    ;; SFX all channels to tone
    db 10,#00         ;; channel 3 volume to silence
    db SFX_CMD_END      


SFX_short_hi_hat:
    db  7,#9c    ;; noise in channel C, and tone in channels B and A
    db 10,#0b    ;; volume
    db  6+MUSIC_CMD_TIME_STEP_FLAG,#01    ;; noise frequency
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#08    ;; volume
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#06    ;; volume
    db  7,#b8    ;; SFX all channels to tone
    db 10,#00         ;; channel 3 volume to silence
    db SFX_CMD_END    


; SFX_pedal_hi_hat:
;     db  7,#9c    ;; noise in channel C, and tone in channels B and A
;     db 10,#05    ;; volume
;     db  6+MUSIC_CMD_TIME_STEP_FLAG,#04    ;; noise frequency
;     db 10+MUSIC_CMD_TIME_STEP_FLAG,#08    ;; volume
;     db 10+MUSIC_CMD_TIME_STEP_FLAG,#0b    ;; volume
;     db  7,#b8    ;; SFX all channels to tone
;     db 10,#00         ;; channel 3 volume to silence
;     db SFX_CMD_END   
