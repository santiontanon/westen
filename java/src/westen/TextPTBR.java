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
 * @author jannone
 */
public class TextPTBR {
    public static PAKFont font = null;
            
    public static void main(String args[]) throws Exception
    {
        List<String> characters = new ArrayList<>();
        characters.add(" !/@'()?,-.");
        characters.add("0123456789:");
        characters.add("ABCDEFGHIJKLMNO");
        characters.add("PQRSTUVWXYZ");
        characters.add("abcdefghijklmno");
        characters.add("pqrstuvwxyzáéíóú");
        characters.add("ÉÇãàõç");
        font = new PAKFont("data/font-ptbr.png", characters);   
        font.generateAssemblerData("src/autogenerated/font-ptbr");
        
        font.printFontInfo();
                
        // Text lines:
        List<String> lines = new ArrayList<>();
        
        HashMap<String,String> lines_with_constant = new HashMap<>();
//        addLineSafe(lines_with_constant, "BRAIN GAMES", "BRAIN_GAMES");
        addLineSafe(lines_with_constant, "Apresenta", "PRESENTS", 8);

        addLineSafe(lines_with_constant, "Londres, 1898", "INTRO_MSG1", 8);
        addLineSafe(lines_with_constant, "Ding Dong!", "INTRO_MSG2", 8);
        addLineSafe(lines_with_constant, "Estou indo!", "INTRO_MSG3", 8);
        addLineSafe(lines_with_constant, "Carta para você, Professor.", "INTRO_MSG4", 16);
        addLineSafe(lines_with_constant, "Obrigado, Richard!", "INTRO_MSG5", 12);
        addLineSafe(lines_with_constant, "Vejamos o que diz...", "INTRO_MSG6", 16);
        addLineSafe(lines_with_constant, "Péssima notícia!", "INTRO_MSG7", 12);
        addLineSafe(lines_with_constant, "JW era um amigo querido!", "INTRO_MSG8", 12);
        addLineSafe(lines_with_constant, "Preciso ir imediatamente!", "INTRO_MSG9", 14);
        
        addLineSafe(lines_with_constant, "Caro Professor Edward Kelvin","LETTER1_LINE1", 28);
        addLineSafe(lines_with_constant, "Lamentamos informar da morte de Jonathan","LETTER1_LINE2", 28);
        addLineSafe(lines_with_constant, "Westen, falecido a 16 de Outubro. Em testamento, o Sr.","LETTER1_LINE3", 28);
        addLineSafe(lines_with_constant, "Westen deixou-lhe seu caderno científico. Além","LETTER1_LINE4", 28);
        addLineSafe(lines_with_constant, "de uma carta, aqui incluída.","LETTER1_LINE5", 28);
        addLineSafe(lines_with_constant, "Também informamos que a Sra. Lucy Westen pretende","LETTER1_LINE6", 28);
        addLineSafe(lines_with_constant, "tomar posse da casa no dia 1 de Dezembro.","LETTER1_LINE7", 28);

        
//        addLineSafe(lines_with_constant, "Dear Ed.","LETTER2_LINE1");
        addLineSafe(lines_with_constant, "Se estiver lendo isto, estou provavelmente","LETTER2_LINE2", 24);
        addLineSafe(lines_with_constant, "morto. Você deve apanhar meu caderno","LETTER2_LINE3", 24);
        addLineSafe(lines_with_constant, "antes que minha irmã Lucy apodere-se","LETTER2_LINE4", 24);
        addLineSafe(lines_with_constant, "da casa. Apenas você será capaz de","LETTER2_LINE5", 24);
        addLineSafe(lines_with_constant, "entendê-lo! Aqui está a chave para","LETTER2_LINE6", 24);
        addLineSafe(lines_with_constant, "a mansão Westen, e parte de uma chave","LETTER2_LINE7", 24);
        addLineSafe(lines_with_constant, "necessária para entrar em meu laboratório.","LETTER2_LINE8", 24);
        addLineSafe(lines_with_constant, "Por favor, é muito importante.","LETTER2_LINE9", 24);
//        addLineSafe(lines_with_constant, "JW","LETTER2_LINE10");
        
        addLineSafe(lines_with_constant, "Cofre: 15-30-10", "LETTER3_LINE1_SECRET", 9);
        addLineSafe(lines_with_constant, "Querido Ed,", "LETTER3_LINE1", 22);
        addLineSafe(lines_with_constant, "Espero que encontre isto antes dos meus", "LETTER3_LINE2", 22);
        addLineSafe(lines_with_constant, "familiares. Contém o segredo da segunda metade", "LETTER3_LINE3", 22);
        addLineSafe(lines_with_constant, "da chave que já possui.", "LETTER3_LINE4", 22);
        addLineSafe(lines_with_constant, "Usei tinta de limão. Você saberá o que fazer.", "LETTER3_LINE5", 22);
        addLineSafe(lines_with_constant, "Logo compreenderá o sigilo.", "LETTER3_LINE6", 22);
        addLineSafe(lines_with_constant, "JW", "LETTER3_LINE7", 22);
        
//        addLineSafe(lines_with_constant, "Dear Ed,", "LETTER4_LINE1");
        addLineSafe(lines_with_constant, "Agora que viu a casa com os próprios olhos,", "LETTER4_LINE2", 24);
        addLineSafe(lines_with_constant, "já deve ter adivinhado. Meu sobrenome", "LETTER4_LINE3", 24);
        addLineSafe(lines_with_constant, "não é Westen, mas sim Westenra.", "LETTER4_LINE4", 24);
        addLineSafe(lines_with_constant, "Ocultamos nossos nomes para proteger a minha irmã.", "LETTER4_LINE5", 24);
        addLineSafe(lines_with_constant, "Como deve se lembrar, Lucy Westenra sofreu", "LETTER4_LINE6", 24);
        addLineSafe(lines_with_constant, "um terrível acidente dois anos atrás", "LETTER4_LINE7", 24);
        addLineSafe(lines_with_constant, "ao encontrar com uma criatura a que chamam de vampiro.", "LETTER4_LINE8", 24);
        addLineSafe(lines_with_constant, "Agora são todos vampiros, Ed!", "LETTER4_LINE9", 24);
        addLineSafe(lines_with_constant, "Ela não morreu como diz a notícia, e ela", "LETTER4_LINE10", 24);
        addLineSafe(lines_with_constant, "não está sozinha. Mas eu tenho um plano. Sei como", "LETTER4_LINE11", 24);
        addLineSafe(lines_with_constant, "matá-los. Procure seus caixões, onde dormem.", "LETTER4_LINE12", 24);
        addLineSafe(lines_with_constant, "Esfregue-os com alho antes que eles", "LETTER4_LINE13", 24);
        addLineSafe(lines_with_constant, "cheguem, e eles perecerão durante o sono!", "LETTER4_LINE14", 24);
        addLineSafe(lines_with_constant, "Mas seja rápido! Faça-o antes que cheguem!", "LETTER4_LINE15", 24);
        addLineSafe(lines_with_constant, "Caso contrário será arriscado matá-los,", "LETTER4_LINE16", 24);
        addLineSafe(lines_with_constant, "pois precisará cravar-lhes no coração", "LETTER4_LINE17", 24);
        addLineSafe(lines_with_constant, "uma estaca ungida em alho enquanto dormem.", "LETTER4_LINE18", 24);
        addLineSafe(lines_with_constant, "Espero que não precise recorrer a isto!", "LETTER4_LINE19", 24);
        addLineSafe(lines_with_constant, "Boa sorte! JW", "LETTER4_LINE20", 24);
        
        addLineSafe(lines_with_constant, "P.S.:", "LETTER5_LINE0", 24);
        addLineSafe(lines_with_constant, "Os vampiros da minha família dormem em", "LETTER5_LINE1", 24);
        addLineSafe(lines_with_constant, "caixões no porão de casa. Reparei que", "LETTER5_LINE2", 24);
        addLineSafe(lines_with_constant, "trancam suas portas com cadeados de combinação.", "LETTER5_LINE3", 24);
        addLineSafe(lines_with_constant, "Creio que tenham usado seus nomes vampíricos como", "LETTER5_LINE4", 24);
        addLineSafe(lines_with_constant, "senha. Vampiros mantém seus nomes", "LETTER5_LINE5", 24);
        addLineSafe(lines_with_constant, "em segredo, mas poderá achar pistas", "LETTER5_LINE6", 24);
        addLineSafe(lines_with_constant, "nos diários e outras anotações", "LETTER5_LINE7", 24);
        addLineSafe(lines_with_constant, "que encontrará pela casa.", "LETTER5_LINE8", 24);

        addLineSafe(lines_with_constant, "Diário de John Seward.", "DIARY1_LINE1", 24);
        addLineSafe(lines_with_constant, "...", "DIARY1_LINE2", 24);
        addLineSafe(lines_with_constant, "7 de Julho de 1897", "DIARY1_LINE3", 24);
        addLineSafe(lines_with_constant, "Sra. Lucy finalmente me fez parte de seu círculo", "DIARY1_LINE4", 24);
        addLineSafe(lines_with_constant, "íntimo! Começarei a adotar o nome deste mês", "DIARY1_LINE5", 24);
        addLineSafe(lines_with_constant, "como o meu próprio para lembrar da ocasião!", "DIARY1_LINE6", 24);

        addLineSafe(lines_with_constant, "Diário de Arthur Holmwood.", "DIARY2_LINE1", 24);
//        addLineSafe(lines_with_constant, "...", "DIARY2_LINE2", 24);
        addLineSafe(lines_with_constant, "26 de Junho de 1897", "DIARY2_LINE3", 24);
        addLineSafe(lines_with_constant, "Minha amada finalmente me converteu. Isto é", "DIARY2_LINE4", 24);
        addLineSafe(lines_with_constant, "emocionante! Preciso escolher um nome agora.", "DIARY2_LINE5", 24);
        addLineSafe(lines_with_constant, "Acho que vou escolher seu nome de família para", "DIARY2_LINE6", 24);
        addLineSafe(lines_with_constant, "mostrar minha devoção.", "DIARY2_LINE7", 24);
        
        addLineSafe(lines_with_constant, "Santiago Ontañón 2021", "CREDITS", 16);
        addLineSafe(lines_with_constant, "ESPAÇO para iniciar", "START", 16);
        addLineSafe(lines_with_constant, "M para instruções", "CONTROLS", 16);
        
        addLineSafe(lines_with_constant, "Game Over", "GAME_OVER", 8);

        addLineSafe(lines_with_constant, "Joystick / cursores: caminhar.", "TUTORIAL1_LINE1", 17);
        addLineSafe(lines_with_constant, "Botão 1 / espaço: saltar.", "TUTORIAL1_LINE2", 17);
        addLineSafe(lines_with_constant, "Q troca mapeamento de direções.", "TUTORIAL1_LINE3", 17);

        addLineSafe(lines_with_constant, "Segurando Botão 2 / M:", "TUTORIAL2_LINE1", 18);
        addLineSafe(lines_with_constant, "- Joystick / cursores para", "TUTORIAL2_LINE2", 18);
        addLineSafe(lines_with_constant, "  selecionar itens do inventário,", "TUTORIAL2_LINE3", 18);
        addLineSafe(lines_with_constant, "- Botão 1 / espaço para usar.", "TUTORIAL2_LINE4", 18);
        
        addLineSafe(lines_with_constant, "Empurre alguns objetos", "TUTORIAL3_LINE1", 17);
        addLineSafe(lines_with_constant, "caminhando contra eles.", "TUTORIAL3_LINE2", 17);

        addLineSafe(lines_with_constant, "Interagir com objetos: aproxime-se", "TUTORIAL4_LINE1", 20);
        addLineSafe(lines_with_constant, "com item vazio selecionado", "TUTORIAL4_LINE2", 20);
        addLineSafe(lines_with_constant, "e aperte Botão 1 / espaço", "TUTORIAL4_LINE3", 20);
        addLineSafe(lines_with_constant, "segurando o Botão 2 / M.", "TUTORIAL4_LINE4", 20);
        addLineSafe(lines_with_constant, "Para pegar: faça o mesmo", "TUTORIAL4_LINE5", 20);
        addLineSafe(lines_with_constant, "estando sobre o objeto.", "TUTORIAL4_LINE6", 20);
        
        addLineSafe(lines_with_constant, "Acabei de chegar a mansão Westen.", "GAME_START_MESSSAGE1", 19);
        addLineSafe(lines_with_constant, "Agora é procurar o caderno de JW!", "GAME_START_MESSSAGE2", 19);        
        
        addLineSafe(lines_with_constant, "Deixarei as banquetas para trás.", "DROP_STOOLS", 19);
        addLineSafe(lines_with_constant, "Uma nota de JW! Vamos ler!", "LETTER3", 19);

        addLineSafe(lines_with_constant, "Nada aqui para usar ou pegar.", "USE_ERROR", 19);
        addLineSafe(lines_with_constant, "Não vejo uma fechadura adequada.", "ITEM_KEY", 19);
        addLineSafe(lines_with_constant, "Parece ser a chave para um baú.", "ITEM_KEY_GUN", 19);
        addLineSafe(lines_with_constant, "Preciso achar a outra metade.", "ITEM_HALF_KEY", 19);
        addLineSafe(lines_with_constant, "Uma garrafa de óleo para lamparina.", "ITEM_OIL", 19);
        addLineSafe(lines_with_constant, "Recarregarei a lamparina com este óleo.", "ITEM_OIL_USED", 19);
        addLineSafe(lines_with_constant, "Uma lamparina. Está sem óleo.", "ITEM_LAMP", 19);
        addLineSafe(lines_with_constant, "Uma lamparina à óleo acesa.", "ITEM_LAMP_ON", 19);
        addLineSafe(lines_with_constant, "O calor da lamparina está revelando", "USE_LAMP1", 19);
        addLineSafe(lines_with_constant, "a tinta de limão na carta!", "USE_LAMP2", 19);
        addLineSafe(lines_with_constant, "Não há nada por trás desta pintura.", "USE_PAINTING", 19);
        addLineSafe(lines_with_constant, "Veja! Um cofre atrás da pintura!", "USE_PAINTING_SAFE", 19);
        addLineSafe(lines_with_constant, "Não sei a combinação.", "USE_SAFE", 19);
        addLineSafe(lines_with_constant, "A-há! O código da carta funcionou!", "USE_SAFE_OPEN1", 19);
        addLineSafe(lines_with_constant, "Não há nada mais por dentro.", "USE_SAFE_OPEN2", 19);
        addLineSafe(lines_with_constant, "As duas metades encaixam perfeitamente!", "MERGE_RED_KEY", 19);
        addLineSafe(lines_with_constant, "Há uma página solta.", "USE_BOOK", 19);
        addLineSafe(lines_with_constant, "Não quero deixar a vela aqui.", "USE_CANDLE", 19);
        
        addLineSafe(lines_with_constant, "Quincey Morris, 1862 - 1897", "USE_TOMBSTONE", 19);
        addLineSafe(lines_with_constant, "Esta porta está trancada.", "USE_DOOR", 19);
        addLineSafe(lines_with_constant, "Vários livros de ocultismo.", "USE_BOOK_STACK", 19);
        addLineSafe(lines_with_constant, "Este baú é apenas decorativo.", "USE_CHEST", 19);
        addLineSafe(lines_with_constant, "Não estou a fim de ir agora.", "USE_TOILET", 19);
        addLineSafe(lines_with_constant, "Não há tempo para tomar banho!", "USE_BATHTUB", 19);
        addLineSafe(lines_with_constant, "Um belo gramofone.", "USE_GRAMOPHONE", 19);
        addLineSafe(lines_with_constant, "Um violino. Não sei tocar.", "USE_VIOLIN", 19);
        addLineSafe(lines_with_constant, "Não preciso lavar as mãos.", "USE_SINK", 19);
        addLineSafe(lines_with_constant, "Esta janela não abre.", "USE_WINDOW", 19);
        addLineSafe(lines_with_constant, "Um caixão de aspecto refinado.", "USE_COFFIN", 19);
        addLineSafe(lines_with_constant, "Estes são restos humanos!", "USE_BONES", 19);  
        addLineSafe(lines_with_constant, "O baú está agora trancado.", "USE_CHEST_GUN1", 19);
        addLineSafe(lines_with_constant, "Não há mais nada neste baú.", "USE_CHEST_GUN2", 19);
        addLineSafe(lines_with_constant, "A chave abriu o baú.", "TAKE_GUN1", 19);
        addLineSafe(lines_with_constant, "Havia um revólver dentro!", "TAKE_GUN2", 19);
        
        addLineSafe(lines_with_constant, "Um livro contábil. Porém, ao", "USE_BOOK_WESTENRA1", 19);
        addLineSafe(lines_with_constant, "invés de Westen, são finanças", "USE_BOOK_WESTENRA2", 19);
        addLineSafe(lines_with_constant, "da família Westenra. Hmm...", "USE_BOOK_WESTENRA3", 19);
        
        addLineSafe(lines_with_constant, "É o diário de Lucy Westenra. Tem", "USE_DIARY3_1", 19);
        addLineSafe(lines_with_constant, "a maioria das páginas arrancadas,", "USE_DIARY3_2", 19);
        addLineSafe(lines_with_constant, "mas encontrei uma chave dentro.", "USE_DIARY3_3", 19);

        addLineSafe(lines_with_constant, "Lucy Westen é Lucy Westenra!", "USE_LAB_NOTES_1", 19);
        addLineSafe(lines_with_constant, "É pior do que eu imaginava!!", "USE_LAB_NOTES_2", 19);
        addLineSafe(lines_with_constant, "Preciso correr e achar alho!", "USE_LAB_NOTES_3", 19);

        addLineSafe(lines_with_constant, "Este caixote parece fraco...", "USE_BREAKABLE_CRATE", 19);
        addLineSafe(lines_with_constant, "Nada que eu possa quebrar por perto.", "USE_HAMMER1", 19);
        addLineSafe(lines_with_constant, "Destruí com o martelo!", "USE_HAMMER2", 19);

        addLineSafe(lines_with_constant, "Um dente de alho.", "USE_GARLIC1", 19);
        addLineSafe(lines_with_constant, "Esfreguei o alho na estaca.", "USE_GARLIC2", 19);
        addLineSafe(lines_with_constant, "Uma estaca de madeira.", "USE_STAKE", 19);
        addLineSafe(lines_with_constant, "Estaca de madeira esfregada com alho.", "USE_RUBBED_STAKE", 19);
        addLineSafe(lines_with_constant, "Agora não! O vampiro está acordado!", "USE_RUBBED_STAKE_AWAKE", 19);
        addLineSafe(lines_with_constant, "Preciso chegar mais perto!", "USE_RUBBED_STAKE_TOO_FAR", 19);
        addLineSafe(lines_with_constant, "Funcionou! Está morto!", "USE_RUBBED_STAKE_KILL", 19);

        addLineSafe(lines_with_constant, "A porta tem um cadeado de combinação.", "USE_VAMPIRE_DOOR", 19);
        
        addLineSafe(lines_with_constant, "Que estranho, esta parte da casa", "MSG_ABANDONED1", 19);
        addLineSafe(lines_with_constant, "parece abandonada...", "MSG_ABANDONED2", 19);

        addLineSafe(lines_with_constant, "Esta sala está cheia de livros", "MSG_BOOKS1", 19);
        addLineSafe(lines_with_constant, "sobre artes ocultas!", "MSG_BOOKS2", 19);
        addLineSafe(lines_with_constant, "Por que JW teria isto?!", "MSG_BOOKS3", 19);

        addLineSafe(lines_with_constant, "Que isso?! Estaria JW a conduzir", "MSG_PENTAGRAM1", 19);
        addLineSafe(lines_with_constant, "rituais satânicos?!", "MSG_PENTAGRAM2", 19);

        addLineSafe(lines_with_constant, "A porta abriu! Pensei estar procurando", "MSG_PENTAGRAM_SOLVED1", 19);
        addLineSafe(lines_with_constant, "o caderno de JW, mas esta casa", "MSG_PENTAGRAM_SOLVED2", 19);
        addLineSafe(lines_with_constant, "é mais estranha do que imaginava!", "MSG_PENTAGRAM_SOLVED3", 19);
        
        addLineSafe(lines_with_constant, "Restos humanos!", "MSG_FEEDING1", 19);
        addLineSafe(lines_with_constant, "Ok, agora está claro que algo", "MSG_FEEDING2", 19);
        addLineSafe(lines_with_constant, "macabro acontece nesta casa!", "MSG_FEEDING3", 19);

        addLineSafe(lines_with_constant, "Finalmente! O laboratório de JW!", "MSG_LAB", 19);

        addLineSafe(lines_with_constant, "Espere, ouço barulhos na entrada!", "MSG_FAMILY_CUTSCENE1", 19);
        addLineSafe(lines_with_constant, "Arthur: Finalmente! Aquele seu irmão morreu!", "MSG_FAMILY_CUTSCENE2", 31);
        addLineSafe(lines_with_constant, "Lucy: Sim! A casa agora é minha!", "MSG_FAMILY_CUTSCENE3", 31);
        addLineSafe(lines_with_constant, "Lucy: Ansiava tanto entrar em meu porão em paz!", "MSG_FAMILY_CUTSCENE4", 31);
        addLineSafe(lines_with_constant, "Lucy: Nesta casa, construiremos nossa família!!", "MSG_FAMILY_CUTSCENE5", 31);
        addLineSafe(lines_with_constant, "Lucy: Hoje somos apenas nós, mas amanhã seremos mais!!", "MSG_FAMILY_CUTSCENE6", 31);
        addLineSafe(lines_with_constant, "Lucy: Hahaha", "MSG_FAMILY_CUTSCENE7A", 31);
        addLineSafe(lines_with_constant, "John: Hahaha", "MSG_FAMILY_CUTSCENE7B", 31);
        addLineSafe(lines_with_constant, "Arthur: Hahaha", "MSG_FAMILY_CUTSCENE7C", 31);
        addLineSafe(lines_with_constant, "Lucy: Bem, já chega! Vamos descansar!", "MSG_FAMILY_CUTSCENE8", 31);

        addLineSafe(lines_with_constant, "Não acredito no que vejo!", "MSG_FAMILY_CUTSCENE9", 19);
        addLineSafe(lines_with_constant, "Já estão aqui! Cheguei tarde!", "MSG_FAMILY_CUTSCENE10", 19);
        addLineSafe(lines_with_constant, "Terei de usar as estacas...", "MSG_FAMILY_CUTSCENE11", 19);
        
        addLineSafe(lines_with_constant, "Abriu!", "OPEN_VAMPIRE1_DOOR", 19);
        addLineSafe(lines_with_constant, "Não preciso mais deste diário...", "OPEN_VAMPIRE1_DOOR2", 19);
        addLineSafe(lines_with_constant, "Um vampiro!", "ENTER_VAMPIRE_ROOM1", 19);
        addLineSafe(lines_with_constant, "Vou me aproximar enquanto dorme...", "ENTER_VAMPIRE_ROOM2", 19);

        addLineSafe(lines_with_constant, "Deve ser a Lucy!", "ENTER_VAMPIRE3_ROOM1", 19);
        addLineSafe(lines_with_constant, "Consegui! Lucy está morta!", "ENTER_VAMPIRE3_ROOM2", 19);
        
        addLineSafe(lines_with_constant, "Achei uma nota no cadáver.", "FIND_VAMPIRE_NOTE", 19);
        
        addLineSafe(lines_with_constant, "Lista de afazeres de John Seward:", "VAMPIRE1_NOTE1", 24);
        addLineSafe(lines_with_constant, "- Matar JW (feito)", "VAMPIRE1_NOTE2", 24);
        addLineSafe(lines_with_constant, "- Achar meu diário", "VAMPIRE1_NOTE3", 24);
        addLineSafe(lines_with_constant, "- Agradecer Lucy por usar nossas iniciais", "VAMPIRE1_NOTE4", 24);
        addLineSafe(lines_with_constant, "  em seu nome vampírico. Uma grande", "VAMPIRE1_NOTE5", 24);
        addLineSafe(lines_with_constant, "  honra para nós três!", "VAMPIRE1_NOTE6", 24);

        addLineSafe(lines_with_constant, "Lucy, por que usou as iniciais", "VAMPIRE2_NOTE1", 22);
        addLineSafe(lines_with_constant, "daqueles dois também? Sou seu marido!", "VAMPIRE2_NOTE2", 22);        
        addLineSafe(lines_with_constant, "Ao menos ponha a minha no início...", "VAMPIRE2_NOTE3", 22);
        addLineSafe(lines_with_constant, "Arthur Holmwood", "VAMPIRE2_NOTE4", 22);
                        
        addLineSafe(lines_with_constant, "2 de Dezembro de 1898", "ENDING_LINE1", 17);
        
        addLineSafe(lines_with_constant, "Ainda não sei como me sinto", "ENDING_LINE2", 17);
        addLineSafe(lines_with_constant, "em relação aos eventos que", "ENDING_LINE3", 17);
        addLineSafe(lines_with_constant, "sucederam na mansão Westen...", "ENDING_LINE4", 17);
        addLineSafe(lines_with_constant, "Digo, Westenra...", "ENDING_LINE5", 17);

        addLineSafe(lines_with_constant, "Apesar do alívio em livrar", "ENDING_LINE6", 17);
        addLineSafe(lines_with_constant, "o mundo daquelas bestas,", "ENDING_LINE7", 17);
        addLineSafe(lines_with_constant, "e sair vivo desta, fico", "ENDING_LINE8", 17);
        addLineSafe(lines_with_constant, "triste em saber que meu", "ENDING_LINE9", 17);
        addLineSafe(lines_with_constant, "bom amigo se foi por", "ENDING_LINE10", 17);
        addLineSafe(lines_with_constant, "culpa de tais criaturas...", "ENDING_LINE11", 17);

        addLineSafe(lines_with_constant, "Espero nunca mais ter de", "ENDING_LINE12", 17);
        addLineSafe(lines_with_constant, "retornar a esta casa...", "ENDING_LINE13", 17);

        addLineSafe(lines_with_constant, "Professor Edward Kelvin", "ENDING_LINE14", 17);

        addLineSafe(lines_with_constant, "Obrigado por jogar", "ENDING2_LINE1", 17);
        addLineSafe(lines_with_constant, "Westen House", "ENDING2_LINE2", 17);
        addLineSafe(lines_with_constant, "Santiago Ontañón, 2021", "ENDING2_LINE3", 17);
        addLineSafe(lines_with_constant, "santi.ontanon@gmail.com", "ENDING2_LINE4", 17);
        addLineSafe(lines_with_constant, "Testes Beta: Jordi Sureda", "ENDING2_LINE5", 17);
        
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
