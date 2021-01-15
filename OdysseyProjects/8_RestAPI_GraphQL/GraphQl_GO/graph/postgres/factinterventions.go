package postgres

import (
	"database/sql"
	"fmt"
	"github.com/go-pg/pg/v10"
	"github.com/tonted/Rocket_ELevators_GraphQl_GO/graph/models"
)

type RepoFactInterventions struct {
	DB *sql.DB
}

func (i *RepoFactInterventions) GetFactInterventions() ([]*models.FactIntervention, error) {
	var fact_intervention []*models.FactIntervention
	fmt.Printf("%+v\n", fact_intervention)
	fmt.Println("##########REPO#########")
	fmt.Println("##########REPO22222#########")
	if err != nil {
		return nil, err
	}
	return fact_intervention, nil
}
