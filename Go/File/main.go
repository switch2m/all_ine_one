package main

import (
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"
)

func readFile(filename string) {
	content, err := ioutil.ReadFile(filename)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("File Content:")
	fmt.Println(string(content))
}

func writeFile(filename string, content []byte) {
	err := ioutil.WriteFile(filename, content, 0644)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("File written successfully.")
}

func copyFile(sourceFilename, destFilename string) {
	sourceFile, err := os.Open(sourceFilename)
	if err != nil {
		log.Fatal(err)
	}
	defer sourceFile.Close()

	destinationFile, err := os.Create(destFilename)
	if err != nil {
		log.Fatal(err)
	}
	defer destinationFile.Close()

	_, err = io.Copy(destinationFile, sourceFile)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("File copied successfully.")
}

func main() {
	readFile("input.txt")

	content := []byte("Hello, this is written to a file!")
	writeFile("output.txt", content)

	copyFile("source.txt", "destination.txt")
}
