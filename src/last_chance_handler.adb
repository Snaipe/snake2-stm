with STM32F429_Discovery;  use STM32F429_Discovery;
with Ada.Real_Time;        use Ada.Real_Time;

package body Last_Chance_Handler is

   procedure Last_Chance_Handler (Msg : System.Address; Line : Integer) is
      pragma Unreferenced (Msg, Line);
   begin
      Initialize_LEDs;

      Off (Green);

      loop
         Toggle (Red);
         delay until Clock + Milliseconds (500);
      end loop;
   end Last_Chance_Handler;

end Last_Chance_Handler;
