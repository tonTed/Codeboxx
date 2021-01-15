package main

import (
	"database/sql"
	"fmt"
	"github.com/tonted/Rocket_ELevators_GraphQl_GO/graph/postgres"
	"log"
	"net/http"
	"os"

	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
	_ "github.com/go-sql-driver/mysql"
	_ "github.com/lib/pq"
	"github.com/tonted/Rocket_ELevators_GraphQl_GO/graph"
	"github.com/tonted/Rocket_ELevators_GraphQl_GO/graph/generated"
)

const defaultPort = "8080"

const (
	pqHost   = "127.0.0.1"
	pqPort   = 5432
	pqUser   = "tonted"
	pqDbname = "warehouse_development"

	myHost     = "127.0.0.1"
	myPort     = 3306
	myUser     = "team1"
	myPassword = "team1"
	myDbname   = "Rocket_Elevators_Information_System_development"
)

func main() {

	// Section for connexion to postgres database
	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s "+
		"dbname=%s sslmode=disable",
		pqHost, pqPort, pqUser, pqDbname)

	mysqlInfo := fmt.Sprintf("%s:%s@tcp(%s:%v)/%s", myUser, myPassword, myHost, myPort, myDbname)

	fmt.Println(mysqlInfo)

	dbpsql, err := sql.Open("postgres", psqlInfo)
	if err != nil {
		panic(err)
	}
	defer dbpsql.Close()

	err = dbpsql.Ping()
	if err != nil {
		panic(err)
	}

	var psqlVersion string

	err2 := dbpsql.QueryRow("SELECT VERSION()").Scan(&psqlVersion)

	fmt.Println(psqlVersion)


	fmt.Println("Successfully connected to " + pqDbname + "!")
	// End Section for connexion to postgres database

	// Section for connexion to mysql database
	dbmysql, err := sql.Open("mysql", mysqlInfo)
	defer dbmysql.Close()

	err = dbmysql.Ping()
	if err != nil {
		panic(err)
	}

	var version string

	err2 = dbmysql.QueryRow("SELECT VERSION()").Scan(&version)

	if err2 != nil {
		log.Fatal(err2)
	}

	fmt.Println(version)

	fmt.Println("Successfully connected to " + myDbname + "!")
	// End Section for connexion to mysql database

	port := os.Getenv("PORT")
	if port == "" {
		port = defaultPort
	}

	srv := handler.NewDefaultServer(generated.NewExecutableSchema(generated.Config{Resolvers: &graph.Resolver{
		InterventionsRepo: postgres.RepoFactInterventions{DB: dbpsql}}}))

	http.Handle("/", playground.Handler("GraphQL playground", "/query"))
	http.Handle("/query", srv)

	log.Printf("connect to http://localhost:%s/ for GraphQL playground", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
