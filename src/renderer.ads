with STM32F4.LCD;

package Renderer is

   subtype Width is STM32F4.LCD.Width;
   subtype Height is STM32F4.LCD.Width; -- Yes, width

   type Buffer_Range is range 0 .. (Width'Last * Width'Last) - 1;
   type Buffer is array (Buffer_Range) of STM32F4.LCD.Pixel with Pack;

   subtype Color is STM32F4.LCD.Pixel;

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

   type Point is record
      X : Width;
      Y : Height;
   end record;

   function "+" (P1, P2 : Point) return Point is (P1.X + P2.X, P1.Y + P2.Y);
   function "-" (P1, P2 : Point) return Point is (P1.X - P2.X, P1.Y - P2.Y);

   procedure Set (P : Point; Col : Color);
   procedure Clear (Col : Color);
   procedure Blit;

end Renderer;
