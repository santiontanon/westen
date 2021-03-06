/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package westen;

import java.io.File;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Random;
import text.EncodeText;
import text.PAKFont;
import util.Pair;

/**
 *
 * @author santi
 */
public class Text {
    public static PAKFont font = null;
            
    public static void main(String args[]) throws Exception
    {
        List<String> characters = new ArrayList<>();
        characters.add(" !/@'()?,-.");
        characters.add("0123456789:");
        characters.add("ABCDEFGHIJKLMNO");
        characters.add("PQRSTUVWXYZ");
        characters.add("abcdefghijklmno");
        characters.add("pqrstuvwxyzó");
        characters.add("ñ");
        font = new PAKFont("data/font.png", characters);   
        font.generateAssemblerData("src/autogenerated/font");
        
        font.printFontInfo();
                
        // Text lines:
        List<String> lines = new ArrayList<>();
        
        HashMap<String,String> lines_with_constant = new HashMap<>();
//        addLineSafe(lines_with_constant, "BRAIN GAMES", "BRAIN_GAMES");
        addLineSafe(lines_with_constant, "Presents", "PRESENTS", 8);

        addLineSafe(lines_with_constant, "London, 1898", "INTRO_MSG1", 8);
        addLineSafe(lines_with_constant, "Ding Dong!", "INTRO_MSG2", 8);
        addLineSafe(lines_with_constant, "Coming!", "INTRO_MSG3", 8);
        addLineSafe(lines_with_constant, "A letter for you, Professor.", "INTRO_MSG4", 16);
        addLineSafe(lines_with_constant, "Thank you, Richard!", "INTRO_MSG5", 12);
        addLineSafe(lines_with_constant, "Let's see what it says...", "INTRO_MSG6", 16);
        addLineSafe(lines_with_constant, "Terrible news!", "INTRO_MSG7", 12);
        addLineSafe(lines_with_constant, "JW was a dear friend!", "INTRO_MSG8", 12);
        addLineSafe(lines_with_constant, "I must go there at once!", "INTRO_MSG9", 14);
        
        addLineSafe(lines_with_constant, "Dear Professor Edward Kelvin","LETTER1_LINE1", 28);
        addLineSafe(lines_with_constant, "We regret to inform you of the passing of Jonathan","LETTER1_LINE2", 28);
        addLineSafe(lines_with_constant, "Westen, who died on October 16th. In his will, Mr.","LETTER1_LINE3", 28);
        addLineSafe(lines_with_constant, "Westen left his scientific notes to you. He also","LETTER1_LINE4", 28);
        addLineSafe(lines_with_constant, "wrote a letter for you, which we've enclosed here.","LETTER1_LINE5", 28);
        addLineSafe(lines_with_constant, "We also inform you that Mrs Lucy Westen plans","LETTER1_LINE6", 28);
        addLineSafe(lines_with_constant, "to take possession of the house on December 1st.","LETTER1_LINE7", 28);

        
//        addLineSafe(lines_with_constant, "Dear Ed.","LETTER2_LINE1");
        addLineSafe(lines_with_constant, "If you are reading this, I am probably","LETTER2_LINE2", 24);
        addLineSafe(lines_with_constant, "dead. You must retrieve my scientific","LETTER2_LINE3", 24);
        addLineSafe(lines_with_constant, "notes before my sister Lucy takes","LETTER2_LINE4", 24);
        addLineSafe(lines_with_constant, "possession of the house. Only you will be","LETTER2_LINE5", 24);
        addLineSafe(lines_with_constant, "able to understand them! Here is the key to","LETTER2_LINE6", 24);
        addLineSafe(lines_with_constant, "Westen House, and part of a key that you","LETTER2_LINE7", 24);
        addLineSafe(lines_with_constant, "will need to reach my laboratory. It is","LETTER2_LINE8", 24);
        addLineSafe(lines_with_constant, "important to me.","LETTER2_LINE9", 24);
//        addLineSafe(lines_with_constant, "JW","LETTER2_LINE10");
        
        addLineSafe(lines_with_constant, "Safe: 15-30-10", "LETTER3_LINE1_SECRET", 9);
        addLineSafe(lines_with_constant, "Dear Ed,", "LETTER3_LINE1", 22);
        addLineSafe(lines_with_constant, "I hope you find this before my family", "LETTER3_LINE2", 22);
        addLineSafe(lines_with_constant, "does. It holds the secret to the second", "LETTER3_LINE3", 22);
        addLineSafe(lines_with_constant, "half of the key you should already have.", "LETTER3_LINE4", 22);
        addLineSafe(lines_with_constant, "I used lemon ink. You will know what to do.", "LETTER3_LINE5", 22);
        addLineSafe(lines_with_constant, "You'll soon understand the secrecy.", "LETTER3_LINE6", 22);
        addLineSafe(lines_with_constant, "JW", "LETTER3_LINE7", 22);
        
//        addLineSafe(lines_with_constant, "Dear Ed,", "LETTER4_LINE1");
        addLineSafe(lines_with_constant, "Now that you have seen the house firsthand", "LETTER4_LINE2", 24);
        addLineSafe(lines_with_constant, "you might have already guessed. My family's", "LETTER4_LINE3", 24);
        addLineSafe(lines_with_constant, "name is not Westen, but Westenra.", "LETTER4_LINE4", 24);
        addLineSafe(lines_with_constant, "We hid our name to hide my sister's identity.", "LETTER4_LINE5", 24);
        addLineSafe(lines_with_constant, "As you might recall, Lucy Westenra was in-", "LETTER4_LINE6", 24);
        addLineSafe(lines_with_constant, "volved in an unfortunate accident two years", "LETTER4_LINE7", 24);
        addLineSafe(lines_with_constant, "ago in an encounter with a creature they call", "LETTER4_LINE8", 24);
        addLineSafe(lines_with_constant, "a vampire. They are all vampires now, Ed!", "LETTER4_LINE9", 24);
        addLineSafe(lines_with_constant, "She did not die as the news said, and she", "LETTER4_LINE10", 24);
        addLineSafe(lines_with_constant, "is not alone. But I have a plan. I know how", "LETTER4_LINE11", 24);
        addLineSafe(lines_with_constant, "to kill them. Seek their coffins, they sleep", "LETTER4_LINE12", 24);
        addLineSafe(lines_with_constant, "there. Rub them with garlic before they", "LETTER4_LINE13", 24);
        addLineSafe(lines_with_constant, "arrive, and they will perish in their sleep!", "LETTER4_LINE14", 24);
        addLineSafe(lines_with_constant, "Work quickly! Prepare it before they arrive!", "LETTER4_LINE15", 24);
        addLineSafe(lines_with_constant, "If you are too late, killing them will be hard!", "LETTER4_LINE16", 24);
        addLineSafe(lines_with_constant, "You will need to drive a stake rubbed", "LETTER4_LINE17", 24);
        addLineSafe(lines_with_constant, "in garlic into their hearts while they sleep.", "LETTER4_LINE18", 24);
        addLineSafe(lines_with_constant, "I hope you do not need to resort to this!", "LETTER4_LINE19", 24);
        addLineSafe(lines_with_constant, "Best of luck! JW", "LETTER4_LINE20", 24);
        
        addLineSafe(lines_with_constant, "P.S.:", "LETTER5_LINE0", 24);
        addLineSafe(lines_with_constant, "Vampires in my family sleep in coffins in", "LETTER5_LINE1", 24);
        addLineSafe(lines_with_constant, "the basement of the house. I noticed they", "LETTER5_LINE2", 24);
        addLineSafe(lines_with_constant, "locked their doors with a combination lock.", "LETTER5_LINE3", 24);
        addLineSafe(lines_with_constant, "I think they used their vampire names as", "LETTER5_LINE4", 24);
        addLineSafe(lines_with_constant, "the pass words. Vampires keep their names", "LETTER5_LINE5", 24);
        addLineSafe(lines_with_constant, "secretively, but probably you can find them", "LETTER5_LINE6", 24);
        addLineSafe(lines_with_constant, "by searching their rooms for diaries or", "LETTER5_LINE7", 24);
        addLineSafe(lines_with_constant, "other notes.", "LETTER5_LINE8", 24);

        addLineSafe(lines_with_constant, "John Seward's Diary.", "DIARY1_LINE1", 24);
        addLineSafe(lines_with_constant, "...", "DIARY1_LINE2", 24);
        addLineSafe(lines_with_constant, "July 7th, 1897", "DIARY1_LINE3", 24);
        addLineSafe(lines_with_constant, "Mrs Lucy finally made me part of her inner", "DIARY1_LINE4", 24);
        addLineSafe(lines_with_constant, "circle! I will now use the name of this month", "DIARY1_LINE5", 24);
        addLineSafe(lines_with_constant, "as my own to remember this occasion!", "DIARY1_LINE6", 24);

        addLineSafe(lines_with_constant, "Arthur Holmwood's Diary.", "DIARY2_LINE1", 24);
//        addLineSafe(lines_with_constant, "...", "DIARY2_LINE2", 24);
        addLineSafe(lines_with_constant, "June 26th, 1897", "DIARY2_LINE3", 24);
        addLineSafe(lines_with_constant, "My beloved finally converted me. This is", "DIARY2_LINE4", 24);
        addLineSafe(lines_with_constant, "exhilarating. I need to choose a name now.", "DIARY2_LINE5", 24);
        addLineSafe(lines_with_constant, "I think I will pick her family name to", "DIARY2_LINE6", 24);
        addLineSafe(lines_with_constant, "show my devotion.", "DIARY2_LINE7", 24);
        
        addLineSafe(lines_with_constant, "Santiago Ontañón 2021", "CREDITS", 16);
        addLineSafe(lines_with_constant, "Press SPACE to Start", "START", 16);
        addLineSafe(lines_with_constant, "Press M for controls", "CONTROLS", 16);
        
        addLineSafe(lines_with_constant, "Game Over", "GAME_OVER", 8);

        addLineSafe(lines_with_constant, "Joystick / arrow keys to move.", "TUTORIAL1_LINE1", 17);
        addLineSafe(lines_with_constant, "Button 1 / space to jump.", "TUTORIAL1_LINE2", 17);
        addLineSafe(lines_with_constant, "Q to toggle direction mapping.", "TUTORIAL1_LINE3", 17);

        addLineSafe(lines_with_constant, "While holding Button 2 / M:", "TUTORIAL2_LINE1", 18);
        addLineSafe(lines_with_constant, "- Joystick / arrow keys to", "TUTORIAL2_LINE2", 18);
        addLineSafe(lines_with_constant, "  select inventory items,", "TUTORIAL2_LINE3", 18);
        addLineSafe(lines_with_constant, "- Button 1 / space to use them.", "TUTORIAL2_LINE4", 18);
        
        addLineSafe(lines_with_constant, "Some objects can be pushed by", "TUTORIAL3_LINE1", 17);
        addLineSafe(lines_with_constant, "walking into them.", "TUTORIAL3_LINE2", 17);

        addLineSafe(lines_with_constant, "To interact with a room object: get", "TUTORIAL4_LINE1", 20);
        addLineSafe(lines_with_constant, "close by with an empty inventory slot", "TUTORIAL4_LINE2", 20);
        addLineSafe(lines_with_constant, "selected, and press Button 1 / space", "TUTORIAL4_LINE3", 20);
        addLineSafe(lines_with_constant, "while holding Button 2 / M.", "TUTORIAL4_LINE4", 20);
        addLineSafe(lines_with_constant, "To pick it up: do the same while", "TUTORIAL4_LINE5", 20);
        addLineSafe(lines_with_constant, "standing on top of the object.", "TUTORIAL4_LINE6", 20);
        
        addLineSafe(lines_with_constant, "I just arrived at Westen House.", "GAME_START_MESSSAGE1", 19);
        addLineSafe(lines_with_constant, "Let's find JW's laboratory.", "GAME_START_MESSSAGE2", 19);        
        
        addLineSafe(lines_with_constant, "I'll leave the stools behind.", "DROP_STOOLS", 19);
        addLineSafe(lines_with_constant, "A note from JW! Let's read it!", "LETTER3", 19);

        addLineSafe(lines_with_constant, "Nothing here to use or pick up.", "USE_ERROR", 19);
        addLineSafe(lines_with_constant, "I don't see the appropriate lock.", "ITEM_KEY", 19);
        addLineSafe(lines_with_constant, "Looks like the key for a chest.", "ITEM_KEY_GUN", 19);
        addLineSafe(lines_with_constant, "I need to find the other half.", "ITEM_HALF_KEY", 19);
        addLineSafe(lines_with_constant, "A bottle of lamp oil.", "ITEM_OIL", 19);
        addLineSafe(lines_with_constant, "I'll refill the lamp with this oil.", "ITEM_OIL_USED", 19);
        addLineSafe(lines_with_constant, "An oil lamp. It's out of oil.", "ITEM_LAMP", 19);
        addLineSafe(lines_with_constant, "An oil lamp. The flame is on.", "ITEM_LAMP_ON", 19);
        addLineSafe(lines_with_constant, "The lamp heat is developing", "USE_LAMP1", 19);
        addLineSafe(lines_with_constant, "the lemon ink in the letter!", "USE_LAMP2", 19);
        addLineSafe(lines_with_constant, "There is nothing behind this painting.", "USE_PAINTING", 19);
        addLineSafe(lines_with_constant, "Look! A safe behind this painting!", "USE_PAINTING_SAFE", 19);
        addLineSafe(lines_with_constant, "I don't know the combination.", "USE_SAFE", 19);
        addLineSafe(lines_with_constant, "Aha! The letter code worked!", "USE_SAFE_OPEN1", 19);
        addLineSafe(lines_with_constant, "There is nothing else inside.", "USE_SAFE_OPEN2", 19);
        addLineSafe(lines_with_constant, "The two halves fit perfectly!", "MERGE_RED_KEY", 19);
        addLineSafe(lines_with_constant, "There is a loose page.", "USE_BOOK", 19);
        addLineSafe(lines_with_constant, "I don't want to put the candle here.", "USE_CANDLE", 19);
        
        addLineSafe(lines_with_constant, "Quincey Morris, 1862 - 1897", "USE_TOMBSTONE", 19);
        addLineSafe(lines_with_constant, "This door is locked.", "USE_DOOR", 19);
        addLineSafe(lines_with_constant, "Lots of dark arts books.", "USE_BOOK_STACK", 19);
        addLineSafe(lines_with_constant, "This chest is just decorative.", "USE_CHEST", 19);
        addLineSafe(lines_with_constant, "I don't feel like going now.", "USE_TOILET", 19);
        addLineSafe(lines_with_constant, "No time for a bath now.", "USE_BATHTUB", 19);
        addLineSafe(lines_with_constant, "A very nice gramophone.", "USE_GRAMOPHONE", 19);
        addLineSafe(lines_with_constant, "A violin, I can't play it.", "USE_VIOLIN", 19);
        addLineSafe(lines_with_constant, "No need to wash my hands now.", "USE_SINK", 19);
        addLineSafe(lines_with_constant, "This window doesn't open.", "USE_WINDOW", 19);
        addLineSafe(lines_with_constant, "A very expensive-looking coffin.", "USE_COFFIN", 19);
        addLineSafe(lines_with_constant, "These are human remains!", "USE_BONES", 19);  
        addLineSafe(lines_with_constant, "This chest is locked.", "USE_CHEST_GUN1", 19);
        addLineSafe(lines_with_constant, "Nothing else in this chest.", "USE_CHEST_GUN2", 19);
        addLineSafe(lines_with_constant, "The key opened the chest.", "TAKE_GUN1", 19);
        addLineSafe(lines_with_constant, "There was a revolver inside!", "TAKE_GUN2", 19);
        
        addLineSafe(lines_with_constant, "An accounting book. It's strange,", "USE_BOOK_WESTENRA1", 19);
        addLineSafe(lines_with_constant, "though, since instead of Westen,", "USE_BOOK_WESTENRA2", 19);
        addLineSafe(lines_with_constant, "this is for the Westenra family...", "USE_BOOK_WESTENRA3", 19);
        
        addLineSafe(lines_with_constant, "This is the diary of Lucy Westenra.", "USE_DIARY3_1", 19);
        addLineSafe(lines_with_constant, "Most pages are torn, but I found", "USE_DIARY3_2", 19);
        addLineSafe(lines_with_constant, "a key inside.", "USE_DIARY3_3", 19);

        addLineSafe(lines_with_constant, "So, Lucy Westen is Lucy Westenra!", "USE_LAB_NOTES_1", 19);
        addLineSafe(lines_with_constant, "This is worse than I thought!", "USE_LAB_NOTES_2", 19);
        addLineSafe(lines_with_constant, "I need to hurry and find garlic!", "USE_LAB_NOTES_3", 19);

        addLineSafe(lines_with_constant, "This crate looks fairly weak...", "USE_BREAKABLE_CRATE", 19);
        addLineSafe(lines_with_constant, "Nothing I can break nearby.", "USE_HAMMER1", 19);
        addLineSafe(lines_with_constant, "I smashed it with the hammer!", "USE_HAMMER2", 19);

        addLineSafe(lines_with_constant, "A clove of garlic.", "USE_GARLIC1", 19);
        addLineSafe(lines_with_constant, "I rubbed the stake with the garlic.", "USE_GARLIC2", 19);
        addLineSafe(lines_with_constant, "A wooden stake.", "USE_STAKE", 19);
        addLineSafe(lines_with_constant, "A wooden stake rubbed in garlic.", "USE_RUBBED_STAKE", 19);
        addLineSafe(lines_with_constant, "Not now! The vampire is awake!", "USE_RUBBED_STAKE_AWAKE", 19);
        addLineSafe(lines_with_constant, "I need to get closer!", "USE_RUBBED_STAKE_TOO_FAR", 19);
        addLineSafe(lines_with_constant, "It worked! I killed it!", "USE_RUBBED_STAKE_KILL", 19);

        addLineSafe(lines_with_constant, "The door has a combination lock.", "USE_VAMPIRE_DOOR", 19);
        
        addLineSafe(lines_with_constant, "How strange, this part of the", "MSG_ABANDONED1", 19);
        addLineSafe(lines_with_constant, "house looks abandoned...", "MSG_ABANDONED2", 19);

        addLineSafe(lines_with_constant, "This room is full of books about", "MSG_BOOKS1", 19);
        addLineSafe(lines_with_constant, "the dark arts!", "MSG_BOOKS2", 19);
        addLineSafe(lines_with_constant, "Why would JW have these?!", "MSG_BOOKS3", 19);

        addLineSafe(lines_with_constant, "What is this?! Was JW conducting", "MSG_PENTAGRAM1", 19);
        addLineSafe(lines_with_constant, "unholy rituals?!", "MSG_PENTAGRAM2", 19);

        addLineSafe(lines_with_constant, "The door opened! I thought I was", "MSG_PENTAGRAM_SOLVED1", 19);
        addLineSafe(lines_with_constant, "just looking for JW's lab, but this", "MSG_PENTAGRAM_SOLVED2", 19);
        addLineSafe(lines_with_constant, "house is stranger than I thought!", "MSG_PENTAGRAM_SOLVED3", 19);
        
        addLineSafe(lines_with_constant, "Human remains!", "MSG_FEEDING1", 19);
        addLineSafe(lines_with_constant, "Ok, it is now clear that something", "MSG_FEEDING2", 19);
        addLineSafe(lines_with_constant, "macabre was going on in this house!", "MSG_FEEDING3", 19);

        addLineSafe(lines_with_constant, "At last! JW's laboratory!", "MSG_LAB", 19);

        addLineSafe(lines_with_constant, "Wait, I hear noises downstairs!", "MSG_FAMILY_CUTSCENE1", 19);
        addLineSafe(lines_with_constant, "Arthur: At last! That brother of yours is dead!", "MSG_FAMILY_CUTSCENE2", 31);
        addLineSafe(lines_with_constant, "Lucy: Indeed! The house is now mine!", "MSG_FAMILY_CUTSCENE3", 31);
        addLineSafe(lines_with_constant, "Lucy: I longed for entering my basement in peace!", "MSG_FAMILY_CUTSCENE4", 31);
        addLineSafe(lines_with_constant, "Lucy: From this house we will build our family!!", "MSG_FAMILY_CUTSCENE5", 31);
        addLineSafe(lines_with_constant, "Lucy: Today it's only us, but tomorrow we will grow!!", "MSG_FAMILY_CUTSCENE6", 31);
        addLineSafe(lines_with_constant, "Lucy: Hahaha", "MSG_FAMILY_CUTSCENE7A", 31);
        addLineSafe(lines_with_constant, "John: Hahaha", "MSG_FAMILY_CUTSCENE7B", 31);
        addLineSafe(lines_with_constant, "Arthur: Hahaha", "MSG_FAMILY_CUTSCENE7C", 31);
        addLineSafe(lines_with_constant, "Lucy: But today we rest! Let's go!", "MSG_FAMILY_CUTSCENE8", 31);

        addLineSafe(lines_with_constant, "I cannot believe my eyes!", "MSG_FAMILY_CUTSCENE9", 19);
        addLineSafe(lines_with_constant, "They are here! I was too slow!", "MSG_FAMILY_CUTSCENE10", 19);
        addLineSafe(lines_with_constant, "I will need to use the stakes...", "MSG_FAMILY_CUTSCENE11", 19);
        
        addLineSafe(lines_with_constant, "It opened!", "OPEN_VAMPIRE1_DOOR", 19);
        addLineSafe(lines_with_constant, "I don't need this diary anymore...", "OPEN_VAMPIRE1_DOOR2", 19);
        addLineSafe(lines_with_constant, "A vampire!", "ENTER_VAMPIRE_ROOM1", 19);
        addLineSafe(lines_with_constant, "I'll approach while it sleeps...", "ENTER_VAMPIRE_ROOM2", 19);

        addLineSafe(lines_with_constant, "This must be Lucy!", "ENTER_VAMPIRE3_ROOM1", 19);
        addLineSafe(lines_with_constant, "I did it! Lucy is dead!", "ENTER_VAMPIRE3_ROOM2", 19);
        
        addLineSafe(lines_with_constant, "I found a note in the corpse.", "FIND_VAMPIRE_NOTE", 19);
        
        addLineSafe(lines_with_constant, "John Seward's to do:", "VAMPIRE1_NOTE1", 24);
        addLineSafe(lines_with_constant, "- Kill JW (done)", "VAMPIRE1_NOTE2", 24);
        addLineSafe(lines_with_constant, "- Find my diary", "VAMPIRE1_NOTE3", 24);
        addLineSafe(lines_with_constant, "- Thank Lucy for using our initials to", "VAMPIRE1_NOTE4", 24);
        addLineSafe(lines_with_constant, "  form her vampire name. Such an honor", "VAMPIRE1_NOTE5", 24);
        addLineSafe(lines_with_constant, "  for all three of us!", "VAMPIRE1_NOTE6", 24);

        addLineSafe(lines_with_constant, "Lucy, why did you need to use the ini-", "VAMPIRE2_NOTE1", 22);
        addLineSafe(lines_with_constant, "tials from those two as well? I am your", "VAMPIRE2_NOTE2", 22);        
        addLineSafe(lines_with_constant, "husband! At least you put mine first...", "VAMPIRE2_NOTE3", 22);
        addLineSafe(lines_with_constant, "Arthur Holmwood", "VAMPIRE2_NOTE4", 22);
                        
        addLineSafe(lines_with_constant, "December 2nd, 1898", "ENDING_LINE1", 17);
        
        addLineSafe(lines_with_constant, "I still don't know how to feel", "ENDING_LINE2", 17);
        addLineSafe(lines_with_constant, "about the events that took", "ENDING_LINE3", 17);
        addLineSafe(lines_with_constant, "place in Westen... I mean", "ENDING_LINE4", 17);
        addLineSafe(lines_with_constant, "Westenra house...", "ENDING_LINE5", 17);

        addLineSafe(lines_with_constant, "Although I am relieved to have", "ENDING_LINE6", 17);
        addLineSafe(lines_with_constant, "rid the world of those beasts", "ENDING_LINE7", 17);
        addLineSafe(lines_with_constant, "and have come out alive, I am", "ENDING_LINE8", 17);
        addLineSafe(lines_with_constant, "saddened to learn that the life", "ENDING_LINE9", 17);
        addLineSafe(lines_with_constant, "of my good friend ended", "ENDING_LINE10", 17);
        addLineSafe(lines_with_constant, "because of such creatures...", "ENDING_LINE11", 17);

        addLineSafe(lines_with_constant, "I really hope I do not need to", "ENDING_LINE12", 17);
        addLineSafe(lines_with_constant, "ever return to this house...", "ENDING_LINE13", 17);

        addLineSafe(lines_with_constant, "Professor Edward Kelvin", "ENDING_LINE14", 17);

        addLineSafe(lines_with_constant, "Thank you for playing", "ENDING2_LINE1", 17);
        addLineSafe(lines_with_constant, "Westen House", "ENDING2_LINE2", 17);
        addLineSafe(lines_with_constant, "Santiago Ontañón, 2021", "ENDING2_LINE3", 17);
        addLineSafe(lines_with_constant, "santi.ontanon@gmail.com", "ENDING2_LINE4", 17);
        addLineSafe(lines_with_constant, "Beta testing: Jordi Sureda", "ENDING2_LINE5", 17);
        
        List<Integer> capitals = font.convertStringToAssembler("ABCDEFGHIJKLMNOPQRSTUVWXYZ ");
        System.out.println("Capitals: " + capitals);
        
        
        for(String s:lines_with_constant.keySet()) {
            if (!lines.contains(s)) lines.add(s);
        }


        // List<String> newlines = lines;
        List<String> newlines = optimizeGrouppings(lines, font, 512);
        // List<String> newlines = optimizeGrouppings(lines, font, 600);
        // List<String> newlines = optimizeGrouppings(lines, font, 640);
        // List<String> newlines = optimizeGrouppings(lines, font, 700);
//         List<String> newlines = optimizeGrouppings(lines, font, 4096);
        
        HashMap<String, Pair<Integer, Integer>> ids = new HashMap<>();
        Pair<List<Integer>,List<Integer>> sizes = EncodeText.encodeTextInBanks(newlines, font, 512, "src/autogenerated", "textBank", ids, "zx0");
        int size_before = 0;
        int size_after = 0;
        for(Integer size:sizes.m_a) size_before += size;
        for(Integer size:sizes.m_b) size_after += size;
        System.out.println("Total size before: " + size_before);
        System.out.println("Total size after: " + size_after);
        // String constants:
        {
            FileWriter fw = new FileWriter(new File("src/autogenerated/text-constants.asm"));
            for(String s:lines_with_constant.keySet()) {
                fw.write("TEXT_"+lines_with_constant.get(s)+"_BANK:   equ " + ids.get(s).m_a + "\n");
                fw.write("TEXT_"+lines_with_constant.get(s)+"_IDX:   equ " + ids.get(s).m_b + "\n");            
            }
            fw.flush();
            fw.close();
        }
    }
    
    
    public static void addLineSafe(HashMap<String,String> lines_with_constant, String line, String tag, int maxWidthInTiles) throws Exception
    {
        if (font.stringWidth(line) > maxWidthInTiles*8) {
            throw new Exception("'"+line+"' is wider than " + maxWidthInTiles + " tiles! (" + font.stringWidth(line) + " pixels, vs " + maxWidthInTiles*8 + ")");
        }
        lines_with_constant.put(line, tag);
    }
        
    
    public static List<String>  optimizeGrouppings(List<String> input_lines, PAKFont font, int group_size) throws Exception
    {
        List<String> bestLines = null;
//        EncodeText.compressor = "zx0";
        int best_size = 0;
        int best_seed = 0;      // seed 234: 1899 (for group_size 512, with 0.5 lateral moves)
                                // seed 0: 1903 (for group size 600)
                                // seed 3: 1874 (for group size 640)
                                // seed 6: 1850 (for group size 700)
        for(int seed = 0;seed<0+1;seed++) {
//        for(int seed = 0;seed<1000;seed++) {
//        for(int seed = 234;seed<234+1;seed++) {

            Pair<List<String>,Integer> tmp = optimizeGrouppingsInternal(input_lines, font, group_size, seed);
            if (bestLines == null || tmp.m_b < best_size) {
                bestLines = tmp.m_a;
                best_size = tmp.m_b;
                best_seed = seed;
                System.out.println("new best_size: " + best_size + " (best_seed: " + best_seed + ")");
            }
        }
        
        System.out.println("final best_size: " + best_size + " (best_seed: " + best_seed + ")");
        return bestLines;
    }
    
    
    public static Pair<List<String>,Integer>  optimizeGrouppingsInternal(List<String> input_lines, PAKFont font, int group_size, int seed) throws Exception  
    {
        String compressorDuringOptimization = "pletter";
        String targetCompressor = "zx0";
        Random r = new Random();
        r.setSeed(seed);

        List<String> lines = new ArrayList<>();
        lines.addAll(input_lines);
        Collections.shuffle(lines, r);
        int initial_size = EncodeText.estimateSizeOfAllTextBanks(lines, font, group_size, compressorDuringOptimization);
        int best = initial_size;
        System.out.println("Original order size: " + initial_size + " (with target compressor: " + 
                EncodeText.estimateSizeOfAllTextBanks(lines, font, group_size, targetCompressor) + ")");
        System.out.println("Initial size (seed " + seed + "):" + initial_size);

        double threshold = 1.0; // 1.0 means doing it sistematically, lower values run faster, but might not result in the best results
        double temperature = 0.0;
        double temperature_decay = 0.8;
        boolean repeat = true;
        // boolean repeat = false;
        while(repeat){
            repeat = false;
            System.out.println("temperature: " + temperature);
            for(int idx1 = 0;idx1<lines.size();idx1++) {
                // System.out.println(idx1 + "");
                for(int idx2 =idx1+1;idx2<lines.size();idx2++) {
                    if (r.nextDouble() > threshold) continue;
                    String tmp1 = lines.get(idx1);
                    String tmp2 = lines.get(idx2);
                    lines.set(idx1, tmp2);
                    lines.set(idx2, tmp1);

                    int size = EncodeText.estimateSizeOfAllTextBanks(lines, font, group_size, compressorDuringOptimization);
                    if (size < best) {
                        System.out.print(size + " ");
                        best = size;
                        repeat = true;
                    } else if (size == best && r.nextDouble() > 0.5) {
                        System.out.print(size + "* ");
                        best = size;
                        // repeat = true;
                    } else {
                        if (r.nextDouble() > temperature) {
                            // undo the swap:
                            lines.set(idx1, tmp1);
                            lines.set(idx2, tmp2);
                        } else {
                            System.out.println("- temperature ("+temperature+") induced random swap: " + size);
                            best = size;
                            repeat = true;                            
                        }
                    }
                }
            }
            System.out.println("");
            temperature *= temperature_decay;
            /*
            if (!repeat && !compressorDuringOptimization.equals(targetCompressor)) {
                // At the end do one round with the target compressor:
                compressorDuringOptimization = targetCompressor;
                best = EncodeText.estimateSizeOfAllTextBanks(lines, font, group_size, targetCompressor);
                repeat = true;
            }*/
            // repeat = false;
        }
        
        // System.out.println(lines);
        System.out.println("After optimization: " + EncodeText.estimateSizeOfAllTextBanks(lines, font, group_size, targetCompressor));
        
        return new Pair<>(lines, best);
    }
}
