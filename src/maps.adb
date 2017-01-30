package body Maps is

   function From_String (S : String) return Map is
      M : Map := (others => (others => Empty));

      function From_Char (C : Character) return Tile is
      begin
         case C is
            when '#' => return Wall;
            when others => return Empty;
         end case;
      end From_Char;
   begin
      for I in S'Range loop
         M ((I - 1) mod Map'Length(1), (I - 1) / Map'Length(1)) := From_Char (S (I));
      end loop;
      return M;
   end From_String;

end Maps;
