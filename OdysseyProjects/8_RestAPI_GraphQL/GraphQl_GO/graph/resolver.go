package graph

import (
	"context"
	"fmt"
	"github.com/tonted/Rocket_ELevators_GraphQl_GO/graph/postgres"

	// "fmt"
	"errors"

	"github.com/tonted/Rocket_ELevators_GraphQl_GO/graph/generated"
	"github.com/tonted/Rocket_ELevators_GraphQl_GO/graph/models"
)

// This file will not be regenerated automatically.
//
// It serves as dependency injection for your app, add any dependencies you require here.

type Resolver struct {
	InterventionsRepo postgres.RepoFactInterventions
}

func (r *employeesResolver) FactInterventions(ctx context.Context, obj *models.Employee) ([]*models.FactIntervention, error) {
	var inters []*models.FactIntervention

	for _, i := range interventions {
		if i.EmployeeID == obj.ID {
			inters = append(inters, i)
		}
	}
	return inters, nil
}

func (r *factInterventionResolver) Employee(ctx context.Context, obj *models.FactIntervention) (*models.Employee, error) {
	employee := new(models.Employee)

	for _, e := range employees {
		if e.ID == obj.EmployeeID {
			employee = e
			break
		}
	}
	if employee == nil {
		return nil, errors.New("employee with id not exist")
	}
	return employee, nil
}

func (r *queryResolver) Interventions(ctx context.Context) ([]*models.FactIntervention, error) {
	fmt.Println("#######################")
	fmt.Println("#######################")
	fmt.Println("#######################")
	fmt.Println("#######################")
	return r.InterventionsRepo.GetFactInterventions()
}

func (r *queryResolver) Employees(ctx context.Context) ([]*models.Employee, error) {
	return employees, nil
}

// Employees returns generated.EmployeesResolver implementation.
func (r *Resolver) Employees() generated.EmployeesResolver { return &employeesResolver{r} }

// FactIntervention returns generated.FactInterventionResolver implementation.
func (r *Resolver) FactIntervention() generated.FactInterventionResolver {
	return &factInterventionResolver{r}
}

// Query returns generated.QueryResolver implementation.
func (r *Resolver) Query() generated.QueryResolver { return &queryResolver{r} }

type employeesResolver struct{ *Resolver }
type factInterventionResolver struct{ *Resolver }
type queryResolver struct{ *Resolver }
