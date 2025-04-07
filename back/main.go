package main

import (
	"fmt"
	"net/http"
	"os"
)

func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.WriteHeader(http.StatusOK)
	fmt.Println("Received health check")
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		panic("Server port not set")
	}

	http.HandleFunc("/health", healthHandler)

	err := http.ListenAndServe(":"+port, nil)
	if err != nil {
		panic(err)
	}
}
