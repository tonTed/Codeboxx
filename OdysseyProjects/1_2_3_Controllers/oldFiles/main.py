################################################## TO DO LIST ##################################################
#	[] - _closeDoor > While for sensor
#	[] - surcharge methode repr pour nom objet
#
#
#
#

import time
from pprint import pprint


class Elevator:
	def __init__(self, id_, floors):								#[]
		self.id_ = id_
		self.floors = floors
		self.status = "up"
		self.currentFloor = 1
		self.elevatorListRequest = []	# {direction:, etage:}
		self.callButtonsInElevator = [{"floor": None, "pressed" : None}]		#first dict is the floor 0

		self._createCallButtonsInElevator()

		#Door
		self.sensorDoor = False
		self.timeOpen = 5
		self.timeToOpen = 2
		self.timeToClose = 2

		#Time Request
			# self.timeRequests = 0
			# self.timeInFloor = self.timeToOpen + self.timeOpen + self.timeToClose
			# self.timeBetweenFloors = 5
			# def computeTimeRequests(self):
			# 	pass

			# def addToElevatorListRequest(self):
			# 	#requested floor
			# 	#direction

	def _createCallButtonsInElevator(self):
		for floor in range(self.floors):
			self.callButtonsInElevator.append({"floor": floor + 1, "pressed" : False})
	
	def openDoor(self):										#[OK]
		self._displayLocation("Door is openning")
		time.sleep(self.timeToOpen)
		self._displayLocation("Door is open")
		time.sleep(self.timeOpen)
		self._closeDoor()

	def _closeDoor(self):									#[$$]
		self._displayLocation("Be careful door is closing")
		time.sleep(self.timeToClose)
		self._displayLocation("Door is close")

	def _displayLocation(self, message):					#[OK]
		print(f":: ELEVATOR {self.id_} ON FLOOR {self.currentFloor}:: {message}")

	def __repr__(self):
		return f"Elevator {self.id_}"

class Column:
	def __init__(self, name, floors, qtyElevators):			#[]
		self.name = name
		self.floors = floors
		self.qtyElevators = qtyElevators
		self.callButtonsInFloors = {}
		self.elevators = {}

		#parameters
		self.firstFloor = 1

		self._createCallButtonsInFloors()
		self._createElevators()
	
	def _createCallButtonsInFloors(self):					#[OK]
		"""
			Function for create call buttons in floors
				One UP in the first floor
				One DOWN in the last floor
				One UP and one Down in the other floors

			Call exemple : column.callButtonsInFloors[floor][direction] = True or False
		"""
		for floor in range(self.firstFloor, self.floors + self.firstFloor):
			if floor == self.firstFloor :
				self.callButtonsInFloors[floor] = {"direction": "up", "pressed": False}
			elif floor == self.floors:
				self.callButtonsInFloors[floor] = {"direction": "down", "pressed": False}
			else:
				self.callButtonsInFloors[floor] = {"direction": "up", "pressed": False}
				self.callButtonsInFloors[floor] = {"direction": "down", "pressed": False}
		# pprint(self.callButtonsInFloors)
	
	def	_createElevators(self): 							#[X]
		"""
			Function for create as much elevators in the column than input

			Call exemple : 
		"""
		for i in range(self.qtyElevators):
			self.elevators[f"elevator{self.name}{i}"] = Elevator(f"{self.name}{i}", self.floors)

	def isOnWay(self, button):
		print("isOnWay")
		listOfElevators = []
		for elevator in self.elevators:
			if self.elevators[elevator].status == button["direction"]:
				if button["direction"] == "up" and button["floor"] > self.elevators[elevator].currentFloor:
					print(self.elevators[elevator].status + f"{button['floor']}")
	
	def choiceElevator(self, button):
		print("choiceElevator")
		self.isOnWay(button)
	
	def run(self):
		i = 1
		for floor in self.callButtonsInFloors:
			print(f"{i} - {self.callButtonsInFloors[floor]}")
			i += 1

		# break
		# if button["pressed"] == True:
		# 	self.choiceElevator(button)
		# 	#choiceelevator then add to list request of elevator
		# 	button["pressed"] = False
		# for elevator in self.elevators:
		# 	for button in self.elevators[elevator].callButtonsInElevator:
		# 		if button["pressed"] == True:
		# 			#choiceelevator then add to list request of elevator
		# 			button["pressed"] = False
			


################################################## TESTING SECTION ##################################################
if __name__ == "__main__":
	columnA = Column("A", 10, 2)
	# columnA.callButtonsInFloors[5]["pressed"] = True
	# columnA.elevators["elevatorA0"].callButtonsInElevator[4]["pressed"] = True
	# print(columnA.elevators["elevatorA0"].callButtonsInElevator[4])
	
	columnA.run()



	

################################################## END TESTING SECTION ##################################################


################################################## ALGO CONCEPTION ######################################################

# MAIN PROGRAM











################################################ END ALGO CONCEPTION ####################################################
