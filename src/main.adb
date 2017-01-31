with Touch;

with Display; use Display;
with Maps; use Maps;
with Gui;
with Game;

with Last_Chance_Handler; pragma Unreferenced (Last_Chance_Handler);

procedure Main
is
   Last_X : Width := (Width'Last - Width'First) / 2;
   Last_Y : Height := (Height'Last - Height'First) / 2;

   Level_Seq : constant array (Level_Range) of Levels := (Level_1, Level_2);

   L : Level_Range := 0;

   Difficulty : Natural := 1;

   package Colors renames Display.Colors;
begin
   Clear (Colors.White);

   Game.Load (Level_Seq (L), 1);
   Game.Draw;

   Gui.Draw;

   loop
      Gui.Update;
      case Game.Update is
         when Game.None => null;
         when Game.Win =>
            L := L + 1;
            Game.Load (Level_Seq (L), Difficulty);
            Game.Draw;
            Gui.Draw;
         when Game.Lose =>
            L := 0;
            Difficulty := 1;
            Game.Load (Level_Seq (L), Difficulty);
            Game.Draw;
            Gui.Draw;
      end case;
   end loop;

end Main;
