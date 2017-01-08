pragma Restrictions (No_Elaboration_Code);

package STM32.SYSCONFIG_Control is

   type EXTI_Register is record
      IMR   : Bits_32x1;
      EMR   : Bits_32x1;
      RTSR  : Bits_32x1;
      FTSR  : Bits_32x1;
      SWIER : Bits_32x1;
      PR    : Bits_32x1;
   end record;

   for EXTI_Register use record
      IMR   at 0  range 0 .. 31;
      EMR   at 4  range 0 .. 31;
      RTSR  at 8  range 0 .. 31;
      FTSR  at 12 range 0 .. 31;
      SWIER at 16 range 0 .. 31;
      PR    at 20 range 0 .. 31;
   end record;

   type SYSCFG_Register is record
      MEMRM   : Word;
      PMC     : Word;
      EXTICR1 : Bits_8x4;
      EXTICR2 : Bits_8x4;
      EXTICR3 : Bits_8x4;
      EXTICR4 : Bits_8x4;
      CMPCR   : Word;
   end record;

   for SYSCFG_Register use record
      MEMRM   at 0  range 0 .. 31;
      PMC     at 4  range 0 .. 31;
      EXTICR1 at 8  range 0 .. 31;
      EXTICR2 at 12 range 0 .. 31;
      EXTICR3 at 16 range 0 .. 31;
      EXTICR4 at 20 range 0 .. 31;
      CMPCR   at 32 range 0 .. 31;
   end record;

end STM32.SYSCONFIG_Control;
