with STM32F4.LCD; use STM32F4.LCD;

package body Renderer is

   Buf : Buffer := (others => Black);

   procedure Set (P : Point; Col : Color) is
   begin
      Buf (Buffer_Range(P.Y * Renderer.Width + P.X)) := Col;
   end Set;

   procedure Clear (Col : Color) is
   begin
      Buf := (others => Col);
   end Clear;

   procedure Blit is
      FB : constant Frame_Buffer_Access := Get_Frame_Buffer (Layer1);
   begin
      for E in Buffer_Range'Range loop
         FB.all (Frame_Buffer_Range(E)) := Buf (E);
      end loop;
   end Blit;

begin
   STM32F4.LCD.Initialize;
   STM32F4.LCD.Set_Background (16#00#, 16#00#, 16#00#);
end Renderer;
