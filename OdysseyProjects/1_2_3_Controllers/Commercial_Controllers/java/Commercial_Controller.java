package Commercial_Controllers.java;

/**
 * Commercial_Controller
 */

import java.util.HashMap; // import the HashMap class

import java.util.ArrayList;

public class Commercial_Controller {
    public static void wait_() {  //wait_();
		try {
			Thread.sleep(50);
		} catch(InterruptedException ex) {
			Thread.currentThread().interrupt();
		}
	}

    public static boolean isInArray(int[] array, int requestedFloor) {
        for (int floor : array) {
            if (floor == requestedFloor) {
                return true;
            }
        }
        return false;
    }

    public static int[] makeRange(int min, int max) {
        int[] a = new int[max - min + 1];
        for (int i = 0 ; i < a.length; i++){
            a[i] = min + i;
        }
        return a;
    }

    public static int[] makeRangeExc(int min, int max, int exc) {
        int[] a = new int[max - min];
        for (int i = 0 ; i < a.length; i++){
            if (min + i == exc){
                a[i] = min + i + 1;
            } else {
                a[i] = min + i;
            }
        }
        return a;
    }

    public static int min(int[] a) {
        int min = a[0];
        int index = 0;
        for (int i = 0; i < a.length; i++){
            if (a[i] <= min){
                min = a[i];
                index = i;
            }
        }     
        return index;
    }

    public static class Button {
        int floorRequested;
        boolean status;

        public Button(int floorRequested) {
            this.floorRequested = floorRequested;
            this.status = false;
        }
    }

	public static class Elevator
    { // Class of Elevator
        public String id_;
        public String status = "up";
        public int currentFloor = 1;
        // this.buttonsElevatorFloor = {};

        int a = 50;
        //Door
        int timeOpen;
        int timeToOpen;
        int timeToClose;
        int timePerFloor;

        public Elevator(String id_)                         // [OK]
        {// Constructor of elevator
            this.id_ = id_;
           
            timeOpen = this.a;      //5
            timeToClose = this.a;   //2
            timeToOpen = this.a;    //2
            timePerFloor = this.a;  //2
        }

        public void openDoor()                                     //[OK]
        {// Function to open the door of the elevator
            System.out.println("\t\tDoor is openning");
            wait_();
            System.out.println("\t\tDoor is open");
            wait_();
            this.closeDoor();
        }

        public void closeDoor()                                    //[OK]
        {// Function to close the door of the elevator
            System.out.println("\t\tBe careful door is closing");
            wait_();
            System.out.println("\t\tDoor is close");
        }

        public void movePrint(int i, int b)
        {
            System.out.println("\t\t\tmoving <" + this.status + "> from " + this.currentFloor + " to " + (this.currentFloor + i));
            this.currentFloor += b;
            wait_();
        }

        public void moveElevator(int requestedFloor)               //[OK]
        {// Function to move the elevator to the requested floor.
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
            System.out.println("\t## Someone want's go to floor " + requestedFloor + " ##");
            // this.buttonsElevatorFloor[requestedFloor].status = true
            this.moveElevator(requestedFloor);
            // this.buttonsElevatorFloor[requestedFloor].status = false
        }

    }

    public static class Column
    {// Class of Column
        public String id_;
        public int[] floorServed;
        private int qtyElevators;
        public HashMap<String, Elevator> listElevators;
        int timeAction = 100;


        public Column(String id_, int qtyElevators, int[] floorServed)
        {// Constructor of Column
            this.id_ = id_;
            this.qtyElevators = qtyElevators;
            this.listElevators = new HashMap<String, Elevator>();
            this.floorServed = floorServed;
            
            createElevators();
        }

        private void createElevators()
        {// function for create elavators in the column
            for(int i = 1; i < this.qtyElevators + 1; i++)
            {   
                String id = this.id_ + String.valueOf(i);
                this.listElevators.put(id, new Elevator(id));
                System.out.println("\t== elevator " + id + " created ==");
                wait_();
            }
        }

        private Elevator isCloser(ArrayList listOfElevators,int requestedFloor)
        {
            int[] diffs = new int[listOfElevators.size()];
            int diff;
            for(int i = 0; i < listOfElevators.size(); i++) {
                diff = Math.abs(requestedFloor - this.listElevators.get(listOfElevators.get(i)).currentFloor);;
                // elevator = this.listElevators.get(listOfElevators.get(i));
                // floor = elevator.currentFloor;
                // diff = Math.abs(requestedFloor - floor);;
                diffs[i] = diff;
            }
            int index = min(diffs);
            return this.listElevators.get(listOfElevators.get(index));
        }
        
        private Elevator returnElevator(ArrayList listOfElevators, int requestedFloor)
        {
            if (listOfElevators.size() == 0)
            {
                return null;
            }
            else if (listOfElevators.size() == 1)
            {
                return this.listElevators.get(listOfElevators.get(0));
            } 
            else 
            {
                return isCloser(listOfElevators, requestedFloor);
            }
        }
        
        private Elevator theAreOnWay(int requestedFloor, String direction) {                //[java]
            ArrayList listOfElevators = new ArrayList();
            this.listElevators.forEach((id, elevator) -> {
                if(elevator.status == direction) {
                    if ((direction == "up" && elevator.currentFloor <= requestedFloor) || (direction == "down" && elevator.currentFloor >= requestedFloor)){
                        listOfElevators.add(id);
                    }
                }
            });
            return returnElevator(listOfElevators, requestedFloor);
        }
        
        private Elevator theAreIdle(int requestedFloor, String direction) {                 // [java]
            ArrayList listOfElevators = new ArrayList();
            this.listElevators.forEach((id, elevator) -> {
                if(elevator.status == "idle"){
                    listOfElevators.add(id);
                }
            });
            return returnElevator(listOfElevators, requestedFloor);
        }
        
        private Elevator theAreNotOnWay(int requestedFloor, String direction) {             // [java]
            ArrayList listOfElevators = new ArrayList();
            this.listElevators.forEach((id, elevator) -> {
                if(elevator.status != direction){
                    listOfElevators.add(id);
                }
            });
            return returnElevator(listOfElevators, requestedFloor);
        }
        
        private Elevator choiceElevator(int requestedFloor, String direction)
        {
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

        public Elevator _requestElevator(int requestedFloor, String direction)
        {
            System.out.println("\n\t:::: Column " + this.id_ + " has been selected ::::");
                wait_();
                //this.buttonsFloorsFloor[requestedFloor + direction].status = true
            Elevator elevator = choiceElevator(1, direction);
                // this.buttonsFloorsFloor[requestedFloor + direction].status = false
            System.out.println("\n\t\t== Elevator " + elevator.id_ + " has been selected ===\n");
                wait_();
            elevator.moveElevator(1);
            elevator.moveElevator(requestedFloor);
            return elevator;
        }

        public Elevator requestElevator(int requestedFloor)
        {
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
            System.out.println("\n\t\t== Elevator " + elevator.id_ + " has been selected ===\n");
                wait_();
            elevator.moveElevator(requestedFloor);
            elevator.moveElevator(1);
            return elevator;
        }
    }

    public static class Batterie
    {// Class of Batterie
        public int floors;
        public int basements;
        public int[][] columns;
        public int qtyElevators;

        public String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        public HashMap<String, Column> listColumns;
        int timeAction = 100;

        public Batterie(int floors, int basements, int[][] columns, int qtyElevators)
        {
            this.floors = floors;
            this.basements = basements;
            this.columns = columns;
            this.qtyElevators = qtyElevators;

            this.listColumns = new HashMap<String, Column>();

            createColumns();
        }

        private void createColumns()
        {
            for(int i = 0; i < this.columns.length; i++)
            {
                char id = this.chars.charAt(i);
                String id_ = String.valueOf(id);
                System.out.println(":::: column " + id + " created ::::");
                wait_();
                listColumns.put(id_, new Column(id_, this.qtyElevators, this.columns[i]));
                System.out.println("\n");
            }
        }
        
        public void AssignElevator(int requestedFloor) {
            System.out.println("\n## Someone call a elevator on RC to go on floor " + requestedFloor + " ##");
            wait_();
            this.listColumns.forEach((key, value) -> {
                if (isInArray(value.floorServed, requestedFloor)){
                    if(requestedFloor < 0){
                        value._requestElevator(requestedFloor, "down");
                    } else if(requestedFloor > 1) {
                        value._requestElevator(requestedFloor, "up");
                    }
                }
            });
        }
    }

    public static void scenario() {
        int[] columnA = makeRangeExc(-6, 1, 0);
        int[] columnB = makeRange(2,20);
        int[] columnC = makeRange(21,40);
        int[] columnD = makeRange(41,60);
        int[][] columns = {columnA, columnB, columnC, columnD};
        int currentFloor;
        String status;
        String id_;
        String elevator;
        
    // Scenario 1
        System.out.println("<><><><><> Scenario 1 <><><><><>");

        Batterie batterie1 = new Batterie(66, 6, columns, 5);
        id_ = "B";

        currentFloor = 20;
        status = "down";
        elevator = id_ + "1";
        batterie1.listColumns.get(id_).listElevators.get(elevator).currentFloor = currentFloor;
        batterie1.listColumns.get(id_).listElevators.get(elevator).status = status;
        System.out.println("===== Elevator "+ elevator +" is on " + currentFloor + " floor, going " + status + "!!");
        wait_(); 
        
        currentFloor = 3;
        status = "up";
        elevator = id_ + "2";
        batterie1.listColumns.get(id_).listElevators.get(elevator).currentFloor = currentFloor;
        batterie1.listColumns.get(id_).listElevators.get(elevator).status = status;
        System.out.println("===== Elevator "+ elevator +" is on " + currentFloor + " floor, going " + status + "!!");
        wait_(); 
        
        currentFloor = 13;
        status = "down";
        elevator = id_ + "3";
        batterie1.listColumns.get(id_).listElevators.get(elevator).currentFloor = currentFloor;
        batterie1.listColumns.get(id_).listElevators.get(elevator).status = status;
        System.out.println("===== Elevator "+ elevator +" is on " + currentFloor + " floor, going " + status + "!!");
        wait_(); 
        
        currentFloor = 15;
        status = "down";
        elevator = id_ + "4";
        batterie1.listColumns.get(id_).listElevators.get(elevator).currentFloor = currentFloor;
        batterie1.listColumns.get(id_).listElevators.get(elevator).status = status;
        System.out.println("===== Elevator "+ elevator +" is on " + currentFloor + " floor, going " + status + "!!");
        wait_(); 
        
        currentFloor = 6;
        status = "down";
        elevator = id_ + "5";
        batterie1.listColumns.get(id_).listElevators.get(elevator).currentFloor = currentFloor;
        batterie1.listColumns.get(id_).listElevators.get(elevator).status = status;
        System.out.println("===== Elevator "+ elevator +" is on " + currentFloor + " floor, going " + status + "!!");
        wait_();
        
        batterie1.AssignElevator(5);
    
    
    // Scenario 2
        System.out.println("<><><><><> Scenario 2 <><><><><>");

        Batterie batterie2 = new Batterie(66, 6, columns, 5);
        id_ = "C";
        
        currentFloor = 1;
        status = "up";
        elevator = id_ + "1";
        batterie2.listColumns.get(id_).listElevators.get(elevator).currentFloor = currentFloor;
        batterie2.listColumns.get(id_).listElevators.get(elevator).status = status;
        System.out.println("===== Elevator "+ elevator +" is on " + currentFloor + " floor, going " + status + "!!");
        wait_(); 
        
        currentFloor = 23;
        status = "up";
        elevator = id_ + "2";
        batterie2.listColumns.get(id_).listElevators.get(elevator).currentFloor = currentFloor;
        batterie2.listColumns.get(id_).listElevators.get(elevator).status = status;
        System.out.println("===== Elevator "+ elevator +" is on " + currentFloor + " floor, going " + status + "!!");
        wait_(); 
        
        currentFloor = 33;
        status = "down";
        elevator = id_ + "3";
        batterie2.listColumns.get(id_).listElevators.get(elevator).currentFloor = currentFloor;
        batterie2.listColumns.get(id_).listElevators.get(elevator).status = status;
        System.out.println("===== Elevator "+ elevator +" is on " + currentFloor + " floor, going " + status + "!!");
        wait_(); 
        
        currentFloor = 40;
        status = "down";
        elevator = id_ + "4";
        batterie2.listColumns.get(id_).listElevators.get(elevator).currentFloor = currentFloor;
        batterie2.listColumns.get(id_).listElevators.get(elevator).status = status;
        System.out.println("===== Elevator "+ elevator +" is on " + currentFloor + " floor, going " + status + "!!");
        wait_(); 
        
        currentFloor = 39;
        status = "down";
        elevator = id_ + "5";
        batterie2.listColumns.get(id_).listElevators.get(elevator).currentFloor = currentFloor;
        batterie2.listColumns.get(id_).listElevators.get(elevator).status = status;
        System.out.println("===== Elevator "+ elevator +" is on " + currentFloor + " floor, going " + status + "!!");
        wait_(); 

        batterie2.AssignElevator(36);
    //

    // Scenario 3
        System.out.println("<><><><><> Scenario 3 <><><><><>");

        Batterie batterie3 = new Batterie(66, 6, columns, 5);
        id_ = "D";
        
        currentFloor = 58;
        status = "down";
        elevator = id_ + "1";
        batterie3.listColumns.get(id_).listElevators.get(elevator).currentFloor = currentFloor;
        batterie3.listColumns.get(id_).listElevators.get(elevator).status = status;
        System.out.println("===== Elevator "+ elevator +" is on " + currentFloor + " floor, going " + status + "!!");
        wait_(); 
        
        currentFloor = 50;
        status = "up";
        elevator = id_ + "2";
        batterie3.listColumns.get(id_).listElevators.get(elevator).currentFloor = currentFloor;
        batterie3.listColumns.get(id_).listElevators.get(elevator).status = status;
        System.out.println("===== Elevator "+ elevator +" is on " + currentFloor + " floor, going " + status + "!!");
        wait_(); 
        
        currentFloor = 46;
        status = "up";
        elevator = id_ + "3";
        batterie3.listColumns.get(id_).listElevators.get(elevator).currentFloor = currentFloor;
        batterie3.listColumns.get(id_).listElevators.get(elevator).status = status;
        System.out.println("===== Elevator "+ elevator +" is on " + currentFloor + " floor, going " + status + "!!");
        wait_(); 
        
        currentFloor = 1;
        status = "up";
        elevator = id_ + "4";
        batterie3.listColumns.get(id_).listElevators.get(elevator).currentFloor = currentFloor;
        batterie3.listColumns.get(id_).listElevators.get(elevator).status = status;
        System.out.println("===== Elevator "+ elevator +" is on " + currentFloor + " floor, going " + status + "!!");
        wait_(); 
        
        currentFloor = 60;
        status = "down";
        elevator = id_ + "5";
        batterie3.listColumns.get(id_).listElevators.get(elevator).currentFloor = currentFloor;
        batterie3.listColumns.get(id_).listElevators.get(elevator).status = status;
        System.out.println("===== Elevator "+ elevator +" is on " + currentFloor + " floor, going " + status + "!!");
        wait_(); 

        batterie3.listColumns.get(id_).requestElevator(54);
    // 

    // Scenario 4
        System.out.println("<><><><><> Scenario 3 <><><><><>");

        Batterie batterie4 = new Batterie(66, 6, columns, 5);
        id_ = "A";
        
        currentFloor = -4;
        status = "idle";
        elevator = id_ + "1";
        batterie4.listColumns.get(id_).listElevators.get(elevator).currentFloor = currentFloor;
        batterie4.listColumns.get(id_).listElevators.get(elevator).status = status;
        System.out.println("===== Elevator "+ elevator +" is on " + currentFloor + " floor, going " + status + "!!");
        wait_(); 
        
        currentFloor = 1;
        status = "idle";
        elevator = id_ + "2";
        batterie4.listColumns.get(id_).listElevators.get(elevator).currentFloor = currentFloor;
        batterie4.listColumns.get(id_).listElevators.get(elevator).status = status;
        System.out.println("===== Elevator "+ elevator +" is on " + currentFloor + " floor, going " + status + "!!");
        wait_(); 
        
        currentFloor = -3;
        status = "down";
        elevator = id_ + "3";
        batterie4.listColumns.get(id_).listElevators.get(elevator).currentFloor = currentFloor;
        batterie4.listColumns.get(id_).listElevators.get(elevator).status = status;
        System.out.println("===== Elevator "+ elevator +" is on " + currentFloor + " floor, going " + status + "!!");
        wait_(); 
        
        currentFloor = -6;
        status = "up";
        elevator = id_ + "4";
        batterie4.listColumns.get(id_).listElevators.get(elevator).currentFloor = currentFloor;
        batterie4.listColumns.get(id_).listElevators.get(elevator).status = status;
        System.out.println("===== Elevator "+ elevator +" is on " + currentFloor + " floor, going " + status + "!!");
        wait_(); 
        
        currentFloor = -1;
        status = "down";
        elevator = id_ + "5";
        batterie4.listColumns.get(id_).listElevators.get(elevator).currentFloor = currentFloor;
        batterie4.listColumns.get(id_).listElevators.get(elevator).status = status;
        System.out.println("===== Elevator "+ elevator +" is on " + currentFloor + " floor, going " + status + "!!");
        wait_(); 

        batterie4.listColumns.get(id_).requestElevator(-3);
    // 
    }

    public static void main(String[] args) {
        scenario();
    }
}