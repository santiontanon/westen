/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;

/**
 *
 * @author santi
 */
public class ZX0Wrapper {

    public static String compressor_path = "java/zx0";

    public static int main(String inFile, String outFile, boolean logSize, boolean quickCompression) throws Exception {
//        // if the destination file exists, delete it:
//        {
//            File f = new File(outFile);
//            if (f.exists()) f.delete();
//        }        
        Runtime rt = Runtime.getRuntime();
        Process p = rt.exec(compressor_path + " -f " + (quickCompression ? "-q ":"") + inFile + " " + outFile);
        new Thread(() -> {
            BufferedReader input = new BufferedReader(new InputStreamReader(p.getInputStream()));            
//            BufferedReader error = new BufferedReader(new InputStreamReader(p.getErrorStream()));
            try {
                while (input.readLine() != null) {}
//                String line;
//                while ((line = error.readLine()) != null) {
//                     System.out.println(line);
//                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }).start();
        p.waitFor();
        
        // print compression rate:
        File f2 = new File(outFile);
        int l2 = (int)f2.length();
        if (logSize) {
            File f1 = new File(inFile);
            int l1 = (int)f1.length();
            System.out.println("ZX0.main(" + inFile + ", " + outFile +"): " + l1 + " --> " + l2);
        }
        return l2;
    }
    
    
    public static int sizeOfCompressedBuffer(List<Integer> data, String tmpFileName, boolean quickCompression) throws Exception
    {
        FileOutputStream fos = new FileOutputStream(tmpFileName + ".bin");
        for(int v:data) fos.write(v);
        fos.flush();
        fos.close();
        
        return main(tmpFileName+".bin", tmpFileName+".zx0", false, quickCompression);
    }
}
