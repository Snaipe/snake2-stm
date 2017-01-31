with Ada.Unchecked_Conversion;
with Display;

package Maps is

   package Tiles is

      type TileVal is mod 2 ** 8 with Size => 8;

      type Tile is (
        Empty,
        Wall,
        Snake,
        Snake_Up,
        Snake_Down,
        Snake_Up_Down,
        Snake_Left,
        Snake_Up_Left,
        Snake_Down_Left,
        Snake_Right,
        Snake_Up_Right,
        Snake_Down_Right,
        Snake_Left_Right);

      for Tile use (
        Empty              => 16#0#,
        Wall               => 16#10#,
        Snake              => 16#20#,
        Snake_Up           => 16#21#,
        Snake_Down         => 16#22#,
        Snake_Up_Down      => 16#23#,
        Snake_Left         => 16#24#,
        Snake_Up_Left      => 16#25#,
        Snake_Down_Left    => 16#26#,
        Snake_Right        => 16#28#,
        Snake_Up_Right     => 16#29#,
        Snake_Down_Right   => 16#2a#,
        Snake_Left_Right   => 16#2c#);

      for Tile'Size use TileVal'Size;

      function Val (T : Tile) return TileVal is (TileVal (T'Enum_Rep));

      function Rep is new Ada.Unchecked_Conversion
           (Source => TileVal, Target => Tile);

      function Is_Snake (T : Tile) return Boolean
        is ((Val (T) and Val (Snake)) /= 0);

      function Is_Snake_Left (T : Tile) return Boolean
        is ((Val (T) and Val (Snake_Left)) = Val (Snake_Left));

      function Is_Snake_Right (T : Tile) return Boolean
        is ((Val (T) and Val (Snake_Right)) = Val (Snake_Right));

      function Is_Snake_Up (T : Tile) return Boolean
        is ((Val (T) and Val (Snake_Up)) = Val (Snake_Up));

      function Is_Snake_Down (T : Tile) return Boolean
        is ((Val (T) and Val (Snake_Down)) = Val (Snake_Down));

      function "+" (T1, T2 : Tile) return Tile is (Rep (Val (T1) or Val (T2)));
      function "-" (T1, T2 : Tile) return Tile is (Rep (Val (T1) and not Val (T2)));

      pragma Compile_Time_Error (not (
         (TileVal (Snake'Enum_Rep) and TileVal (Snake_Up'Enum_Rep))     /= 0 and then
         (TileVal (Snake'Enum_Rep) and TileVal (Snake_Down'Enum_Rep))   /= 0 and then
         (TileVal (Snake'Enum_Rep) and TileVal (Snake_Left'Enum_Rep))   /= 0 and then
         (TileVal (Snake'Enum_Rep) and TileVal (Snake_Right'Enum_Rep))  /= 0
        ), "Snake subkinds are not masked by Snake");

      pragma Compile_Time_Error (not (
         (TileVal (Snake_Up'Enum_Rep)     and TileVal (Snake_Down'Enum_Rep))  /= TileVal (Snake_Up_Down'Enum_Rep)    and then
         (TileVal (Snake_Left'Enum_Rep)   and TileVal (Snake_Down'Enum_Rep))  /= TileVal (Snake_Down_Left'Enum_Rep)  and then
         (TileVal (Snake_Right'Enum_Rep)  and TileVal (Snake_Down'Enum_Rep))  /= TileVal (Snake_Down_Right'Enum_Rep) and then
         (TileVal (Snake_Left'Enum_Rep)   and TileVal (Snake_Up'Enum_Rep))    /= TileVal (Snake_Up_Left'Enum_Rep)    and then
         (TileVal (Snake_Right'Enum_Rep)  and TileVal (Snake_Up'Enum_Rep))    /= TileVal (Snake_Up_Right'Enum_Rep)   and then
         (TileVal (Snake_Right'Enum_Rep)  and TileVal (Snake_Left'Enum_Rep))  /= TileVal (Snake_Left_Right'Enum_Rep)
        ), "Snake bitwise compositions are invalid");

   end Tiles;

   Div : constant Natural := 8;

   subtype MapCoord is Natural range Display.Width'First / Div .. (Display.Width'Last + 1) / Div - 1;

   type Map is array (
     MapCoord range MapCoord'First .. MapCoord'Last,
     MapCoord range MapCoord'First .. MapCoord'Last) of Tiles.Tile;

   pragma Compile_Time_Error (Map'Length(1) /= Map'Length(2),
     "Map is not a square");

   type MapPoint is record
      X : MapCoord;
      Y : MapCoord;
   end record;

   function "+" (P1, P2 : MapPoint) return MapPoint is (P1.X + P2.X, P1.Y + P2.Y);
   function "-" (P1, P2 : MapPoint) return MapPoint is (P1.X - P2.X, P1.Y - P2.Y);

   function From_String (S : String; Head, Tail : out MapPoint) return Map
      with Pre => S'Length = Map'Length(1) * Map'Length(2);

   procedure Draw_Tile (M : Map; P : MapPoint);
   procedure Draw (M : Map);

   Level1 : constant String :=
      "                              " &
      "                              " &
      "                              " &
      "                              " &
      "                              " &
      "                              " &
      "                              " &
      "                              " &
      "                              " &
      "                              " &
      "                              " &
      "                              " &
      "                              " &
      "            TssssH            " &
      "                              " &
      "                              " &
      "                              " &
      "                              " &
      "                              " &
      "                              " &
      "                              " &
      "                              " &
      "                              " &
      "                              " &
      "                              " &
      "                              " &
      "                              " &
      "                              " &
      "                              ";

   Level2 : constant String :=
      "##############################" &
      "#                            #" &
      "#                            #" &
      "#                            #" &
      "#                            #" &
      "#                            #" &
      "#                            #" &
      "#                            #" &
      "#                            #" &
      "#                            #" &
      "#                            #" &
      "#                            #" &
      "#                            #" &
      "#                            #" &
      "#    ####################    #" &
      "#    ####################    #" &
      "#                            #" &
      "#                            #" &
      "#           TssssH           #" &
      "#                            #" &
      "#                            #" &
      "#                            #" &
      "#                            #" &
      "#                            #" &
      "#                            #" &
      "#                            #" &
      "#                            #" &
      "#                            #" &
      "#                            #" &
      "##############################";

end Maps;
