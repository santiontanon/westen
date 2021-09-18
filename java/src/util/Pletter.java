/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.List;

/**
 *
 * @author santi
 */
public class Pletter {

    static int d_bytes[];
//    static byte d[];
    static int maxlen[] = {128, 128 + 128, 512 + 128, 1024 + 128, 2048 + 128, 4096 + 128, 8192 + 128};
    static int varcost[] = new int[65536];

    public static class Metadata {

        int reeks;
        int cpos[] = new int[7];
        int clen[] = new int[7];
    };
    static Metadata m[];

    public static class Pakdata {

        int cost, mode, mlen;
    }
    static Pakdata p[][] = new Pakdata[7][];

    static String sourcefilename = null, destfilename = null;
    static boolean savelength = false;
    static int length, offset;

    public static class Saves {

        int buf[];
        int ep, dp, p, e;

        void init() {
            ep = dp = p = e = 0;
            buf = new int[length * 2];
        }

        void add0() {
            if (p == 0) {
                claimevent();
            }
            e *= 2;
            ++p;
            if (p == 8) {
                addevent();
            }
        }

        void add1() {
            if (p == 0) {
                claimevent();
            }
            e *= 2;
            ++p;
            ++e;
            if (p == 8) {
                addevent();
            }
        }

        void addbit(int b) {
            if (b != 0) {
                add1();
            } else {
                add0();
            }
        }

        void add3(int b) {
            addbit(b & 4);
            addbit(b & 2);
            addbit(b & 1);
        }

        void addvar(int i) {
            int j = 32768;
            while ((i & j) == 0) {
                j /= 2;
            }
            do {
                if (j == 1) {
                    add0();
                    return;
                }
                j /= 2;
                add1();
                if ((i & j) != 0) {
                    add1();
                } else {
                    add0();
                }
            } while (true);
        }

        void adddata(int d) throws Exception {
            if (d<0 || d>=256) throw new Exception("d is out of byte range! " + d);
            buf[dp] = d;
            dp++;
        }

        void addevent() {
            buf[ep] = (byte) e;
            e = p = 0;
        }

        void claimevent() {
            ep = dp;
            ++dp;
        }

        void done() throws Exception {
            if (p != 0) {
                while (p != 8) {
                    e *= 2;
                    ++p;
                }
                addevent();
            }
            if (destfilename != null) {
                DataOutputStream os = new DataOutputStream(new FileOutputStream(destfilename));
                for(int i = 0;i<dp;i++) {
                    os.writeByte(buf[i]);
                }
                os.close();
                System.out.println(" " + destfilename + ": " + length + " -> " + dp);
            }
        }
    };
    static Saves s = new Saves();

    static void loadfile(String sourcefilename) throws Exception {
        File file = new File(sourcefilename);
        if (length == 0) {
            length = (int) file.length();
        }
        DataInputStream is = new DataInputStream(new FileInputStream(file));
        d_bytes = new int[length + 1];
        m = new Metadata[length + 1];
        for(int i = 0;i<length+1;i++) {
            m[i] = new Metadata();
        }
        for(int i = 0;i<length;i++) {
            d_bytes[i] = is.readUnsignedByte();
        }
        d_bytes[length] = 0;
        is.close();
    }

    static void initvarcost() {
        int v = 1, b = 1, r = 1;
        while (r != 65536) {
            for (int j = 0; j != r; ++j) {
                varcost[v++] = b;
            }
            b += 2;
            r *= 2;
        }
    }

    static void createmetadata() {
        int last[] = new int[65536];
        for (int i = 0; i < last.length; i++) {
            last[i] = -1;
        }
        int prev[] = new int[length + 1];
        for (int i = 0; i < length; i++) {
            m[i].cpos[0] = m[i].clen[0] = 0;
            prev[i] = last[d_bytes[i] + d_bytes[i + 1] * 256];
            last[d_bytes[i] + d_bytes[i + 1] * 256] = i;
        }
        int r = 255, t = 0;
        for (int i = length - 1; i >= 0; i--) {
            if (d_bytes[i] == r) {
                m[i].reeks = ++t;
            } else {
                r = d_bytes[i];
                m[i].reeks = t = 1;
            }
        }
        for (int bl = 0; bl < 7; bl++) {
            for (int i = 0; i < length; i++) {
                int l, p2;
                p2 = i;
                if (bl != 0) {
                    m[i].clen[bl] = m[i].clen[bl - 1];
                    m[i].cpos[bl] = m[i].cpos[bl - 1];
                    p2 = i - m[i].cpos[bl];
                }
                p2 = prev[p2];
                while (p2 != -1) {
                    if (i - p2 > maxlen[bl]) {
                        break;
                    }
                    l = 0;
//                    System.out.println("(first) p2: " + p2 + ", l: " + l + ", i: " + i);
                    while ((d_bytes[p2 + l] == d_bytes[i + l]) && 
                           ((i + l) < length)) {
//                        System.out.println("p2: " + p2 + ", l: " + l + ", i: " + i);
                        if (m[i + l].reeks > 1) {
                            int j = m[i + l].reeks;
                            if (j > m[p2 + l].reeks) {
                                j = m[p2 + l].reeks;
                            }
                            l += j;
                        } else {
                            ++l;
                        }
                    }
                    if (l > m[i].clen[bl]) {
                        m[i].clen[bl] = l;
                        m[i].cpos[bl] = i - p2;
                    }
                    p2 = prev[p2];
                }
            }
            //System.out.print(".");
        }
        //System.out.print(" ");
    }

    
    static int getlen(Pakdata p[], int q) {
        int i, j, cc, ccc, kc, kmode, kl;
        p[length].cost = 0;
        for (i = length - 1; i != -1; --i) {
            kmode = 0;
            kl = 0;
            kc = 9 + p[i + 1].cost;

            j = m[i].clen[0];
            while (j > 1) {
                cc = 9 + varcost[j - 1] + p[i + j].cost;
                if (cc < kc) {
                    kc = cc;
                    kmode = 1;
                    kl = j;
                }
                --j;
            }

            j = m[i].clen[q];
            if (q == 1) {
                ccc = 9;
            } else {
                ccc = 9 + q;
            }
            while (j > 1) {
                cc = ccc + varcost[j - 1] + p[i + j].cost;
                if (cc < kc) {
                    kc = cc;
                    kmode = 2;
                    kl = j;
                }
                --j;
            }

            p[i].cost = kc;
            p[i].mode = kmode;
            p[i].mlen = kl;
        }
        return p[0].cost;
    }

    
    static int save(Pakdata p[], int q) throws Exception {
        s.init();
        int i, j;

        if (savelength) {
            s.adddata((byte) (length & 255));
            s.adddata((byte) (length >> 8));
        }

        s.add3(q - 1);
        s.adddata(d_bytes[0]);

        i = 1;
        while (i < length) {
            switch (p[i].mode) {
                case 0:
                    s.add0();
                    s.adddata(d_bytes[i]);
                    ++i;
                    break;
                case 1:
                    s.add1();
                    s.addvar(p[i].mlen - 1);
                    j = m[i].cpos[0] - 1;
                    if (j > 127) {
                        System.out.println("-j>128-");
                    }
                    s.adddata((byte) j);
                    i += p[i].mlen;
                    break;
                case 2:
                    s.add1();
                    s.addvar(p[i].mlen - 1);
                    j = m[i].cpos[q] - 1;
                    if (j < 128) {
                        System.out.println("-j<128-");
                    }
                    j -= 128;
                    s.adddata((128 | (j & 127)));
                    switch (q) {
                        case 6:
                            s.addbit(j & 4096);
                        case 5:
                            s.addbit(j & 2048);
                        case 4:
                            s.addbit(j & 1024);
                        case 3:
                            s.addbit(j & 512);
                        case 2:
                            s.addbit(j & 256);
                            s.addbit(j & 128);
                        case 1:
                            break;
                        default:
                            System.out.println("-2-");
                            break;
                    }
                    i += p[i].mlen;
                    break;
                default:
                    System.out.println("-?-");
                    break;
            }
        }

        for (i = 0; i != 34; ++i) {
            s.add1();
        }
        s.done();
        return s.dp;
    }
    
    
    public static boolean isdigit(char c) {
        return c>='0' && c<='9';
    }
    

    public static void main(String args[]) throws Exception {
        intMain(args);
    }
    
    
    public static int intMain(String args[]) throws Exception {
        if (args.length == 0) System.out.println("");
        System.out.println("Pletter v0.5c1 - www.xl2s.tk - (converted to Java by Santiago Ontañón, 2017)");
        if (args.length == 0) {
            System.out.println("\nUsage:\npletter [-s[ave_length]] sourcefile [[offset [length]] [destinationfile]]");
            System.exit(0);
        }

        offset = 0;
        length = 0;

        int i = 0;
        if (args[i].charAt(0) == '-') {
            savelength = (args[i].charAt(1) == 's') || (args[i].charAt(1) == 'S');
            i++;
        }
        if (args.length>i) {
            sourcefilename = args[i];
            i++;
        }
        if (args.length>i && isdigit(args[i].charAt(0))) {
            offset = Integer.parseInt(args[i]);
            i++;
            if (args.length>i && isdigit(args[i].charAt(0))) {
                length = Integer.parseInt(args[i]);
                i++;
            }
        }
        if (args.length>i) {
            destfilename = args[i];
            i++;
        }

        if (sourcefilename == null) {
            System.out.println("No inputfile");
            System.exit(1);
        }
        if (destfilename == null) {
            destfilename = sourcefilename + ".plet5";
        }

        loadfile(sourcefilename);

        initvarcost();
        createmetadata();

        int minlen = length * 1000;
        int minbl = 0;
        for (i = 1; i != 7; i++) {
            p[i] = new Pakdata[length + 1];
            for(int j = 0;j<length+1;j++) p[i][j] = new Pakdata();
            int l = getlen(p[i], i);
            if ((l < minlen) && i!=0) { // the i!=0 seems redundant, but I just left it since it was in the original c++ code
                minlen = l;
                minbl = i;
            }
            //System.out.print(".");
        }
        return save(p[minbl], minbl);
    }


    public static int sizeOfCompressedBuffer(List<Integer> bytes) throws Exception {
        offset = 0;
        length = bytes.size();

        d_bytes = new int[length + 1];
        m = new Metadata[length + 1];
        for(int i = 0;i<length+1;i++) {
            m[i] = new Metadata();
        }
        for(int i = 0;i<length;i++) {
            d_bytes[i] = bytes.get(i);
        }
        d_bytes[length] = 0;
        destfilename = null;
       
        initvarcost();
        createmetadata();

        int minlen = length * 1000;
        int minbl = 0;
        for (int i = 1; i != 7; i++) {
            p[i] = new Pakdata[length + 1];
            for(int j = 0;j<length+1;j++) p[i][j] = new Pakdata();
            int l = getlen(p[i], i);
            if ((l < minlen) && i!=0) { // the i!=0 seems redundant, but I just left it since it was in the original c++ code
                minlen = l;
                minbl = i;
            }
        }
        return save(p[minbl], minbl);
    }

}
