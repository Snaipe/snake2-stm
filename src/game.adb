with Ada.Numerics.Discrete_Random;

with Maps; use Maps;
with Input;

package body Game is

   use Maps.Tiles;

   type Direction is (Left, Right, Up, Down);

   pragma Compile_Time_Error (not (
         Left  = Direction'Val(Input.ButLeft'Enum_Rep) and then
         Right = Direction'Val(Input.ButRight'Enum_Rep) and then
         Up    = Direction'Val(Input.ButUp'Enum_Rep) and then
         Down  = Direction'Val(Input.ButDown'Enum_Rep)
      ), "Directions does not match buttons");

   function Opposite_Dir (Dir : Direction) return Direction is
   begin
      case Dir is
         when Left   => return Right;
         when Right  => return Left;
         when Up     => return Down;
         when Down   => return Up;
      end case;
   end Opposite_Dir;

   CurDir : Direction := Right;
   CurMap : Map := (others => (others => Tiles.Empty));
   Head : MapPoint := (0, 0);
   Tail : MapPoint := (0, 0);
   Difficulty : Positive := 1;
   Score : Natural := 0;

   Has_Bonus : Boolean := False;
   Bonus : MapPoint := (0, 0);
   Bonus_Counter : Natural := 0;
   Bonus_Threshold : constant Natural := 20;

   function Spawn_Fruit (T : Tile) return MapPoint
      with Pre => Maps.Tiles.Is_Food (T);

   function Get_Empty_Slots return Natural is
      C : Natural := 0;
   begin
      for J in MapCoord'Range loop
         for I in MapCoord'Range loop
            if CurMap (I, J) = Empty then
               C := C + 1;
            end if;
         end loop;
      end loop;
      return C;
   end Get_Empty_Slots;

   procedure Load (L : Maps.Levels; D : Positive) is
      P : MapPoint;
      pragma Unreferenced (P);
   begin
      CurMap := Maps.From_String (Maps.Get_Level(L), Head, Tail);
      Difficulty := D;
      P := Spawn_Fruit (Maps.Tiles.Food);
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

   function Spawn_Fruit (T : Tile) return MapPoint is
   begin
      declare
         subtype Slot is Integer range 0 .. Get_Empty_Slots;
         package Random_Slot is new Ada.Numerics.Discrete_Random (Slot);
         use Random_Slot;

         G : Generator;
         S : Slot;
         Cur : Slot := 0;
      begin
         Reset (G);
         S := Random (G);
         for J in MapCoord'Range loop
            for I in MapCoord'Range loop
               if CurMap (I, J) = Empty then
                  if Cur = S then
                     CurMap (I, J) := T;
                     return (I, J);
                  end if;
                  Cur := Cur + 1;
               end if;
            end loop;
         end loop;
         return (0, 0);
      end;
   end Spawn_Fruit;

   function Update (T : out Ada.Real_Time.Time) return Victory is

      use Ada.Real_Time;
      use Input;

      Tail_Tile : Tile;
      New_Tail : MapPoint := Snake_Dir (Tail, Tail_Tile);

      Head_Tile : Tile;
      New_Head : MapPoint;
   begin
      if Score > Difficulty * 20 then
         return Win;
      end if;

      if Bonus_Counter < Bonus_Threshold then
         Bonus_Counter := Bonus_Counter + 1;
      else
         if not Has_Bonus then
            Bonus := Spawn_Fruit (Fruit_1);
            if CurMap (Bonus.X, Bonus.Y) = Fruit_1 then
               Maps.Draw_Tile (CurMap, Bonus);
               Has_Bonus := True;
            end if;
         else
            CurMap (Bonus.X, Bonus.Y) := Empty;
            Maps.Draw_Tile (CurMap, Bonus);
            Has_Bonus := False;
         end if;
         Bonus_Counter := 0;
      end if;

      T := Clock + Milliseconds (500 / Difficulty);

      for I in Direction'Range loop
         if (Is_Pressed (Input.Get (Buttons'Val (I'Enum_Rep)))) and then
           (I /= Opposite_Dir (CurDir)) then
            CurDir := I;
         end if;
      end loop;

      Next_Head (CurDir, Head_Tile, New_Head);

      if Is_Solid (CurMap (New_Head.X, New_Head.Y)) then
         return Lose;
      elsif Is_Food (CurMap (New_Head.X, New_Head.Y)) then
         New_Tail := Tail;
         if New_Head.X = Bonus.X and New_Head.Y = Bonus.Y then
            Bonus_Counter := 0;
            Has_Bonus := False;
            Score := Score + 10;
         else
            Score := Score + 1;
            Maps.Draw_Tile (CurMap, Spawn_Fruit (Food));
         end if;
      else
         CurMap (Tail.X, Tail.Y) := Empty;
         CurMap (New_Tail.X, New_Tail.Y) := CurMap (New_Tail.X, New_Tail.Y)
                                          - Tail_Tile + Snake;
      end if;

      CurMap (New_Head.X, New_Head.Y) := Head_Tile;
      CurMap (Head.X, Head.Y) := CurMap (Head.X, Head.Y)
                              + Opposite_Tile (Head_Tile);

      Maps.Draw (CurMap);

      Head := New_Head;
      Tail := New_Tail;

      return None;
   end Update;

end Game;
