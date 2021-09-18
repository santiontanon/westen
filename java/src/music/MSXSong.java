/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package music;

import java.io.PrintStream;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author santi
 */
public class MSXSong {
    public static final int N_CHANNELS = 3;
    
    public List<MSXNote> channels[];
    public int loopBackTime = -1;
    
    public MSXSong() {
        channels = new List[N_CHANNELS];
        for(int i = 0;i<N_CHANNELS;i++) {
            channels[i] = new ArrayList<>();
        }
    }


    public MSXSong(MSXSong s) {
        channels = new List[N_CHANNELS];
        for(int i = 0;i<N_CHANNELS;i++) {
            channels[i] = new ArrayList<>();
            for(MSXNote n:s.channels[i]) {
                channels[i].add(new MSXNote(n));
            }
        }
    }
    
    
    public void addNote(MSXNote note, int channel) {
        channels[channel].add(note);
    }
    
    
    public int channelLength(int channel) {
        int l = 0;
        for(MSXNote n:channels[channel]) {
            l+=n.duration;
        }
        return l;
    }
    
    
    public int getNextIndex(int channel) {
        return channels[channel].size();
    }
    
    
    public void transpose(int shift) {
        for(int i = 0;i<3;i++) {
            for(MSXNote n:channels[i]) {
                if (n.absoluteNote >= 0) n.absoluteNote+=shift;
            }
        }
    }
    
    
    public void convertToAssembler(String songName, List<Integer> notesUsed, PrintStream w) throws Exception
    {
        convertToAssembler(songName, notesUsed, "  include \"../constants.asm\"", w);
    }
    

    public void convertToAssembler(String songName, List<Integer> notesUsed, String constantsInclude, PrintStream w) throws Exception
    {
        int instrument[] = new int[N_CHANNELS];
        int index[] = new int[N_CHANNELS];
        int channelTime[] = new int[N_CHANNELS];
        int currentTime = 0;
        boolean loopBackPrinted = false;
        List<String> lines = new ArrayList<>();
        
        for(int i = 0;i<N_CHANNELS;i++) {
            instrument[i] = MSXNote.INSTRUMENT_SQUARE_WAVE;
            index[i] = 0;
            channelTime[i] = 0;
        }
        currentTime = 0;
        
        lines.add(constantsInclude);
        lines.add("  org #0000");
        lines.add(songName + ":");
        lines.add("  db 7,184");   // set all three channels to wave
        
        boolean repeatStart = false;
        while(true) {
            boolean done = true;
            boolean advanceTime = true;
            if (currentTime == loopBackTime && !loopBackPrinted) {
                lines.add(songName + "_loop:");
                loopBackPrinted = true;
            }
            for(int i = 0;i<N_CHANNELS;i++) {
                if (index[i]<channels[i].size()) {
                    done = false;
                    if (currentTime >= channelTime[i]) {
                        // channel note:
                        MSXNote note = channels[i].get(index[i]);
                        index[i]++;
                        
                        if (note.absoluteNote==-1) {
                            // silence:
                            if (instrument[i] != MSXNote.INSTRUMENT_SQUARE_WAVE) {
                                lines.add("  db MUSIC_CMD_SET_INSTRUMENT, MUSIC_INSTRUMENT_SQUARE_WAVE, " + i);
                                instrument[i] = MSXNote.INSTRUMENT_SQUARE_WAVE;
                            }
                            lines.add("  db " + (8+i) + ", 0");
                            channelTime[i] += note.duration;
                        } else if (note.absoluteNote == MSXNote.SFX) {
//                            lines.add("  db MUSIC_CMD_PLAY_SFX" + note.sfx);                            
                            if (note.sfx.equals("SFX_PEDAL_HIHAT")) {
                                lines.add("  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT");                            
                            } else if (note.sfx.toLowerCase().equals("sfx_open_hihat")) {
                                lines.add("  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT");
                            } else if (note.sfx.equals("sfx_drum_short_re")) {
                                lines.add("  db MUSIC_CMD_PLAY_SFX_DRUM_SHORT_RE");
                            } else if (note.sfx.equals("sfx_drum_shorter_re")) {
                                lines.add("  db MUSIC_CMD_PLAY_SFX_DRUM_SHORTER_RE");
                            } else if (note.sfx.equals("sfx_short_hihat")) {
                                lines.add("  db MUSIC_CMD_PLAY_SFX_SHORT_HIHAT");
                            } else {
                                throw new Exception("Unsupported SFX!:" + note.sfx);
                            }
                            channelTime[i] += note.duration;
                        } else if (note.absoluteNote == MSXNote.START_REPEAT) {
                            lines.add("  db MUSIC_CMD_REPEAT, " + note.volume);
                            advanceTime = false;
                            break;
                        } else if (note.absoluteNote == MSXNote.END_REPEAT) {
                            lines.add("  db MUSIC_CMD_END_REPEAT");
                            advanceTime = false;
                            repeatStart = true;
                            break;
                        } else if (note.absoluteNote == MSXNote.CLEAR_TRANSPOSE) {
                            lines.add("  db MUSIC_CMD_CLEAR_TRANSPOSE");
                            advanceTime = false;
                        } else if (note.absoluteNote == MSXNote.TRANSPOSE_UP) {
                            lines.add("  db MUSIC_CMD_TRANSPOSE_UP");
                            advanceTime = false;
                        } else {
                            // We also include the instruments in repeat starts, just in case:
                            if (instrument[i] != note.instrument || repeatStart) {
                                if (note.instrument>=MSXNote.instrumentNames.length) {
                                    System.out.println("WFT?!");
                                }
                                lines.add("  db MUSIC_CMD_SET_INSTRUMENT, " + MSXNote.instrumentNames[note.instrument] + ", " + i);
                                instrument[i] = note.instrument;
                            }  
//                            int period = MSXNote.PSGNotePeriod(note.absoluteNote); 
//                            lines.add("  db MUSIC_CMD_PLAY_INSTRUMENT_CH" + (i+1) + ", " + (period/256) + ", " + (period%256));
                            lines.add("  db MUSIC_CMD_PLAY_INSTRUMENT_CH" + (i+1) + ", " + notesUsed.indexOf(note.absoluteNote));
                            channelTime[i] += note.duration;
                        }
                    }
                } else {
                    if (currentTime < channelTime[i]) done = false;
                }
            }
            if (done) break;
            if (advanceTime) {
                lines.add("  db MUSIC_CMD_SKIP");
                currentTime++;
                repeatStart = false;
            }
        }
        if (loopBackTime==-1) {
            lines.add("  db MUSIC_CMD_END");
        } else {
            lines.add("  db MUSIC_CMD_GOTO");
            lines.add("  dw (" + songName + "_loop - " + songName + ")");
        }
        
        // optimize lines:
        for(int i = 0;i<lines.size();i++) {
            if (lines.get(i).equals("  db MUSIC_CMD_SKIP")) {
                String previous = lines.get(i-1);
                if (previous.endsWith("MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT")) {
                    lines.set(i-1, "  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG");
                    lines.remove(i);
                    i--;
                } else if (previous.endsWith("MUSIC_CMD_PLAY_SFX_OPEN_HIHAT")) {
                    lines.set(i-1, "  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG");
                    lines.remove(i);
                    i--;
                } else if (previous.contains("MUSIC_CMD_PLAY_INSTRUMENT_CH1,")) {
                    lines.set(i-1, previous.replace("MUSIC_CMD_PLAY_INSTRUMENT_CH1", "MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG"));
                    lines.remove(i);
                    i--;
                } else if (previous.contains("MUSIC_CMD_PLAY_INSTRUMENT_CH2,")) {
                    lines.set(i-1, previous.replace("MUSIC_CMD_PLAY_INSTRUMENT_CH2", "MUSIC_CMD_PLAY_INSTRUMENT_CH2 + MUSIC_CMD_TIME_STEP_FLAG"));
                    lines.remove(i);
                    i--;
                } else if (previous.contains("MUSIC_CMD_PLAY_INSTRUMENT_CH3,")) {
                    lines.set(i-1, previous.replace("MUSIC_CMD_PLAY_INSTRUMENT_CH3", "MUSIC_CMD_PLAY_INSTRUMENT_CH3 + MUSIC_CMD_TIME_STEP_FLAG"));
                    lines.remove(i);
                    i--;
                }
            }
        }
        
        
        // write lines:
        for(String line:lines) w.println(line);
        
        System.out.println("Channel times: " + channelTime[0] + ", " + channelTime[1] + ", " + channelTime[2]);
    }    
    
    
    public void generateWavFile(String fileName, int tempo) throws Exception
    {
        MSXSongWavGenerator.generateWavFile(fileName, tempo, this);
    }
    
    
    public void findNotesUsedBySong(int transposeRange, List<Integer> notes)
    {
        for(int c = 0;c<3;c++) {
            for(MSXNote n:channels[c]) {
                if (n.absoluteNote >= 0) {
                    for(int i = 0;i<=transposeRange;i++) {
                        if (!notes.contains(n.absoluteNote+i)) notes.add(n.absoluteNote+i);
                    }
                }
            }
        }
    }    
}
