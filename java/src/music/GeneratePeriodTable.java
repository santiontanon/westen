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
public class GeneratePeriodTable {
    public static void main(String args[]) throws Exception
    {
        /*
        System.out.print("public static double noteFrequencies[] = {");
        for(int octave = 0;octave<8;octave++) {
            // ...
        }
        */

        System.out.print("note_period_table:");
        for(int note = 0;note<60;note++) {
            int period = MSXNote.PSGNotePeriod(note); 
            if (note%12 == 0) System.out.print("\n  db ");
            System.out.print((period/256) + "," + (period%256) + ",  ");
        }
        
    }
}
