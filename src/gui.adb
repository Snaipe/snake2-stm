with Ada.Real_Time;
with Display   ; use Display;
with Input     ; use Input;
with Touch     ; use Touch;

package body Gui is

   package Colors renames Display.Colors;

   subtype Button is Display.Rect;

   Width       : constant Display.Width  := Display.Width'Last;
   Height      : constant Display.Height := Display.Height'Last - Width;
   W_Side      : constant Display.Width  := Width * 25 / 100;
   W_Center    : constant Display.Width  := Width - 2 * W_Side;

   Btn_Left  : constant Button := (X => 0, Y => Width,
                                       W => W_Side, H => Height);
   Btn_Up    : constant Button := (X => Btn_Left.W, Y => Width,
                                       W => W_Center, H => Height / 2);
   Btn_Down  : constant Button := (X => Btn_Left.W, Y => Width + Height / 2,
                                       W => W_Center, H => Height - Btn_Up.H);
   Btn_Right : constant Button := (X => W_Side + W_Center, Y => Width,
                                       W => W_Side, H => Height);

   task body GuiTask is
      use Ada.Real_Time;
   begin
      loop
         Update;
         delay until Time_First;
      end loop;
   end GuiTask;

   procedure Update is
      Touch : constant Touch_State := Get_Touch_State;
   begin
      Input.Update (Touch.Touch_Detected);
      if Intersect (Btn_Left, (Touch.X, Touch.Y))   then PressLeft;   end if;
      if Intersect (Btn_Right, (Touch.X, Touch.Y))  then PressRight;  end if;
      if Intersect (Btn_Up, (Touch.X, Touch.Y))     then PressUp;     end if;
      if Intersect (Btn_Down, (Touch.X, Touch.Y))   then PressDown;   end if;

      -- Test: Hold > Idle
      if Input.Keys (0) = Hold then Fill (Btn_Left, Colors.Blue);  end if;
      if Input.Keys (0) = Idle then Fill (Btn_Left, Colors.Red);   end if;
      if Input.Keys (1) = Hold then Fill (Btn_Right, Colors.Blue); end if;
      if Input.Keys (1) = Idle then Fill (Btn_Right, Colors.Red);  end if;
      if Input.Keys (2) = Hold then Fill (Btn_Up, Colors.Blue);    end if;
      if Input.Keys (2) = Idle then Fill (Btn_Up, Colors.Red);     end if;
      if Input.Keys (3) = Hold then Fill (Btn_Down, Colors.Blue);  end if;
      if Input.Keys (3) = Idle then Fill (Btn_Down, Colors.Red);   end if;
   end;

   procedure Draw is
   begin
      Fill (Btn_Left, Colors.Red);
      Fill (Btn_Right, Colors.Red);
      Fill (Btn_Up, Colors.Red);
      Fill (Btn_Down, Colors.Red);
   end;

begin
   null;
end Gui;
