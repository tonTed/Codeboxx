require 'zendesk_api'

module TicketHelper
  def client_con
    client = ZendeskAPI::Client.new do |config|

      config.url = "https://carotorre.zendesk.com/api/v2"
      config.username = ENV["ZENDESK_USERNAME"]
      config.token = ENV["ZENDESK_TOKEN"]
      config.retry = true
      config.raise_error_when_rate_limited = false

      require 'logger'
      config.logger = Logger.new(STDOUT)
    end
    return client
  end

  def ticket_save(client, subject, comment, type)
    ticket = ZendeskAPI::Ticket.new(client, :subject => subject, :comment => {:body => comment}, :type => type)
    ticket.save!
  end

  def ticket_lead(params)
    client = client_con()

    subject = "#{params['full_name']} from #{params['company_name']}"
    comment = "The contact #{params['full_name']} from company #{params['company_name']} can be reached at email  #{params['email']} and at phone number #{params['phone_number']}. #{params['department']} has a project named #{params['project_name']} which would require contribution from Rocket Elevators.\n Project description: #{params['project_description']}\nAttached Message: #{params['message']}"

    ticket_save(client, subject, comment, "question")
  end

  def ticket_quote(params)
    client = client_con()

    subject = "Quote for #{params['company_name']}"
    comment = "The company #{params['company_name']} has made an estimate for #{params['elevator_needed']} elevator(s) of the #{params['game']} model in a #{params['building_type']} building with #{params['floors_qty']} floors for a total amount of #{number_to_currency(params['total_price'])}.
		The contact email is #{params['email']}."

    ticket_save(client, subject, comment, "task")
  end

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

end
