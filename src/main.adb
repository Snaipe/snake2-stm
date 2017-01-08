with System;

-- Install last chance handler
with STM32.Last_Chance_Handler;
pragma Unreferenced (STM32.Last_Chance_Handler);

procedure Main is
   pragma Priority (System.Priority'First);
begin
   loop
      null;
   end loop;
end Main;
