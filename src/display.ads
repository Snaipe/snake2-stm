with STM32F4.LCD;

package Display is

   subtype Width is STM32F4.LCD.Width;
   subtype Height is STM32F4.LCD.Height;

   subtype Color is STM32F4.LCD.Pixel;

   package Colors is
      Black      : Color renames STM32F4.LCD.Black;
      White      : Color renames STM32F4.LCD.White;
      Red        : Color renames STM32F4.LCD.Red;
      Green      : Color renames STM32F4.LCD.Green;
      Blue       : Color renames STM32F4.LCD.Blue;
      Gray       : Color renames STM32F4.LCD.Gray;
      Light_Gray : Color renames STM32F4.LCD.Light_Gray;
      Sky_Blue   : Color renames STM32F4.LCD.Sky_Blue;
      Yellow     : Color renames STM32F4.LCD.Yellow;
      Orange     : Color renames STM32F4.LCD.Orange;
      Pink       : Color renames STM32F4.LCD.Pink;
      Violet     : Color renames STM32F4.LCD.Violet;
   end Colors;

   type Point is record
      X : Width;
      Y : Height;
   end record;

   type Rect is record
      X : Width;
      Y : Height;
      W : Width;
      H : Height;
   end record;

   function "+" (P1, P2 : Point) return Point is (P1.X + P2.X, P1.Y + P2.Y);
   function "-" (P1, P2 : Point) return Point is (P1.X - P2.X, P1.Y - P2.Y);
   function Intersect (R: Rect; P : Point) return Boolean;

   procedure Set (P : Point; Col : Color);
   procedure Clear (Col : Color);
   procedure Fill (P1, P2 : Point; Col : Color);
   procedure Fill (Bounds : Rect; Col : Color);

end Display;
