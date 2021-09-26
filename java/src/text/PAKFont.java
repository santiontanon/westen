/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package text;

import java.awt.image.BufferedImage;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import javax.imageio.ImageIO;
import util.Pletter;
import util.Z80Assembler;
import util.ZX0Wrapper;

/**
 *
 * @author santi
 */
public class PAKFont {
    public static List<String> characters = null;
    public static List<Integer> indexes = null;
    public static List<Integer> widths = null;

    List<Integer> bytesForAssembler = null;

    public PAKFont(String a_fontFile, List<String> a_characters) throws Exception
    {        
        int index_resolution = 3;
     
        characters = a_characters;
        List<List<Integer>> data = extractFontCharacters(a_fontFile);
        indexes = new ArrayList<>();
        widths = new ArrayList<>();
        bytesForAssembler = new ArrayList<>();
        for(List<Integer> characterData:data) {
            int index = bytesForAssembler.size();
            while(index%index_resolution != 0) {
                bytesForAssembler.add(bytesForAssembler.get(index-1));
                index++;
            }
            if (index/index_resolution >= 256) throw new Exception("Font is too large!");
            indexes.add(index/index_resolution);
            widths.add(characterData.size());
            bytesForAssembler.add(characterData.size());
            bytesForAssembler.addAll(characterData);
        }
        System.out.println("PAKFont from: " + a_fontFile);
        System.out.println("    Flattened data size: " + bytesForAssembler.size());
        System.out.println("    Indexes: " + indexes);
        System.out.println("    Character widths: " + widths);
    }
    
    
    public void generateAssemblerData(String outputFileName) throws Exception
    {
//        FileWriter fw = new FileWriter(outputFileName+".asm");
//        Z80Assembler.dataBlockToAssembler(bytesForAssembler, "font", fw, 16);
//        fw.flush();
//        fw.close();
//        nl.grauw.glass.Assembler.main(new String[]{outputFileName + ".asm", outputFileName + ".bin"});
        Z80Assembler.dataToBinary(bytesForAssembler, outputFileName + ".bin");
        Pletter.intMain(new String[]{outputFileName + ".bin", outputFileName + ".plt"});
        ZX0Wrapper.main(outputFileName + ".bin", outputFileName + ".plt", true, false);
    }
    
    
    public String convertStringToAssemblerString(String sentence) throws Exception
    {
        List<Integer> data = convertStringToAssembler(sentence);
        String str = "";
        for(int i = 0;i<data.size();i++) {
            if (i!=0) str += ", ";
            str += data.get(i);
        }
        return str;
    }
    
    
    public int characterIndex(char c) {
        int index = 0;
        for(int j = 0;j<characters.size();j++) {
            int index_line = characters.get(j).indexOf(c);
            if (index_line >=0) {
                return indexes.get(index + index_line);
            }
            index += characters.get(j).length();
        }
        return -1;
    }
    
    
    public List<Integer> convertStringToAssembler(String sentence) throws Exception
    {
        List<Integer> data = new ArrayList<>();
        
        // the first byte is the sentence length
        data.add(sentence.length());
        
        for(int i = 0;i<sentence.length();i++) {
            boolean found = false;
            int index = 0;
            for(int j = 0;j<characters.size();j++) {
                int index_line = characters.get(j).indexOf(sentence.charAt(i));
                if (index_line >=0) {
                    data.add(indexes.get(index + index_line));
                    found = true;
                    break;
                }
                index += characters.get(j).length();
            }
            if (!found) throw new Exception("character '"+sentence.charAt(i)+"' in '"+sentence+"' not found!");
        }
        
        return data;
    }
    
    
    public int stringWidthInPixels(String sentence) throws Exception
    {
        int width = 0;
        for(int i = 0;i<sentence.length();i++) {
            boolean found = false;
            int index = 0;
            for(int j = 0;j<characters.size();j++) {
                int index_line = characters.get(j).indexOf(sentence.charAt(i));
                if (index_line >=0) {
                    found = true;
                    width += widths.get(index+index_line);
                    break;
                }
                index += characters.get(j).length();
            }  
            if (!found) throw new Exception("character '"+sentence.charAt(i)+"' in '"+sentence+"' not found!");
        }
        return width;
    }
    
    
    public List<List<Integer>> extractFontCharacters(String fontImageFileName) throws Exception
    {
        int dy = 8;
        BufferedImage img = ImageIO.read(new File(fontImageFileName));
        List<List<Integer>> data = new ArrayList<>();
             
        for(int i = 0;i<characters.size();i++) {
            int current_x = 0;
            for(int j = 0;j<characters.get(i).length();j++) {
                List<Integer> characterData = new ArrayList<>();
                boolean anyNonEmpty = false;
                while(current_x<img.getWidth()) {
                    int bitmap[] = extractColumnBitmap(img, current_x, i*dy, dy);
                    current_x++;
                    if (bitmap == null) {
                        // column that separates characters:
                        if (!characterData.isEmpty()) {
                            break;
                        }
                    } else {
                        int value = 0;
                        int mask = 1;
                        for(int l = 0;l<dy;l++) {
                            if (bitmap[l]!=0) value += mask;
                            mask *= 2;
                        }
                        characterData.add(value);                    
                        if (value == 0) {
                            if (anyNonEmpty) break;
                        } else {
                            anyNonEmpty = true;
                        }
                    }
                }
                if (!characterData.isEmpty()) {
                    // System.out.println(characters[i].charAt(j)+ " -> " + start + " - " + (start+characterData.size()));
                    data.add(characterData);
                }                
            }
        }
        
        return data;
    }
    
    
    public static int[] extractColumnBitmap(BufferedImage img, int x, int y, int h) throws Exception
    {
        int bitmap[] = new int[h];
        
        for(int i = 0;i<h;i++) {
            int color = img.getRGB(x, y+i);
            int r = (color & 0xff0000)>>16;
            int g = (color & 0x00ff00)>>8;
            int b = color & 0x0000ff;
            int a = (color & 0xff000000)>>24;
            if (r>0 && g==0 && b==0 &&a!=0) return null;
            if (a!=0 && r > 0 && g > 0 && b > 0) {
                bitmap[i] = 1;
            } else {
                bitmap[i] = 0;
            }
        }
        return bitmap;
    }
    
    
    public void printFontInfo()
    {
        for(String line:characters) {
            
            for(int i = 0;i<line.length();i++) {
                char c = line.charAt(i);
                System.out.println("'" + line.charAt(i) + "': " + characterIndex(c));
            }
        }
    }
    
    
    public int stringWidth(String str) throws Exception
    {
        int width = 0;
        
        for(int i = 0;i<str.length();i++) {
            boolean found = false;
            int index = 0;
            for(int j = 0;j<characters.size();j++) {
                int index_line = characters.get(j).indexOf(str.charAt(i));
                if (index_line >=0) {
                    width += widths.get(index + index_line);
                    found = true;
                    break;
                }
                index += characters.get(j).length();
            }
            if (!found) throw new Exception("character '"+str.charAt(i)+"' in '"+str+"' not found!");
        }
        
        return width;
    }
        
}
