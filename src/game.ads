with Maps;

package Game is

   type Victory is (None, Win, Lose);

   procedure Load (L : Maps.Levels; D : Positive);
   function Update return Victory;
   procedure Draw;

end Game;
