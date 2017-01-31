package body Maps is

   package Colors renames Display.Colors;

   function From_String (S : String) return Map is
      M : Map := (others => (others => Tiles.Empty));

      function From_Char (C : Character) return Tiles.Tile is
      begin
         case C is
            when '#' => return Tiles.Wall;
            when others => return Tiles.Empty;
         end case;
      end From_Char;
   begin
      for I in S'Range loop
         M ((I - 1) mod Map'Length(1), (I - 1) / Map'Length(1)) := From_Char (S (I));
      end loop;
      return M;
   end From_String;

   procedure DrawTile (M : Map; P : MapPoint) is
      use Display;

      P1 : Point := (P.X * Div, P.Y * Div);
      P2 : Point := (P1.X + Div - 1, P1.Y + Div - 1);
   begin
      case M (P.X, P.Y) is
         when Tiles.Empty =>
            Display.Fill(P1, P2, Colors.White);
         when Tiles.Wall =>
            Display.Fill(P1, P2, Colors.Black);
         when Tiles.Snake_Up .. Tiles.Snake_Right =>
            Display.Fill(P1, P2, Colors.Blue);
         when others => null;
      end case;
   end DrawTile;

   procedure Draw (M : Map) is
   begin
      for Y in MapCoord'Range loop
         for X in MapCoord'Range loop
            DrawTile (CurMap, (X, Y));
         end loop;
      end loop;
   end Draw;

   --procedure Move (M : Map, Dir : Direction)

end Maps;
