/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package util.zx0;

/**
 *
 * @author santi
 */
public class Optimizer {
    public static final int QTY_BLOCKS = 2000;
    public static final int MAX_SCALE = 50;
    
    public static boolean print_output = false;

    BLOCK ghost_root = null;
    BLOCK dead_array[] = null;
    int dead_array_size = 0;
    
    public BLOCK optimize(byte input_data[], int skip, int offset_limit)
    {
        int input_size = input_data.length;
        int max_offset = offset_ceiling(input_size-1, offset_limit);
        int best_length_size;
        int bits;
        int index;
        int offset;
        int length;
        int bits2;
        int dots = 2;

        // allocate all main data structures at once 
        BLOCK last_literal[] = new BLOCK[max_offset+1];
        for(int i = 0;i<last_literal.length;i++) last_literal[i] = null;
        
        BLOCK last_match[] = new BLOCK[max_offset+1];
        for(int i = 0;i<last_match.length;i++) last_match[i] = null;
        
        BLOCK optimal[] = new BLOCK[input_size+1];
        for(int i = 0;i<optimal.length;i++) optimal[i] = null;
        
        int match_length[] = new int[max_offset+1];
        int best_length[] = new int[input_size+1];

        best_length[2] = 2;

        // start with fake block
        assign(last_match, ZX0.INITIAL_OFFSET, allocate(-1, skip-1, ZX0.INITIAL_OFFSET, 0, null));

        if (print_output) System.out.println("[");

        // process remaining bytes 
        for (index = skip; index < input_size; index++) {
            best_length_size = 2;
            max_offset = offset_ceiling(index, offset_limit);
            for (offset = 1; offset <= max_offset; offset++) {
                if (index != skip && index >= offset && input_data[index] == input_data[index-offset]) {
                    // copy from last offset 
                    if (last_literal[offset] != null) {
                        length = index-last_literal[offset].index;
                        bits = last_literal[offset].bits + 1 + elias_gamma_bits(length);
                        assign(last_match, offset, allocate(bits, index, offset, length, last_literal[offset]));
                        if (optimal[index] == null || optimal[index].bits > bits) {
                            assign(optimal, index, last_match[offset]);
                        }
                    }

                    // copy from new offset 
                    match_length[offset]++;
                    if (match_length[offset] > 1) {
                        if (best_length_size < match_length[offset]) {
                            bits = optimal[index-best_length[best_length_size]].bits + elias_gamma_bits(best_length[best_length_size]-1);
                            do {
                                best_length_size++;
                                bits2 = optimal[index-best_length_size].bits + elias_gamma_bits(best_length_size-1);
                                if (bits2 <= bits) {
                                    best_length[best_length_size] = best_length_size;
                                    bits = bits2;
                                } else {
                                    best_length[best_length_size] = best_length[best_length_size-1];
                                }
                            } while(best_length_size < match_length[offset]);
                        }
                        length = best_length[match_length[offset]];
                        bits = optimal[index-length].bits + 8 + elias_gamma_bits((offset-1)/128+1) + elias_gamma_bits(length-1);
                        if (last_match[offset] == null || last_match[offset].index != index || last_match[offset].bits > bits) {
                            assign(last_match, offset, allocate(bits, index, offset, length, optimal[index-length]));
                            if (optimal[index] == null || optimal[index].bits > bits)
                                assign(optimal, index, last_match[offset]);
                        }
                    }
                } else {
                    // copy literals 
                    match_length[offset] = 0;
                    if (last_match[offset] != null) {
                        length = index-last_match[offset].index;
                        bits = last_match[offset].bits + 1 + elias_gamma_bits(length) + length*8;
                        assign(last_literal, offset, allocate(bits, index, 0, length, last_match[offset]));
                        if (optimal[index] == null || optimal[index].bits > bits)
                            assign(optimal, index, last_literal[offset]);
                    }
                }
            }

            if (print_output && index*MAX_SCALE/input_size > dots) {
                System.out.print(".");
                dots++;
            }
        }

        if (print_output) System.out.println("]");
        return optimal[input_size-1];
    }
    
    
    public int offset_ceiling(int index, int offset_limit) {
        return index > offset_limit ? offset_limit : index < ZX0.INITIAL_OFFSET ? ZX0.INITIAL_OFFSET : index;
    }
        
    
    public BLOCK allocate(int bits, int index, int offset, int length, BLOCK chain) {
        BLOCK ptr;

        if (ghost_root != null) {
            ptr = ghost_root;
            ghost_root = ptr.ghost_chain;
            if (ptr.chain != null) {
                ptr.chain.references--;
                if (ptr.chain.references == 0) {
                    ptr.chain.ghost_chain = ghost_root;
                    ghost_root = ptr.chain;
                }
            }
        } else {
            if (dead_array_size == 0) {
                dead_array = new BLOCK[QTY_BLOCKS];
                for(int i = 0;i<QTY_BLOCKS;i++) dead_array[i] = new BLOCK();
                dead_array_size = QTY_BLOCKS;
            }
            dead_array_size--;
            ptr = dead_array[dead_array_size];
        }
        ptr.bits = bits;
        ptr.index = index;
        ptr.offset = offset;
        ptr.length = length;
        if (chain != null) {
            chain.references++;
        }
        ptr.chain = chain;
        ptr.references = 0;
        return ptr;
    }
    
    
    public void assign(BLOCK ptr[], int ptr_idx, BLOCK chain) {
        chain.references++;
        if (ptr[ptr_idx] != null) {
            ptr[ptr_idx].references--;
            if (ptr[ptr_idx].references == 0) {
                ptr[ptr_idx].ghost_chain = ghost_root;
                ghost_root = ptr[ptr_idx];
            }
        }
        ptr[ptr_idx] = chain;
    }    
    
    
    public int elias_gamma_bits(int value) {
        int bits = 1;
        while (value > 1) {
            bits += 2;
            value >>= 1;
        }
        return bits;
    }    
}
