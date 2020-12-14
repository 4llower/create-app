all:
	echo "Сompilation started..."
	kotlinc main.kt -include-runtime -d main.jar
	echo "Compilation completed!"

	if [[ ! -d ./debug ]]
	then
		echo "Creation a folder ./debug"
		mkdir debug
	fi
	mv main.jar ./debug

	java -jar ./debug/main.jar