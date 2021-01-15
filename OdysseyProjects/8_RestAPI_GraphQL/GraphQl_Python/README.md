# Rocket_ELevators_GraphQl_API
## Requirements
#### A requestable API via GraphQl to restore the data coming from two separate data sources in the same request.
- Source 1: The Postgres decision database.
- Source 2: The MySQL operational database.


#### The GraphQl API should answer the following questions:
- Retrieving the address of the building, the beginning and the end of the intervention for a specific intervention.
- Retrieving customer information and the list of interventions that took place for a specific building.
- Retrieval of all interventions carried out by a specified employee with the buildings associated with these interventions including the details (Table BuildingDetails) associated with these buildings.

### URL API
https://rocket-elevators-graphql-api.herokuapp.com/graphql/

### Databases
posgresql >>    cindy_okino_warehouse
mysql >>        cindy_okino_db


## Django API by Python
### START THE PROJECT
##### Create a virtual environment to isolate our package dependencies locally
```sh
$ python3 -m venv env
$ source env/bin/activate           # for activate the virtual environment
```
#### While in our virtual environment, we use pip to install packages
```sh
$ pip install --upgrade pip         # Update pip
$ pip install Django                # Python Web framework   
$ pip install graphene_django       # GraphQL functionalities for Django
$ pip install psycopg2-binary
$ pip install mysqlclient
```
#### Create the Django project and app.
A Django project can consist of many apps. Apps are reusable components within a project.
```sh
$ django-admin.py startproject rocket_graphql
$ django-admin.py startapp interventions 
```

### CONFIGURATIONS FOR DATABASES
#### Settings the urls of the differents databases
/rocket_graphql/settings.py
```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'cindy_okino_db',
        'USER': os.getenv('MYSQL_USER'),
        'PASSWORD': os.getenv('MYSQL_PASSWORD'),
        'HOST': 'codeboxx.cq6zrczewpu2.us-east-1.rds.amazonaws.com',
        'PORT': '3306',
    },    
    'psql': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'cindy_okino_warehouse',
        'USER': os.getenv('POSTGRES_USER'),
        'PASSWORD': os.getenv('POSTGRES_PASSWORD'),
        'HOST': 'codeboxx-postgresql.cq6zrczewpu2.us-east-1.rds.amazonaws.com',
        'PORT': '5432',
    }
}
```


#### Settings the routes for the differents models
/rocket_graphql/router.py
```python
class CheckerRouter:

    def db_for_read(self, model, **hints):
        if model._meta.app_label == 'psql':
            return 'psql'
        return 'default'

    def db_for_write(self, model, **hints):
        if model._meta.app_label == 'psql':
            return 'psql'
        return 'default'

    def allow_relation(self, obj1, obj2, **hints):
        if obj1._meta.app_label == 'psql' or obj2._meta.app_label == 'psql':
            return True
        elif 'psql' not in [obj1._meta.app_label, obj2._meta.app_label]:
            return True
        return False

    def allow_migrate(self, db, app_label, model_name=None, **hints):
        if app_label == 'psql':
            return db == 'psql'
        return None

```
/rocket_graphql/settings.py
```python
DATABASE_ROUTERS = ['rocket_graphql.router.CheckerRouter']
```

### CREATING MODELS
#### Importing models from the databases
Import the default database without flag:
```sh
$ python manage.py inspectdb                        # View the output    
$ python manage.py inspectdb > models_default.py    # Save this as a file
```
Using a flag for change the database:
```sh  
$ python manage.py inspectdb --database=psql > models_psql.py    
```
Exemple of output:
```python
class FactIntervention(models.Model):
    id = models.BigAutoField(primary_key=True)
    employee_id = models.IntegerField(blank=True, null=True)
    building_id = models.IntegerField(blank=True, null=True)
    battery_id = models.IntegerField(blank=True, null=True)
    column_id = models.IntegerField(blank=True, null=True)
    elevator_id = models.IntegerField(blank=True, null=True)
    start_date_intervention = models.DateTimeField(blank=True, null=True)
    end_date_intervention = models.DateTimeField(blank=True, null=True)
    result = models.CharField(max_length=-1, blank=True, null=True)
    report = models.TextField(blank=True, null=True)
    status = models.CharField(max_length=-1, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'fact_intervention'
```
We need to make some modifications to make it work properly, associate the right database and link the objects between the different databases:
```python
class Buildings(models.Model):
    ....

class Employees(models.Model):
    ....

class FactIntervention(models.Model):
    id = models.BigAutoField(primary_key=True)
    employee = models.ForeignKey(Employees, on_delete=models.DO_NOTHING)  
    # link with the model employee
    building = models.ForeignKey(Buildings, on_delete=models.DO_NOTHING)  
    # link with the model building
    battery_id = models.IntegerField(blank=True, null=True)
    column_id = models.IntegerField(blank=True, null=True)
    elevator_id = models.IntegerField(blank=True, null=True)
    start_date_intervention = models.DateTimeField(blank=True, null=True)
    end_date_intervention = models.DateTimeField(blank=True, null=True)
    result = models.CharField(max_length=255, blank=True, null=True)         # change the max_length
    report = models.TextField(blank=True, null=True)
    status = models.CharField(max_length=255, blank=True, null=True)        
# change the max_length
    
    class Meta:
        managed = False
        app_label = 'psql'                      # Label of database route      
        db_table = 'fact_intervention'.         # Name of table in database
```

### CREATING THE SCHEMA
#### Exemple of schema for query 'query getIntervention'
Exemple of query:
```sh
query getIntervention {
  intervention(id: 1){
    startDateIntervention
    endDateIntervention
    status
    result
    }
  }
}
```
schema.py file:
```python
import graphene
from graphene_django.types import DjangoObjectType, ObjectType
from rocket_graphql.interventions.models import FactIntervention

# Create a GraphQL type for the FactIntervention model
# We need to create a type for all of models needed
class FactInterventionType(DjangoObjectType):
    class Meta:
        model = FactIntervention

class Query(ObjectType):
    intervention = graphene.Field(FactInterventionType, id=graphene.Int())

    def resolve_intervention(self, info, **kwargs):
        id = kwargs.get('id')
        _intervention = FactIntervention.objects.get(pk=id)
        
        if id is not None:
            return _intervention
```
#### If you want to have the infos of the buildings you have to add its type.
Exemple of query:
```sh
query getIntervention {
  intervention(id: 1){
    startDateIntervention
    endDateIntervention
    status
    result
    building{
      address{
        address
        city
        postalCode
      }
    }
  }
}
```
Add to the schema.py file:
```python
...
from rocket_graphql.interventions.models import Buildings, FactIntervention
...

# Create a GraphQL type for the building model
class BuildingType(DjangoObjectType):
    
    class Meta:
        model = Buildings
...
```



## Colections of Querys
https://www.getpostman.com/collections/12ced57cb41658e2e6c4

## Sources
https://docs.djangoproject.com/en/3.1/howto/legacy-databases/

https://stackabuse.com/building-a-graphql-api-with-django/

https://docs.djangoproject.com/fr/3.1/topics/db/multi-db/

https://medium.com/dev-genius/multiple-databases-in-django-925ca821bdd0

https://docs.graphene-python.org/projects/django/en/latest/

https://www.digitalocean.com/community/tutorials/how-to-create-a-django-app-and-connect-it-to-a-database#step-4-%E2%80%94-install-mysql-database-connector


## Developpers
- Cindy Okino (Team Leader)
- Kem Tardif
- Kiefer Rivard
- Teddy Blanco


## Extras :
Go graphql in progress:

https://github.com/tonTed/Rocket_ELevators_GraphQl_Go

Java graphql in progress:

https://github.com/cindyokino/graphql-java

DotNet GraphQL :

https://github.com/kemtardif/graphql_api.git
