
function sleep(milliseconds) {
	var start = new Date().getTime();
	while((new Date().getTime() - start) < milliseconds){
	};
};

class Button{
	constructor(floorRequested){
		this.floorRequested = floorRequested;
		this.status = false
	}
};

class ButtonFloor extends Button{
	constructor(floorRequested, direction){
		super(floorRequested);
		this.direction = direction;
	}
}

class Elevator{
	constructor(id_, floors, firstFloor){			//[OK]
	/** 
	 * Constructor for the class Elevator
	 *
	 *	Args:
	 *		id_ (int): ID of the elevator
	 *		floors (int): amount of floor served by the Elevator
	 *		firstFloor (int): first floor served by the Elevator
	 *
	 *	Attributes:
	 *		status (str): the status of the elevator "up", "down" or "idle"
	 *		currentFloor (int): the current floor of the elevator
	 *		buttonsElevatorFloor (object): object with all buttons in the elevator
	 *
	 */

		this.id_ = id_;
		this.status = "idle";
		this.currentFloor = 1;
		this.floors = floors;
		this.firstFloor = firstFloor;
		this.buttonsElevatorFloor = {};

		this._createButtonsElevatorFloor();

		let a = 100;
		//Door
		this.timeOpen = a;		//5
		this.timeToOpen = a;	//2
		this.timeToClose = a;	//2

		//Elevator
		this.timePerFloor = a;	//1
	};

	_createButtonsElevatorFloor(){					//[OK]
		// Function to create the buttons inside the elevator for requested the floor

		for(let floor = this.firstFloor; floor <= this.floors; floor++){
			this.buttonsElevatorFloor[floor] = new Button(floor);
		};
	};

	_openDoor(){									//[OK]
		// Function to open the door of the elevator
		
		console.log("\t\tDoor is openning");
		sleep(this.timeOpen);
		console.log("\t\tDoor is open");
		sleep(this.timeOpen);
		this._closeDoor();
	};

	_closeDoor(){									//[OK]
		// Function to close the door of the elevator
		
		console.log("\t\tBe careful door is closing");
		sleep(this.timeToClose);
		console.log("\t\tDoor is close\n");
	};

	_moveElevator(requestedFloor){					//[OK]
		/** 
		 * Function to move the elevator to the requested floor.
		 *	Depending on status "up" or "down", it moves on the direction status.
		 *	It increases or decreases the current floor of the elevator.
		 *	At the end it changes the status to "idle"
		 *
		 *	Args:
		 *		requestedFloor (int): requested floor for user or function requestElevator
		 */

		if (this.currentFloor < requestedFloor) {
			this.status = "up";
			while(this.currentFloor != requestedFloor){
				console.log("\t\tmoving <" + this.status + "> from " + this.currentFloor + " to " + (this.currentFloor + 1));
				this.currentFloor++;
				sleep(this.timePerFloor);
			};
		} else if (this.currentFloor > requestedFloor) {
			this.status = "down";
			while(this.currentFloor != requestedFloor){
				console.log("\t\tmoving <" + this.status + "> from " + this.currentFloor + " to " + (this.currentFloor - 1));
				this.currentFloor--;
				sleep(this.timePerFloor);
			};
		};
		this._openDoor();
		this.status = "idle";
	}

	requestedFloor(requestedFloor){					//[OK]
		/** 
		 * Function to call the function moveElevator.
		 * It changes also the status of the button to True at de beginning,
		 * then to False after the elevator move
		 * 
		 * Args:
		 * 		requestedFloor (int): requested floor for user
		 */

		console.log("\t## Someone want's go to floor " + requestedFloor + " ##");
		this.buttonsElevatorFloor[requestedFloor].status = true
		this._moveElevator(requestedFloor)
		this.buttonsElevatorFloor[requestedFloor].status = false
	};
};

class Column{
	constructor(floors, qtyElevators){					//[OK]
		/**
		 * Constructor for the class Column
		 *
		 *	Args:
		 *		floors (int): floors on the column
		 *		qtyElevators (int): quantity of elevators in the column
		 *
		 *	Attributes:
		 *		listElevator (object): object with the elevators
		 *		firstFloor (int): parameter for get the first floor in the column  (1 per default)
		 *		buttonsFloorsFloor (object): object with all buttons in the floors
		 */

		this.floors = floors;
		this.qtyElevators = qtyElevators;
		this.listElevators = {};
		this.firstFloor = 1;
		this.buttonsFloorsFloor = {};

		this._createElevators();
		this._createButtonsFloorsFloor();
	};

	_createButtonsFloorsFloor(){						//[OK]
		/**
		 * Function for create the call button on ecah floor
		 *	It creates two buttons per floor "up" and "down",
		 *	excep the firstfloor where it creates only a "up" button,
		 *	and on the last floor only a "down" button.
		 */

		for(let floor = this.firstFloor; floor <= this.floors; floor++){
			if (floor === this.firstFloor){
				this.buttonsFloorsFloor[floor + "up"] = new ButtonFloor(floor, "up");
			} else if (floor === this.floors){
				this.buttonsFloorsFloor[floor + "down"] = new ButtonFloor(floor, "down");
			} else {
				this.buttonsFloorsFloor[floor + "up"] = new ButtonFloor(floor, "up");
				this.buttonsFloorsFloor[floor + "down"] = new ButtonFloor(floor, "down");
			}
		};
	};

	_createElevators() { 								//[OK]
		// Function for create elevators

		for(let i = 0; i < this.qtyElevators; i++){
			this.listElevators["elevator" + i] = new Elevator(i, this.floors, this.firstFloor);
			console.log(":: elevator" + i + "created ::")
		};
	};

	_isCloser(listElevators, requestedFloor){			//[OK]
		/**
		 * Function to find the elevator closer that the requested floor.
		 *	It creates a list of tuples with the elevator and 
		 *	the difference between his current floor and the requested floor.
		 *	Then sort the list and returns the first elevator in the list.
		 *
		 *	Args:
		 *		listElevators (list): list of objects Elevator
		 *		requestedFloor (int): floor requested for the user
		 *
		 *	Returns:
		 *		Elevator: The elevator closer that the requeste floor
		 */

		let sortedList = [];
		for (let elevator_ in listElevators){
			let elevator = listElevators[elevator_];
			sortedList.push([elevator , Math.abs(elevator.currentFloor - requestedFloor)]);
		};
		sortedList.sort((a, b) => {
			if (a[1] < b[1]) return -1;
			if (a[1] > b[1]) return 1;
			return 0;
		});
		return sortedList[0][0];
	}

	_returnElevator(listElevators, requestedFloor){		//[OK]
		/**
		 * Function to check the length of the list receipt,
		 *	and return False if is empty, return the elevator if is length is 1,
		 *	else it calls the function isCloser.
		 *
		 *	Args:
		 *		listElevators (list): list of objects Elevator	
		 *		requestedFloor (int): floor requested for the user
 		 *
		 * 	Returns:
		 *		bool: if the list is empty
		 *		or
		 *		Elevator: The best elevator
		 */

		if (listElevators.length == 0){
			return false;
		} else if (listElevators.length == 1){
			return listElevators[0];
		} else {
			return this._isCloser(listElevators, requestedFloor);
		};
	};

	_theAreOnWay(requestedFloor, direction){			//[OK]
		/**
		 * Function to check if one or more elevators are on the same way.
		 *	It creates a list of elevator on the same way, then returns the list. 
		 *
		 *	Args:
		 *		requestedFloor (int): floor requested for the user
		 *		direction (str): "up" or "down" 
		 *
		 *	Returns:
		 *		list: the list of elevator on the same way
		 */

		let listOfElevators = []
		for(let elevator_ in this.listElevators){
			let elevator = this.listElevators[elevator_]
			if (elevator.status === direction){
				if ((direction === "up" && elevator.currentFloor <= requestedFloor) || (direction === "down" && elevator.currentFloor >= requestedFloor)){
					listOfElevators.push(elevator);
				};
			};
		};
		return this._returnElevator(listOfElevators, requestedFloor);
	};

	_theAreNotOnWay(requestedFloor, direction){			//[OK]
		/**
		 * Function to check if one or more elevators are no on the same way.
		 *	It creates a list of elevator not on the same way, then returns the list. 
		 *
		 *	Args:
		 *		requestedFloor (int): floor requested for the user
		 *		direction (str): "up" or "down" 
		 *
		 *	Returns:
		 *		list: the list of elevator on the same way
		 */

		let listOfElevators = []
		for(let elevator_ in this.listElevators){
			let elevator = this.listElevators[elevator_]
			if (elevator.status !== direction){
				listOfElevators.push(elevator);
			};
		};
		return this._returnElevator(listOfElevators, requestedFloor);
	};

	_theAreIdle(requestedFloor, direction){				//[OK]
		/**
		 * Function to check if one or more elevators are "idle".
		 *	It creates a list of elevator "idle", then returns the list. 
		 *
		 *	Args:
		 *		requestedFloor (int): floor requested for the user
		 *
		 *	Returns:
		 *		list: the list of elevator on the same way
		 */

		let listOfElevators = []
		for(let elevator_ in this.listElevators){
			let elevator = this.listElevators[elevator_]
			if (elevator.status === "idle"){
				listOfElevators.push(elevator);
			};
		};
		return this._returnElevator(listOfElevators, requestedFloor);
	};

	_choiceElevator(requestedFloor, direction){			//[OK]
		/**
		 * Function to choice the best elevator
		 *	It calling others functions and returns the best elevator
		 *
		 *	Args:
		 *		requestedFloor (int): floor requested for the user
		 *		direction (str): "up" or "down" 
 		 *
		 *	Returns:
		 *		Elevator: The best elevator
		 */

		let elevator = this._theAreOnWay(requestedFloor, direction);
		if (elevator){
			return elevator;
		}
		elevator = this._theAreIdle(requestedFloor, direction);
		if (elevator){
			return elevator;
		} else {
			return this._theAreNotOnWay(requestedFloor, direction);
		}

	}

	requestElevator(requestedFloor, direction){			//[OK]
		/**
		 * Function for request the best elevator an move them.
		 *	It changes the status of button requested from the beginning.
		 *	Then it calls the function for choice the best elevator.
		 *	Then it move the elevator selected and change the status of the button.
		 *
		 *	Args:
		 *		requestedFloor (int): floor requested for the user
		 *		direction (str): "up" or "down" 
		 *
		 *	Returns:
		 *		Elevator: The best elevator
		 */

		console.log("## Someone call a elevator on floor " + requestedFloor + " ##")
		this.buttonsFloorsFloor[requestedFloor + direction].status = true
		let elevator = this._choiceElevator(requestedFloor, direction)
		console.log("\t>>> elevator" + elevator.id_ + " was called <<<")
		this.buttonsFloorsFloor[requestedFloor + direction].status = false
		elevator._moveElevator(requestedFloor)
		return elevator
	}


};


////////////////////// SCENARIO SECTION //////////////////////
function letsGo(){	
	function scenario1(column){
		console.log("\n----- Scenario 1 -----");
		column.listElevators["elevator0"].currentFloor = 2;
		column.listElevators["elevator1"].currentFloor = 6;
		
		elevator = column.requestElevator(3, "up");
		elevator.requestedFloor(7);
	};

	function scenario2(column){
		console.log("\n----- Scenario 2 -----")
		column.listElevators["elevator0"].currentFloor = 10;
		column.listElevators["elevator1"].currentFloor = 3;

		elevator = column.requestElevator(1, "up");
		elevator.requestedFloor(6);
		elevator = column.requestElevator(3, "up");
		elevator.requestedFloor(5);
		elevator = column.requestElevator(9, "down");
		elevator.requestedFloor(2);
	};

	function scenario3(column){
		console.log("\n----- Scenario 3 -----")
		column.listElevators["elevator0"].currentFloor = 10;
		column.listElevators["elevator1"].currentFloor = 3;
		column.listElevators["elevator1"].status = "up";

		elevator = column.requestElevator(3, "down");
		elevator.requestedFloor(2)

		console.log("\n========== elevator1 moving");
		column.listElevators["elevator1"]._moveElevator(6);
		console.log("============\n");

		elevator = column.requestElevator(10, "down");
		elevator.requestedFloor(3);
	};

	columnScenario1 = new Column(10, 2);
	scenario1(columnScenario1);

	columnScenario2 = new Column(10, 2);
	scenario2(columnScenario2);

	columnScenario3 = new Column(10, 2);
	scenario3(columnScenario3);
};

//////////////////// END SCENARIO SECTION ///////////////////*/

////////////////////// TESTING SECTION ///////////////////////

letsGo();

////////////////////// END TESTING SECTION ///////////////////*/