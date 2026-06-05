.PHONY: all run clean

OBJECTS=build/main.o build/ruleset.o build/match.o build/init_lookup.o build/render_buffer.o build/init_buffers.o  build/next_gen.o build/zeropage.o
CFLAGS=-O -t c64
LDFLAGS=-C c64-langton.cfg

all: build/langton.prg

run: build/langton.prg
	python3 upload.py --host 10.0.0.219 --run $<

clean:
	rm -rf build

build/langton.prg: $(OBJECTS) c64-langton.cfg
	mkdir -p build
	cl65 $(LDFLAGS) -o $@ $(OBJECTS)

build/match.o: match.s
	mkdir -p build
	ca65 -o $@ $^

build/init_lookup.o: init_lookup.s
	mkdir -p build
	ca65 -o $@ $^

build/init_buffers.o: init_buffers.s
	mkdir -p build
	ca65 -o $@ $^

build/render_buffer.o: render_buffer.s
	mkdir -p build
	ca65 -o $@ $^

build/zeropage.o: zeropage.s
	mkdir -p build
	ca65 -o $@ $^

build/next_gen.o: next_gen.s
	mkdir -p build
	ca65 -o $@ $^

build/ruleset.o: ruleset.c ruleset.h
	mkdir -p build
	cl65 $(CFLAGS) -c -o $@ $<

build/main.o: main.c ruleset.h
	mkdir -p build
	cl65 $(CFLAGS) -c -o $@ $<
