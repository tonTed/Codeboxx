import time
from pprint import pprint

class Button:
	def __init__(self,floorRequested):
		self.floorRequested = floorRequested
		self.status = False

	def __repr__(self):
		return f"[ floorRequested: {self.floorRequested}, status: {self.status} ]"

class ButtonFloor(Button):
	def __init__(self, floorRequested, direction):
		super().__init__(floorRequested)
		self.direction = direction
	
	def __repr__(self):
		return f"[ floorRequested: {self.floorRequested}, direction: {self.direction}, status: {self.status} ]"
	
class Elevator:
	def __init__(self, id_, floors, firstFloor):				#[OK]
		"""Constructor for the class Elevator

			Args:
				id_ (int): ID of the elevator
				floors (int): amount of floor served by the Elevator
				firstFloor (int): first floor served by the Elevator

			Attributes:
				status (str): the status of the elevator "up", "down" or "idle"
				currentFloor (int): the current floor of the elevator
				buttonsElevatorFloor (dict): dict with all buttons in the elevator
		"""
		
		self.id_ = id_
		self.status = "idle"
		self.currentFloor = 1
		self.floors = floors
		self.firstFloor = firstFloor
		self.buttonsElevatorFloor = {}

		self._createButtonsElevatorFloor()

		a = 0.200
		#Door
		self.timeOpen = a		#5
		self.timeToOpen = a		#2
		self.timeToClose = a	#2

		#Elevator
		self.timePerFloor = a	#1

		#actions
		self.timeAction = 0.300

	def __repr__(self):											#[OK]
		"""Function to change de output when you call the object

			Returns:
				str: name of object
		"""
		return f"{self.id_}"

	def _createButtonsElevatorFloor(self):						#[OK]
		"""Function to create the buttons inside the elevator for requested the floor
		"""
		for floor in range(self.firstFloor, self.floors + self.firstFloor):
			self.buttonsElevatorFloor[floor] = Button(floor)

	def _openDoor(self):										#[OK]
		"""Function to open the door of the elevator
		"""
		print("\t\tDoor is openning")
		time.sleep(self.timeToOpen)
		print("\t\tDoor is open")
		time.sleep(self.timeOpen)
		self._closeDoor()

	def _closeDoor(self):										#[while sensor path blocked]
		"""function to close the door of elevator
		"""
		print("\t\tBe careful door is closing")
		time.sleep(self.timeToClose)
		print("\t\tDoor is close\n")
	
	def _moveElevator(self, requestedFloor):					#[OK]
		"""Function to move the elevator to the requested floor.
			Depending on status "up" or "down", it moves on the direction status.
			It increases or decreases the current floor of the elevator.
			At the end it changes the status to "idle"

			Args:
				requestedFloor (int): requested floor for user or function requestElevator
		"""
		if self.currentFloor < requestedFloor:
			self.status = "up"
			for i in range(self.currentFloor, requestedFloor):
				print(f"\t\tmoving <{self.status}> from {self.currentFloor} to {self.currentFloor + 1}")
				self.currentFloor += 1
				time.sleep(self.timePerFloor)
		elif self.currentFloor > requestedFloor:
			self.status = "down"
			for i in range(requestedFloor, self.currentFloor):
				print(f"\t\tmoving <{self.status}> from {self.currentFloor} to {self.currentFloor - 1}")
				self.currentFloor -= 1
				time.sleep(self.timePerFloor)
		self._openDoor()
		self.status = "idle"

	def requestedFloor(self, requestedFloor):					#[OK]
		"""Function to call the function moveElevator.
			It changes also the status of the button to True at de beginning,
			then to False after the elevator move

			Args:
				requestedFloor (int): requested floor for user
		"""
		print(f"\t## Someone want's go to floor {requestedFloor} ##")
		self.buttonsElevatorFloor[requestedFloor].status = True
		self._moveElevator(requestedFloor)
		self.buttonsElevatorFloor[requestedFloor].status = False

class Column:
	def __init__(self, floors, qtyElevators):					#[OK]
		"""Constructor for the class Column

			Args:
				floors (int): floors on the column
				qtyElevators (int): quantity of elevators in the column

			Attributes:
				listElevator (dict): dict with the elevators
				firstFloor (int): parameter for get the first floor in the column  (1 per default)
				buttonsFloorsFloor (dict): dict with all buttons in the floors
		"""
		self.floors = floors
		self.qtyElevators = qtyElevators
		self.listElevators = {}
		self.firstFloor = 1
		self.buttonsFloorsFloor = {}

		self._createElevators()
		self._createButtonsFloorsFloor()
	
	def	_createElevators(self): 								#[OK]
		"""Function for create elevators
			It create as much elevator that were requested during the creation of the column
		"""
		for i in range(self.qtyElevators):
			self.listElevators[f"elevator{i}"] = Elevator(f"elevator{i}", self.floors, self.firstFloor)
			print(f":: elevator{i} created ::")
		print("\n")
	
	def _createButtonsFloorsFloor(self):						#[OK]
		"""Function for create the call button on ecah floor
			It creates two buttons per floor "up" and "down",
			excep the firstfloor where it creates only a "up" button,
			and on the last floor only a "down" button.
		"""
		for floor in range(self.firstFloor, self.floors + self.firstFloor):
			if floor == self.firstFloor:
				self.buttonsFloorsFloor[f"{floor}up"] = ButtonFloor(floor, "up")
			elif floor == self.floors:
				self.buttonsFloorsFloor[f"{floor}down"] = ButtonFloor(floor, "down")
			else:
				self.buttonsFloorsFloor[f"{floor}up"] = ButtonFloor(floor, "up")
				self.buttonsFloorsFloor[f"{floor}down"] = ButtonFloor(floor, "down")
		# pprint(self.buttonsFloorsFloor)

	def _isCloser(self, listElevators, requestedFloor):			#[OK]
		"""Function to find the elevator closer that the requested floor.
			It creates a list of tuples with the elevator and 
			the difference between his current floor and the requested floor.
			Then sort the list and returns the first elevator in the list.

			Args:
				listElevators (list): list of objects Elevator
				requestedFloor (int): floor requested for the user

			Returns:
				Elevator: The elevator closer that the requeste floor
		"""

		sortedList = []
		for elevator in listElevators:
			sortedList.append((abs(elevator.currentFloor - requestedFloor), elevator))
		sortedList.sort(key=lambda diff: diff[0])
		return sortedList[0][1]
	
	def _returnElevator(self, listElevators, requestedFloor):	#[OK]
		"""Function to check the length of the list receipt,
			and return False if is empty, return the elevator if is length is 1,
			else it calls the function isCloser.

			Args:
				listElevators (list): list of objects Elevator	
				requestedFloor (int): floor requested for the user

			Returns:
				bool: if the list is empty
				or
				Elevator: The best elevator
		"""
		if len(listElevators) == 0:
			return False
		elif len(listElevators) == 1:
			return listElevators[0]
		else:
			return self._isCloser(listElevators, requestedFloor)
	
	def _theAreOnWay(self, requestedFloor, direction):			#[OK]
		"""Function to check if one or more elevators are on the same way.
			It creates a list of elevator on the same way, then returns the list. 

			Args:
				requestedFloor (int): floor requested for the user
				direction (str): "up" or "down" 

			Returns:
				list: the list of elevator on the same way
		"""

		listOfElevators = []
		for elevator in self.listElevators:
			elevator = self.listElevators[elevator]
			if elevator.status == direction:
				if (direction == "up" and elevator.currentFloor <= requestedFloor) or (direction == "down" and elevator.currentFloor >= requestedFloor):
					listOfElevators.append(elevator)
		return self._returnElevator(listOfElevators, requestedFloor)

	def _theAreNotOnWay(self, requestedFloor, direction):		#[OK]
		"""Function to check if one or more elevators are not on the same way.
			It creates a list of elevator not on the same way, then returns the list. 

			Args:
				requestedFloor (int): floor requested for the user
				direction (str): "up" or "down" 

			Returns:
				list: the list of elevator not on the same way
		"""

		listOfElevators = []
		for elevator in self.listElevators:
			elevator = self.listElevators[elevator]
			if elevator.status != direction:
				listOfElevators.append(elevator)
		return self._returnElevator(listOfElevators, requestedFloor)

	def _theAreIdle(self, requestedFloor):						#[OK]
		"""Function to check if one or more elevators are "idle".
			It creates a list of elevator "idle", then returns the list. 

			Args:
				requestedFloor (int): floor requested for the user

			Returns:
				list: the list of elevator on the same way
		"""
		listOfElevators = []
		for elevator in self.listElevators:
			elevator = self.listElevators[elevator]
			if elevator.status == "idle":
				listOfElevators.append(elevator)
		return self._returnElevator(listOfElevators, requestedFloor)

	def _choiceElevator(self, requestedFloor, direction):		#[OK]	
		"""Function to choice the best elevator
			It calling others functions and returns the best elevator

			Args:
				requestedFloor (int): floor requested for the user
				direction (str): "up" or "down" 

			Returns:
				Elevator: The best elevator
		"""
		
		if elevator := self._theAreOnWay(requestedFloor, direction):
			return elevator
		if elevator := self._theAreIdle(requestedFloor):
			return elevator
		else:
			return self._theAreNotOnWay(requestedFloor, direction)
	
	def requestElevator(self, requestedFloor, direction):		#[OK]
		"""Function for request the best elevator an move them.
			It changes the status of button requested from the beginning.
			Then it calls the function for choice the best elevator.
			Then it move the elevator selected and change the status of the button.

			Args:
				requestedFloor (int): floor requested for the user
				direction (str): "up" or "down" 

			Returns:
				Elevator: The best elevator
		"""

		print(f"## Someone call a elevator on floor {requestedFloor} ##")
		self.buttonsFloorsFloor[f"{requestedFloor}{direction}"].status = True
		elevator = self._choiceElevator(requestedFloor, direction)
		print(f"\t>>> {elevator} was called <<<")
		elevator._moveElevator(requestedFloor)
		self.buttonsFloorsFloor[f"{requestedFloor}{direction}"].status = False
		return elevator

########################### SCENARIO SECTION ###########################
def letsGo():	
	def scenario1(column):
		column.listElevators["elevator0"].currentFloor = 2
		column.listElevators["elevator1"].currentFloor = 6

		elevator = column.requestElevator(3, "up")
		elevator.requestedFloor(7)

	def scenario2(column):
		column.listElevators["elevator0"].currentFloor = 10
		column.listElevators["elevator1"].currentFloor = 3

		elevator = column.requestElevator(1, "up")
		elevator.requestedFloor(6)
		elevator = column.requestElevator(3, "up")
		elevator.requestedFloor(5)
		elevator = column.requestElevator(9, "down")
		elevator.requestedFloor(2)

	def scenario3(column):
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

	print("\n----- Scenario 1 -----")
	columnScenario1 = Column(10, 2)
	scenario1(columnScenario1)

	print("\n----- Scenario 2 -----")
	columnScenario2 = Column(10, 2)
	scenario2(columnScenario2)

	print("\n----- Scenario 3 -----")
	columnScenario3 = Column(10, 2)
	scenario3(columnScenario3)

######################### END SCENARIO SECTION #########################

############################ TESTING SECTION ###########################

if __name__ == "__main__":
	letsGo()

########################## END TESTING SECTION #########################



