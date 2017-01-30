with Touch;

with Screen_Interface; use Screen_Interface;

with Last_Chance_Handler; pragma Unreferenced (Last_Chance_Handler);

procedure Main
is
   type Tile is (Empty, Wall, Snake_Up, Snake_Down, Snake_left, Snake_Right);

   Div : constant Natural := 8;

   subtype MapCoord is Natural range Width'First / Div .. (Width'Last + 1) / Div - 1;

   type Screen is array (
     MapCoord range MapCoord'First .. MapCoord'Last,
     MapCoord range MapCoord'First .. MapCoord'Last) of Tile;

   type Coord is record
      X : MapCoord;
      Y : MapCoord;
   end record;

   Map : Screen := (others => (others => Empty));

   Head : Coord := (X => (MapCoord'Last + MapCoord'First) / 2 + 3,
                    Y => (MapCoord'Last + MapCoord'First) / 2);
   Tail : Coord := (X => (MapCoord'Last + MapCoord'First) / 2 - 3,
                    Y => (MapCoord'Last + MapCoord'First) / 2);

   procedure DrawTile (Map : Screen; X : MapCoord; Y : MapCoord) is
   begin
      case Map (X, Y) is
         when Empty =>
            for J in Y * Div .. (Y + 1) * Div - 1 loop
               for I in X * Div .. (X + 1) * Div - 1 loop
                  Set_Pixel ((I, J), White);
               end loop;
            end loop;
         when Wall =>
            for J in Y * Div .. (Y + 1) * Div - 1 loop
               for I in X * Div .. (X + 1) * Div - 1 loop
                  Set_Pixel ((I, J), Black);
               end loop;
            end loop;
         when Snake_Up .. Snake_Right =>
            for J in Y * Div .. (Y + 1) * Div - 1 loop
               for I in X * Div .. (X + 1) * Div - 1 loop
                  Set_Pixel ((I, J), Blue);
               end loop;
            end loop;
         when others => null;
      end case;
   end DrawTile;

begin
   Screen_Interface.Initialize;

   for X in Head.X .. Tail.X loop
      Map (X, Head.Y) := Snake_Down;
   end loop;

   for Y in MapCoord'Range loop
      Map (MapCoord'First, Y) := Wall;
      Map (MapCoord'Last, Y) := Wall;
   end loop;
   for X in MapCoord'Range loop
      Map (X, MapCoord'First) := Wall;
      Map (X, MapCoord'Last) := Wall;
   end loop;

   Fill_Screen (White);

   loop
      for Y in MapCoord'Range loop
         for X in MapCoord'Range loop
            DrawTile (Map, X, Y);
         end loop;
      end loop;

      for X in Width'Range loop
         Set_Pixel ((X, Width'Last + 1), Black);
      end loop;

      declare
         Last_X : Width := (Width'Last - Width'First) / 2;
         Last_Y : Height := (Height'Last - Height'First) / 2;
         State : Touch.Touch_State;
      begin
         State := Touch.Get_Touch_State;

         if State.Touch_Detected then
            --  Draw cross.
            Last_Y := State.Y;
            Last_X := State.X;
         end if;

         for I in Width loop
            Set_Pixel ((I, Last_Y), Red);
         end loop;
         for I in Height loop
            Set_Pixel ((Last_X, I), Red);
         end loop;
      end;
   end loop;

end Main;
