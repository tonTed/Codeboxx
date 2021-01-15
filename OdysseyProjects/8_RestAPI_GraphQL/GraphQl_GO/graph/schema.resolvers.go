package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"github.com/tonted/Rocket_ELevators_GraphQl_GO/graph/models"
)

var interventions = []*models.FactIntervention{
	{
		ID:         "1",
		BuildingID: 4,
		Result:     "Complete",
		Status:     "Succes",
		EmployeeID:	"1",
	},
	{
		ID:         "4",
		BuildingID: 5,
		Result:     "Failure",
		Status:     "resumed",
		EmployeeID:	"2",
	},
}
var employees = []*models.Employee{
	{
		ID:        "1",
		FirstName: "Teddy",
		LastName:  "Blanco",
	},
	{
		ID:        "2",
		FirstName: "Mathieu",
		LastName:  "Houde",
	},
}