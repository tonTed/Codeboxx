# -------------------------------------------------------------------------
# Django models describe the layout of our project's database. 
# Each model is a Python class that's usually mapped to a database table. 
# The class properties are mapped to the database's columns.
# -------------------------------------------------------------------------

from django.db import models

class Addresses(models.Model):
    id = models.BigAutoField(primary_key=True)
    type_address = models.CharField(max_length=255, blank=True, null=True)
    status = models.CharField(max_length=255, blank=True, null=True)
    entite = models.CharField(max_length=255, blank=True, null=True)
    address = models.CharField(max_length=255, blank=True, null=True)
    address2 = models.CharField(max_length=255, blank=True, null=True)
    city = models.CharField(max_length=255, blank=True, null=True)
    postal_code = models.CharField(max_length=255, blank=True, null=True)
    country = models.CharField(max_length=255, blank=True, null=True)
    notes = models.TextField(blank=True, null=True)
    latitude = models.FloatField(blank=True, null=True)
    longitude = models.FloatField(blank=True, null=True)
    full_street_address = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'addresses'

class Batteries(models.Model):
    id = models.BigAutoField(primary_key=True)
    type_building = models.CharField(max_length=255, blank=True, null=True)
    status = models.CharField(max_length=255, blank=True, null=True)
    date_commissioning = models.DateField(blank=True, null=True)
    date_last_inspection = models.DateField(blank=True, null=True)
    cert_ope = models.CharField(max_length=255, blank=True, null=True)
    information = models.CharField(max_length=255, blank=True, null=True)
    notes = models.TextField(blank=True, null=True)
    building = models.ForeignKey('Buildings', models.DO_NOTHING, blank=True, null=True)
    employee = models.ForeignKey('Employees', models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'batteries'

class Customers(models.Model):
    id = models.BigAutoField(primary_key=True)
    date_create = models.DateField(blank=True, null=True)
    company_name = models.CharField(max_length=255, blank=True, null=True)
    cpy_contact_name = models.CharField(max_length=255, blank=True, null=True)
    cpy_contact_phone = models.CharField(max_length=255, blank=True, null=True)
    cpy_contact_email = models.CharField(max_length=255, blank=True, null=True)
    cpy_description = models.CharField(max_length=255, blank=True, null=True)
    sta_name = models.CharField(max_length=255, blank=True, null=True)
    sta_phone = models.CharField(max_length=255, blank=True, null=True)
    sta_mail = models.CharField(max_length=255, blank=True, null=True)
    # user = models.ForeignKey('Users', models.DO_NOTHING, blank=True, null=True)
    address = models.ForeignKey(Addresses, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'customers'

class Buildings(models.Model):
    id = models.BigAutoField(primary_key=True)
    adm_contact_name = models.CharField(max_length=255, blank=True, null=True)
    adm_contact_mail = models.CharField(max_length=255, blank=True, null=True)
    adm_contact_phone = models.CharField(max_length=255, blank=True, null=True)
    tect_contact_name = models.CharField(max_length=255, blank=True, null=True)
    tect_contact_email = models.CharField(max_length=255, blank=True, null=True)
    tect_contact_phone = models.CharField(max_length=255, blank=True, null=True)
    customer = models.ForeignKey(Customers, models.DO_NOTHING, blank=True, null=True)
    address = models.ForeignKey(Addresses, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'buildings'

class BuildingsDetails(models.Model):
    id = models.BigAutoField(primary_key=True)
    info_key = models.CharField(max_length=255, blank=True, null=True)
    value = models.CharField(max_length=255, blank=True, null=True)
    building = models.ForeignKey(Buildings, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'buildings_details'

class Columns(models.Model):
    id = models.BigAutoField(primary_key=True)
    type_building = models.CharField(max_length=255, blank=True, null=True)
    amount_floors_served = models.IntegerField(blank=True, null=True)
    status = models.CharField(max_length=255, blank=True, null=True)
    information = models.CharField(max_length=255, blank=True, null=True)
    notes = models.TextField(blank=True, null=True)
    battery = models.ForeignKey(Batteries, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'columns'

class Elevators(models.Model):
    id = models.BigAutoField(primary_key=True)
    serial_number = models.CharField(max_length=255, blank=True, null=True)
    model = models.CharField(max_length=255, blank=True, null=True)
    type_building = models.CharField(max_length=255, blank=True, null=True)
    status = models.CharField(max_length=255, blank=True, null=True)
    date_commissioning = models.DateField(blank=True, null=True)
    date_last_inspection = models.DateField(blank=True, null=True)
    cert_ope = models.CharField(max_length=255, blank=True, null=True)
    information = models.CharField(max_length=255, blank=True, null=True)
    notes = models.TextField(blank=True, null=True)
    column = models.ForeignKey(Columns, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'elevators'

class Employees(models.Model):
    id = models.BigAutoField(primary_key=True)
    first_name = models.CharField(max_length=255, blank=True, null=True)
    last_name = models.CharField(max_length=255, blank=True, null=True)
    title = models.CharField(max_length=255, blank=True, null=True)
    # user = models.ForeignKey('Users', models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'employees'

class DimCustomers(models.Model):
    id = models.BigAutoField(primary_key=True)
    creation_date = models.DateField(blank=True, null=True)
    cpy_contact_name = models.CharField(max_length=255, blank=True, null=True)
    cpy_contact_email = models.CharField(max_length=255, blank=True, null=True)
    amount_elevator = models.IntegerField(blank=True, null=True)
    customer_city = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'dim_customers'

class FactContacts(models.Model):
    id = models.BigAutoField(primary_key=True)
    contact_id = models.IntegerField(blank=True, null=True)
    creation_date = models.DateField(blank=True, null=True)
    company_name = models.CharField(max_length=255, blank=True, null=True)
    email = models.CharField(max_length=255, blank=True, null=True)
    project_name = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'fact_contacts'

class FactElevators(models.Model):
    id = models.BigAutoField(primary_key=True)
    serial_number = models.CharField(max_length=255, blank=True, null=True)
    commissioning_date = models.DateField(blank=True, null=True)
    building_id = models.CharField(max_length=255, blank=True, null=True)
    customer_id = models.CharField(max_length=255, blank=True, null=True)
    building_city = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'fact_elevators'

class FactIntervention(models.Model):
    id = models.BigAutoField(primary_key=True)
    employee = models.ForeignKey(Employees, on_delete=models.DO_NOTHING)
    building = models.ForeignKey(Buildings, on_delete=models.DO_NOTHING)
    battery_id = models.IntegerField(blank=True, null=True)
    column_id = models.IntegerField(blank=True, null=True)
    elevator_id = models.IntegerField(blank=True, null=True)
    start_date_intervention = models.DateTimeField(blank=True, null=True)
    end_date_intervention = models.DateTimeField(blank=True, null=True)
    result = models.CharField(max_length=255, blank=True, null=True)
    report = models.TextField(blank=True, null=True)
    status = models.CharField(max_length=255, blank=True, null=True)
    

    class Meta:
        managed = False
        app_label = 'psql'
        db_table = 'fact_intervention'

class FactQuotes(models.Model):
    id = models.BigAutoField(primary_key=True)
    quote_id = models.IntegerField(blank=True, null=True)
    creation_date = models.DateField(blank=True, null=True)
    company_name = models.CharField(max_length=255, blank=True, null=True)
    email = models.CharField(max_length=255, blank=True, null=True)
    amount_elevator = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'fact_quotes'

# class InterventionsInfos1(models.Model):
#     intervention = models.OneToOneField(FactIntervention, on_delete=models.DO_NOTHING)
#     buildings = models.ManyToManyField(Buildings)
