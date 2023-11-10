GCC_LIBS := -lm -lc
GCC_FLAGS := -g -z noexecstack -no-pie 

NASM_FLAGS := -f elf64 -g

SOURCEDIR := src/
BUILDDIR := build/

SOURCES := $(wildcard $(SOURCEDIR)*.asm)
OBJECTS := $(patsubst $(SOURCEDIR)%.asm,$(BUILDDIR)%.o,$(SOURCES))

TARGETDIR := target/
MAIN := $(TARGETDIR)main


main: $(OBJECTS)
	gcc -o $(MAIN) $(OBJECTS) $(GCC_FLAGS) $(GCC_LIBS)

$(OBJECTS): $(BUILDDIR)%.o: $(SOURCEDIR)%.asm
	nasm $< $(NASM_FLAGS) -o $@

