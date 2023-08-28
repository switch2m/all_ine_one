package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", rootPath)

	port := 8080
	fmt.Printf("Server is running on port %d...\n", port)
	err := http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
	if err != nil {
		panic(err)
	}
}
func rootPath(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintln(w, "Hello, World!")
}
func firstEndpoint(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "first endpoint!")
}
//fmt.Println(...) prints content to the standard output (console).
//fmt.Fprintln(w, ...) writes content to the HTTP response body.

