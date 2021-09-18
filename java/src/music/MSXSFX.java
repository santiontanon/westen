/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package music;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 *
 * @author santi
 */
public class MSXSFX {
    public static void main(String args[]) throws Exception {

//        List<Integer> bufferCollapse = renderSFX(convert("../SFX/collapse.afx"), 22050.0);   
//        MSXSongWavGenerator.playBuffer(bufferCollapse,6);        

/*
        List<Integer> bufferEngine = renderSFX(new String[] 
            {   "7","#38",
                "10","#08",
                "5", "#02", "4", "#00",
                "MUSIC_CMD_SKIP",
                "10","#06",
                "MUSIC_CMD_SKIP",
                "10","#0a",
                "5", "#02", "4", "#00",
                "MUSIC_CMD_SKIP",
                "10","#08",
                "MUSIC_CMD_SKIP",
                "5", "#02", "4", "#80",
                "10","#0c",
                "MUSIC_CMD_SKIP",
                "10","#09",
                "MUSIC_CMD_SKIP",
                "10","#0e",
                "5", "#03", "4", "#00",
                "MUSIC_CMD_SKIP",
                "10","#0b",
                "MUSIC_CMD_SKIP",
                "10","#0d",
                "5", "#05", "4", "#00",
                "MUSIC_CMD_SKIP",
                "10","#0a",
                "MUSIC_CMD_SKIP",
                "10","#0d",
                "5", "#07", "4", "#00",
                "MUSIC_CMD_SKIP",
                "10","#0a",
                "MUSIC_CMD_SKIP",
                "10","#0c",
                "5", "#08", "4", "#00",
                "MUSIC_CMD_SKIP",
                "10","#09",
                "MUSIC_CMD_SKIP",
                "10","#0b",
                "5", "#08", "4", "#80",
                "MUSIC_CMD_SKIP",
                "10","#08",
                "MUSIC_CMD_SKIP",
                "10","#09",
                "MUSIC_CMD_SKIP",
                "10","#07",
                "5", "#09", "4", "#00",
                "MUSIC_CMD_SKIP",
                "10","#08",
                "MUSIC_CMD_SKIP",
                "10","#06",
                "MUSIC_CMD_SKIP",
                "10","#00",
                "SFX_CMD_END"
            }, 22050.0);        
        MSXSongWavGenerator.playBuffer(bufferEngine,1);
*/
        /*
        List<Integer> bufferBrake = renderSFX(new String[] 
            {   "7","#18",
                "6" , "#04",
            
                "10","#0f",
                "5", "#00", "4", "#68",
                "MUSIC_CMD_SKIP",
                "5", "#00", "4", "#60",
                "MUSIC_CMD_SKIP",
                "10","#0d",
                "5", "#00", "4", "#68",
                "MUSIC_CMD_SKIP",
                "5", "#00", "4", "#60",
                "MUSIC_CMD_SKIP",
                
                "10","#0f",
                "5", "#00", "4", "#68",
                "MUSIC_CMD_SKIP",
                "5", "#00", "4", "#60",
                "MUSIC_CMD_SKIP",
                "10","#0d",
                "5", "#00", "4", "#68",
                "MUSIC_CMD_SKIP",
                "5", "#00", "4", "#60",
                "MUSIC_CMD_SKIP",

                "10","#0f",
                "5", "#00", "4", "#68",
                "MUSIC_CMD_SKIP",
                "5", "#00", "4", "#60",
                "MUSIC_CMD_SKIP",
                "10","#0d",
                "5", "#00", "4", "#68",
                "MUSIC_CMD_SKIP",
                "5", "#00", "4", "#60",
                "MUSIC_CMD_SKIP",
                
                "10","#0f",
                "5", "#00", "4", "#68",
                "MUSIC_CMD_SKIP",
                "5", "#00", "4", "#60",
                "MUSIC_CMD_SKIP",
                "10","#0d",
                "5", "#00", "4", "#68",
                "MUSIC_CMD_SKIP",
                "5", "#00", "4", "#60",
                "MUSIC_CMD_SKIP",
                
                "10", "#00",
                "7", "#38",
                "SFX_CMD_END"
            }, 22050.0);        
        MSXSongWavGenerator.playBuffer(bufferBrake,1);
        */
        
        /*
        List<Integer> bufferEngine = renderSFX(new String[] 
            {   "7","#38",
                "10","#0f",
                "5", "#0f", "4", "#00",
                "MUSIC_CMD_SKIP",
                "10","#0c",
                "MUSIC_CMD_SKIP",
                "10","#0f",
                "MUSIC_CMD_SKIP",
                "10","#0c",
                "MUSIC_CMD_SKIP",
                "5", "#0e", "4", "#00",
                "10","#0f",
                "MUSIC_CMD_SKIP",
                "10","#0c",
                "MUSIC_CMD_SKIP",
                "10","#0f",
                "MUSIC_CMD_SKIP",
                "10","#0c",
                "MUSIC_CMD_SKIP",
                "5", "#0d", "4", "#00",
                "10","#0f",
                "MUSIC_CMD_SKIP",
                "10","#0c",
                "MUSIC_CMD_SKIP",
                "10","#0f",
                "MUSIC_CMD_SKIP",
                "10","#0c",
                "MUSIC_CMD_SKIP",
                "5", "#0c", "4", "#00",
                "10","#0f",
                "MUSIC_CMD_SKIP",
                "10","#0c",
                "MUSIC_CMD_SKIP",
                "10","#0f",
                "MUSIC_CMD_SKIP",
                "10","#0c",
                "MUSIC_CMD_SKIP",
                "5", "#0b", "4", "#00",
                "10","#0f",
                "MUSIC_CMD_SKIP",
                "10","#0c",
                "MUSIC_CMD_SKIP",
                "10","#0f",
                "MUSIC_CMD_SKIP",
                "10","#0c",
                "MUSIC_CMD_SKIP",
                "5", "#0a", "4", "#00",
                "10","#0f",
                "MUSIC_CMD_SKIP",
                "10","#0c",
                "MUSIC_CMD_SKIP",
                "10","#0f",
                "MUSIC_CMD_SKIP",
                "10","#0c",
                "MUSIC_CMD_SKIP",
                "5", "#09", "4", "#00",
                "10","#0f",
                "MUSIC_CMD_SKIP",
                "10","#0c",
                "MUSIC_CMD_SKIP",
                "10","#0f",
                "MUSIC_CMD_SKIP",
                "10","#0c",
                "MUSIC_CMD_SKIP",
                "5", "#08", "4", "#00",
                "10","#0f",
                "MUSIC_CMD_SKIP",
                "10","#0c",
                "MUSIC_CMD_SKIP",
                "10","#0f",
                "MUSIC_CMD_SKIP",
                "10","#0c",
                "MUSIC_CMD_SKIP",
//                "5", "#07", "4", "#00",
                "10","#0f",
                "MUSIC_CMD_SKIP",
                "10","#0c",
                "MUSIC_CMD_SKIP",
                "10","#0f",
                "MUSIC_CMD_SKIP",
                "10","#0c",
                "MUSIC_CMD_SKIP",
                "10","#00",
                "SFX_CMD_END"
            }, 22050.0);        
        MSXSongWavGenerator.playBuffer(bufferEngine,1);
        */
                
        /*
        List<Integer> bufferCrash1 = renderSFX(new String[] 
            {   "7","#18",
                "10","#0f",
                "5", "#06", "4", "#00",
                "6" , "#01",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10", "#0a",
                "MUSIC_CMD_SKIP",
                "10", "#06",
                "MUSIC_CMD_SKIP",
                "10", "#00",
                "7", "#38",
                "SFX_CMD_END"
            }, 22050.0);        
        MSXSongWavGenerator.playBuffer(bufferCrash1,1);
        
        List<Integer> bufferCrash2 = renderSFX(new String[] 
            {   "7","#18",
                "10","#0f",
                "5", "#06", "4", "#00",
                "6" , "#1f",
                "MUSIC_CMD_SKIP", 
                "6" , "#1c",
                "MUSIC_CMD_SKIP",
                "6" , "#1a",
                "MUSIC_CMD_SKIP",
                "7", "#1c",
                "10", "#0c",
                "6" , "#08",
                "MUSIC_CMD_SKIP",
                "10", "#0a",
                "MUSIC_CMD_SKIP",
                "10", "#08",
                "MUSIC_CMD_SKIP",
                "10", "#06",
                "MUSIC_CMD_SKIP",
                "10", "#00",
                "7", "#38",
                "SFX_CMD_END"
            }, 22050.0);        
        MSXSongWavGenerator.playBuffer(bufferCrash2,1);
        */
        
        /*
        List<Integer> bufferSemaphore = renderSFX(new String[] 
            {   "7","#38",
                "10","#0f",
                "5", "#06", "4", "#00",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10","#0d",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10","#0c",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10","#0b",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10","#0a",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10","#00",

                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                
                "7","#38",
                "10","#0f",
                "5", "#06", "4", "#00",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10","#0d",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10","#0c",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10","#0b",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10","#0a",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10","#00",

                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",                
                
                "7","#38",
                "10","#0f",
                "5", "#02", "4", "#20",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10","#0d",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10","#0c",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10","#0b",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10","#0a",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10","#00",                
                "SFX_CMD_END",
            }, 22050.0);   
        MSXSongWavGenerator.playBuffer(bufferSemaphore,1);
        */
        
        /*
        List<Integer> bufferExplosion = renderSFX(new String[] 
            {   
                "7", "#98",         // A: tone, B: tone, C: tone+noise
                "10", "#0e",        // C volume
                "6" , "#10",        // noise freq
                "4" , "#00", "5" , "#04",        // C freq (RE)
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10", "#0c",
                "4" , "#10", "5" , "#04",        // C freq (RE)
                "6" , "#12",        // noise freq
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10", "#0c",
                "4" , "#20", "5" , "#04",        // C freq (RE)
                "6" , "#14",        // noise freq
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10", "#0a",
                "6" , "#16",        // noise freq
                "4" , "#30", "5" , "#04",        // C freq (RE)
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10", "#08",
                "6" , "#18",        // noise freq
                "4" , "#40", "5" , "#04",        // C freq (RE)
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10", "#06",
                "6" , "#1a",        // noise freq
                "4" , "#50", "5" , "#04",        // C freq (RE)
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10", "#0c",
                "6" , "#1c",        // noise freq
                "4" , "#60", "5" , "#04",        // C freq (RE)
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10", "#0a",
                "6" , "#1f",        // noise freq
                "4" , "#70", "5" , "#04",        // C freq (RE)
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10", "#08",
                "4" , "#80", "5" , "#04",        // C freq (RE)
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10", "#06",
                "4" , "#90", "5" , "#04",        // C freq (RE)
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10", "#04",
                "4" , "#a0", "5" , "#04",        // C freq (RE)
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10", "#08",
                "4" , "#b0", "5" , "#04",        // C freq (RE)
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10", "#06",
                "4" , "#c0", "5" , "#04",        // C freq (RE)
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10", "#04",
                "4" , "#d0", "5" , "#04",        // C freq (RE)
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10", "#03",
                "4" , "#e0", "5" , "#04",        // C freq (RE)
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP", "MUSIC_CMD_SKIP",
                "10", "#00",
                "7", "#b8",
                "SFX_CMD_END"
            }, 22050.0);        
        MSXSongWavGenerator.playBuffer(bufferExplosion,1);        
        
        Thread.sleep(1000);        
        */
        
        List<Integer> bufferDrum = renderSFX(new String[] 
            {   
                "7", "#98",         // A: tone, B: tone, C: tone+noise
                "10", "#0b",        // C volume
                "6" , "#18",        // noise freq
                "4" , "#fa", "5" , "#02",        // C freq (RE)
                "MUSIC_CMD_SKIP",
                "4" , "#20", "5" , "#03",
                "7", "#b8",
                "MUSIC_CMD_SKIP",
                "10", "#09",
                "4" , "#40", 
                "MUSIC_CMD_SKIP",
                "4" , "#60", 
                "MUSIC_CMD_SKIP",
                "10", "#07",
                "4" , "#80", 
                "MUSIC_CMD_SKIP",
                "4" , "#a0", 
                "MUSIC_CMD_SKIP",
                "10", "#05",
                "4" , "#c0", 
                "MUSIC_CMD_SKIP",
                "4" , "#e0", 
                "MUSIC_CMD_SKIP",
                "10", "#00",
                "SFX_CMD_END"
            }, 22050.0);        
        
        MSXSongWavGenerator.playBuffer(bufferDrum,1);
        Thread.sleep(200);
        MSXSongWavGenerator.playBuffer(bufferDrum,1);
        Thread.sleep(200);
        MSXSongWavGenerator.playBuffer(bufferDrum,1);
        Thread.sleep(600);
        
        List<Integer> bufferHiHat = renderSFX(new String[] 
            {   "7", "#1c",
                "10", "#0c",
                "6" , "#01",
                "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP",
                "10", "#0a",
                "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP",
                "10", "#08",
                "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP",
                "10", "#00",
                "7", "#38",
                "SFX_CMD_END"
            }, 22050.0);        
        MSXSongWavGenerator.playBuffer(bufferHiHat,1);
        
        Thread.sleep(500);
        
        List<Integer> bufferPedalHiHat = renderSFX(new String[] 
            {   "7", "#1c",
                "10", "#05",
                "6" , "#01",
                "MUSIC_CMD_SKIP",
                "10", "#08",
                "MUSIC_CMD_SKIP",
                "10", "#0b",
                "MUSIC_CMD_SKIP",
                "10", "#00",
                "7", "#38",
                "SFX_CMD_END"
            }, 22050.0);        
        MSXSongWavGenerator.playBuffer(bufferPedalHiHat,1);
        
        
        /*
        List<Integer> bufferArrow = renderSFX(new String[] 
            {   "7", "#1c",
                "10", "#0b",     // volume
                "6" , "#10",     // noise frequency
                "MUSIC_CMD_SKIP",
                "10", "#09",     
                "MUSIC_CMD_SKIP",
                "10", "#07",     
                "MUSIC_CMD_SKIP",
                "10", "#05",     
                "MUSIC_CMD_SKIP",
                "6", "#01",
                "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP",
                "10", "#06",     
                "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP",
                "10", "#07",     
                "MUSIC_CMD_SKIP",
                "MUSIC_CMD_SKIP",
                "10", "#00",
                "7", "#38",
                "SFX_CMD_END"
            }, 22050.0);        
        MSXSongWavGenerator.generateWavFile("tests/arrow.wav", bufferArrow);
        */
        
        
    }
    
    
    public static List<Integer> renderSFX(String commands[], double sampleRate)
    {
        Random r = new Random();
        int samplesPerMinorTick = (int)((1/50.0)*sampleRate);

        int register[] = {0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0};        
        List<Integer> buffer = new ArrayList<>();
        double factor = MSXNote.PSG_Master_Frequency/sampleRate;
        
        for(int i = 0;i<commands.length;i++) {
            if (commands[i].equals("SFX_CMD_END")) {
                break;
            } else if (commands[i].equals("MUSIC_CMD_SKIP")) {
                // render audio:
                boolean noise = false;
                boolean tone = false;
                if ((register[7] & 0x04) == 0) tone = true;
                if ((register[7] & 0x20) == 0) noise = true;
                int tonePeriod = register[5]*256 + register[4];
                int noisePeriod = (register[6] & 0x1f);
                if (noisePeriod == 0) noisePeriod = 1;
                int volume = register[10];
                if (volume >= 16) {
                    // envelope modulated:
                    // ...
                }
//                    System.out.println("noise: " + noisePeriod + "(" + volume + ")");
                int lastCycle = -1;
                boolean val = r.nextBoolean();
                for(int k = 0;k<samplesPerMinorTick;k++) {
                    int position = buffer.size();
                    int position_corrected = (int)(position*factor);
                    int cycle = position_corrected / noisePeriod;
                    if (cycle > lastCycle) val = r.nextBoolean();
                    int v = 0;
                    if (noise) {
                        if (val) {
                            v += MSXSongWavGenerator.volumeToSample(volume);
    //                            v = volume * MSXSongWavGenerator.volume_multiplier;
                        } else {
                            v -= MSXSongWavGenerator.volumeToSample(volume);
    //                            v = - volume * MSXSongWavGenerator.volume_multiplier;
                        }
                    }
                    if (tone) {
                        int offset = position_corrected % tonePeriod;
                       if (offset < tonePeriod/2) {
                            v += MSXSongWavGenerator.volumeToSample(volume);
//                            v = volume * MSXSongWavGenerator.volume_multiplier;
                        } else {
                            v -= MSXSongWavGenerator.volumeToSample(volume);
//                            v = - volume * MSXSongWavGenerator.volume_multiplier;
                        }
                    }
                    buffer.add(v);
                    lastCycle = cycle;
                }
                    
            } else {
                int reg = parseIntOrHexValue(commands[i]);
                i++;
                int value = parseIntOrHexValue(commands[i]);
                register[reg] = value;
//                System.out.println("  R" + reg + " = " + value);
            }
        }
        
        return buffer;
    }
    
    
    public static int parseIntOrHexValue(String str) 
    {
        String hex = "0123456789abcdef";
        if (str.startsWith("#")) {
            str = str.toLowerCase();
            int v = 0;
            for(int i = 1;i<str.length();i++) {
                v*=16;
                v += hex.indexOf(str.charAt(i));
            }
            return v;
        } else {
            return Integer.parseInt(str);
        }
    }
}
