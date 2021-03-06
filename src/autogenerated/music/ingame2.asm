  include "../../constants.asm"
  org #0000
song:
  db 7,184
song_loop:
  db MUSIC_CMD_REPEAT, 2
  db MUSIC_CMD_REPEAT, 4
  db MUSIC_CMD_SET_INSTRUMENT, MUSIC_INSTRUMENT_PIANO, 0
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 9
  db MUSIC_CMD_SET_INSTRUMENT, MUSIC_INSTRUMENT_PIANO, 1
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 34
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 28
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 9
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2 + MUSIC_CMD_TIME_STEP_FLAG, 31
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2 + MUSIC_CMD_TIME_STEP_FLAG, 28
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_END_REPEAT
  db MUSIC_CMD_REPEAT, 4
  db MUSIC_CMD_SET_INSTRUMENT, MUSIC_INSTRUMENT_PIANO, 0
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 11
  db MUSIC_CMD_SET_INSTRUMENT, MUSIC_INSTRUMENT_PIANO, 1
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 33
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 28
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 11
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2 + MUSIC_CMD_TIME_STEP_FLAG, 31
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2 + MUSIC_CMD_TIME_STEP_FLAG, 28
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_END_REPEAT
  db MUSIC_CMD_END_REPEAT
  db MUSIC_CMD_REPEAT, 2
  db MUSIC_CMD_SET_INSTRUMENT, MUSIC_INSTRUMENT_PIANO, 0
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 9
  db MUSIC_CMD_SET_INSTRUMENT, MUSIC_INSTRUMENT_PIANO, 1
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 28
  db MUSIC_CMD_PLAY_SFX_DRUM_SHORT_RE
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 9
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 9
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 9
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 5
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 31
  db MUSIC_CMD_PLAY_SFX_DRUM_SHORT_RE
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 5
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 5
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 5
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 4
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 33
  db MUSIC_CMD_PLAY_SFX_DRUM_SHORT_RE
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 4
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 4
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 4
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 4
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 34
  db MUSIC_CMD_PLAY_SFX_DRUM_SHORT_RE
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 4
  db MUSIC_CMD_SET_INSTRUMENT, MUSIC_INSTRUMENT_SQUARE_WAVE, 1
  db 9, 0
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 5
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 7
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_END_REPEAT
  db MUSIC_CMD_REPEAT, 2
  db MUSIC_CMD_SET_INSTRUMENT, MUSIC_INSTRUMENT_PIANO, 0
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 9
  db MUSIC_CMD_SET_INSTRUMENT, MUSIC_INSTRUMENT_PIANO, 1
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 34
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 38
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 34
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 5
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 33
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 5
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 5
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 5
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_END_REPEAT
  db MUSIC_CMD_REPEAT, 2
  db MUSIC_CMD_SET_INSTRUMENT, MUSIC_INSTRUMENT_PIANO, 0
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 9
  db MUSIC_CMD_SET_INSTRUMENT, MUSIC_INSTRUMENT_PIANO, 1
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 28
  db MUSIC_CMD_PLAY_SFX_DRUM_SHORT_RE
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 9
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 9
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 9
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 5
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 31
  db MUSIC_CMD_PLAY_SFX_DRUM_SHORT_RE
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 5
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 5
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 5
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 4
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 33
  db MUSIC_CMD_PLAY_SFX_DRUM_SHORT_RE
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 4
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 4
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 4
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 4
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 34
  db MUSIC_CMD_PLAY_SFX_DRUM_SHORT_RE
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 4
  db MUSIC_CMD_SET_INSTRUMENT, MUSIC_INSTRUMENT_SQUARE_WAVE, 1
  db 9, 0
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 5
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 7
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_END_REPEAT
  db MUSIC_CMD_REPEAT, 2
  db MUSIC_CMD_SET_INSTRUMENT, MUSIC_INSTRUMENT_PIANO, 0
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 9
  db MUSIC_CMD_SET_INSTRUMENT, MUSIC_INSTRUMENT_PIANO, 1
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 28
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 9
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 9
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 28
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 5
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 25
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 5
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 5
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 25
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 4
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 24
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 4
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_END_REPEAT
  db MUSIC_CMD_SET_INSTRUMENT, MUSIC_INSTRUMENT_PIANO, 0
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 9
  db MUSIC_CMD_SET_INSTRUMENT, MUSIC_INSTRUMENT_PIANO, 1
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 0
  db MUSIC_CMD_PLAY_SFX_DRUM_SHORT_RE
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 9
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 9
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 9
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 12
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 1
  db MUSIC_CMD_PLAY_SFX_DRUM_SHORT_RE
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 12
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 12
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 12
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 14
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 3
  db MUSIC_CMD_PLAY_SFX_DRUM_SHORT_RE
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 14
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 14
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 14
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 15
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 4
  db MUSIC_CMD_PLAY_SFX_DRUM_SHORT_RE
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 15
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 15
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 15
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 9
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 0
  db MUSIC_CMD_PLAY_SFX_DRUM_SHORT_RE
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 9
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 9
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 9
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 12
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 1
  db MUSIC_CMD_PLAY_SFX_DRUM_SHORT_RE
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 12
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 12
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 12
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 14
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 3
  db MUSIC_CMD_PLAY_SFX_DRUM_SHORT_RE
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 14
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 14
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 14
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 15
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 4
  db MUSIC_CMD_PLAY_SFX_DRUM_SHORT_RE
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 15
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 15
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 15
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 16
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 5
  db MUSIC_CMD_PLAY_SFX_DRUM_SHORT_RE
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 16
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 16
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 16
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 16
  db MUSIC_CMD_PLAY_SFX_DRUM_SHORT_RE
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 16
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 16
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 16
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 15
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 4
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 14
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 3
  db MUSIC_CMD_PLAY_SFX_DRUM_SHORT_RE
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 14
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 14
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 14
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 15
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 4
  db MUSIC_CMD_PLAY_SFX_DRUM_SHORT_RE
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 15
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 15
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 15
  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_GOTO
  dw (song_loop - song)
