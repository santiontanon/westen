;-----------------------------------------------
; Sound related constants:
; instrument codes are the indexes of their first byte in the profile
MUSIC_INSTRUMENT_SQUARE_WAVE:   equ 0
MUSIC_INSTRUMENT_PIANO:         equ 1 
MUSIC_INSTRUMENT_PIANO_SOFT:    equ 15 
MUSIC_INSTRUMENT_PAD:			equ 29

SFX_PRIORITY_MUSIC:				equ 1	; this is the lowest priority
SFX_PRIORITY_LOW:				equ 2
SFX_PRIORITY_HIGH:				equ 3

MUSIC_CMD_FLAG:					equ #80
MUSIC_CMD_TIME_STEP_FLAG:		equ #40

MUSIC_CMD_SKIP:             	equ #00+MUSIC_CMD_FLAG
MUSIC_CMD_SET_INSTRUMENT:       equ #01+MUSIC_CMD_FLAG
MUSIC_CMD_PLAY_INSTRUMENT_CH1:  equ #02+MUSIC_CMD_FLAG
MUSIC_CMD_PLAY_INSTRUMENT_CH2:  equ #03+MUSIC_CMD_FLAG
MUSIC_CMD_PLAY_INSTRUMENT_CH3:  equ #04+MUSIC_CMD_FLAG
MUSIC_CMD_PLAY_SFX_OPEN_HIHAT:  equ #05+MUSIC_CMD_FLAG
MUSIC_CMD_PLAY_SFX_SHORT_HIHAT: equ #06+MUSIC_CMD_FLAG
MUSIC_CMD_PLAY_SFX_DRUM_SHORT_RE: equ #07+MUSIC_CMD_FLAG
MUSIC_CMD_PLAY_SFX_DRUM_SHORTER_RE: equ #08+MUSIC_CMD_FLAG
MUSIC_CMD_GOTO:             	equ #09+MUSIC_CMD_FLAG
MUSIC_CMD_REPEAT:           	equ #0a+MUSIC_CMD_FLAG
MUSIC_CMD_END_REPEAT:       	equ #0b+MUSIC_CMD_FLAG
MUSIC_CMD_TRANSPOSE_UP:			equ #0c+MUSIC_CMD_FLAG
MUSIC_CMD_CLEAR_TRANSPOSE:		equ #0d+MUSIC_CMD_FLAG
MUSIC_CMD_END:                	equ #0e+MUSIC_CMD_FLAG
SFX_CMD_END:                	equ #0f+MUSIC_CMD_FLAG



