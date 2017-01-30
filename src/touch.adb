with STM32F4.Touch_Panel;

package body Touch is

   function Get_Touch_State return Touch_State is
      TS : Touch_State;
      ST_TS : STM32F4.Touch_Panel.TP_State;
   begin
     ST_TS := STM32F4.Touch_Panel.Get_State;

      TS.Touch_Detected := ST_TS.Touch_Detected;
      TS.X := ST_TS.X;
      TS.Y := ST_TS.Y;
      return TS;
   end Get_Touch_State;

begin
   STM32F4.Touch_Panel.Initialize;
end Touch;
