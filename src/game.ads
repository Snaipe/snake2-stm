with Ada.Real_Time;
with Maps;

package Game is

   type Victory is (None, Win, Lose);

   procedure Load (L : Maps.Levels; D : Positive);
   function Update (T : out Ada.Real_Time.Time) return Victory;
   procedure Draw;

end Game;
