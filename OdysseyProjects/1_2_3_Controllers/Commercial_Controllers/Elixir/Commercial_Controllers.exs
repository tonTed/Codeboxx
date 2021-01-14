
defmodule Tools do
  def sleep() do
    :timer.sleep(100)
  end
end

defmodule Elevator do
  defstruct [
    id: "A1",
    status: "idle",
    c_floor: 1
  ]

  def openDoor() do
    IO.puts "\t\tDoor is openning"
    Tools.sleep()
    IO.puts "\t\tDoor is open"
    Tools.sleep()
    closeDoor()
  end

  def closeDoor() do
    IO.puts "\t\tBe careful door is closing"
    Tools.sleep()
    IO.puts "\t\tDoor is close"
    Tools.sleep()
  end

  def moveElevator(requestedFloor, currentFloor) do
      if requestedFloor > currentFloor do
        moveUp(requestedFloor, currentFloor)
      else
        moveDown(requestedFloor, currentFloor)
      end
    end
    defp moveUp(requestedFloor, currentFloor) do
      if requestedFloor == currentFloor do
        IO.puts "\t\t Your are comming on floor #{currentFloor}"
        openDoor()
      else
        IO.puts "\t\t Moving from #{currentFloor} to #{currentFloor + 1}"
        Tools.sleep()
        moveUp(requestedFloor, currentFloor + 1)
      end
  end

  defp moveDown(requestedFloor, currentFloor) do
    if requestedFloor == currentFloor do
      IO.puts "\t\t Your are comming on floor #{currentFloor}"
      Elevator.openDoor()
    else
      IO.puts "\t\t Moving from #{currentFloor} to #{currentFloor - 1}"
      Tools.sleep()
      moveDown(requestedFloor, currentFloor - 1)
    end
  end
end

defmodule Column do
  defstruct [
    id: "",
    f_served: {},
    q_elevators: 0,
    l_elevators: %{},
  ]

  def create_elevators(id, q) do
    for i <- 1..q, into: %{}, do: {{"#{id}#{i}"}, %Elevator{id: "#{id}#{i}"}}
  end

end

defmodule Batterie do
  defstruct [
    floors: 0,          # unused
    basements: 0,       # unused
    l_columns: {},
    q_elevators: 0,
  ]

  def c_columns(qty_c, qty_e) do
    for i <- 1..qty_c, into: %{}, do: {"C#{i}", %Column{id: "C#{i}", l_elevators: Column.create_elevators("C#{i}", qty_e)}}
  end

  # def assignElevator(requestedFloor) do
  #   find_column(requestedFloor)                 # return the column
  #     |> choice_Elevator(requestedFloor)        # return elevator
  #     |> Elevator.moveElevator(requestedFloor)  # move the elevator
  # end
end

defmodule Setup do
  def batterie(floors, basements, q_columns, q_elevators) do
    %Batterie{floors: floors, basements: basements, l_columns: Batterie.c_columns(q_columns, q_elevators)}
  end
end

defmodule Main do
  def main do

    # Parameters Floors, Basements, columns, elevators per columns
    batterie = Setup.batterie(66, 6, 4, 5)
    IO.inspect(batterie)

    # move elevator between 2 floors
    Elevator.moveElevator(10,5)
    Elevator.moveElevator(2,16)
    Elevator.moveElevator(10,10)


    # columns = Batterie.c_columns(4, 5)
    # IO.inspect(columns)

    # a1 = %Elevator{id: "a1"}
    # a2 = %Elevator{id: "a2"}
    # a3 = %Elevator{id: "a3"}
    # a4 = %Elevator{id: "a4"}

    # IO.inspect(a1)
    # IO.inspect(a2)
    # IO.inspect(a3)
    # IO.inspect(a4)

    # a = %{}
    # IO.inspect a

    # :test
    # IO.puts(:test)



  end
end

Main.main
