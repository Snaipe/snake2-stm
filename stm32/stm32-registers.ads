with System;
with STM32;                     use STM32;
with STM32.GPIO;                use STM32.GPIO;
with STM32.Reset_Clock_Control; use STM32.Reset_Clock_Control;
with STM32.SYSCONFIG_Control;   use STM32.SYSCONFIG_Control;

package STM32.Registers is

   pragma Warnings (Off, "*may call Last_Chance_Handler");
   pragma Warnings (Off, "*may be incompatible with alignment of object");

   RCC : RCC_Register with
     Volatile,
     Address => System'To_Address (RCC_Base),
     Import;

   GPIOA : GPIO_Register with
     Volatile,
     Address => System'To_Address (GPIOA_Base),
     Import;

   GPIOD : GPIO_Register with
     Volatile,
     Address => System'To_Address (GPIOD_Base),
     Import;

   GPIOG : GPIO_Register with
     Volatile,
     Address => System'To_Address (GPIOG_Base),
     Import;

   EXTI : EXTI_Register with
     Volatile,
     Address => System'To_Address (EXTI_Base),
     Import;

   SYSCFG : SYSCFG_Register with
     Volatile,
     Address => System'To_Address (SYSCFG_Base),
     Import;

   pragma Warnings (On, "*may call Last_Chance_Handler");
   pragma Warnings (On, "*may be incompatible with alignment of object");

end STM32.Registers;
