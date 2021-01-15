from django.urls import path, include
# from django.urls import path
from django.contrib import admin
admin.autodiscover()
import interventions.views
from graphene_django.views import GraphQLView
from rocket_graphql.schema import schema

# To add a new path, first import the app:
# import blog
#
# Then add the new path:
# path('blog/', blog.urls, name="blog")
#
# Learn more here: https://docs.djangoproject.com/en/2.1/topics/http/urls/

# ------------------------------------------------------------------------------------------------------------------
# GraphQL APIs are reached via one endpoint, /graphql. We need to register that route, or rather view, in Django.
# Once your server is running head to https://rocket-elevators-graphql-api.herokuapp.com/graphql/
#  You'll encounter GraphiQL - a built in IDE to run your queries!
# ------------------------------------------------------------------------------------------------------------------

urlpatterns = [
    path('admin/', admin.site.urls),
    path('graphql/', GraphQLView.as_view(graphiql=True)),
]





