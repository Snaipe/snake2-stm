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

begin
   STM32F4.LCD.Initialize;
   STM32F4.LCD.Set_Background (16#00#, 16#00#, 16#00#);
end Display;
