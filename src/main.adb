with Touch;

with Display; use Display;
with Maps; use Maps;
with Gui;

with Last_Chance_Handler; pragma Unreferenced (Last_Chance_Handler);

procedure Main
is
   Last_X : Width := (Width'Last - Width'First) / 2;
   Last_Y : Height := (Height'Last - Height'First) / 2;

   package Colors renames Display.Colors;
begin
   CurMap := Maps.From_String (Maps.Level2);

   Clear (Colors.White);

   Maps.Draw (CurMap);

   Gui.Draw;

   loop
      Gui.Update;

      for X in Width'Range loop
         Set ((X, Width'Last + 1), Colors.Black);
      end loop;

      declare
         State : Touch.Touch_State;
      begin
         State := Touch.Get_Touch_State;

         if State.Touch_Detected then
            --  Draw cross.
            Last_Y := State.Y;
            Last_X := State.X;
         end if;

         for I in Width loop
            Set ((I, Last_Y), Colors.Red);
         end loop;
         for I in Height loop
            Set ((Last_X, I), Colors.Red);
         end loop;
      end;
   end loop;

end Main;
