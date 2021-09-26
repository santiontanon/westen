/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package westen;

/**
 *
 * @author santi
 */
public class Main {
    public static void main(String args[]) throws Exception
    {
        Floor.main(args);
        Walls.main(args);
        Doors.main(args);
        Objects.main(args);
        Rooms.main(args);  // This should be called after "Objects"
        Sprites.main(args);
        Hud.main(args);
        Text.main(args);
        TextES.main(args);
        Enemies.main(args);
        Inventory.main(args);
    }
}
