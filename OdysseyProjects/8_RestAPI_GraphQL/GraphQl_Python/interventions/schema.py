import graphene
from graphene_django.types import DjangoObjectType, ObjectType
from interventions.models import Addresses, Buildings, Customers, FactIntervention, Employees, Batteries, BuildingsDetails
from pprint import pprint

# Retrieving the address of the building, the beginning and the end of the intervention for a specific intervention.
# Retrieving customer information and the list of interventions that took place for a specific building
# Retrieval of all interventions carried out by a specified employee with the buildings associated with these interventions including the details (Table BuildingDetails) associated with these buildings.


# -------------------------------- GRAPHQL TYPES --------------------------------
# With Graphene's help, to create a GraphQL type we simply specify which Django model has the properties we want in the API.

# Create a GraphQL type for the address model
class AddressType(DjangoObjectType):
    class Meta:
        model = Addresses

# Create a GraphQL type for the employee model
class EmployeeType(DjangoObjectType):
    class Meta:
        model = Employees

# Create a GraphQL type for the FactIntervention model
class FactInterventionType(DjangoObjectType):
    class Meta:
        model = FactIntervention

# Create a GraphQL type for the building model
class BuildingType(DjangoObjectType):
    
    class Meta:
        model = Buildings

# Create a GraphQL type for the buildingsDetail model
class BuildingDetailsType(DjangoObjectType):
    
    class Meta:
        model = BuildingsDetails

# Create a GraphQL type for the customer model
class CustomerType(DjangoObjectType):
    class Meta:
        model = Customers

# Create a GraphQL type for the battery model
class BatteryType(DjangoObjectType):
    class Meta:
        model = Batteries


# -------------------------------- QUERY TYPES --------------------------------
# A query specifies what data can be retrieved and what's required to get to it
# Each property of the Query class corresponds to a GraphQL query

class Query(ObjectType):
    # address = graphene.Field(AddressType, id=graphene.Int())
    # customer = graphene.Field(CustomerType, id=graphene.Int())
    building = graphene.Field(BuildingType, id=graphene.Int())
    intervention = graphene.Field(FactInterventionType, id=graphene.Int())
    employee = graphene.Field(EmployeeType, id=graphene.Int())
    battery = graphene.Field(BatteryType, id=graphene.Int())
    building_detail = graphene.Field(BuildingDetailsType, id=graphene.Int())
    # addresses = graphene.List(AddressType)
    buildings = graphene.List(BuildingType)
    employees = graphene.List(EmployeeType)
    interventions = graphene.List(FactInterventionType)
    # factinterventions = graphene.List(FactInterventionType)

    def resolve_employee(self, info, **kwargs):
        id = kwargs.get('id')
        _employee = Employees.objects.get(pk=id)

        if id is not None:
            return _employee
        
        return None

    def resolve_battery(self, info, **kwargs):
        id = kwargs.get('id')
        _battery = Batteries.objects.get(pk=id)

        if id is not None:
            return _battery
        
        return None

    def resolve_building(self, info, **kwargs):
        id = kwargs.get('id')
        _building = Buildings.objects.get(pk=id)
        # print(patate.factintervention_set.first().employee_id)
        # print(dir(patate.factintervention_set.first().employee_id))

        if id is not None:
            return _building

        return None

    def resolve_building_detail(self, info, **kwargs):
        id = kwargs.get('id')
        _buildingDetail = BuildingsDetails.objects.get(pk=id)

        if id is not None:
            return _buildingDetail
        
        return None

    def resolve_intervention(self, info, **kwargs):
        id = kwargs.get('id')
        _intervention = FactIntervention.objects.get(pk=id)
        _building = Buildings.objects.get(pk=_intervention.building_id)
        # pprint (dir(_intervention))
        # print(_intervention.building)
        # print(_intervention.building)
        # pprint (dir(FactIntervention.objects.using('psql').get(pk=id)))
        # pprint (_intervention.building)
        # # _intervention.building = Buildings.objects.get(pk=_intervention.building_id)
        # pprint(dir(_intervention.building))
        
        if id is not None:
            return _intervention

    def resolve_buildings(self, info, **kwargs):
        return Buildings.objects.all()

    def resolve_employees(self, info, **kwargs):
        return Employees.objects.all()

    def resolve_interventions(self, info, **kwargs):
        return FactIntervention.objects.all()

schema = graphene.Schema(query=Query)