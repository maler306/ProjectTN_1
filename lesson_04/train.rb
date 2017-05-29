class Train < Route
  # Разделить поезда на два типа PassengerTrain и CargoTrain, сделать родителя для классов,
# который будет содержать общие методы и свойства
# Определить, какие методы могут быть помещены в private/protected и вынести их в такую секцию.
# В комментарии к методу обосновать, почему он был вынесен в private/protected
# Вагоны теперь делятся на грузовые и пассажирские (отдельные классы).
# К пассажирскому поезду можно прицепить только пассажирские, к грузовому - грузовые.
TYPE = {cargo: "грузовой", passenger: "пассажирский"}
START_SPEED = 0

  attr_writer  :current_station
  attr_reader :number, :typ_train, :carriages, :speed, :current_station

  def initialize(number)
    @number = number.to_s
    self.carriages = []
    self.speed = START_SPEED
  end

  def add_carriage(carriage)
    if @speed.zero?
       @carriages << carriage
     else
        puts "Данная операция возможно только при остановке поезда"
    end
  end

  def remove_carriage(carriage)
    if @speed.zero?
       @carriages.delete(carriage)
    else
        puts "Данная операция возможно только при остановке поезда"
    end
  end

  def departure(route)
    @route = route.route
    self.current_station = @route[0]
  end

  def forward
    index = @route.index(@current_station) + 1
   self.current_station = @route[index]  if index  < @route.size
  end

  def backward
    index = @route.index(@current_station)  - 1
   self.current_station = @route[index] if index  >= 0
  end

# нет прямого доступа к скорости из интерфейса
protected
attr_writer :speed,
  def stop
    self.speed = 0
  end

end



