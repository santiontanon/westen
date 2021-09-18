/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package util.zx0;

import java.io.File;
import java.io.FileInputStream;
import java.util.List;

/**
 *
 * @author santi
 * 
 * This code is a translation from the ZX0 compressor by Einar Saukas to Java
 * Translation by Santiago Ontañón
 */
public class ZX0 {
    public static final int MAX_OFFSET_ZX0 = 32640;
    public static final int MAX_OFFSET_ZX7 = 2176;
    public static final int MAX_OFFSET_QUICK = 1024;
    public static final int INITIAL_OFFSET = 1;

    
    public static byte[] compress(byte input_data[], int skip, int max_offset) throws Exception 
    { 
        Compressor c = new Compressor();
        Optimizer o = new Optimizer();
        
        BLOCK optimal = o.optimize(input_data, skip, max_offset);
        byte output_data[] = c.compress(optimal, input_data, skip, false);

        return output_data;
    }
    
    
    public static int sizeOfCompressedBuffer(List<Integer> input_data_list, int max_offset) 
    {
        byte input_data[] = new byte[input_data_list.size()];
        for(int i = 0;i<input_data.length;i++) {
            input_data[i] = (byte)(int)input_data_list.get(i);
        }
        Compressor c = new Compressor();
        Optimizer o = new Optimizer();
        
        BLOCK optimal = o.optimize(input_data, 0, max_offset);
        byte output_data[] = c.compress(optimal, input_data, 0, false);

        return output_data.length;
    }

}
