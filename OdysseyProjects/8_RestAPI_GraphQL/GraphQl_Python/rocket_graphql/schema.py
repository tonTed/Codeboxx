# -------------------------------------------------------------------------------------------
# From here we can register graphene and tell it to use our schema at interventions/schema.py
# -------------------------------------------------------------------------------------------

import graphene
import interventions.schema

class Query(interventions.schema.Query, graphene.ObjectType):
    # This class will inherit from multiple Queries
    # as we begin to add more apps to our project
    pass

schema = graphene.Schema(query=Query)