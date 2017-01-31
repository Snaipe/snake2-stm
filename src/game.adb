with Maps; use Maps;

package body Game is

   use Maps.Tiles;

   type Direction is (Left, Right, Up, Down);
   CurDir : Direction := Right;

   CurMap : Map := (others => (others => Tiles.Empty));
   Head : MapPoint := (0, 0);
   Tail : MapPoint := (0, 0);
   Difficulty : Positive := 1;

   Update_Counter : Natural := 0;

   Counter_Threshold : constant Natural := 100000;

   procedure Load (L : Maps.Levels; D : Positive) is
   begin
      CurMap := Maps.From_String (Maps.Get_Level(L), Head, Tail);
      Difficulty := D;
   end Load;

   procedure Draw is
   begin
      Maps.Draw (CurMap);
   end Draw;

   function Snake_Dir (P : MapPoint; K : out Tile) return MapPoint is
      Lim : constant Natural := Natural (MapCoord'Last) + 1;
      DX : Integer := 0;
      DY : Integer := 0;
   begin
      if Is_Snake_Left (CurMap (P.X, P.Y)) then
         K := Snake_Right;
         DX := -1;
      elsif Is_Snake_Right (CurMap (P.X, P.Y)) then
         K := Snake_Left;
         DX := 1;
      elsif Is_Snake_Up (CurMap (P.X, P.Y)) then
         K := Snake_Down;
         DY := -1;
      elsif Is_Snake_Down (CurMap (P.X, P.Y)) then
         K := Snake_Up;
         DY := 1;
      end if;
      return ((P.X + DX + Lim) mod Lim, (P.Y + DY + Lim) mod Lim);
   end Snake_Dir;

   function Opposite_Tile (T : Tile) return Tile
     with Pre => Is_Snake (T);

   function Opposite_Tile (T : Tile) return Tile is
      Op : Tile := Snake;
   begin
      if Is_Snake_Up (T) then
         Op := Op + Snake_Down;
      end if;
      if Is_Snake_Down (T) then
         Op := Op + Snake_Up;
      end if;
      if Is_Snake_Left (T) then
         Op := Op + Snake_Right;
      end if;
      if Is_Snake_Right (T) then
         Op := Op + Snake_Left;
      end if;
      return Op;
   end Opposite_Tile;

   procedure Next_Head (D : Direction; T : out Tile; P : out MapPoint) is
      Lim : constant Natural := Natural (MapCoord'Last) + 1;
   begin
      case D is
         when Up     => T := Snake_Down;  P := (Head.X, (Head.Y - 1 + Lim) mod Lim);
         when Down   => T := Snake_Up;    P := (Head.X, (Head.Y + 1 + Lim) mod Lim);
         when Left   => T := Snake_Right; P := ((Head.X - 1 + Lim) mod Lim, Head.Y);
         when Right  => T := Snake_Left;  P := ((Head.X + 1 + Lim) mod Lim, Head.Y);
      end case;
   end Next_Head;

   function Update return Victory is
      Pellets : Natural := 0;
      Tail_Tile : Tile;
      New_Tail : constant MapPoint := Snake_Dir (Tail, Tail_Tile);

      Head_Tile : Tile;
      New_Head : MapPoint;
   begin
      if Update_Counter > Counter_Threshold / Difficulty then
         Next_Head (CurDir, Head_Tile, New_Head);

         if Is_Solid (CurMap (New_Head.X, New_Head.Y)) then
            return Lose;
         end if;

         CurMap (Tail.X, Tail.Y) := Empty;
         CurMap (New_Tail.X, New_Tail.Y) := CurMap (New_Tail.X, New_Tail.Y)
                                          - Tail_Tile + Snake;

         CurMap (New_Head.X, New_Head.Y) := Head_Tile;
         CurMap (Head.X, Head.Y) := CurMap (Head.X, Head.Y)
                                 + Opposite_Tile (Head_Tile);

         Maps.Draw_Tile (CurMap, Head);
         Maps.Draw_Tile (CurMap, New_Head);
         Maps.Draw_Tile (CurMap, Tail);
         Maps.Draw_Tile (CurMap, New_Tail);

         Head := New_Head;
         Tail := New_Tail;
         Update_Counter := 0;
      else
         Update_Counter := Update_Counter + 1;
      end if;
      return None;
   end Update;

end Game;
