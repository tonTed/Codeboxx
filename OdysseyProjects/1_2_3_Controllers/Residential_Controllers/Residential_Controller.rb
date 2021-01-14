require 'pp'


class Button
	
	attr_accessor :status
	
	def initialize(floorRequested)
		@floorRequested = floorRequested
		@status = false
	end
end

class ButtonFloor < Button
	
	attr_accessor :status
	
	def initialize(floorRequested, direction)
		super(floorRequested)
		@direction = direction
	end
end

class Elevator

	attr_accessor :currentFloor, :status, :buttonsElevatorFloor
	attr_reader :id_, :firstFloor

	def initialize(id_, floors, firstFloor)					#[OK]
		# Constructor for the class Elevator
		#
		#	Args:
		#		id_ (int): ID of the elevator
		#		floors (int): amount of floor served by the Elevator
		#		firstFloor (int): first floor served by the Elevator
		#
		#	Attributes:
		#		status (str): the status of the elevator "up", "down" or "idle"
		#		currentFloor (int): the current floor of the elevator
		#		buttonsElevatorFloor (hash): hash with all buttons in the elevator

		@id_ = id_
		@status = "idle"
		@currentFloor = 1
		@floors = floors
		@firstFloor = firstFloor
		@buttonsElevatorFloor = {}

		a = 0.100
		#Door
		@timeOpen = a		#5
		@timeToOpen = a		#2
		@timeToClose = a	#2

		#Elevator
		@timePerFloor = a	#1

		_createButtonsElevatorFloor
	end

	def _createButtonsElevatorFloor							#[OK]
		# Function to create the buttons inside the elevator for requested the floor
		
		for floor in @firstFloor...(@floors + @firstFloor)
			@buttonsElevatorFloor[floor] = Button.new(floor)
		end
	end

	def _openDoor											#[OK]
		# Function to open the door of the elevator

		puts "\t\tDoor is openning"
		sleep(@timeToOpen)
		puts "\t\tDoor is open"
		sleep(@timeOpen)
		_closeDoor
	end

	def _closeDoor											#[while sensor path blocked]
		# function to close the door of elevator
		
		puts("\t\tBe careful door is closing")
		sleep(@timeToClose)
		puts("\t\tDoor is close\n")
	end

	def _moveElevator(requestedFloor)						#[OK]
		# Function to move the elevator to the requested floor.
		# 	Depending on status "up" or "down", it moves on the direction status.
		# 	It increases or decreases the current floor of the elevator.
		# 	At the end it changes the status to "idle"
		# 
		# 	Args:
		# 		requestedFloor (int): requested floor for user or function requestElevator

		if @currentFloor < requestedFloor
			@status = "up"
			for i in @currentFloor...requestedFloor
				puts "\t\tmoving <#@status> from #@currentFloor to #{@currentFloor + 1}"
				@currentFloor += 1
				sleep(@timePerFloor)
			end
		elsif @currentFloor > requestedFloor
			@status = "down"
			for i in requestedFloor...@currentFloor
				puts "\t\tmoving <#@status> from #@currentFloor to #{@currentFloor - 1}"
				@currentFloor -= 1
				sleep(@timePerFloor)
			end
		end
		_openDoor
		@status = "idle"
	end

	def requestedFloor(requestedFloor)						#[OK]
		# Function to call the function moveElevator.
		# 	It changes also the status of the button to True at de beginning,
		# 	then to False after the elevator move
		# 
		# Args:
		# 	requestedFloor (int): requested floor for user
		
		puts "\t## Someone want's go to floor #{requestedFloor} ##"
		@buttonsElevatorFloor[requestedFloor].status = true
		_moveElevator(requestedFloor)
		@buttonsElevatorFloor[requestedFloor].status = false
	end

end

class Column

	attr_accessor :listElevators, :buttonsFloorsFloor
	attr_reader :firstFloor, :floors

	def initialize(floors, qtyElevators)					#[OK]
		# Constructor for the class Column
		# 
		# Args:
		# 	floors (int): floors on the column
		# 	qtyElevators (int): quantity of elevators in the column
		# 
		# Attributes:
		# 	listElevator (hash): hash with the elevators
		# 	firstFloor (int): parameter for get the first floor in the column  (1 per default)
		# 	buttonsFloorsFloor (hash): hash with all buttons in the floors

		@floors = floors
		@qtyElevators = qtyElevators
		@listElevators = {}
		@firstFloor = 1
		@buttonsFloorsFloor = {}

		_createElevators
		_createButtonsFloorsFloor
	end

	def _createButtonsFloorsFloor							#[OK]
		# Function for create the call button on ecah floor
		# 	It creates two buttons per floor "up" and "down",
		# 	excep the firstfloor where it creates only a "up" button,
		# 	and on the last floor only a "down" button.
		
		for floor in @firstFloor...(@floors + @firstFloor)
			if floor == @firstFloor
				@buttonsFloorsFloor["#{floor}up"] = ButtonFloor.new(floor, "up")
			elsif floor == @floors
				@buttonsFloorsFloor["#{floor}down"] = ButtonFloor.new(floor, "down")
			else
				@buttonsFloorsFloor["#{floor}up"] = ButtonFloor.new(floor, "up")
				@buttonsFloorsFloor["#{floor}down"] = ButtonFloor.new(floor, "down")
			end
		end
	end

	def	_createElevators 									#[OK]
		# Function for create elevators
		
		for i in 0...@qtyElevators
			@listElevators["elevator#{i}"] = Elevator.new("elevator#{i}", @floors, @firstFloor)
			puts ":: elevator#{i} created ::"
		print "\n"
		end
	end

	def _isCloser(listElevators, requestedFloor)			#[OK]
		# Function to find the elevator closer that the requested floor.
		# 	It creates a list of tuples with the elevator and 
		# 	the difference between his current floor and the requested floor.
		# 	Then sort the list and returns the first elevator in the list.
		# 
		# 	Args:
		# 		listElevators (list): list of objects Elevator
		# 		requestedFloor (int): floor requested for the user
		# 
		# 	Returns:
		# 		Elevator: The elevator closer that the requeste floor
		
		sortedList = []
		listElevators.each do |elevator|
			sortedList.push({:diff => (elevator.currentFloor - requestedFloor).abs, :elevator => elevator})
		end
		sortedList.sort_by! do |elevator|
			elevator[:diff]
		end
		return sortedList[0][:elevator]
	end
	
	def _returnElevator(listElevators, requestedFloor)		#[OK]
		# Function to check the length of the list receipt,
		# 	and return False if is empty, return the elevator if is length is 1,
		# 	else it calls the function isCloser.
		# 
		# Args:
		# 	listElevators (list): list of objects Elevator	
		# 	requestedFloor (int): floor requested for the user
		# 
		# Returns:
		# 	bool: if the list is empty
		# 	or
		# 	Elevator: The best elevator

		if listElevators.length == 0
			return false
		elsif listElevators.length == 1
			return listElevators[0]
		else
			return _isCloser(listElevators, requestedFloor)
		end
	end
	
	def _theAreOnWay(requestedFloor, direction)				#[OK]
		# Function to check if one or more elevators are on the same way.
		# 	It creates a list of elevator on the same way, then returns the list. 
		# 
		# 	Args:
		# 		requestedFloor (int): floor requested for the user
		# 		direction (str): "up" or "down" 
		# 
		# 	Returns:
		# 		list: the list of elevator on the same way

		listOfElevators = []
		@listElevators.each do |key, elevator|
			if elevator.status == direction
				if (direction == "up" and elevator.currentFloor <= requestedFloor) or (direction == "down" and elevator.currentFloor >= requestedFloor)
					listOfElevators.push(elevator)
				end
			end
		end
		return _returnElevator(listOfElevators, requestedFloor)
	end
		
	def _theAreNotOnWay(requestedFloor, direction)				#[OK]
		# Function to check if one or more elevators are not on the same way.
		# 	It creates a list of elevator not on the same way, then returns the list. 
		# 
		# 	Args:
		# 		requestedFloor (int): floor requested for the user
		# 		direction (str): "up" or "down" 
		# 
		# 	Returns:
		# 		list: the list of elevator on the same way

		listOfElevators = []
		@listElevators.each do |key, elevator|
			if elevator.status != direction
				listOfElevators.push(elevator)
			end
		end
		return _returnElevator(listOfElevators, requestedFloor)
	end
	
	def _therAreIdle(requestedFloor)				#[OK]
		# Function to check if one or more elevators are "idle".
		# 	It creates a list of elevator "idle", then returns the list. 
		# 
		# 	Args:
		# 		requestedFloor (int): floor requested for the user
		# 
		# 	Returns:
		# 		list: the list of elevator on the same way

		listOfElevators = []
		@listElevators.each do |key, elevator|
			if elevator.status == "idle"
				listOfElevators.push(elevator)
			end
		end
		return _returnElevator(listOfElevators, requestedFloor)
	end

	def _choiceElevator(requestedFloor, direction)			#[OK]
		# Function to choice the best elevator
		# 	It calling others functions and returns the best elevator
		# 
		# 	Args:
		# 		requestedFloor (int): floor requested for the user
		# 		direction (str): "up" or "down" 
		# 
		# 	Returns:
		# 		Elevator: The best elevator

		elevator = _theAreOnWay(requestedFloor, direction) ? _theAreOnWay(requestedFloor, direction) : false
		elevator = _therAreIdle(requestedFloor) ? _therAreIdle(requestedFloor) : false
		elevator = _theAreNotOnWay(requestedFloor, direction)
		return elevator
	end
		
	def requestElevator(requestedFloor, direction)			#[OK]
		# Function for request the best elevator an move them.
		# 	It changes the status of button requested from the beginning.
		# 	Then it calls the function for choice the best elevator.
		# 	Then it move the elevator selected and change the status of the button.
		# 
		# 	Args:
		# 		requestedFloor (int): floor requested for the user
		# 		direction (str): "up" or "down" 
		# 
		# 	Returns:
		# 		Elevator: The best elevator
		
		puts "## Someone call a elevator on floor #{requestedFloor} ##"
		@buttonsFloorsFloor["#{requestedFloor}#{direction}"].status = true
		elevator = _choiceElevator(requestedFloor, direction)
		puts "\t>>> elevator #{elevator.id_} was called <<<"
		@buttonsFloorsFloor["#{requestedFloor}#{direction}"].status = false
		elevator._moveElevator(requestedFloor)
		return elevator
	end
end

########################### SCENARIO SECTION ###########################
def lets_go
	def scenario1(column)
		column.listElevators["elevator0"].currentFloor = 2
		column.listElevators["elevator1"].currentFloor = 6

		elevator = column.requestElevator(3, "up")
		elevator.requestedFloor(7)
	end

	def scenario2(column)
		column.listElevators["elevator0"].currentFloor = 10
		column.listElevators["elevator1"].currentFloor = 3

		elevator = column.requestElevator(1, "up")
		elevator.requestedFloor(6)
		elevator = column.requestElevator(3, "up")
		elevator.requestedFloor(5)
		elevator = column.requestElevator(9, "down")
		elevator.requestedFloor(2)
	end

	def scenario3(column)
		column.listElevators["elevator0"].currentFloor = 10
		column.listElevators["elevator1"].currentFloor = 3
		column.listElevators["elevator1"].status = "up"

		elevator = column.requestElevator(3, "down")
		elevator.requestedFloor(2)

		print("\n========== elevator1 moving")
		column.listElevators["elevator1"]._moveElevator(6)
		print("============\n")

		elevator = column.requestElevator(10, "down")
		elevator.requestedFloor(3)
	end

	puts "\n----- Scenario 1 -----"
	columnScenario1 = Column.new(10, 2)
	scenario1(columnScenario1)

	puts "\n----- Scenario 2 -----"
	columnScenario2 = Column.new(10, 2)
	scenario2(columnScenario2)

	puts "\n----- Scenario 3 -----"
	columnScenario3 = Column.new(10, 2)
	scenario3(columnScenario3)
end

######################### END SCENARIO SECTION #########################



########################## UI TERMINAL SECTION #########################

class Game

	attr_accessor :name, :column

	def initialize
		@name = ""
		@timeSleep = 0.800
		@column = ""

		_welcome
	end

	def _sleep_loop(times, time)
		times.times do
			print "."
			sleep(time)
		end
	end
	
	def _isnumber?(number, min, max)
		number = number.to_i
		if number < min or number > max or number == 0
			puts "\nOups, we need a number between #{min} and #{max}"
			return false
		else
			return number
		end
	end
	
	def _get_number(min, max, anwser)
		number = 0
		loop do
			print "\n#{anwser}"
			number = gets.chomp
			number = _isnumber?(number, min, max)
			break if number != false
		end
		return number
	end
	
	def _qty_elevators
		number = _get_number(2, 99, "So, how many elevators you want ? ")
		return number
	end
	
	def _floors
		number = _get_number(2, 99, "So, how many floors you want ? ")
		return number
	end

	def _welcome
		print "\nHello, what's yout name? "
		@name = gets.chomp
		puts "\nNice to meet you #{@name} !!!"
		sleep(@timeSleep)
		qtyElevators = _qty_elevators
		floors = _floors
		_create_column(floors, qtyElevators)
		_teleported

	end

	def _create_column(floors, qtyElevators)
		@column = Column.new(floors, qtyElevators)
		puts "Now let's go puts elevator in a random floor >>"
		@column.listElevators.each do |key, elevator|
			elevator.currentFloor = rand(elevator.firstFloor..floors)
			_sleep_loop(5, 0.3)
			puts "#{elevator.id_} is on floor #{elevator.currentFloor}"
		end
	end
	
	def upORdown(requestedFloor)
		if requestedFloor == 1
			print "\nwhich floor do you want to go up? "
			direction = "up"
		elsif
			requestedFloor == @column.floors
			print "\nwhich floor do you want to go down? "
			direction = "down"
		else
			loop do
				print "\nDo you want to go up or go down (up/down)? "
				direction = gets.chomp
				break if direction == "up" or direction == "down"
			end
		return direction
		end
	end

	def _teleported
		requestedFloor = _get_number(@column.firstFloor, @column.floors,"So, now on what floor do you want be teleported ? ")
		puts "\nBadaboummmmm, your are on floor #{requestedFloor}"
		_play(requestedFloor)
	end

	def yes_or_no?
		loop do
			print "Do you want call another elevator (o/n)? "
			@continue = gets.chomp
			break if @continue == "o" or @continue == "n"
		end
		return @continue == "o" ? "o" : false
	end

	def _play(requestedFloor)
		loop do
			direction = upORdown(requestedFloor)
			elevator = @column.requestElevator(requestedFloor, direction)
			requestedFloor = _get_number(@column.firstFloor, @column.floors,"Welcom in our pretty #{elevator.id_}. What floor do you want to go? ")
			puts "hang on we go to floor #{requestedFloor} !!!"
			elevator.requestedFloor(requestedFloor)
			break if !yes_or_no?
		end
	end
	

end

######################## END UI TERMINAL SECTION #######################



############################ TESTING SECTION ###########################

lets_go
newGame = Game.new

########################## END TESTING SECTION #########################