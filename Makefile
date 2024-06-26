PRINT := printf '
 ENDCOLOR := \033[0m
 WHITE     := \033[0m
 ENDWHITE  := $(ENDCOLOR)
 GREEN     := \033[0;32m
 ENDGREEN  := $(ENDCOLOR)
 BLUE      := \033[0;34m
 ENDBLUE   := $(ENDCOLOR)
 YELLOW    := \033[0;33m
 ENDYELLOW := $(ENDCOLOR)
 PURPLE    := \033[0;35m
 ENDPURPLE := $(ENDCOLOR)
ENDLINE := \n'


# List of source files
SOURCES = $(wildcard src/*.c)

# List of object files, generated from the source files
OBJECTS = $(SOURCES:src/%.c=obj/%.o)

OUTPUT_FILE = asm/main.asm

CC := mips64-elf-gcc
INCLUDE_PATH := -Iinclude
STANDARDFLAGS := -O2 -Wall -Wno-missing-braces -mtune=vr4300 -march=vr4300 -mabi=32 -fomit-frame-pointer -mno-abicalls -fno-pic -G0 $(INCLUDE_PATH)
SPEEDFLAGS := -Os -Wall -Wno-missing-braces -mtune=vr4300 -march=vr4300 -mabi=32 -fomit-frame-pointer -mno-abicalls -fno-pic -G0 $(INCLUDE_PATH)

# Default target
all: $(OBJECTS) genMain assemble

# Rule for building object files from source files
obj/%.o: src/%.c | obj
	@$(PRINT)$(GREEN)Compiling C file: $(ENDGREEN)$(BLUE)$<$(ENDBLUE)$(ENDCOLOR)$(ENDLINE)
	@$(CC) $(STANDARDFLAGS) -c $< -o $@

assemble: $(OBJECTS)
	@$(PRINT)$(GREEN)Assembling with armips: $(ENDGREEN)$(BLUE)asm/main.asm$(ENDBLUE)$(ENDCOLOR)$(ENDLINE)
	@armips asm/main.asm
	@$(PRINT)$(GREEN)n64crc $(ENDGREEN)$(BLUE)"rom/shadowgate64.mod.z64"$(ENDBLUE)$(ENDCOLOR)$(ENDLINE)
	@./n64crc.exe "rom/shadowgate64.mod.z64"

genMain:
	@$(PRINT)$(GREEN)Generating: $(ENDGREEN)$(BLUE)asm/main.asm$(ENDBLUE)$(ENDCOLOR)$(ENDLINE)
	$(file > $(OUTPUT_FILE),//Automatically generated by makefile, do not edit)
	$(file >> $(OUTPUT_FILE),.n64 // Let armips know we're coding for the N64 architecture)
	$(file >> $(OUTPUT_FILE),.open "rom/shadowgate64.z64", "rom/shadowgate64.mod.z64", 0 // Open the ROM file)
	$(file >> $(OUTPUT_FILE),.include "asm/symbols.asm" // Include symbols.asm to tell armips' linker where to find the game's function(s))
	$(file >> $(OUTPUT_FILE),.include "asm/bootPatch.asm")	
	$(file >> $(OUTPUT_FILE),.headersize 0x7F400000)
	$(file >> $(OUTPUT_FILE),.org 0x80400000)
	$(foreach obj_file,$(OBJECTS),$(file >> $(OUTPUT_FILE),.importobj "$(obj_file)"))
# put this last because it modifies the headersize
	$(file >> $(OUTPUT_FILE),.include "asm/hooks.s")
	$(file >> $(OUTPUT_FILE),.close //close file)

# Rule for creating the obj folder
obj:
	@mkdir -p obj

# Rule for cleaning up the project
clean:
	@rm -f $(OBJECTS)