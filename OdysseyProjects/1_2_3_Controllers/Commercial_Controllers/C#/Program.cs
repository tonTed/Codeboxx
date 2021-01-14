using System;
using System.Threading;
using System.Collections.Generic;
using System.Linq;

class Program
{
    public class Elevator
    { // Class of Elevator
        public string id_;
        public string status = "up";
        public int currentFloor = 1;
        // this.buttonsElevatorFloor = {};

        int a = 50;
        //Door
        int timeOpen;
        int timeToOpen;
        int timeToClose;
        int timePerFloor;

        public Elevator(string id_)                         // [OK]
        {// Constructor of elevator
            this.id_ = id_;
           
            timeOpen = this.a;      //5
            timeToClose = this.a;   //2
            timeToOpen = this.a;    //2
            timePerFloor = this.a;  //2
        }

        void openDoor()                                     //[OK]
        {// Function to open the door of the elevator
            Console.WriteLine("\t\tDoor is openning");
            Thread.Sleep(this.timeToOpen);
            Console.WriteLine("\t\tDoor is open");
            Thread.Sleep(this.timeOpen);
            this.closeDoor();
        }

        void closeDoor()                                    //[OK]
        {// Function to close the door of the elevator
            Console.WriteLine("\t\tBe careful door is closing");
            Thread.Sleep(this.timeToClose);
            Console.WriteLine("\t\tDoor is close");
        }

        public void movePrint(int i, int b)
        {// Function for print the movement
            Console.WriteLine("\t\t\tmoving <" + this.status + "> from " + this.currentFloor + " to " + (this.currentFloor + i));
            this.currentFloor += b;
            Thread.Sleep(this.timePerFloor);
        }

        public void moveElevator(int requestedFloor)               //[OK]
        {// Function to move the elevator to the requested floor. The floor 0 it skips.
            if (this.currentFloor < requestedFloor)
            {
                this.status = "up";
                while(this.currentFloor != requestedFloor)
                {
                    if(this.currentFloor != -1)
                    {
                        this.movePrint(1, 1);
                    }
                    else
                    {
                        this.movePrint(2, 1);
                        break;
                    }
                }
            } 
            else if (this.currentFloor > requestedFloor) 
            {
                this.status = "down";
                while(this.currentFloor != requestedFloor)
                {
                    if(this.currentFloor != 1)
                    {
                        this.movePrint(-1, -1);
                    }
                    else
                    {
                        this.movePrint(-2, -2);
                    }
                }
            }
            this.openDoor();
        }

        public void requestedFloor(int requestedFloor)      //[OK]
        {// Function to call the function moveElevator
            Console.WriteLine("\t## Someone want's go to floor " + requestedFloor + " ##");
            // this.buttonsElevatorFloor[requestedFloor].status = true
            this.moveElevator(requestedFloor);
            // this.buttonsElevatorFloor[requestedFloor].status = false
        }

    }

    public class Column
    {// Class of Column
        public char id_;
        public List<int> floorServed;
        private int qtyElevators;
        public Dictionary<string, Elevator> listElevators;
        int timeAction = 100;


        public Column(char id_, int qtyElevators, List<int> floorServed)
        {// Constructor of Column
            this.id_ = id_;
            this.qtyElevators = qtyElevators;
            this.listElevators = new Dictionary<string, Elevator>();
            this.floorServed = floorServed;
            
            createElevators();
        }

        private void createElevators()
        {// function for create elavators in the column
            for(int i = 1; i < this.qtyElevators + 1; i++)
            {
                string id = this.id_ + i.ToString();
                this.listElevators.Add(id, new Elevator(id));
                Console.WriteLine("\t== elevator " + id + " created ==");
                Thread.Sleep(this.timeAction);
            }
        }

        private Elevator isCloser(List<Elevator> listOfElevators,int requestedFloor)
        {// Function for sort the list of elevator according to difference between the floors
            Dictionary<Elevator, int> newListOfElevators = new Dictionary<Elevator, int>();
            for(int i = 0; i < listOfElevators.Count; i++)
            {
                newListOfElevators.Add(listOfElevators[i], Math.Abs(listOfElevators[i].currentFloor - requestedFloor));
            }
            var sortedList = newListOfElevators.OrderBy(x => x.Value);
            return sortedList.ElementAt(0).Key;
        }
        
        private Elevator returnElevator(List<Elevator> listOfElevators, int requestedFloor)
        {// Function for check how many elevator in a list and return the best elevator
            if (listOfElevators.Count == 0)
            {
                return null;
            }
            else if (listOfElevators.Count == 1)
            {
                return listOfElevators[0];
            } 
            else 
            {
                return isCloser(listOfElevators, requestedFloor);
            }
        }
        
        private Elevator theAreOnWay(int requestedFloor, string direction)
        {// Function for check if the elevators are on to the same way
            List<Elevator> listOfElevators = new List<Elevator>();
            foreach(KeyValuePair<string, Elevator> elevator in this.listElevators)
            {
                if(elevator.Value.status == direction)
                {
                    if ((direction == "up" && elevator.Value.currentFloor <= requestedFloor) || (direction == "down" && elevator.Value.currentFloor >= requestedFloor))
                    {
                        listOfElevators.Add(elevator.Value);
                    }
                }
            }
            return returnElevator(listOfElevators, requestedFloor);
        }
        
        private Elevator theAreIdle(int requestedFloor, string direction)
        {// Function for check if the elevators are idle
            List<Elevator> listOfElevators = new List<Elevator>();
            foreach(KeyValuePair<string, Elevator> elevator in this.listElevators)
            {
                if(elevator.Value.status == "idle")
                {
                    listOfElevators.Add(elevator.Value);
                }
            }
            return returnElevator(listOfElevators, requestedFloor);
        }
        
        private Elevator theAreNotOnWay(int requestedFloor, string direction)
        {// Function for check if the elevators are not on to the same way
            List<Elevator> listOfElevators = new List<Elevator>();
            foreach(KeyValuePair<string, Elevator> elevator in this.listElevators)
            {
                if(elevator.Value.status != direction)
                {
                    listOfElevators.Add(elevator.Value);
                }
            }
            return returnElevator(listOfElevators, requestedFloor);
        }
        
        private Elevator choiceElevator(int requestedFloor, string direction)
        {// Main function for choose the best elevator
            Elevator elevator = theAreOnWay(requestedFloor, direction);
            if(elevator != null)
            {
                return elevator;
            }
            elevator = theAreIdle(requestedFloor, direction);
            if(elevator != null)
            {
                return elevator;
            }
            else
            {
                return theAreNotOnWay(requestedFloor, direction);
            }
        }

        public Elevator _requestElevator(int requestedFloor, string direction)
        {// internal function request the elevator from assignElevator function
            Console.WriteLine("\n\t:::: Column " + this.id_ + " has been selected ::::");
            Thread.Sleep(this.timeAction);
                //this.buttonsFloorsFloor[requestedFloor + direction].status = true
            Elevator elevator = choiceElevator(1, direction);
                // this.buttonsFloorsFloor[requestedFloor + direction].status = false
            Console.WriteLine("\n\t\t== Elevator " + elevator.id_ + " has been selected ===\n");
            Thread.Sleep(this.timeAction);
            elevator.moveElevator(1);
            elevator.moveElevator(requestedFloor);
            return elevator;
        }

        public Elevator requestElevator(int requestedFloor)
        {// function for request the Elevator by the user
            Elevator elevator;
            
                //this.buttonsFloorsFloor[requestedFloor + direction].status = true
            if (requestedFloor < 0)
            {
                elevator = choiceElevator(requestedFloor, "up");
            }
            else
            {
                elevator = choiceElevator(requestedFloor, "down");
            }
                // this.buttonsFloorsFloor[requestedFloor + direction].status = false
            Console.WriteLine("\n\t\t== Elevator " + elevator.id_ + " has been selected ===\n");
            Thread.Sleep(this.timeAction);
            elevator.moveElevator(requestedFloor);
            elevator.moveElevator(1);
            return elevator;
        }
    }

    public class Batterie
    {// Class of Batterie
        public int floors;
        public int basements;
        public List<List<int>> columns;
        public int qtyElevators;

        public List<char> chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".ToList();
        public Dictionary<char, Column> listColumns;
        int timeAction = 100;

        public Batterie(int floors, int basements, List<List<int>> columns, int qtyElevators)
        {
            this.floors = floors;
            this.basements = basements;
            this.columns = new List<List<int>>(columns);
            this.qtyElevators = qtyElevators;

            this.listColumns = new Dictionary<char, Column>();

            createColumns();
        }

        private void createColumns()
        {// Function for create the columns
            for(int i = 0; i < this.columns.Count; i++)
            {
                char id = this.chars[i];
                Console.WriteLine(":::: column " + id + " created ::::");
                Thread.Sleep(this.timeAction);
                listColumns.Add(id, new Column(id, this.qtyElevators, this.columns[i]));
                Console.WriteLine("\n");
            }
        }
        
        public Elevator AssignElevator(int requestedFloor)
        {// Fonction use by the user pour request the floor where they can go
            Console.WriteLine("\n## Someone call a elevator on RC to go on floor " + requestedFloor + " ##");
            Thread.Sleep(this.timeAction);
            Elevator elevator;
            foreach (KeyValuePair<char, Column> column in this.listColumns)
            {
                if (column.Value.floorServed.Contains(requestedFloor))
                {
                    if(requestedFloor < 0)
                    {
                        elevator = column.Value._requestElevator(requestedFloor, "down");
                        return elevator;
                    }
                    else if(requestedFloor > 1)
                    {
                        elevator = column.Value._requestElevator(requestedFloor, "up");
                        return elevator;
                    }
                }
            }
            return null;
        }

    }
    
    public class Scenario
    {
        public void scenario1()
        {
            List<int> columnA = Enumerable.Range(-6,6).ToList();
            List<int> columnB = Enumerable.Range(2,18).ToList();
            List<int> columnC = Enumerable.Range(21,19).ToList();
            List<int> columnD = Enumerable.Range(41,19).ToList();
            List<List<int>> columns = new List<List<int>>()
            {
                columnA,
                columnB,
                columnC,
                columnD
            };

            int timeAction = 100;

            Batterie batterie1 = new Batterie(66, 6, columns, 5);

            Elevator elevatorB1 = batterie1.listColumns['B'].listElevators["B1"];
            elevatorB1.currentFloor = 20;
            elevatorB1.status = "down";
            Console.WriteLine("===== Elevator " + elevatorB1.id_ + " is on " + elevatorB1.currentFloor + " floor, going " + elevatorB1.status + "!!");
            Thread.Sleep(timeAction); 
            
            Elevator elevatorB2 = batterie1.listColumns['B'].listElevators["B2"];
            elevatorB2.currentFloor = 3;
            elevatorB2.status = "up";
            Console.WriteLine("===== Elevator " + elevatorB2.id_ + " is on " + elevatorB2.currentFloor + " floor, going " + elevatorB2.status + "!!"); 
            Thread.Sleep(timeAction); 
            
            Elevator elevatorB3 = batterie1.listColumns['B'].listElevators["B3"];
            elevatorB3.currentFloor = 13;
            elevatorB3.status = "down";
            Console.WriteLine("===== Elevator " + elevatorB3.id_ + " is on " + elevatorB3.currentFloor + " floor, going " + elevatorB3.status + "!!"); 
            Thread.Sleep(timeAction); 
            
            Elevator elevatorB4 = batterie1.listColumns['B'].listElevators["B4"];
            elevatorB4.currentFloor = 15;
            elevatorB4.status = "down";
            Console.WriteLine("===== Elevator " + elevatorB4.id_ + " is on " + elevatorB4.currentFloor + " floor, going " + elevatorB4.status + "!!"); 
            Thread.Sleep(timeAction); 
            
            Elevator elevatorB5 = batterie1.listColumns['B'].listElevators["B5"];
            elevatorB5.currentFloor = 6;
            elevatorB5.status = "down";
            Console.WriteLine("===== Elevator " + elevatorB5.id_ + " is on " + elevatorB5.currentFloor + " floor, going " + elevatorB5.status + "!!"); 
            Thread.Sleep(timeAction); 
            
            batterie1.AssignElevator(5);
        }
        public void scenario2()
        {
            List<int> columnA = Enumerable.Range(-6,6).ToList();
            List<int> columnB = Enumerable.Range(2,18).ToList();
            List<int> columnC = Enumerable.Range(21,19).ToList();
            List<int> columnD = Enumerable.Range(41,19).ToList();
            List<List<int>> columns = new List<List<int>>()
            {
                columnA,
                columnB,
                columnC,
                columnD
            };

            int timeAction = 100;

            Batterie batterie2 = new Batterie(66, 6, columns, 5);

            Elevator elevatorC1 = batterie2.listColumns['C'].listElevators["C1"];
            elevatorC1.currentFloor = 1;
            elevatorC1.status = "up";
            Console.WriteLine("===== Elevator " + elevatorC1.id_ + " is on " + elevatorC1.currentFloor + " floor, going " + elevatorC1.status + "!!");
            Thread.Sleep(timeAction); 
            
            Elevator elevatorC2 = batterie2.listColumns['C'].listElevators["C2"];
            elevatorC2.currentFloor = 23;
            elevatorC2.status = "up";
            Console.WriteLine("===== Elevator " + elevatorC2.id_ + " is on " + elevatorC2.currentFloor + " floor, going " + elevatorC2.status + "!!"); 
            Thread.Sleep(timeAction); 
            
            Elevator elevatorC3 = batterie2.listColumns['C'].listElevators["C3"];
            elevatorC3.currentFloor = 33;
            elevatorC3.status = "down";
            Console.WriteLine("===== Elevator " + elevatorC3.id_ + " is on " + elevatorC3.currentFloor + " floor, going " + elevatorC3.status + "!!"); 
            Thread.Sleep(timeAction); 
            
            Elevator elevatorC4 = batterie2.listColumns['C'].listElevators["C4"];
            elevatorC4.currentFloor = 40;
            elevatorC4.status = "down";
            Console.WriteLine("===== Elevator " + elevatorC4.id_ + " is on " + elevatorC4.currentFloor + " floor, going " + elevatorC4.status + "!!"); 
            Thread.Sleep(timeAction); 
            
            Elevator elevatorC5 = batterie2.listColumns['C'].listElevators["C5"];
            elevatorC5.currentFloor = 39;
            elevatorC5.status = "down";
            Console.WriteLine("===== Elevator " + elevatorC5.id_ + " is on " + elevatorC5.currentFloor + " floor, going " + elevatorC5.status + "!!"); 
            Thread.Sleep(timeAction); 
            
            batterie2.AssignElevator(36);
        }
        public void scenario3()
        {
            List<int> columnA = Enumerable.Range(-6,6).ToList();
            List<int> columnB = Enumerable.Range(2,18).ToList();
            List<int> columnC = Enumerable.Range(21,19).ToList();
            List<int> columnD = Enumerable.Range(41,19).ToList();
            List<List<int>> columns = new List<List<int>>()
            {
                columnA,
                columnB,
                columnC,
                columnD
            };

            int timeAction = 100;

            Batterie batterie3 = new Batterie(66, 6, columns, 5);

            Elevator elevatorD1 = batterie3.listColumns['D'].listElevators["D1"];
            elevatorD1.currentFloor = 58;
            elevatorD1.status = "down";
            Console.WriteLine("===== Elevator " + elevatorD1.id_ + " is on " + elevatorD1.currentFloor + " floor, going " + elevatorD1.status + "!!");
            Thread.Sleep(timeAction); 
            
            Elevator elevatorD2 = batterie3.listColumns['D'].listElevators["D2"];
            elevatorD2.currentFloor = 50;
            elevatorD2.status = "up";
            Console.WriteLine("===== Elevator " + elevatorD2.id_ + " is on " + elevatorD2.currentFloor + " floor, going " + elevatorD2.status + "!!"); 
            Thread.Sleep(timeAction); 
            
            Elevator elevatorD3 = batterie3.listColumns['D'].listElevators["D3"];
            elevatorD3.currentFloor = 46;
            elevatorD3.status = "up";
            Console.WriteLine("===== Elevator " + elevatorD3.id_ + " is on " + elevatorD3.currentFloor + " floor, going " + elevatorD3.status + "!!"); 
            Thread.Sleep(timeAction); 
            
            Elevator elevatorD4 = batterie3.listColumns['D'].listElevators["D4"];
            elevatorD4.currentFloor = 1;
            elevatorD4.status = "up";
            Console.WriteLine("===== Elevator " + elevatorD4.id_ + " is on " + elevatorD4.currentFloor + " floor, going " + elevatorD4.status + "!!"); 
            Thread.Sleep(timeAction); 
            
            Elevator elevatorD5 = batterie3.listColumns['D'].listElevators["D5"];
            elevatorD5.currentFloor = 60;
            elevatorD5.status = "down";
            Console.WriteLine("===== Elevator " + elevatorD5.id_ + " is on " + elevatorD5.currentFloor + " floor, going " + elevatorD5.status + "!!"); 
            Thread.Sleep(timeAction); 
            
            batterie3.listColumns['D'].requestElevator(54);

        }
        public void scenario4()
        {
            List<int> columnA = Enumerable.Range(-6,6).ToList();
            List<int> columnB = Enumerable.Range(2,18).ToList();
            List<int> columnC = Enumerable.Range(21,19).ToList();
            List<int> columnD = Enumerable.Range(41,19).ToList();
            List<List<int>> columns = new List<List<int>>()
            {
                columnA,
                columnB,
                columnC,
                columnD
            };

            int timeAction = 100;

            Batterie batterie4 = new Batterie(66, 6, columns, 5);

            Elevator elevatorA1 = batterie4.listColumns['A'].listElevators["A1"];
            elevatorA1.currentFloor = -4;
            elevatorA1.status = "idle";
            Console.WriteLine("===== Elevator " + elevatorA1.id_ + " is on " + elevatorA1.currentFloor + " floor, going " + elevatorA1.status + "!!");
            Thread.Sleep(timeAction); 
            
            Elevator elevatorA2 = batterie4.listColumns['A'].listElevators["A2"];
            elevatorA2.currentFloor = 1;
            elevatorA2.status = "idle";
            Console.WriteLine("===== Elevator " + elevatorA2.id_ + " is on " + elevatorA2.currentFloor + " floor, going " + elevatorA2.status + "!!"); 
            Thread.Sleep(timeAction); 
            
            Elevator elevatorA3 = batterie4.listColumns['A'].listElevators["A3"];
            elevatorA3.currentFloor = -3;
            elevatorA3.status = "down";
            Console.WriteLine("===== Elevator " + elevatorA3.id_ + " is on " + elevatorA3.currentFloor + " floor, going " + elevatorA3.status + "!!"); 
            Thread.Sleep(timeAction); 
            
            Elevator elevatorA4 = batterie4.listColumns['A'].listElevators["A4"];
            elevatorA4.currentFloor = -6;
            elevatorA4.status = "up";
            Console.WriteLine("===== Elevator " + elevatorA4.id_ + " is on " + elevatorA4.currentFloor + " floor, going " + elevatorA4.status + "!!"); 
            Thread.Sleep(timeAction); 
            
            Elevator elevatorA5 = batterie4.listColumns['A'].listElevators["A5"];
            elevatorA5.currentFloor = -1;
            elevatorA5.status = "down";
            Console.WriteLine("===== Elevator " + elevatorA5.id_ + " is on " + elevatorA5.currentFloor + " floor, going " + elevatorA5.status + "!!"); 
            Thread.Sleep(timeAction); 
            
            batterie4.listColumns['A'].requestElevator(-3);

        }
    }
    static void Main(string[] args)
    {
        Scenario scenario = new Scenario();
        Console.WriteLine("<><><><><> Scenario 1 <><><><><>");
        scenario.scenario1();
        Console.WriteLine("\n<><><><><> Scenario 2 <><><><><>");
        scenario.scenario2();
        Console.WriteLine("\n<><><><><> Scenario 3 <><><><><>");
        scenario.scenario3();
        Console.WriteLine("\n<><><><><> Scenario 4 <><><><><>");
        scenario.scenario4();
    }
}