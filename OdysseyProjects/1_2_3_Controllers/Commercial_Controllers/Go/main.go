package main

import (
	"fmt"
	"math"
	"strconv"
	"time"
)

func min(a []int) int {
	// Function to return the index of the less value
	min := a[0]
	index := 0
	for i, v := range a {
		if v <= min {
			min = v
			index = i
		}
	}
	return index
}

func makeRange(min, max int) []int {
	// Function to return a array of int according to a range between two numbers
	a := make([]int, max-min+1)
	for i := range a {
		a[i] = min + i
	}
	return a
}

func makeRangeExc(min, max, exc int) []int {
	// Function to return a array of int according to a range between two numbers excluding one number
	a := make([]int, max-min)
	for i := range a {
		if min+i == exc {
			a[i] = min + i + 1
		} else {
			a[i] = min + i
		}
	}
	return a
}

func sleep() {
	// Function for sleep the processus
	time.Sleep(50 * time.Millisecond)
}

func intInSlice(a int, slice []int) bool {
	// Function for check if a value is in a slice
	for _, b := range slice {
		if b == a {
			return true
		}
	}
	return false
}

//////////////////////// ELEVATOR ////////////////////////

type Elevator struct { //[OK]
	id           string
	status       string
	currentFloor int
}

func NewElevator(id string) *Elevator { //[OK]
	// Constructeur of Elevator
	return &Elevator{
		id:           id,
		status:       "idle",
		currentFloor: 1,
	}
}

func (e Elevator) String() string {
	// Function for change the output of the Elevator object
	return fmt.Sprintf("\n\t\t\t== Elevator %s __Status: %s", e.id, e.status)
}

func (e Elevator) closeDoor() { //[OK]
	// Function for close the door
	fmt.Println("\t\tBe careful door is closing")
	sleep()
	fmt.Println("\t\tDoor is close")
	sleep()
}

func (e Elevator) openDoor() { //[OK]
	// Function for open the door
	fmt.Println("\t\tDoor is openning")
	sleep()
	fmt.Println("\t\tDoor is open")
	sleep()
	e.closeDoor()
}

func (e *Elevator) movePrint(i int, b int) {
	// Function for print the movement
	fmt.Printf("\t\t\tmoving <%s> from %d to %d\n", e.status, e.currentFloor, e.currentFloor+i)
	e.currentFloor += b
	sleep()
}

func (e *Elevator) moveElevator(requestedFloor int) { //[exclude floor 0]
	// Function for move the elevator
	if e.currentFloor < requestedFloor {
		e.status = "up"
		for e.currentFloor != requestedFloor {
			if e.currentFloor != -1 {
				e.movePrint(1, 1)
			} else {
				e.movePrint(2, 1)
				break
			}
		}
	} else {
		e.status = "down"
		for e.currentFloor != requestedFloor {
			if e.currentFloor != 1 {
				e.movePrint(-1, -1)
			} else {
				e.movePrint(-2, -2)
			}
		}
	}
	e.openDoor()
	e.status = "idle"
}

////////////////////// END ELEVATOR //////////////////////

///////////////////////// COLUMN /////////////////////////

type Column struct {
	id              string
	qtyElevators    int
	floorServed     []int
	listOfElevators map[string]*Elevator
}

func (c Column) String() string {
	// Function for change the output of the Column object
	a := fmt.Sprintf("\n\t\t :::: Column %s __FloorServed: %d to %d", c.id, c.floorServed[0], c.floorServed[len(c.floorServed)-1])
	for i := range c.listOfElevators {
		a += c.listOfElevators[i].String()
	}
	return a
}

func _NewColumn(id string, qtyElevators int, floorServed []int) *Column {
	// Constructor of Column
	return &Column{
		id:              id,
		qtyElevators:    qtyElevators,
		floorServed:     floorServed,
		listOfElevators: make(map[string]*Elevator),
	}
}

func NewColumn(id string, qtyElevators int, floorServed []int) *Column {
	// Function for call the Constructor of column them call create elevators
	column := _NewColumn(id, qtyElevators, floorServed)
	fmt.Printf("\n\t:::: Column %s are created, serving floors %d to %d\n", id, floorServed[0], floorServed[len(floorServed)-1])
	column.createElevators()
	return column
}

func (c *Column) createElevators() {
	// Function for create the elevators in the column
	for i := 0; i < c.qtyElevators; i++ {
		id := c.id + strconv.Itoa(i+1)
		c.listOfElevators[id] = NewElevator(id)
		fmt.Println("\t\t== elevator " + id + " created ==")
		sleep()
	}
}

func (c *Column) isCloser(listOfElevators []string, requestedFloor int) string {
	// Function for sort the list of elevator according to difference between the floors
	diffs := make([]int, len(listOfElevators))
	var diff int
	for i := range listOfElevators {
		diff = int(math.Abs(float64(c.listOfElevators[listOfElevators[i]].currentFloor - requestedFloor)))
		diffs[i] = diff
	}
	index := min(diffs)
	return listOfElevators[index]
}

func (c *Column) returnElevator(listOfElevators []string, requestedFloor int) string {
	// Function for check how many elevator in a list and return the best elevator
	if len(listOfElevators) == 0 {
		return ""
	} else if len(listOfElevators) == 1 {
		return listOfElevators[0]
	} else {
		return c.isCloser(listOfElevators, requestedFloor)
	}
}

func (c *Column) theAreOnWay(requestedFloor int, direction string) string {
	// Function for check if the elevators are on to the same way
	listOfElevators := make([]string, 0)
	for id, elevator := range c.listOfElevators {
		if elevator.status != direction {
			continue
		} else if direction == "up" && elevator.currentFloor > requestedFloor {
			continue
		} else if direction == "down" && elevator.currentFloor < requestedFloor {
			continue
		} else {
			listOfElevators = append(listOfElevators, id)
		}
	}
	return c.returnElevator(listOfElevators, requestedFloor)
}

func (c *Column) theAreNotOnWay(requestedFloor int, direction string) string {

	listOfElevators := make([]string, 0)
	for id, elevator := range c.listOfElevators {
		if elevator.status == direction {
			continue
		} else {
			listOfElevators = append(listOfElevators, id)
		}
	}
	return c.returnElevator(listOfElevators, requestedFloor)
}

func (c *Column) theAreIdle(requestedFloor int, direction string) string {
	// Function for check if the elevators are idle
	listOfElevators := make([]string, 0)
	for id, elevator := range c.listOfElevators {
		if elevator.status != "idle" {
			continue
		} else {
			listOfElevators = append(listOfElevators, id)
		}
	}
	return c.returnElevator(listOfElevators, requestedFloor)
}

func (c *Column) choiceElevator(requestedFloor int, direction string) string {
	// Main function for choose the best elevator
	id := c.theAreOnWay(requestedFloor, direction)
	if len(id) != 0 {
		return id
	}
	id = c.theAreIdle(requestedFloor, direction)
	if len(id) != 0 {
		return id
	} else {
		return c.theAreNotOnWay(requestedFloor, direction)
	}
}

func (c *Column) _requestElevator(requestedFloor int, direction string) {
	// internal function request the elevator from assignElevator function
	fmt.Printf("\n\t:::: Column %s has been selected ::::\n", c.id)
	sleep()
	id_elevator := c.choiceElevator(1, direction)
	fmt.Printf(("\n\t\t== Elevator %s has been selected ===\n\n"), id_elevator)
	sleep()
	c.listOfElevators[id_elevator].moveElevator(1)
	c.listOfElevators[id_elevator].moveElevator(requestedFloor)
}

func (c *Column) requestElevator(requestedFloor int) {
	// function for request the Elevator by the user
	var id_elevator string
	if requestedFloor < 0 {
		id_elevator = c.choiceElevator(requestedFloor, "up")
	} else {
		id_elevator = c.choiceElevator(requestedFloor, "down")
	}
	fmt.Printf(("\n\t\t== Elevator %s has been selected ===\n\n"), id_elevator)
	sleep()
	c.listOfElevators[id_elevator].moveElevator(requestedFloor)
	c.listOfElevators[id_elevator].moveElevator(1)

}

/////////////////////// END COLUMN ///////////////////////

//////////////////////// BATTERIE ////////////////////////

type Batterie struct {
	floors        int
	basements     int
	qtyElevators  int
	listOfColumns map[string]*Column
	listOfChars   string
	columns       [][]int
}

func (b Batterie) String() string {
	// Function for change the output of the Batterie object
	a := fmt.Sprintf("Batterie : \n\t> Floors: %d \n\t> Basements: %d", b.floors, b.basements)
	for i := range b.listOfColumns {
		a += b.listOfColumns[i].String()
	}
	return a
}

func _NewBatterie(floors int, basements int, columns [][]int, qtyElevators int) *Batterie {
	// Constructor of Batterie
	return &Batterie{
		floors:        floors,
		basements:     basements,
		columns:       columns,
		qtyElevators:  qtyElevators,
		listOfColumns: make(map[string]*Column),
		listOfChars:   "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
	}
}

func NewBatterie(floors int, basements int, columns [][]int, qtyElevators int) Batterie {
	// Function for call the Constructor of batterie them call create columns
	batterie := _NewBatterie(floors, basements, columns, qtyElevators)
	fmt.Printf("\n$$ The Batterie are create with %d floors, %d basements and %d columns with %d elevators each.\n", floors, basements, len(columns), qtyElevators)
	batterie.createColumns()
	fmt.Println("\n--------------------------------------------------------------------------------\n")
	return *batterie
}

func (b *Batterie) createColumns() {
	// Function for create columns
	for i := range b.columns {
		id := string(b.listOfChars[i])
		b.listOfColumns[id] = NewColumn(id, b.qtyElevators, b.columns[i])
	}
}

func (b Batterie) assignElevator(requestedFloor int) {
	// Fonction use by the user pour request the floor where they can go
	fmt.Printf("\n## Someone call a elevator on RC to go on floor %d\n", requestedFloor)
	sleep()
	for _, column := range b.listOfColumns {
		if !intInSlice(requestedFloor, column.floorServed) {
			continue
		}
		if requestedFloor < 0 {
			column._requestElevator(requestedFloor, "down")
		} else {
			column._requestElevator(requestedFloor, "up")
		}
	}
}

////////////////////// END BATTERIE //////////////////////c

func Sceniario1() {

	println("\n<><><><><> Scenario 1 <><><><><>")
	columnA___1 := makeRangeExc(-6, 1, 0)
	columnB___1 := makeRange(2, 20)
	columnC___1 := makeRange(21, 40)
	columnD___1 := makeRange(41, 60)

	columns := [][]int{
		columnA___1,
		columnB___1,
		columnC___1,
		columnD___1,
	}

	batterie___1 := NewBatterie(66, 6, columns, 5)

	a := "B"

	b := "1"
	floor := 20
	status := "down"
	batterie___1.listOfColumns[a].listOfElevators[a+b].currentFloor = floor
	batterie___1.listOfColumns[a].listOfElevators[a+b].status = status
	fmt.Printf("===== Elevator %s%s is on %d floor, going %s !!\n", a, b, floor, status)

	b = "2"
	floor = 3
	status = "up"
	batterie___1.listOfColumns[a].listOfElevators[a+b].currentFloor = floor
	batterie___1.listOfColumns[a].listOfElevators[a+b].status = status
	fmt.Printf("===== Elevator %s%s is on %d floor, going %s !!\n", a, b, floor, status)

	b = "3"
	floor = 13
	status = "down"
	batterie___1.listOfColumns[a].listOfElevators[a+b].currentFloor = floor
	batterie___1.listOfColumns[a].listOfElevators[a+b].status = status
	fmt.Printf("===== Elevator %s%s is on %d floor, going %s !!\n", a, b, floor, status)

	b = "4"
	floor = 15
	status = "down"
	batterie___1.listOfColumns[a].listOfElevators[a+b].currentFloor = floor
	batterie___1.listOfColumns[a].listOfElevators[a+b].status = status
	fmt.Printf("===== Elevator %s%s is on %d floor, going %s !!\n", a, b, floor, status)

	b = "5"
	floor = 6
	status = "down"
	batterie___1.listOfColumns[a].listOfElevators[a+b].currentFloor = floor
	batterie___1.listOfColumns[a].listOfElevators[a+b].status = status
	fmt.Printf("===== Elevator %s%s is on %d floor, going %s !!\n", a, b, floor, status)

	fmt.Println("\n--------------------------------------------------------------------------------\n")

	batterie___1.assignElevator(5)
}

func Sceniario2() {

	println("\n<><><><><> Scenario 2 <><><><><>")
	columnA___2 := makeRangeExc(-6, 1, 0)
	columnB___2 := makeRange(2, 20)
	columnC___2 := makeRange(21, 40)
	columnD___2 := makeRange(41, 60)

	columns := [][]int{
		columnA___2,
		columnB___2,
		columnC___2,
		columnD___2,
	}

	batterie___2 := NewBatterie(66, 6, columns, 5)

	a := "C"

	b := "1"
	floor := 1
	status := "up"
	batterie___2.listOfColumns[a].listOfElevators[a+b].currentFloor = floor
	batterie___2.listOfColumns[a].listOfElevators[a+b].status = status
	fmt.Printf("===== Elevator %s%s is on %d floor, going %s !!\n", a, b, floor, status)

	b = "2"
	floor = 23
	status = "up"
	batterie___2.listOfColumns[a].listOfElevators[a+b].currentFloor = floor
	batterie___2.listOfColumns[a].listOfElevators[a+b].status = status
	fmt.Printf("===== Elevator %s%s is on %d floor, going %s !!\n", a, b, floor, status)

	b = "3"
	floor = 33
	status = "down"
	batterie___2.listOfColumns[a].listOfElevators[a+b].currentFloor = floor
	batterie___2.listOfColumns[a].listOfElevators[a+b].status = status
	fmt.Printf("===== Elevator %s%s is on %d floor, going %s !!\n", a, b, floor, status)

	b = "4"
	floor = 40
	status = "down"
	batterie___2.listOfColumns[a].listOfElevators[a+b].currentFloor = floor
	batterie___2.listOfColumns[a].listOfElevators[a+b].status = status
	fmt.Printf("===== Elevator %s%s is on %d floor, going %s !!\n", a, b, floor, status)

	b = "5"
	floor = 39
	status = "down"
	batterie___2.listOfColumns[a].listOfElevators[a+b].currentFloor = floor
	batterie___2.listOfColumns[a].listOfElevators[a+b].status = status
	fmt.Printf("===== Elevator %s%s is on %d floor, going %s !!\n", a, b, floor, status)

	fmt.Println("\n--------------------------------------------------------------------------------\n")

	batterie___2.assignElevator(36)
}

func Sceniario3() {

	println("\n<><><><><> Scenario 3 <><><><><>")
	columnA___3 := makeRangeExc(-6, 1, 0)
	columnB___3 := makeRange(2, 20)
	columnC___3 := makeRange(21, 40)
	columnD___3 := makeRange(41, 60)

	columns := [][]int{
		columnA___3,
		columnB___3,
		columnC___3,
		columnD___3,
	}

	batterie___3 := NewBatterie(66, 6, columns, 5)

	a := "D"

	b := "1"
	floor := 58
	status := "down"
	batterie___3.listOfColumns[a].listOfElevators[a+b].currentFloor = floor
	batterie___3.listOfColumns[a].listOfElevators[a+b].status = status
	fmt.Printf("===== Elevator %s%s is on %d floor, going %s !!\n", a, b, floor, status)

	b = "2"
	floor = 50
	status = "up"
	batterie___3.listOfColumns[a].listOfElevators[a+b].currentFloor = floor
	batterie___3.listOfColumns[a].listOfElevators[a+b].status = status
	fmt.Printf("===== Elevator %s%s is on %d floor, going %s !!\n", a, b, floor, status)

	b = "3"
	floor = 46
	status = "up"
	batterie___3.listOfColumns[a].listOfElevators[a+b].currentFloor = floor
	batterie___3.listOfColumns[a].listOfElevators[a+b].status = status
	fmt.Printf("===== Elevator %s%s is on %d floor, going %s !!\n", a, b, floor, status)

	b = "4"
	floor = 1
	status = "up"
	batterie___3.listOfColumns[a].listOfElevators[a+b].currentFloor = floor
	batterie___3.listOfColumns[a].listOfElevators[a+b].status = status
	fmt.Printf("===== Elevator %s%s is on %d floor, going %s !!\n", a, b, floor, status)

	b = "5"
	floor = 60
	status = "down"
	batterie___3.listOfColumns[a].listOfElevators[a+b].currentFloor = floor
	batterie___3.listOfColumns[a].listOfElevators[a+b].status = status
	fmt.Printf("===== Elevator %s%s is on %d floor, going %s !!\n", a, b, floor, status)

	fmt.Println("\n--------------------------------------------------------------------------------\n")

	batterie___3.listOfColumns[a].requestElevator(54)
}

func Sceniario4() {

	println("\n<><><><><> Scenario 4 <><><><><>")
	columnA___4 := makeRangeExc(-6, 1, 0)
	columnB___4 := makeRange(2, 20)
	columnC___4 := makeRange(21, 40)
	columnD___4 := makeRange(41, 60)

	columns := [][]int{
		columnA___4,
		columnB___4,
		columnC___4,
		columnD___4,
	}

	batterie___4 := NewBatterie(66, 6, columns, 5)

	a := "A"

	b := "1"
	floor := -4
	status := "idle"
	batterie___4.listOfColumns[a].listOfElevators[a+b].currentFloor = floor
	batterie___4.listOfColumns[a].listOfElevators[a+b].status = status
	fmt.Printf("===== Elevator %s%s is on %d floor, going %s !!\n", a, b, floor, status)

	b = "2"
	floor = 1
	status = "idle"
	batterie___4.listOfColumns[a].listOfElevators[a+b].currentFloor = floor
	batterie___4.listOfColumns[a].listOfElevators[a+b].status = status
	fmt.Printf("===== Elevator %s%s is on %d floor, going %s !!\n", a, b, floor, status)

	b = "3"
	floor = -3
	status = "down"
	batterie___4.listOfColumns[a].listOfElevators[a+b].currentFloor = floor
	batterie___4.listOfColumns[a].listOfElevators[a+b].status = status
	fmt.Printf("===== Elevator %s%s is on %d floor, going %s !!\n", a, b, floor, status)

	b = "4"
	floor = -6
	status = "up"
	batterie___4.listOfColumns[a].listOfElevators[a+b].currentFloor = floor
	batterie___4.listOfColumns[a].listOfElevators[a+b].status = status
	fmt.Printf("===== Elevator %s%s is on %d floor, going %s !!\n", a, b, floor, status)

	b = "5"
	floor = -1
	status = "down"
	batterie___4.listOfColumns[a].listOfElevators[a+b].currentFloor = floor
	batterie___4.listOfColumns[a].listOfElevators[a+b].status = status
	fmt.Printf("===== Elevator %s%s is on %d floor, going %s !!\n", a, b, floor, status)

	fmt.Println("\n--------------------------------------------------------------------------------\n")

	batterie___4.listOfColumns[a].requestElevator(-3)
}

func main() {

	Sceniario1()
	Sceniario2()
	Sceniario3()
	Sceniario4()

}
