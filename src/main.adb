with Touch;

with STM32F429_Discovery;
with Screen_Interface; use Screen_Interface;
with Maps; use Maps;

with Last_Chance_Handler; pragma Unreferenced (Last_Chance_Handler);

procedure Main
is
   procedure DrawTile (M : Map; X : MapCoord; Y : MapCoord) is
   begin
      case M (X, Y) is
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
   STM32F429_Discovery.Initialize_LEDS;
   Screen_Interface.Initialize;

   STM32F429_Discovery.On (STM32F429_Discovery.Green);

   --for X in Head.X .. Tail.X loop
   --   CurMap (X, Head.Y) := Snake_Down;
   --end loop;

   --for Y in MapCoord'Range loop
   --   CurMap (MapCoord'First, Y) := Wall;
   --   CurMap (MapCoord'Last, Y) := Wall;
   --end loop;
   --for X in MapCoord'Range loop
   --   CurMap (X, MapCoord'First) := Wall;
   --   CurMap (X, MapCoord'Last) := Wall;
   --end loop;

   CurMap := Maps.From_String (Maps.Level2);

   Fill_Screen (White);

   loop
      for Y in MapCoord'Range loop
         for X in MapCoord'Range loop
            DrawTile (CurMap, X, Y);
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

            raise Program_Error;
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
