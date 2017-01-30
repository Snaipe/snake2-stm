with Renderer;
with Touch;

with Screen_Interface; use Screen_Interface;

procedure Main
is
   type Tile is (Empty, Wall, Snake_Up, Snake_Down, Snake_left, Snake_Right);

   Div : constant Natural := 8;

   subtype MapCoord is Natural range Renderer.Width'First / Div .. (Renderer.Width'Last + 1) / Div - 1;

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
                  Renderer.Set ((I, J), Renderer.White);
               end loop;
            end loop;
         when Wall =>
            for J in Y * Div .. (Y + 1) * Div - 1 loop
               for I in X * Div .. (X + 1) * Div - 1 loop
                  Renderer.Set ((I, J), Renderer.Black);
               end loop;
            end loop;
         when Snake_Up .. Snake_Right =>
            for J in Y * Div .. (Y + 1) * Div - 1 loop
               for I in X * Div .. (X + 1) * Div - 1 loop
                  Renderer.Set ((I, J), Renderer.Blue);
               end loop;
            end loop;
         when others => null;
      end case;
   end DrawTile;

begin
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

   loop
      Renderer.Clear (Renderer.White);

      for Y in MapCoord'Range loop
         for X in MapCoord'Range loop
            DrawTile (Map, X, Y);
         end loop;
      end loop;

      for X in Renderer.Width'Range loop
         Set_Pixel ((X, Renderer.Width'Last + 1), Renderer.Black);
      end loop;

      declare
         Last_X : Renderer.Width := (Renderer.Width'Last - Renderer.Width'First) / 2;
         Last_Y : Renderer.Height := (Renderer.Height'Last - Renderer.Height'First) / 2;
         State : Touch.Touch_State;
      begin
         State := Touch.Get_Touch_State;

         if State.Touch_Detected then
            --  Draw cross.
            Last_Y := State.Y;
            Last_X := State.X;
         end if;

         for I in Renderer.Width loop
            Set_Pixel ((I, Last_Y), Renderer.Red);
         end loop;
         for I in Renderer.Height loop
            Set_Pixel ((Last_X, I), Renderer.Red);
         end loop;
      end;
   end loop;

   if True then
      loop
         raise Program_Error;
      end loop;
   else
      while not Touch.Get_Touch_State.Touch_Detected loop
         null;
      end loop;

      Renderer.Clear (Renderer.Gray);

      declare
         Last_X : Renderer.Width := (Renderer.Width'Last - Renderer.Width'First) / 2;
         Last_Y : Renderer.Height := (Renderer.Height'Last - Renderer.Height'First) / 2;
         State : Touch.Touch_State;
      begin
         loop
            loop
               State := Touch.Get_Touch_State;
               exit when State.Touch_Detected
                 and then (State.X /= Last_X or State.Y /= Last_Y);
            end loop;

            --  Clear cross.
            for I in Renderer.Width loop
               Renderer.Set ((I, Last_Y), Renderer.Gray);
            end loop;
            for I in Renderer.Height loop
               Renderer.Set ((Last_X, I), Renderer.Gray);
            end loop;

            --  Draw cross.
            Last_Y := State.Y;
            Last_X := State.X;

            for I in Renderer.Width loop
               Renderer.Set ((I, Last_Y), Renderer.Red);
            end loop;
            for I in Renderer.Height loop
               Renderer.Set ((Last_X, I), Renderer.Red);
            end loop;
         end loop;
      end;
   end if;

end Main;
