with Screen_Interface; use Screen_Interface;

package Maps is

   type Tile is (Empty, Wall, Snake_Up, Snake_Down, Snake_left, Snake_Right);

   Div : constant Natural := 8;

   subtype MapCoord is Natural range Width'First / Div .. (Width'Last + 1) / Div - 1;

   type Map is array (
     MapCoord range MapCoord'First .. MapCoord'Last,
     MapCoord range MapCoord'First .. MapCoord'Last) of Tile;

   pragma Compile_Time_Error (Map'Length(1) /= Map'Length(2),
     "Map is not a square");

   type MapPoint is record
      X : MapCoord;
      Y : MapCoord;
   end record;

   function From_String (S : String) return Map
      with Pre => S'Length = Map'Length(1) * Map'Length(2);

   CurMap : Map := (others => (others => Empty));

   Head : MapPoint := (X => (MapCoord'Last + MapCoord'First) / 2 + 3,
                       Y => (MapCoord'Last + MapCoord'First) / 2);
   Tail : MapPoint := (X => (MapCoord'Last + MapCoord'First) / 2 - 3,
                       Y => (MapCoord'Last + MapCoord'First) / 2);

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
      "##############################";

end Maps;
