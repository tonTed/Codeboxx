# ted = ["tonted",""]
# alex = ["postgres", "root"]
# jorge = ["jorge", "postgres"]
# jf = ["postgres", "postgres"]


host_ = "codeboxx-postgresql.cq6zrczewpu2.us-east-1.rds.amazonaws.com"
dbname_ = "warehouseTB"
user_ = "codeboxx"
password_ = "Codeboxx1!"


# make sure to connect the good user
require 'pg'
namespace :dwh do
    task mysql: :environment do
        mysqltest = ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['development'])
        puts mysqltest.connection.current_database
    end
    task postgres: :environment do
        pgsqltest = PG.connect(host: host_, dbname: dbname_, user: user_, password: password_)
        puts pgsqltest
    end

    
    desc "leads to FactContact import data"
    task fact_contact: :environment do
        conn = PG.connect( host: host_, dbname: dbname_, user: user_, password: password_ )
        # puts conn
        puts "leads table to fact_contacts table"
        Lead.all.each do |ldcontact|
            # pp ldcontact
            conn.exec_params(
                'INSERT INTO fact_contacts (contact_id, creation_date, company_name, email, project_name) VALUES ($1, $2, $3, $4, $5)',
                [ldcontact.id, ldcontact.create_at, "#{ldcontact.company_name}", "#{ldcontact.email}", "#{ldcontact.project_name}"])
        end
    end

    desc "get data from customer=>building=>batteries=>columns=>elevators"
    task fact_elevator: :environment do
        conn = PG.connect( host: host_, dbname: dbname_, user: user_, password: password_ )
        # puts conn
            Customer.all.each do |customer|          
                customer.buildings.each do |building|
                    building.batteries.each do |battery|
                        battery.columns.each do |column|
                            column.elevators.each do |elevator|
                                conn.exec_params(
                                    'INSERT INTO fact_elevators (serial_number, commissioning_date, building_id, customer_id, building_city) VALUES ($1, $2, $3, $4, $5)',
                                    ["#{elevator.serial_number}", elevator.date_commissioning, battery.building_id, building.customer_id, "#{building.address.city}"])                                  
                            end
                        end
                    end
                end
            end       
    end

    desc "quotes to fact_quote"
    task fact_quote: :environment do
        conn = PG.connect( host: host_, dbname: dbname_, user: user_, password: password_ )
        puts conn
        Quote.all.each do |quote|        
            conn.exec_params(
                'INSERT INTO fact_quotes (quote_id, creation_date, company_name, email, amount_elevator) VALUES ($1, $2, $3, $4, $5)',
                [quote.id, quote.create_at, "#{quote.company_name}", "#{quote.email}", quote.elevator_needed])           
        end
    end

    desc "customers to dimcustomers table"
    task dimcustomers: :environment do
        conn = PG.connect( host: host_, dbname: dbname_, user: user_, password: password_ )
        puts conn
        puts "elev to fact_elevators import data"

        def find_addres(id_)
            Address.all.each do |address|
                Address.count.times do
                    if address.id == id_
                        return address.city
                    end
                end
            end
        end

        Customer.all.each do |customer|
            $amount_elevators = 0      
            customer.buildings.each do |building|
                building.batteries.each do |battery|
                    battery.columns.each do |column|
                        $amount_elevators += column.elevators.count
                        column.elevators.each do |elevator|
                        end
                    end
                end
            end 
            qty_elevators = $amount_elevators
            # c_city = find_addres(customer.address_id)
            # puts "Customer #{customer.company_name} as #{qty_elevators} elevators!!"         
            conn.exec_params(
                'INSERT INTO dim_customers (creation_date, company_name, cpy_contact_name, cpy_contact_email, amount_elevator, customer_city) VALUES ($1, $2, $3, $4, $5, $6)',
                [customer.date_create, "#{customer.company_name}", "#{customer.cpy_contact_name}", "#{customer.cpy_contact_email}", qty_elevators,"#{find_addres(customer.address_id)}"]) 
        end

    end
end