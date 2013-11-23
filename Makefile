PROJECT=template
MCU=LPC810
OPTS = -Os -fstrict-aliasing -fsingle-precision-constant -funsigned-char -funsigned-bitfields -fshort-enums -fno-builtin -ffunction-sections -fno-common -fdata-sections
WARNINGS = -Wno-strict-aliasing -Wundef -Wall -Wextra -Wunreachable-code
LDSCRIPT=core/$(MCU).ld

ASM_SOURCES=$(wildcard core/*.s)
C_SOURCES=$(wildcard core/*.c) $(wildcard *.c)
CXX_SOURCES=$(wildcard *.cpp)
ELF_NAME=$(PROJECT).elf
BIN_NAME=$(PROJECT).bin

OBJECTS=$(patsubst %,.bin/%,$(C_SOURCES:.c=.o)) $(patsubst %,.bin/%,$(CXX_SOURCES:.cpp=.o)) $(patsubst %,.bin/%,$(ASM_SOURCES:.s=.o))
DEPS=$(patsubst %,.bin/%,$(C_SOURCES:.c=.d)) $(patsubst %,.bin/%,$(CXX_SOURCES:.cpp=.d)) $(patsubst %,.bin/%,$(ASM_SOURCES:.s=.d)) 
LSTFILES=$(patsubst %,.bin/%,$(C_SOURCES:.c=.lst)) $(patsubst %,.bin/%,$(CXX_SOURCES:.cpp=.lst)) $(patsubst %,.bin/%,$(ASM_SOURCES:.s=.lst))

CC = arm-none-eabi-gcc
CXX = arm-none-eabi-g++
OBJCOPY = arm-none-eabi-objcopy
REMOVE = rm -f
SIZE = arm-none-eabi-size
CFLAGS = -std=gnu99 -mcpu=cortex-m0 -mthumb -I. -Icore $(OPTS) -Wstrict-prototypes $(WARNINGS) -Wa,-adhlns=.bin/$(<:.c=.lst)
CXXFLAGS = -std=c++11 -mcpu=cortex-m0 -mthumb -I. -Icore $(OPTS) $(WARNINGS) -Wa,-adhlns=.bin/$(<:.cpp=.lst)
LDFLAGS = -T$(LDSCRIPT) -nostartfiles  -Wl,--gc-section 

#########################################################################

all: .bin .bin/core $(BIN_NAME) stats

.bin:
	mkdir .bin

.bin/core:
	mkdir .bin/core

$(BIN_NAME): .bin/$(ELF_NAME) Makefile
	@$(OBJCOPY) -R .stack -O binary .bin/$(ELF_NAME) $(BIN_NAME)

.bin/$(ELF_NAME): $(OBJECTS) Makefile
	@echo "  LD  ($(OBJECTS)) -> $(ELF_NAME)"
	@$(CC) -o .bin/$(ELF_NAME) $(OBJECTS) $(CFLAGS) $(LDFLAGS) 

stats: .bin/$(ELF_NAME) 
	@$(SIZE) .bin/$(ELF_NAME)

clean:
	@echo "  Cleanup $<"
	@$(REMOVE) $(OBJECTS)
	@$(REMOVE) $(DEPS)
	@$(REMOVE) $(LSTFILES)
	@$(REMOVE) .bin/core/startup_LPC8xx.s
	@$(REMOVE) $(BIN_NAME)
	@$(REMOVE) .bin/$(ELF_NAME)
	@$(REMOVE) -d .bin/core
	@$(REMOVE) -d .bin

-include $(DEPS)

#########################################################################

.bin/%.o: %.c Makefile 
	@echo "  CC $<"
	@$(CC) $(CFLAGS) -o $@ -c $<
	@$(CC) $(CFLAGS) -MM $< > $*.d.tmp
	@sed -e 's|.*:|.bin/$*.o:|' < $*.d.tmp > .bin/$*.d
	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | fmt -1 | \
		sed -e 's/^ *//' -e 's/$$/:/' >> .bin/$*.d
	@rm -f $*.d.tmp

.bin/%.o: %.cpp Makefile 
	@echo "  CXX $<"
	@$(CXX) $(CXXFLAGS) -o $@ -c $<
	@$(CXX) $(CXXFLAGS) -MM $< > $*.d.tmp
	@sed -e 's|.*:|.bin/$*.o:|' < $*.d.tmp > .bin/$*.d
	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | fmt -1 | \
		sed -e 's/^ *//' -e 's/$$/:/' >> .bin/$*.d
	@rm -f $*.d.tmp

.bin/%.o: %.s Makefile 
	@echo "  CC $<"
	@$(CC) $(CFLAGS) -o $@ -c $<
	@$(CC) $(CFLAGS) -MM $< > $*.d.tmp
	@sed -e 's|.*:|.bin/$*.o:|' < $*.d.tmp > .bin/$*.d
	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | fmt -1 | \
		sed -e 's/^ *//' -e 's/$$/:/' >> .bin/$*.d
	@rm -f $*.d.tmp

.PHONY : clean all stats

