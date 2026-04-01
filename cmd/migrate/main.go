// Command migrate applies or rolls back database migrations for the Car Rental System.
//
// Usage:
//
//	migrate -dsn <postgres-dsn> [-dir <migrations-dir>] up|down [N]
//
// Flags:
//
//	-dsn   PostgreSQL DSN, e.g. postgres://user:pass@host:5432/dbname?sslmode=disable
//	       May also be supplied via the DATABASE_URL environment variable.
//	-dir   Directory containing the *.sql migration files (default: "db/migrations").
//
// Commands:
//
//	up [N]    Apply all pending migrations, or only the next N steps.
//	down [N]  Roll back the last N applied migrations (default N=1).
//	version   Print the currently applied migration version.
package main

import (
	"errors"
	"flag"
	"fmt"
	"log"
	"os"
	"strconv"

	"github.com/golang-migrate/migrate/v4"
	_ "github.com/golang-migrate/migrate/v4/database/pgx/v5"
	_ "github.com/golang-migrate/migrate/v4/source/file"
)

func main() {
	dsn := flag.String("dsn", "", "PostgreSQL DSN (overrides DATABASE_URL env var)")
	dir := flag.String("dir", "db/migrations", "Directory containing SQL migration files")
	flag.Parse()

	// Resolve DSN from flag or environment variable.
	if *dsn == "" {
		*dsn = os.Getenv("DATABASE_URL")
	}
	if *dsn == "" {
		log.Fatal("database DSN required: set -dsn flag or DATABASE_URL environment variable")
	}

	args := flag.Args()
	if len(args) == 0 {
		log.Fatal("command required: up, down, or version")
	}
	command := args[0]

	// golang-migrate expects the file source URL as "file:///<path>".
	sourceURL := "file://" + *dir

	m, err := migrate.New(sourceURL, *dsn)
	if err != nil {
		log.Fatalf("failed to initialise migrate: %v", err)
	}
	defer func() {
		srcErr, dbErr := m.Close()
		if srcErr != nil {
			log.Printf("warning: error closing migration source: %v", srcErr)
		}
		if dbErr != nil {
			log.Printf("warning: error closing database connection: %v", dbErr)
		}
	}()

	switch command {
	case "up":
		steps, err := parseOptionalSteps(args)
		if err != nil {
			log.Fatalf("invalid step count: %v", err)
		}
		if steps > 0 {
			err = m.Steps(steps)
		} else {
			err = m.Up()
		}
		if errors.Is(err, migrate.ErrNoChange) {
			fmt.Println("no migrations to apply")
			return
		}
		if err != nil {
			log.Fatalf("migration up failed: %v", err)
		}
		fmt.Println("migrations applied successfully")

	case "down":
		steps, err := parseOptionalSteps(args)
		if err != nil {
			log.Fatalf("invalid step count: %v", err)
		}
		if steps == 0 {
			steps = 1 // default: roll back one migration
		}
		if err := m.Steps(-steps); err != nil && !errors.Is(err, migrate.ErrNoChange) {
			log.Fatalf("migration down failed: %v", err)
		}
		fmt.Printf("rolled back %d migration(s)\n", steps)

	case "version":
		version, dirty, err := m.Version()
		if errors.Is(err, migrate.ErrNilVersion) {
			fmt.Println("no migrations applied")
			return
		}
		if err != nil {
			log.Fatalf("failed to read migration version: %v", err)
		}
		if dirty {
			fmt.Printf("version: %d (dirty — previous migration failed)\n", version)
		} else {
			fmt.Printf("version: %d\n", version)
		}

	default:
		log.Fatalf("unknown command %q — valid commands: up, down, version", command)
	}
}

// parseOptionalSteps returns the integer step count from args[1], if present.
// Returns 0 when no step argument is given.
func parseOptionalSteps(args []string) (int, error) {
	if len(args) < 2 {
		return 0, nil
	}
	n, err := strconv.Atoi(args[1])
	if err != nil || n <= 0 {
		return 0, fmt.Errorf("step count must be a positive integer, got %q", args[1])
	}
	return n, nil
}
