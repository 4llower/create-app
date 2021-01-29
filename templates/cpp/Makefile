ENTRY=main

all: create_debug build run

build:
	clear
	g++ $(ENTRY).cpp -o $(ENTRY)
	mv $(ENTRY) debug
run:
	clear
	./debug/$(ENTRY)

create_debug:
	@if [[ ! -d ./debug ]]; then mkdir debug; fi;
