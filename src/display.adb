with STM32F4.LCD; use STM32F4.LCD;

package body Display is

   procedure Set (P : Point; Col : Color) is
   begin
      STM32F4.LCD.Set_Pixel (STM32F4.LCD.Layer1, P.X, P.Y, Col);
   end Set;

   procedure Clear (Col : Color) is
      FB : constant Frame_Buffer_Access := Get_Frame_Buffer (Layer1);
   begin
      FB.all := (others => Col);
   end Clear;

   procedure Fill (P1, P2 : Point; Col : Color) is
      R : constant Rect := (Width'Min (P1.X, P2.X), Height'Min (P1.Y, P2.Y),
        abs (P1.X - P2.X), abs (P1.Y - P2.Y));
   begin
      Fill (R, Col);
   end Fill;

   procedure Fill (Bounds : Rect; Col : Color) is
      FB : constant Frame_Buffer_Access := Get_Frame_Buffer (Layer1);
   begin
      for Y in Bounds.Y .. Bounds.Y + Bounds.H loop
         for X in Bounds.X .. Bounds.X + Bounds.W loop
            FB.all (Frame_Buffer_Range (Y * STM32F4.LCD.LCD_PIXEL_WIDTH + X)) := Col;
         end loop;
      end loop;
   end Fill;

   function Intersect (R : Rect; P : Point) return Boolean is
   begin
         if P.X >= R.X and P.X <= (R.X + R.W)
            and P.Y >= R.Y and P.Y <= (R.Y + R.H) then
            return True;
         end if;
         return False;
   end Intersect;

begin
   STM32F4.LCD.Initialize;
   STM32F4.LCD.Set_Background (16#00#, 16#00#, 16#00#);
end Display;
