package body Input is

   function Get (B : Buttons) return State is
   begin
      return Keys (B'Enum_Rep);
   end Get;

   procedure Update (isTouched : Boolean) is
   begin
         for I in Keys'Range loop
             Update_State (Keys (I), IsTouched);
         end loop;
   end Update;

   procedure Update_State (S : in out State; IsTouched : Boolean) is
   begin
         if IsTouched then
            case S is
               when Pressed         => S := Hold;
               when others          => null;
            end case;
         else
            case S is
               when Pressed | Hold  => S := Release;
               when Release         => S := Idle;
               when others          => null;
            end case;
         end if;
   end Update_State;

   procedure Press(Key: in out State) is
   begin
      for I in Keys'Range loop
         Keys (I) := Idle;
      end loop;
      if Key /= Hold then Key := Pressed; end if;
   end Press;

   procedure PressLeft  is begin Press (Keys (ButLeft'Enum_Rep)); end PressLeft;
   procedure PressRight is begin Press (Keys (ButRight'Enum_Rep)); end PressRight;
   procedure PressUp    is begin Press (Keys (ButUp'Enum_Rep)); end PressUp;
   procedure PressDown  is begin Press (Keys (ButDown'Enum_Rep)); end PressDown;
   procedure PressPause is begin Press (Keys (ButPause'Enum_Rep)); end PressPause;
   procedure PressStart is begin Press (Keys (ButStart'Enum_Rep)); end PressStart;

begin
   null;
end Input;
