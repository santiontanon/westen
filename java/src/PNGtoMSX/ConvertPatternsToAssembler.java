/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package PNGtoMSX;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import javax.imageio.ImageIO;

/**
 *
 * @author santi
 */
public class ConvertPatternsToAssembler {
    static int ERROR_color_count = 0;
    static int PW = 8;
    static int PH = 8;
    /*
    static public int MSX1Palette[][] = {{0,0,0},
                                    {0,0,0},
                                    {43,221,81},
                                    {81,255,118},
                                    {81,81,255},
                                    {118,118,255},
                                    {221,81,81},
                                    {81,255,255},
                                    {255,81,81},
                                    {255,118,118},
                                    {255,221,81},
                                    {255,255,118},
                                    {43,187,43},
                                    {221,81,187},
                                    {221,221,221},
                                    {255,255,255}};     */
    
    public static int MSX1Palette[][]={
                                {0,0,0},              // Transparent 0 
                                {0,0,0},              // Black 1
                                {36,219,36},          // Medium Green 2
                                {109,255,109},        // Light Green 3
                                {36,36,255},          // Dark Blue 4
                                {73,109,255},         // Light Blue 5
                                {182,36,36},          // Dark Red 6
                                {73,219,255},         // Cyan
                                {255,36,36},          // Medium Red
                                {255,109,109},        // Light Red
                                {219,219,36},         // Dark Yellow
                                {219,219,146},        // Light Yellow
                                {36,146,36},          // Dark Green
                                {219,73,182},         // Magenta
                                {182,182,182},        // Grey
                                {255,255,255}};       // White      
    
    public static void main(String args[]) throws Exception {
        String inputFile = args[0];
        File f = new File(inputFile);
        BufferedImage sourceImage = ImageIO.read(f);
        System.out.println("  org #0000");
        System.out.println("");
        System.out.println("patterns:");
        for(int i = 0;i<256;i++) {
            int x = i%16;
            int y = i/16;
            String line = generateAssemblerPatternBitmapString(x, y, sourceImage, 0);
            System.out.println(line);
        }
        System.out.println("endpatterns:");
        System.out.println("patternattributes:");
        for(int i = 0;i<256;i++) {
            int x = i%16;
            int y = i/16;
            String line = generateAssemblerPatternAttributesString(x, y, sourceImage, 0);
            System.out.println(line);
        }
        System.out.println("endpatternattributes:");
    }
    

    public static int convert(String inputFile, String outputFile, boolean saveSize) throws Exception {
        System.out.println("Converting " + inputFile);
        File f = new File(inputFile);
        BufferedImage sourceImage = ImageIO.read(f);
        FileWriter fw = new FileWriter(new File(outputFile));
        // determine the size:
        int sizeInBytes = 256*8;    // 8 bytes per pattern

        fw.write("    org #0000\n\n");
        if (saveSize) {
            fw.write("; patterns_length:\n");
            fw.write(";     dw " + sizeInBytes + "\n");
        }
        fw.write("patterns:\n");
        for(int i = 0;i<256;i++) {
            int x = i%16;
            int y = i/16;
            String line = generateAssemblerPatternBitmapString(x,y,sourceImage, 0);
            if (line != null) {
                fw.write(line + "\n");
            } else {
                fw.write("    db 0,0,0,0,0,0,0,0");
            }
        }
        fw.write("patternattributes:\n");
        for(int i = 0;i<256;i++) {
            int x = i%16;
            int y = i/16;
            String line = generateAssemblerPatternAttributesString(x,y,sourceImage, 0);
            if (line != null) {
                fw.write(line + "\n");
            } else {
                fw.write("    db 0,0,0,0,0,0,0,0");
            }
        }
        fw.close();
        return sizeInBytes;
    }    
    
    
    public static List<Integer> generateAssemblerPatternBitmap(int tilex, int tiley, BufferedImage image, int tolerance) throws Exception {
        List<Integer> differentColors = new ArrayList<>();
        List<Integer> data = new ArrayList<>();
        for(int i = 0;i<PH;i++) {
            List<Integer> pixels = patternColors(tilex, tiley, i, image, tolerance);
            differentColors.clear();
            for(int c:pixels) {
                if (!differentColors.contains(c)) {
                    differentColors.add(c);
                }
            }
            if (differentColors.size()==1) differentColors.add(0);
            Collections.sort(differentColors);
            int bitmap = 0;
            int mask = (int)Math.pow(2, PW-1);
            for(int j = 0;j<PW;j++) {
                if (pixels.get(j).equals(differentColors.get(0))) {
                    // 0
                } else {
                    // 1
                    bitmap+=mask;
                }
                mask/=2;
            }
            data.add(bitmap);
        }
        return data;
    }
    
    
    public static String generateAssemblerPatternBitmapString(int tilex, int tiley, BufferedImage image, int tolerance) throws Exception {
        List<Integer> data = generateAssemblerPatternBitmap(tilex, tiley, image, tolerance);
        String line = "    db ";
        for(int i = 0;i<PH;i++) {
            int bitmap = data.get(i);
            line += toHex8bit(bitmap);
            if (i<PH-1) line+=",";
        }
        return line;
    }

    
    public static List<Integer> generateAssemblerPatternAttributes(int tilex, int tiley, BufferedImage image, int tolerance) throws Exception {
        List<Integer> differentColors = new ArrayList<>();
        List<Integer> data = new ArrayList<>();
        String line = "    db ";
        for(int i = 0;i<PH;i++) {
            List<Integer> pixels = patternColors(tilex, tiley, i, image, tolerance);
            differentColors.clear();
            for(int c:pixels) if (!differentColors.contains(c)) differentColors.add(c);
            if (differentColors.size()==1) {
                // try to uniformize for better compression:
                if (differentColors.get(0) == 0) {
                    boolean found = false;
                    for(int i2 = i+1;i2<PH;i2++) {
                        List<Integer> pixels_next = patternColors(tilex, tiley, i2, image, tolerance);
                        List<Integer> differentColors_next = new ArrayList<>();
                        for(int c:pixels_next) if (!differentColors_next.contains(c)) differentColors_next.add(c);
                        Collections.sort(differentColors_next);
                        if (differentColors_next.size()==2 && differentColors_next.get(0) == 0) {
                            found = true;
                            differentColors.add(differentColors_next.get(1));
                            break;
                        }
                    }
                    if (!found) {
                        for(int i2 = i-1;i2>=0;i2--) {
                            List<Integer> pixels_next = patternColors(tilex, tiley, i2, image, tolerance);
                            List<Integer> differentColors_next = new ArrayList<>();
                            for(int c:pixels_next) if (!differentColors_next.contains(c)) differentColors_next.add(c);
                            Collections.sort(differentColors_next);
                            if (differentColors_next.size()==2 && differentColors_next.get(0) == 0) {
                                found = true;
                                differentColors.add(differentColors_next.get(1));
                                break;
                            }
                        }
                    }
                    if (!found) {
                        differentColors.add(0);
                    }
                } else {
                    differentColors.add(0);                    
                }
            }
            Collections.sort(differentColors);
            int bitmap = differentColors.get(0) + 16*differentColors.get(1);
            data.add(bitmap);
        }
        return data;
    }    
    
    
    public static String generateAssemblerPatternAttributesString(int tilex, int tiley, BufferedImage image, int tolerance) throws Exception {
        List<Integer> data = generateAssemblerPatternAttributes(tilex, tiley, image, tolerance);
        String line = "    db ";
        for(int i = 0;i<PH;i++) {
            int bitmap = data.get(i);
            line += toHex8bit(bitmap);
            if (i<PH-1) line+=",";
        }
        return line;
    }    
    
    
    public static String toHex8bit(int value) {
        char table[] = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
        return "#" + table[value/16] + table[value%16];
    }
    
    
    public static int pixelColor(int image_x, int image_y, BufferedImage image) throws Exception {
        int color = image.getRGB(image_x, image_y);
        int r = (color & 0xff0000)>>16;
        int g = (color & 0x00ff00)>>8;
        int b = color & 0x0000ff;
        int a = (color & 0xff000000)>>24;
        if (a == 0) r = g = b = 0;
        return findMSXColor(r, g, b);
    }
    
    
    public static int findMSXColor(int x, int y, BufferedImage image) {
        int color = image.getRGB(x, y);
        int r = (color & 0xff0000)>>16;
        int g = (color & 0x00ff00)>>8;
        int b = color & 0x0000ff;
        int a = (color & 0xff000000)>>24;
        if (a == 0) return -1;
        for(int i = 1;i<MSX1Palette.length;i++) {
            if (r==MSX1Palette[i][0] &&
                g==MSX1Palette[i][1] &&
                b==MSX1Palette[i][2]) {
                return i;
            }
        }
        return -1;
    }    

    
    public static int findMSXColor(int x, int y, BufferedImage image, int tolerance) {
        int color = image.getRGB(x, y);
        int r = (color & 0xff0000)>>16;
        int g = (color & 0x00ff00)>>8;
        int b = color & 0x0000ff;
        int a = (color & 0xff000000)>>24;
        if (a == 0) return -1;
        return findMSXColor(r, g, b, tolerance);
    }    
    
    
    public static List<Integer> patternColors(int tilex, int tiley, int line, BufferedImage image) throws Exception {
        List<Integer> pixels = new ArrayList<>();
        List<Integer> differentColors = new ArrayList<>();
        for(int j = 0;j<PW;j++) {
            int image_x = tilex*PW + j;
            int image_y = tiley*PH + line;
            int color = image.getRGB(image_x, image_y);
            int r = (color & 0xff0000)>>16;
            int g = (color & 0x00ff00)>>8;
            int b = color & 0x0000ff;
            int a = (color & 0xff000000)>>24;
            if (a == 0) r = g = b = 0;
            int msxColor = findMSXColor(r, g, b);
            if (msxColor==-1) throw new Exception("Undefined color at " + image_x + ", " + image_y + ": " + r + ", " + g + ", " + b);
            if (!differentColors.contains(msxColor)) differentColors.add(msxColor);
            pixels.add(msxColor);
        }
        if (differentColors.size()>2) System.out.println("ERROR "+(ERROR_color_count++)+": more than 2 colors in line " + tilex*PW + ", " + (tiley*PH) + "+" + line);
        return pixels;        
    }
    
    
    public static List<Integer> patternColors(int tilex, int tiley, int line, BufferedImage image, int tolerance) throws Exception {
        List<Integer> pixels = new ArrayList<>();
        List<Integer> differentColors = new ArrayList<>();
        for(int j = 0;j<PW;j++) {
            int image_x = tilex*PW + j;
            int image_y = tiley*PH + line;
            int color = image.getRGB(image_x, image_y);
            int r = (color & 0xff0000)>>16;
            int g = (color & 0x00ff00)>>8;
            int b = color & 0x0000ff;
            int a = (color & 0xff000000)>>24;
            if (a == 0) r = g = b = 0;
            int msxColor = findMSXColor(r, g, b, tolerance);
            if (msxColor==-1) throw new Exception("Undefined color at " + image_x + ", " + image_y + ": " + r + ", " + g + ", " + b);
            if (!differentColors.contains(msxColor)) differentColors.add(msxColor);
            pixels.add(msxColor);
        }
        if (differentColors.size()>2) System.out.println("ERROR "+(ERROR_color_count++)+": more than 2 colors in line " + tilex*PW + ", " + (tiley*PH) + "+" + line);
        return pixels;        
    }    
    
    
    public static int MSXColorToRGB(int color)
    {
        return (MSX1Palette[color][0] << 16) + (MSX1Palette[color][1]<<8) + (MSX1Palette[color][2]) + 0xff000000;
    }


    public static int findMSXColor(int color) {
        int r = (color & 0xff0000)>>16;
        int g = (color & 0x00ff00)>>8;
        int b = color & 0x0000ff;
        int a = (color & 0xff000000)>>24;
        if (a == 0) r = g = b = 0;
        return findMSXColor(r, g, b);
    }
    
    
    public static int findMSXColor(int r, int g, int b) {
        for(int i = 0;i<MSX1Palette.length;i++) {
            if (r==MSX1Palette[i][0] &&
                g==MSX1Palette[i][1] &&
                b==MSX1Palette[i][2]) {
                return i;
            }
        }
        return -1;
    }


    public static int findMSXColor(int color, int tolerance) {
        int r = (color & 0xff0000)>>16;
        int g = (color & 0x00ff00)>>8;
        int b = color & 0x0000ff;
        int a = (color & 0xff000000)>>24;
        if (a == 0) r = g = b = 0;
        return findMSXColor(r, g, b, tolerance);
    }
    
    
    public static int findMSXColor(int r, int g, int b, int tolerance) {
        int best_diff = 0;
        int best = -1;
        for(int i = 0;i<MSX1Palette.length;i++) {
            int diff = Math.abs(r - MSX1Palette[i][0]) + 
                       Math.abs(g - MSX1Palette[i][1]) + 
                       Math.abs(b - MSX1Palette[i][2]);
            if (diff < best_diff || best == -1) {
                best = i;
                best_diff = diff;
            }
        }
        if (best_diff <= tolerance) return best;
        System.out.println("best_diff = " + best_diff + " (tolerance = " + tolerance + ": "+r+","+g+","+b+")");
        return -1;
    }

}
