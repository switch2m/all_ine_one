package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
	"os"
)

func main() {
	args := os.Args

	if _, err := url.ParseRequestURI(args[1]); err != nil {
		os.Exit(1)
	}
	//
	response, err := http.Get(args[1])

	if err != nil {
		log.Fatal(err)
	}

	defer response.Body.Close()

	fmt.Println("HTTP Status Code: ", response.StatusCode)
	//
	body, err := io.ReadAll(response.Body)

	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("The Body is: %s", body)
}
