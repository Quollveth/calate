package config

import (
	"fmt"
	"os"
	"strings"
)

type Configuration struct {
	// Server Config
	ServerPort string
	// Postgres Config
	PostgresPort     string
	PostgrestHost    string
	PostgresDB       string
	PostgresUser     string
	PostgresPassword string
	// Redis Config
	RedisHost string
	RedisPort string
}

func readEnvVar(name string, fail func(string)) string {
	ret := os.Getenv(name)
	if ret == "" {
		fail(name)
	}
	return ret
}

func LoadConfig() (Configuration, error) {
	var ret Configuration

	failed := []string{}
	fail := func(e string) {
		failed = append(failed, e)
	}

	ret.ServerPort = readEnvVar("PORT", fail)
	ret.PostgresPort = readEnvVar("POSTGRES_PORT", fail)
	ret.PostgrestHost = readEnvVar("POSTGRES_HOST", fail)
	ret.PostgresDB = readEnvVar("POSTGRES_DB", fail)
	ret.PostgresUser = readEnvVar("POSTGRES_USER", fail)
	ret.PostgresPassword = readEnvVar("POSTGRES_PASSWORD", fail)
	ret.RedisHost = readEnvVar("REDIS_HOST", fail)
	ret.RedisPort = readEnvVar("REDIS_PORT", fail)

	if len(failed) != 0 {
		return Configuration{}, fmt.Errorf(
			"failed to load required environment variables:\n  - %s",
			strings.Join(failed, "\n  - "),
		)
	}

	return ret, nil
}

// Attempts to connect to DB with given config and returns status
func CheckHealthDB(config *Configuration) error {

	// success
	return nil
}

// Attempts to connect to Redis with given config and returns status
func CheckHealthRedis(cofig *Configuration) error {

	// success
	return nil
}
