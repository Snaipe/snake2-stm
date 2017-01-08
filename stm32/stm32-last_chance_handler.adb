with STM32.LEDs; use STM32.LEDs;

package body STM32.Last_Chance_Handler is

   procedure Last_Chance_Handler (Msg : System.Address; Line : Integer) is
      pragma Unreferenced (Msg, Line);
   begin
      Off (Green);
      On (Red);

      pragma Warnings (Off, "*rewritten as loop");
      <<spin>> goto spin;
      pragma Warnings (On, "*rewritten as loop");
   end Last_Chance_Handler;

end STM32.Last_Chance_Handler;
