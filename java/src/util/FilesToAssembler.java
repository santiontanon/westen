/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

import java.io.DataInputStream;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author santi
 */
public class FilesToAssembler {
    
    public static void main(String args[]) throws Exception {
        convertBinaryFileToAssembler("/Users/santi/Dropbox/Brain/8bit-programming/MSX/talesofpopolon/uncompressed/map1.plt", 16);
        convertBinaryFileToAssembler("/Users/santi/Dropbox/Brain/8bit-programming/MSX/talesofpopolon/uncompressed/map2.plt", 16);
        convertBinaryFileToAssembler("/Users/santi/Dropbox/Brain/8bit-programming/MSX/talesofpopolon/uncompressed/map-tunnel1.plt", 16);
/*
        convertBinaryFileToAssembler("/Users/santi/Dropbox/Brain/8bit-programming/MSX/talesofpopolon/uncompressed/title-sprites.plt", 16);

        convertBinaryFileToAssembler("/Users/santi/Dropbox/Brain/8bit-programming/MSX/talesofpopolon/uncompressed/story.plt", 16);

        convertBinaryFileToAssembler("/Users/santi/Dropbox/Brain/8bit-programming/MSX/talesofpopolon/uncompressed/ToPStorySong.plt", 16);
        convertBinaryFileToAssembler("/Users/santi/Dropbox/Brain/8bit-programming/MSX/talesofpopolon/uncompressed/ToPInGameSong.plt", 16);
        convertBinaryFileToAssembler("/Users/santi/Dropbox/Brain/8bit-programming/MSX/talesofpopolon/uncompressed/ToPBossSong.plt", 16);
        convertBinaryFileToAssembler("/Users/santi/Dropbox/Brain/8bit-programming/MSX/talesofpopolon/uncompressed/ToPStartSong.plt", 16);
        convertBinaryFileToAssembler("/Users/santi/Dropbox/Brain/8bit-programming/MSX/talesofpopolon/uncompressed/ToPGameOverSong.plt", 16);
*/
        convertBinaryFileToAssembler("/Users/santi/Dropbox/Brain/8bit-programming/MSX/talesofpopolon/uncompressed/textures.plt", 16);
    }
    
    
    public static String toHex8bit(int value) {
        char table[] = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
        return "#" + table[value/16] + table[value%16];
    }
    
    
    public static void convertBinaryFileToAssembler(String path, int bytesPerLine) throws Exception
    {
        DataInputStream is = new DataInputStream(new FileInputStream(path));
        
        List<Integer> l = new ArrayList<>();
        while(is.available()>0) {
            l.add((is.readByte() & 0xff));
        }
        
        System.out.println("; File: " + path);
        System.out.println("; bytes read " + l.size());
        for(int i = 0;i<l.size();i++) {
            if ((i%bytesPerLine)==0) {
                System.out.print("    db ");
            }
            System.out.print(toHex8bit(l.get(i)));
            if ((i%bytesPerLine)==bytesPerLine-1 || i==l.size()-1) {
                System.out.println("");
            } else {
                System.out.print(", ");
            }
        }
    }    
}
