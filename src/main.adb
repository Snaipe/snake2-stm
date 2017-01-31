with Ada.Real_Time;

with Touch;
with Display;
with Maps;
with Gui;
with Game;

with Last_Chance_Handler; pragma Unreferenced (Last_Chance_Handler);

procedure Main is
   use Maps;
   use Display;

   package Colors renames Display.Colors;
   package RT renames Ada.Real_Time;

   Last_X : Width := (Width'Last - Width'First) / 2;
   Last_Y : Height := (Height'Last - Height'First) / 2;

   Level_Seq : constant array (Level_Range) of Levels := (Level_1, Level_2, Level_3);

   L : Level_Range := 0;
   Difficulty : Natural := 1;

begin
   Clear (Colors.White);

   Game.Load (Level_Seq (L), Difficulty);
   Game.Draw;

   Gui.Draw;

   loop
      declare
         T : RT.Time;
      begin
         case Game.Update (T) is
            when Game.None => null;
            when Game.Win =>
               L := L + 1;
               Difficulty := Difficulty + 1;
               Clear (Colors.White);
               Game.Load (Level_Seq (L), Difficulty);
               Game.Draw;
               Gui.Draw;
            when Game.Lose =>
               L := 0;
               Difficulty := 1;
               Clear (Colors.White);
               Game.Load (Level_Seq (L), Difficulty);
               Game.Draw;
               Gui.Draw;
         end case;
         delay until T;
      end;
   end loop;

end Main;
