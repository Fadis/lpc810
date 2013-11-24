PROJECT=template
MCU=LPC810
OPTS = -Os -fstrict-aliasing -fsingle-precision-constant -funsigned-char -funsigned-bitfields -fshort-enums -fno-builtin -ffunction-sections -fno-common -fdata-sections -fomit-frame-pointer
WARNINGS = -Wno-strict-aliasing -Wundef -Wall -Wextra -Wunreachable-code
LDSCRIPT=core/$(MCU).ld
MBED_TARGET_SPECIFIC_DIR=./mbed/target/hal/TARGET_NXP/TARGET_LPC81X/
MBED_HAL_DIR=./mbed/hal/
MBED_API_DIR=./mbed/api/
MBED_COMMON_DIR=./mbed/common/
MBED_INCLUDES=-I$(MBED_TARGET_SPECIFIC_DIR) -I$(MBED_TARGET_SPECIFIC_DIR)/TARGET_$(MCU) -I$(MBED_HAL_DIR) -I$(MBED_API_DIR)

ASM_SOURCES=$(wildcard core/*.s)
C_SOURCES=$(wildcard core/*.c) $(wildcard $(MBED_TARGET_SPECIFIC_DIR)/*.c) $(wildcard $(MBED_TARGET_SPECIFIC_DIR)/TARGET_$(MCU)/*.c)
CXX_SOURCES=$(wildcard src/*.cpp) $(wildcard core/*.cpp) $(wildcard $(MBED_COMMON_DIR)/*.cpp) 
ELF_NAME=$(PROJECT).elf
BIN_NAME=$(PROJECT).bin

OBJECTS=$(patsubst %,./%,$(C_SOURCES:.c=.o)) $(patsubst %,./%,$(CXX_SOURCES:.cpp=.o)) $(patsubst %,./%,$(ASM_SOURCES:.s=.o))
DEPS=$(patsubst %,./%,$(C_SOURCES:.c=.d)) $(patsubst %,./%,$(CXX_SOURCES:.cpp=.d)) $(patsubst %,./%,$(ASM_SOURCES:.s=.d)) 
LSTFILES=$(patsubst %,./%,$(C_SOURCES:.c=.lst)) $(patsubst %,./%,$(CXX_SOURCES:.cpp=.lst)) $(patsubst %,./%,$(ASM_SOURCES:.s=.lst))

AS = arm-none-eabi-as
CC = arm-none-eabi-gcc
CXX = arm-none-eabi-g++
OBJCOPY = arm-none-eabi-objcopy
REMOVE = rm -f
SIZE = arm-none-eabi-size
CFLAGS = -std=gnu99 -mcpu=cortex-m0 -mthumb -I. -Icore $(MBED_INCLUDES) $(OPTS) -Wstrict-prototypes $(WARNINGS) -Wa,-adhlns=./$(<:.c=.lst)
CXXFLAGS = -std=gnu++11 -mcpu=cortex-m0 -mthumb -I. -Icore $(MBED_INCLUDES) $(OPTS) $(WARNINGS) -Wa,-adhlns=./$(<:.cpp=.lst)
LDFLAGS = -T$(LDSCRIPT) -nostartfiles  -Wl,--gc-sections

#########################################################################

all: .bin ./core $(BIN_NAME) stats

.bin:
	mkdir .bin

./core:
	mkdir ./core

$(BIN_NAME): ./$(ELF_NAME) Makefile
	@$(OBJCOPY) -R .stack -O binary ./$(ELF_NAME) $(BIN_NAME)

./$(ELF_NAME): $(OBJECTS) Makefile
	@echo "  LD  ($(OBJECTS)) -> $(ELF_NAME)"
	@$(CC) -o ./$(ELF_NAME) $(OBJECTS) $(CFLAGS) $(LDFLAGS) 

stats: ./$(ELF_NAME) 
	@$(SIZE) ./$(ELF_NAME)

clean:
	@echo "  Cleanup $<"
	@$(REMOVE) $(OBJECTS)
	@$(REMOVE) $(DEPS)
	@$(REMOVE) $(LSTFILES)
	@$(REMOVE) $(BIN_NAME)
	@$(REMOVE) $(ELF_NAME)
-include $(DEPS)

#########################################################################

./%.o: %.c Makefile 
	@echo "  CC $<"
	@$(CC) $(CFLAGS) -o $@ -c $<

./%.o: %.cpp Makefile 
	@echo "  CXX $<"
	@$(CXX) $(CXXFLAGS) -o $@ -c $<

./%.o: %.s Makefile 
	@echo "  AS $<"
	@$(AS) -o $@ -c $<

.PHONY : clean all stats

