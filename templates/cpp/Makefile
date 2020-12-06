ENRTY=main

all: create_debug build run

build:
	clear
	g++ $(ENRTY).cpp -o $(ENRTY)
	mv $(ENRTY) debug
run:
	clear
	./debug/$(ENRTY)

create_debug:
	@if [[ ! -d ./debug ]]; then mkdir debug; fi;
