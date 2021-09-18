/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package music;

/**
 *
 * @author santi
 */
public class MSXNote {
    public static final int MAX_VOLUME = 15;
    
    public static final int CLEAR_TRANSPOSE = -6;
    public static final int TRANSPOSE_UP = -5;
    public static final int END_REPEAT = -4;
    public static final int START_REPEAT = -3;
    public static final int SFX = -2;
    public static final int SILENCE = -1;
    
    public static final int DO = 0;
    public static final int DO_SHARP = 1;
    public static final int RE_FLAT = 1;
    public static final int RE = 2;
    public static final int RE_SHARP = 3;
    public static final int MI_FLAT = 3;
    public static final int MI = 4;
    public static final int FA = 5;
    public static final int FA_SHARP = 6;
    public static final int SOL_FLAT = 6;
    public static final int SOL = 7;
    public static final int SOL_SHARP = 8;
    public static final int LA_FLAT = 8;
    public static final int LA = 9;
    public static final int LA_SHARP = 10;
    public static final int SI_FLAT = 10;
    public static final int SI = 11;
    
    public static final int INSTRUMENT_SQUARE_WAVE = 0;
    public static final int INSTRUMENT_PIANO = 1;
    public static final int INSTRUMENT_WIND = 2;
    public static final int INSTRUMENT_PIANO_SOFT = 3;
    public static final int INSTRUMENT_WIND_SOFT = 4;
    public static final int INSTRUMENT_PIANO_FREQUENCY_VIBRATION = 5;
    public static final int INSTRUMENT_PIANO_STACCATO = 6;
    public static final int INSTRUMENT_WIND_FADING = 7;
    public static final int INSTRUMENT_PAD = 8;
    public static final int INSTRUMENT_FADE = 9;
    public static final int INSTRUMENT_SHORTWIND = 10;
    
    
    public static final String instrumentNames[] = {
                            "MUSIC_INSTRUMENT_SQUARE_WAVE",
                            "MUSIC_INSTRUMENT_PIANO", 
                            "MUSIC_INSTRUMENT_WIND",
                            "MUSIC_INSTRUMENT_PIANO_SOFT",
                            "MUSIC_INSTRUMENT_WIND_SOFT",
                            "",
                            "",
                            "",
                            "MUSIC_INSTRUMENT_PAD",
                        };
    
    public static double PSG_Master_Frequency = 111861; // Hz (in MSX)
//    public static double PSG_Master_Frequency = 62500; // Hz (in CPC)
    public static double noteFrequencies[] = {
                            // some old songs assume this first line doesn't exist:
                            // do0:
                            16.351, 17.324, 18.354, 19.445, 20.601, 21.827, 23.124, 24.499, 25.906, 27.500, 29.135, 30.867,
                            // do1:
                            32.703, 34.648, 36.708, 38.891, 41.203, 43.654, 46.249, 48.999, 51.913, 55.000, 58.270, 61.735,
                            // do2:
                            65.406, 69.296, 73.416, 77.782, 82.407, 87.307, 92.499, 97.999, 103.83, 110.00, 116.54, 123.47,
                            // do3:
                            130.81, 138.59, 146.83, 155.56, 164.81, 174.61, 185, 196, 207.65, 220.00, 233.08, 246.94,
                            // do4:
                            261.63, 277.18, 293.67, 311.13, 329.63, 349.23, 369.99, 392.00, 415.30, 440.00, 466.16, 493.88,
                            // do5:
                            523.25, 554.37, 587.33, 622.25, 659.26, 698.46, 739.99, 783.99, 830.61, 880, 932.33, 987.77,
                            // do6:
                            1046.5, 1108.7, 1174.7, 1244.5, 1318.5, 1396.9, 1480.0, 1568.0, 1661.2, 1760.0, 1864.7, 1975.5,
                            // do7:
                            2093.0, 2217.5, 2349.3, 2489.0, 2637.0, 2793.0, 2960.0, 3136.0, 3322.4, 3520.0, 3729.3, 3951.1,
                            // do8:
                            4186.0    
                            };    
    
    public int absoluteNote;
    public int volume;
    public int duration;
    public int parameter;
    public int instrument;
    public String sfx = null;
    
    
    public MSXNote(MSXNote n)
    {
        absoluteNote = n.absoluteNote;
        volume = n.volume;
        duration = n.duration;
        parameter = n.parameter;
        instrument = n.instrument;
        sfx = n.sfx;
    }
    
    
    // for actual notes:
    public MSXNote(int octave, int note, int a_volume, int a_duration, int a_instrument) {
        absoluteNote = octave*12 + note;
        volume = a_volume;
        duration = a_duration;
        instrument = a_instrument;
    }

    
    // for actual notes:
    public MSXNote(int octave, int note, int a_volume, int a_duration) {
        absoluteNote = octave*12 + note;
        volume = a_volume;
        duration = a_duration;
        instrument = INSTRUMENT_SQUARE_WAVE;
    }

    
    // for silences:
    public MSXNote(int a_duration) {
        absoluteNote = SILENCE;
        volume = 0;
        instrument = INSTRUMENT_SQUARE_WAVE;
        duration = a_duration;
    }    

    // for commands:
    public MSXNote(int a_command, int a_parameter) {
        absoluteNote = a_command;
        volume = a_parameter;
        instrument = 0;
        duration = 0;
    }    
    
    
    // for SFX:
    public MSXNote(String a_sfx, int a_duration) {
        absoluteNote = SFX;
        volume = MAX_VOLUME;
        instrument = INSTRUMENT_SQUARE_WAVE;
        duration = a_duration;
        sfx = a_sfx;
    }    


    public static int PSGNotePeriod(int note)
    {
        double desiredFrequency = noteFrequencies[note];
        int period = (int)Math.round(PSG_Master_Frequency/desiredFrequency);
        return period;
    }

}
