ENTRY=main

all: create_debug build run

build:
	clear
	echo "Build started..."
	kotlinc $(ENTRY).kt -include-runtime -d $(ENTRY).jar
	echo "Build completed!"
	mv $(ENTRY).jar ./debug
run:
	clear
	java -jar ./debug/$(ENTRY).jar

create_debug:
	@if [[ ! -d ./debug ]]; then mkdir debug; fi;
