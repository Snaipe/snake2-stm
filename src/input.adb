with Touch; use Touch;

package body Input is

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

   procedure PressLeft  is begin Press (Keys (0)); end PressLeft;
   procedure PressRight is begin Press (Keys (1)); end PressRight;
   procedure PressUp    is begin Press (Keys (2)); end PressUp;
   procedure PressDown  is begin Press (Keys (3)); end PressDown;
   procedure PressPause is begin Press (Keys (4)); end PressPause;
   procedure PressStart is begin Press (Keys (5)); end PressStart;

begin
   null;
end Input;
