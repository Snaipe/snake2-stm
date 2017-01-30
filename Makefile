GDB:=arm-none-eabi-gdb

OPENOCD:=/usr/bin/openocd
OPENOCD_ROOT:=/usr/share/openocd

BINDIR=build
BINELF=snake2

all: build

deploy:
	$(OPENOCD) -f "$(OPENOCD_ROOT)/scripts/board/stm32f4discovery.cfg" \
		-c "program $(BINDIR)/$(BINELF) verify reset exit"

connect:
	$(OPENOCD) -f "$(OPENOCD_ROOT)/scripts/board/stm32f4discovery.cfg" \
		-c "init" -c "reset halt"

.gdbscript:
	@echo "target remote localhost:3333" > .gdbscript
	@echo "monitor reset halt" >> .gdbscript
	@echo "monitor flash protect 0 0 11 off" >> .gdbscript
	@echo "monitor flash write_image erase \"$(shell realpath $(BINDIR)/$(BINELF))\"" >> .gdbscript
	@echo "monitor reset halt" >> .gdbscript
	@echo "file $(BINDIR)/$(BINELF)" >> .gdbscript
	@echo "load" >> .gdbscript
	@echo "break _ada_main" >> .gdbscript
	@echo "tabset" >> .gdbscript
	@echo "continue" >> .gdbscript

gdb: | .gdbscript
	$(GDB) -command=.gdbscript

build:
	gprbuild -p snake2.gpr

.PHONY: build all gdb connect deploy
