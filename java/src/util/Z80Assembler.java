/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

import java.io.FileOutputStream;
import java.io.FileWriter;
import java.util.List;

/**
 *
 * @author santi
 */
public class Z80Assembler {
    
    public static String toHex8bit(int value) throws Exception {
        char table[] = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
        if (value > 255) throw new Exception("trying to convert value " + value + " to a 8bit Hex!");
        return "#" + table[value/16] + table[value%16];
    }

    public static String toHex16bit(int value, boolean hash) throws Exception {
        char table[] = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
        if (value > 65535) throw new Exception("trying to convert value " + value + " to a 16bit Hex!");
        return (hash ? "#":"") + table[value/(16*16*16)] + table[(value/(16*16))%16] + table[(value/16)%16] + table[value%16];
    }
    
    
    public static void dataBlockToAssembler(List<Integer> data, String name, FileWriter fw, int bytesPerLine) throws Exception
    {
        fw.write("; size in bytes: " + data.size() + "\n");
        fw.write(name+":\n");
        for(int i = 0;i<data.size();i++) {
            if (i%bytesPerLine == 0) fw.write("    db ");
            fw.write(toHex8bit(data.get(i)));
            if (i%bytesPerLine != (bytesPerLine-1) && i<data.size()-1) {
                fw.write(",");
            } else {
                fw.write("\n");
            }
        }
        fw.write("end_"+name+":\n");
    }        
    

    public static void twoDArrayToAssembler(int data[][], String name, FileWriter fw) throws Exception
    {
        fw.write("; size in bytes: " + data.length * data[0].length+ "\n");
        fw.write(name+":\n");
        for(int i = 0;i<data.length;i++) {
            fw.write("    db ");
            for(int j = 0;j<data[0].length;j++) {
                fw.write(toHex8bit(data[i][j]));
                if (j < data[0].length-1) {
                    fw.write(",");
                } else {
                    fw.write("\n");
                }
            }
        }
        fw.write("end_"+name+":\n");
    }     

    
    public static void dataToBinary(List<Integer> data, String fileName) throws Exception
    {
        FileOutputStream fos = new FileOutputStream(fileName);
        for(Integer v: data) {
            fos.write(v);
        }
        fos.flush();
        fos.close();
    }
}
