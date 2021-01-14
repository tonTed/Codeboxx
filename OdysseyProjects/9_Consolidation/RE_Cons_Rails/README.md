# Week 9 - Consolidation of Achievements

Improve de application rails and RestAPI

https://tonted.xyz/

## Summary
- [Requirements](#requirements)
    - [Intervention Request Form](#intervention-request-form)
    - [Intervention Table](#add-a-new-table-intervention-in-mysql)
    - [Zendesk Ticket](#Creating-a-Ticket-in-ZenDesk)
    - [Rest API](#Creating-new-GET-and-PUT-requests-in-the-REST-API)
- [Rails App](#rails-app)
    - [Create a scaffold intervention](#create-a-scaffold-intervention)
    - [Modify the model intervention](#modify-the-model-intervention)
    - [Modify the models who belongs the table intervention](#modify-the-models-who-belongs-the-table-intervention)
    - [Modify the migration of create intervention](#modify-the-migration-of-create-intervention)
    - [Create a migration for add references to the database](#create-a-migration-for-add-references-to-the-database)
    - [Modify the intervention controller](#modify-the-intervention-controller)
    - [Create a method in the application controller](#create-a-method-in-the-application-controller)
    - [Migration for create the table in the database](#migration-for-create-the-table-in-the-database)
    - [Create the form](#create-the-form)
- [Zendesk Ticket](#zendesk-ticket)
- [Request Rest API](#request-rest-api)
    - [First Request](#first-request)
    - [Second Request](#second-request)
    - [Third Request](#third-request)
- [Links & Access](#links-and-access)

    
## Requirements:
### Intervention Request Form
The form is for Rocket Elevators employees to enter a new request for intervention. The first step is to determine for which entity this intervention should be performed:
- Display a DropDown Selector listing all clients (Table Customers), only one client can be selected at a time. As soon as the selection is made, the change triggers the action of the building selection field of the form - next step 2
- Once you have selected the customer, you must then display a selector listing the buildings belonging to this customer. The dropdown selector allows you to enter only one building at a time. As soon as the selection is made, the change triggers the action of the battery selection field of the form - next step 3
- Once the selection of the building has been made, a selector listing the batteries belonging to that building must then be displayed. The Dropdown selector allows only one battery to be entered at a time. As soon as the selection is made, the change triggers the action of the column selection field of the form - next step 4
- Once the battery selection has been made, a selector listing the columns belonging to the battery must then be displayed. The Dropdown selector has a value of "None" among the choices and this is the default choice. The dropdown allows the entry of only one column at a time. As soon as the selection is made, the change triggers the action of the column selection field of the form - next step 5
- Once the column has been selected, a selector listing the lifts belonging to the column is displayed. The Dropdown selector has a value "None" among the choices and it is the default choice. The dropdown allows the entry of only one elevator at a time.
- The form also includes a Dropdown selector that lists all the company's employees (Table Employees) it has a value of "None" among the choices and this is the default choice. This dropdown is not linked to the previous cascade described via the dependencies of fields 1 to 5. This field is visible and accessible at all times in the form.
- A "Description" input field is used to describe the nature of the intervention required.
- A "Submit" button allows the request to be sent to the processing centre.

### Add a new table intervention in MySQL:
- Author (EmployeeID of the ticket author)
- CustomerID
- BuildingID
- BatteryID (May be null)
- ColumnID (Can be null if none specified)
- ElevatorID (Can be null if none specified)
- EmployeeID (Can be null if none specified)
- Start date and time of the intervention (must be null and void because it is not filled in the form. The field will be edited later at the time of the intervention)
- End date and time of the intervention (must be null and void because not filled in the form. The field will be edited later at the conclusion of the intervention)
- Result (Incomplete by default)
- Report (To persist the Description field)
- Status (Pending by default)

### Creating a Ticket in ZenDesk
At the time of saving the service request, the website form creates a new ticket of type "problem" or "question" in ZenDesk. It adds in the detail section of the created ticket all the data entered in the form:
- The Requester
- The Customer (Company Name)
- Building ID
- The Battery ID
- The Column ID if specified
- Elevator ID if specified
- The employee to be assigned to the task
- Description of the request for intervention


### Creating new GET and PUT requests in the REST API
The REST API needs to be modified and enhanced to offer data through new interaction points:
- GET: Returns all fields of all Service Request records that do not have a start date and are in "Pending" status.
- PUT: Change the status of the intervention request to "InProgress" and add a start date and time (Timestamp).
- PUT: Change the status of the request for action to "Completed" and add an end date and time (Timestamp).

## Rails App
#### Create a scaffold intervention
It's generate views, model, controller and migration
```sh 
rails generate scaffold Intervention
```
#### Modify the model intervention
Explanations to comments in the code block
```rb
class Intervention < ApplicationRecord
  #belongs_to link to the intervention to other tables, the name of column is the table_id
  # for exemple for :customer the name of the column in the table interventions is customer_id
  belongs_to :customer
  belongs_to :building
  belongs_to :battery, optional: true
  belongs_to :column, optional: true
  belongs_to :elevator, optional: true
  belongs_to :employee, optional: true
  belongs_to :author, class_name: "Employee"    #class name permit to link the author_id to a employee
  
end
```
#### Modify the models who belongs the table intervention
Explanations to comments in the code block
We take the model employee for exemple:
```rb
class Employee < ApplicationRecord
  belongs_to :user
  has_many :batteries
  has_many :interventions   #has_many permit to have multiples interventions

  # Method for format how we show in the dropdown form
  def full_name
    "#{first_name} #{last_name}"
  end
end
```

#### Modify the migration of create intervention
Explanations to comments in the code block
```rb
class CreateInterventions < ActiveRecord::Migration[5.2]
  def change
    create_table :interventions do |t|
      #the method :default permit to put a default value when the intervention is create
      t.datetime :start_date_intervention, :default => nil
      t.datetime :end_date_intervention, :default => nil
      t.string :result, :default => "Incomplete"
      t.text :report
      t.string :status, :default => "Pending"

      t.timestamps
    end
  end
```

#### Create a migration for add references to the database
```sh
rails g migration AddInterventionReference
```
Explanations to comments in the code block
```rb
class AddInterventionReference < ActiveRecord::Migration[5.2]
  def change
    add_reference :interventions, :customer, foreign_key: true
    add_reference :interventions, :building, foreign_key: true
    add_reference :interventions, :battery, foreign_key: true
    add_reference :interventions, :column, foreign_key: true
    add_reference :interventions, :elevator, foreign_key: true
    add_reference :interventions, :employee, foreign_key: true
    add_reference :interventions, :author, foreign_key: {to_table: :employees}
  end
end
```

#### Modify the intervention controller
Explanations to comments in the code block
```rb
class InterventionsController < ApplicationController
  before_action :set_intervention, only: [:show, :edit, :update, :destroy]
  
  before_action :is_employee? #method for check is the current user is a employee
  
  # POST /interventions
  # POST /interventions.json
  def create
    @intervention = Intervention.new(intervention_params)

    # Get format name of employee connected
    employee = current_user.employee.full_name

    # Give the id of the employee connected
    @intervention.author_id = current_user.employee.id

    # Data get for zendesk ticket
    battery_id = @intervention.battery_id
    column_id = @intervention.column_id
    elevator_id = @intervention.elevator_id

    # Condition for null ids not required
    if @intervention.elevator_id
      @intervention.battery_id = nil
      @intervention.column_id = nil
    elsif @intervention.column_id
      @intervention.battery_id = nil
    end

    respond_to do |format|
      if @intervention.save
        format.html { redirect_to '/interventions/new', notice: 'Intervention was successfully created.' }
        format.json { render :show, status: :created, location: @intervention }

        # Call method for create a zendesk ticket
        helpers.ticket_intervention(@intervention, employee, battery_id, column_id, elevator_id)
      else
        format.html { render :new }
        format.json { render json: @intervention.errors, status: :unprocessable_entity }
      end
    end
  end
end
```
#### Create a method in the application controller
Explanations to comments in the code block
```rb
class ApplicationController < ActionController::Base
    
    # Create method for check is the current user is a employee, if not it's redirect to the home page with a alert
    def is_employee?
        if !current_user || current_user.has_role?('employee') == false
            redirect_to '/home', alert: "You need to be a employee"
        elsif current_user.has_role? :employee
        else
            redirect_to '/home', alert: "You need to be a employee"
        end
    end
end
```

#### Migration for create the table in the database
```sh
rake db:migrate
end
```

#### Create the form
Explanations:
We use two method:
- `:collection_select` for get all of ine table, in this exemple,the customer and we shoe the company_name
- `:grouped_collection_select` for regroup by customer the differents buildings, show the address calling the method `:loc_building` in the building model.

*Partial Code:*
```rb
<div class="field">
  <%= f.label :customer_id %>
  <%= f.collection_select :customer_id, Customer.order(:company_name), :id, :company_name,{}, {:include_blank => "Select a customer", :required => true} %>
</div>
<div class="field">
  <%= f.label :building_id %>
  <%= f.grouped_collection_select :building_id, Customer.order(:id), :buildings, :company_name, :id, :loc_building, {}, {:required => true} %>
</div>
```
After that we hide the fields not link with the customer and otherwise in a coffee scrip:
```js
// ./app/assets/javascripts/interventions.coffee
jQuery ->
  $("#intervention_building_id").parent().hide()
  $("#intervention_battery_id").parent().hide()
  $("#intervention_column_id").parent().hide()
  $("#intervention_elevator_id").parent().hide()
  $("#intervention_elevator_id").val("null")
  $("#intervention_column_id").val("null")
  $("#intervention_battery_id").val("null")
  buildings = $('#intervention_building_id').html()
  batteries = $('#intervention_battery_id').html()
  columns = $('#intervention_column_id').html()
  elevators = $('#intervention_elevator_id').html()
  $('#intervention_customer_id').change ->
    $("#intervention_elevator_id").parent().hide()
    $("#intervention_column_id").parent().hide()
    $("#intervention_battery_id").parent().hide()
    customer = $("#intervention_customer_id :selected").text()
    options = $(buildings).filter("optgroup[label='#{customer}']").html()
    if options
      $("#intervention_building_id").html(options)
      $("#intervention_building_id").parent().show()
      $("#intervention_building_id").val("null")
    else
      $("#intervention_building_id").empty()
      $("#intervention_building_id").parent().hide()
  $('#intervention_building_id').change ->
    $("#intervention_elevator_id").parent().hide()
    $("#intervention_column_id").parent().hide()
    building = $("#intervention_building_id :selected").text()
    options = $(batteries).filter("optgroup[label='#{building}']").html()
    if options
      $("#intervention_battery_id").html(options)
      $("#intervention_battery_id").parent().show()
      $("#intervention_battery_id").val("null")
    else
      $("#intervention_battery_id").empty()
      $("#intervention_battery_id").parent().hide()
  $('#intervention_battery_id').change ->
    $("#intervention_elevator_id").parent().hide()
    battery = $("#intervention_battery_id :selected").text()
    options = $(columns).filter("optgroup[label='#{battery}']").html()
    if options
      $("#intervention_column_id").html(options)
      $("#intervention_column_id").parent().show()
      $("#intervention_column_id").val("null")
    else
      $("#intervention_column_id").empty()
      $("#intervention_column_id").parent().hide()
  $('#intervention_column_id').change ->
    column = $("#intervention_column_id :selected").text()
    options = $(elevators).filter("optgroup[label='#{column}']").html()
    if options
      $("#intervention_elevator_id").html(options)
      $("#intervention_elevator_id").parent().show()
      $("#intervention_elevator_id").val("null")
    else
      $("#intervention_elevator_id").empty()
      $("#intervention_elevator_id").parent().hide()
```
#### Zendesk Ticket
Calling the method `:ticket_intervention` in the `ticket_helper.rb`

*Partials Code:*
```rb
# interventions_controller.rb
  def create
    @intervention = Intervention.new(intervention_params)

    # Get format name of employee connected
    employee = current_user.employee.full_name

    # Give the id of the employee connected
    @intervention.author_id = current_user.employee.id

    # Data get for zendesk ticket
    battery_id = @intervention.battery_id
    column_id = @intervention.column_id
    elevator_id = @intervention.elevator_id

    # Condition for null ids not required
    if @intervention.elevator_id
      @intervention.battery_id = nil
      @intervention.column_id = nil
    elsif @intervention.column_id
      @intervention.battery_id = nil
    end

    respond_to do |format|
      if @intervention.save
        format.html { redirect_to '/interventions/new', notice: 'Intervention was successfully created.' }
        format.json { render :show, status: :created, location: @intervention }

        # Call method for create a zendesk ticket
        helpers.ticket_intervention(@intervention, employee, battery_id, column_id, elevator_id)
      else
        format.html { render :new }
        format.json { render json: @intervention.errors, status: :unprocessable_entity }
      end
    end
  end
```
``` rb
# ticket_helper.rb
  def ticket_intervention(params, requester, battery_id, column_id, elevator_id)
    client = client_con()

    # Fin the customer and get the name of the company
    company_name = Customer.find(params['customer_id']).company_name

    # Condition for check if a employee is assign in the form, else take the author and get the full name using the methode :full_name in the model Employee
    if params['employee_id'] == nil
      employee_assigns = Employee.find(params['author_id']).full_name
    else
      employee_assigns = Employee.find(params['employee_id']).full_name
    end

    # Create the fields and format them for the ticket
    subject = "Intervention for #{company_name}"
    comment = "Hello #{employee_assigns}, you have a new intervention for #{company_name}.\nInformations:\n\t - Buidlding_id: #{params['building_id']}\n\t - Battery_id: #{battery_id}"

    # Add the information of column and elevator if exists
    if column_id
      comment += "\n\t - Column_id: #{column_id}"
    end
    if elevator_id
      comment += "\n\t - Elevator_id: #{elevator_id}"
    end
    comment += "\nReport: #{params['report']}\n Cordially\n #{requester}"

    # Save the tickets
    ticket_save(client, subject, comment, "problem")
  end
```

## Request Rest API
#### Code Model Intervention
```c#
public class Intervention 
    {
        public int id { get; set; }
        public int author_id { get; set; }
        public int customer_id { get; set; }
        public int building_id { get; set; }
        public int? battery_id { get; set; }       // ? field can be null
        public int? column_id { get; set; }
        public int? elevator_id { get; set; }
        public int? employee_id { get; set; }
        public DateTime? start_date_intervention { get; set; }
        public DateTime? end_date_intervention { get; set; }
        public string result { get; set; }
        public string report { get; set; }
        public string status { get; set; }
        public DateTime created_at { get; set; }
        public DateTime updated_at { get; set; }
    
    }
```
#### First Request
GET: Returns all fields of all Service Request records that do not have a start date and are in "Pending" status.
#### Route request
https://tontedrocketelevatorrestapi.azurewebsites.net/api/interventions/pending
##### Code 
Explanations to comments in the code block
```c#
[Route("api/Interventions/Pending")]
// GET: api/Interventions/Pending
[HttpGet]
public async Task<ActionResult<IEnumerable<Intervention>>> GetInterventions()
{   
    // Create a list of interventions where the status is "Pending" and the start_date_intervention is null
    var listInterventions =    from inter in _context.interventions
                                where inter.start_date_intervention == null &&
                                inter.status == "Pending"
                                select inter;

    // Return the list to the client in json format
    return await listInterventions.ToListAsync();
}
```

#### Second Request
PUT: Change the status of the intervention request to "InProgress" and add a start date and time (Timestamp).
##### Route request
*Careful to put the id of the intervention you want to request*

https://tontedrocketelevatorrestapi.azurewebsites.net/api/interventions/start/ {id}
##### Code 
Explanations to comments in the code block
```c#
[Route("api/Interventions/Start/{id}")]
[HttpPut("{id}")]
public async Task<ActionResult<Intervention>> InterventionStarted(int id)
{
    // Create a instance of Intervention getting the data of the database with the id give in the query
    var intervention = await _context.interventions.FindAsync(id);

    // Check if the intervention exists
    if (id != intervention.id)
    {
        return BadRequest();
    }
    
    // Change the attribut to datetime a the query and the status to "InProgress"
    intervention.start_date_intervention = DateTime.Now;
    intervention.status = "InProgress";
    
    // Push modifications to the database
    await _context.SaveChangesAsync();

    // Return the new object internvention with the modifications to the client
    return intervention;
}
```
#### Third Request
PUT: Change the status of the intervention request to "InProgress" and add a start date and time (Timestamp).
##### Route request:
*Careful to put the id of the intervention you want to request*
https://tontedrocketelevatorrestapi.azurewebsites.net/api/interventions/End/ {id}
##### Code:
Explanations to comments in the code block
```c#
[Route("api/Interventions/End/{id}")]
[HttpPut("{id}")]

public async Task<ActionResult<Intervention>> InterventionFinish(int id)
{
    // Create a instance of Intervention getting the data of the database with the id give in the query
    var intervention = await _context.interventions.FindAsync(id);
    
    // Check if the intervention exists
    if (id != intervention.id)
    {
        return BadRequest();
    }

    // Change the end_date_intervention attribut to datetime a the query and the status to "Complete"
    intervention.end_date_intervention = DateTime.Now;
    intervention.status = "Complete";

    // Push modifications to the database
    await _context.SaveChangesAsync();
    
    // Return the new object internvention with the modifications to the client
    return intervention;
}
```

## Links and Access
### Links
Web app &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;        -> &nbsp;&nbsp;https://tonted.xyz/

Rest API &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;          -> &nbsp;&nbsp;https://tontedrocketelevatorrestapi.azurewebsites.net/

GitHub Rest API &nbsp;&nbsp;->&nbsp;&nbsp; https://github.com/tonTed/RE_Cons_RESTApi

Zendesk Agent &nbsp;&nbsp;&nbsp;&nbsp;->&nbsp;&nbsp; https://carotorre.zendesk.com/agent

### Access
##### Users in Web App:
|User|Password|Role|
|:---|:---|:---|
|admin@tonted.xyz| password| admin|
|nicolas.genest@codeboxx.biz| nicolas| employee|
|nadya.fortier@codeboxx.biz| nadya1| employee|
|martin.chantal@codeboxx.biz| martin| employee|
|mathieu.houde@codeboxx.biz| mathieu| employee|
|david.boutin@codeboxx.biz| david1| employee|
|mathieu.lortie@codeboxx.biz| mathieu| employee|
|thomas.carrier@codeboxx.biz| thomas| employee|



