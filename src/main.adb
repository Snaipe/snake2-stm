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

   package Colors renames Display.Colors;
begin
   Clear (Colors.White);

   Game.Load (Maps.Level2, 1);
   Game.Draw;

   Gui.Draw;

   loop
      Gui.Update;
      Game.Update;
   end loop;

end Main;
