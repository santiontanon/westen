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
public class BLOCK {
    public BLOCK chain = null, ghost_chain = null;
    public int bits, index, offset, length, references;
    
    
    public String toString()
    {
        return "BLOCK(" + bits + ", " + index + ", " + offset + ", " + length + ", " + references + ", chain" + 
                (chain == null ? "=null":"!=null") + ", ghost_chain" + (ghost_chain == null ? "=null":"!=null") + ")";
    }
}
