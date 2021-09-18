/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package util.zx0;

/**
 *
 * @author santi
 * 
 * This code is a translation from the ZX0 compressor by Einar Saukas to Java
 * Translation by Santiago Ontañón
 */
public class Compressor {
    public static boolean print_output = false;
        
    byte output_data[] = null;
    int output_index = 0;
    int input_index = 0;
    int bit_index = 0;
    int bit_mask = 0;
    int diff = 0;
    boolean backtrack = false;
    
    public byte[] compress(BLOCK optimal, byte input_data[], int skip, boolean backwards_mode)
    {
        int input_size = input_data.length;
        BLOCK next;
        BLOCK prev;
        int last_offset = ZX0.INITIAL_OFFSET;
        boolean first = true;
        int i;

        // calculate and allocate output buffer 
        int output_size = (optimal.bits+18+7)/8;
        output_data = new byte[output_size];
        
        // initialize delta 
        diff = output_size-input_size+skip;
        int delta = 0;

        // un-reverse optimal sequence 
        next = null;
        while (optimal != null) {
            prev = optimal.chain;
            optimal.chain = next;
            next = optimal;
            optimal = prev;
        }
        
        input_index = skip;
        output_index = 0;
        bit_mask = 0;

        for (optimal = next.chain; optimal != null; optimal = optimal.chain) {
            if (optimal.offset == 0) {
                // copy literals indicator 
                if (first) {
                    first = false;
                } else {
                    write_bit(false);
                }

                // copy literals length 
                write_interlaced_elias_gamma(optimal.length, backwards_mode);

                // copy literals values 
                for (i = 0; i < optimal.length; i++) {
                    write_byte(input_data[input_index]);
                    delta = read_bytes(1, delta);
                }
            } else if (optimal.offset == last_offset) {
                // copy from last offset indicator 
                write_bit(false);

                // copy from last offset length 
                write_interlaced_elias_gamma(optimal.length, backwards_mode);
                delta = read_bytes(optimal.length, delta);
            } else {
                // copy from new offset indicator 
                write_bit(true);

                // copy from new offset MSB 
                write_interlaced_elias_gamma((optimal.offset-1)/128+1, backwards_mode);

                // copy from new offset LSB 
                if (backwards_mode) {
                    write_byte((byte)(((optimal.offset-1)%128)<<1));
                } else {
                    write_byte((byte)((255-((optimal.offset-1)%128))<<1));
                }
                backtrack = true;

                // copy from new offset length 
                write_interlaced_elias_gamma(optimal.length-1, backwards_mode);
                delta = read_bytes(optimal.length, delta);

                last_offset = optimal.offset;
            }
        }

        // end marker 
        write_bit(true);
        write_interlaced_elias_gamma(256, backwards_mode);

        return output_data;        
    }
    
    
    public int read_bytes(int n, int delta) {
        input_index += n;
        diff += n;
        if (diff > delta) {
            return diff;
        }
        return delta;
    }


    public void write_byte(byte value) {
        output_data[output_index] = value;
        output_index++;
        diff--;
    } 

    
    public void write_bit(boolean value)
    {
        if (backtrack) {
            if (value) {
                output_data[output_index-1] |= 1;
            }
            backtrack = false;
        } else {
            if (bit_mask == 0) {
                bit_mask = 128;
                bit_index = output_index;
                write_byte((byte)0);
            }
            if (value) {
                output_data[bit_index] |= bit_mask;
            }
            bit_mask >>= 1;
        }        
    }
    

    public void write_interlaced_elias_gamma(int value, boolean backwards_mode) {
        int i;

        for (i = 2; i <= value; i <<= 1) {}
        
        i >>= 1;
        while ((i >>= 1) > 0) {
            write_bit(backwards_mode);
            write_bit((value & i) != 0);
        }
        write_bit(!backwards_mode);
    }    

}
