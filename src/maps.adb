package body Maps is

   package Colors renames Display.Colors;

   function From_String (S : String; Head, Tail : out MapPoint) return Map is
      use Tiles;
      use Display;

      M : Map := (others => (others => Tiles.Empty));

      function From_Char (C : Character) return Tile is
      begin
         case C is
            when '#' => return Wall;
            when 's' | 'T' | 'H' => return Snake;
            when others => return Empty;
         end case;
      end From_Char;

      procedure Snake_Correct (X, Y : MapCoord) is
      begin
         if X - 1 in Width and then Is_Snake (M (X - 1, Y)) then
            M (X, Y) := M (X, Y) + Snake_Left;
         end if;
         if X + 1 in Width and then Is_Snake (M (X + 1, Y)) then
            M (X, Y) := M (X, Y) + Snake_Right;
         end if;
         if Y - 1 in Height and then Is_Snake (M (X, Y - 1)) then
            M (X, Y) := M (X, Y) + Snake_Up;
         end if;
         if Y + 1 in Height and then Is_Snake (M (X, Y + 1)) then
            M (X, Y) := M (X, Y) + Snake_Down;
         end if;
      end Snake_Correct;

   begin
      for I in S'Range loop
         declare
            X : constant Width := (I - 1) mod Map'Length(1);
            Y : constant Height := (I - 1) / Map'Length(1);
         begin
            M (X, Y) := From_Char (S (I));
            case S (I) is
               when 'H'    => Head := (X, Y);
               when 'T'    => Tail := (X, Y);
               when others => null;
            end case;
         end;
      end loop;
      for Y in MapCoord loop
         for X in MapCoord loop
            if M (X, Y) = Snake then
               Snake_Correct (X, Y);
            end if;
         end loop;
      end loop;
      return M;
   end From_String;

   Snake_Color : Display.Color renames Colors.Blue;
   Wall_Color  : Display.Color renames Colors.Black;

   procedure Draw_Tile (M : Map; P : MapPoint) is
      use Display;
      use Maps.Tiles;

      P1 : constant Point := (P.X * Div, P.Y * Div);
      P2 : constant Point := (P1.X + Div - 1, P1.Y + Div - 1);
   begin
      case M (P.X, P.Y) is
         when Empty  => Display.Fill(P1, P2, Colors.White);
         when Wall   => Display.Fill(P1, P2, Wall_Color);
         when others =>
            if Is_Snake (M (P.X, P.Y)) then
               Display.Fill ((P1.X + 2, P1.Y + 2), (P2.X - 2, P2.Y - 2), Snake_Color);

               if Is_Snake_Left (M (P.X, P.Y)) then
                  Display.Fill ((P1.X, P1.Y + 2), (P1.X + 2, P2.Y - 2), Snake_Color);
               end if;
               if Is_Snake_Right (M (P.X, P.Y)) then
                  Display.Fill ((P2.X - 2, P1.Y + 2), (P2.X, P2.Y - 2), Snake_Color);
               end if;
               if Is_Snake_Up (M (P.X, P.Y)) then
                  Display.Fill ((P1.X + 2, P1.Y), (P2.X - 2, P1.Y + 2), Snake_Color);
               end if;
               if Is_Snake_Down (M (P.X, P.Y)) then
                  Display.Fill ((P1.X + 2, P2.Y - 2), (P2.X - 2, P2.Y), Snake_Color);
               end if;
            end if;
      end case;
   end Draw_Tile;

   procedure Draw (M : Map) is
   begin
      for Y in MapCoord'Range loop
         for X in MapCoord'Range loop
            Draw_Tile (M, (X, Y));
         end loop;
      end loop;
   end Draw;

end Maps;
