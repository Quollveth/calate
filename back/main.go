package main

import (
	//stdlib
	"encoding/json"
	"fmt"
	"net/http"

	//project
	"github.com/quollveth/calate/config"
	//external
	"github.com/joho/godotenv"
)

func healthHandler(w http.ResponseWriter, r *http.Request, c *config.Configuration) {
	fmt.Println("Received health check")

	dbErr := config.CheckHealthDB(c)
	redisErr := config.CheckHealthRedis(c)

	dbStatus := "ok"
	redisStatus := "ok"

	if dbErr != nil {
		dbStatus = "failed"
		fmt.Printf("Failed to connect to postgres on %s:%s: %v\n", c.PostgrestHost, c.PostgresPort, dbErr)
	} else {
		fmt.Printf("Connected to postgres on %s:%s\n", c.PostgrestHost, c.PostgresPort)
	}

	if redisErr != nil {
		redisStatus = "failed"
		fmt.Printf("Failed to connect to redis on %s:%s: %v\n", c.RedisHost, c.RedisPort, redisErr)
	} else {
		fmt.Printf("Connected to redis on %s:%s\n", c.RedisHost, c.RedisPort)
	}

	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Content-Type", "application/json")

	if dbErr == nil && redisErr == nil {
		w.WriteHeader(http.StatusOK)
		return
	}

	status := map[string]string{
		"postgres": dbStatus,
		"redis":    redisStatus,
	}

	jsonResp, err := json.Marshal(status)
	if err != nil {
		fmt.Printf("Error marshaling health check response: %v\n", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	w.Write(jsonResp)
}

func main() {
	err := godotenv.Load()
	if err != nil {
		panic("Error loading .env file")
	}

	config, err := config.LoadConfig()

	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		healthHandler(w, r, &config)
	})

	err = http.ListenAndServe(":"+config.ServerPort, nil)
	if err != nil {
		panic(err)
	}
}
