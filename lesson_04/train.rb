class Train < Route

  TYPE = {cargo: "грузовой", passenger: "пассажирский"}
  START_SPEED = 0

  attr_accessor  :current_station, :carriages, :typ_train
  attr_reader :number, :speed

  def initialize(number)
    @number = number.to_s
    self.carriages = []
    self.speed = START_SPEED
  end

  def add_carriage(carriage)
    if @speed.zero?
       @carriages << carriage if carriage.typ_carriage == typ_train
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
  attr_writer :speed
    def stop
      self.speed = 0
    end

end
