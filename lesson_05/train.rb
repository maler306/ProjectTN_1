class Train < Route
  NUMBER_FORMAT = /^[а-я0-9]{3}(\s|\-)[а-я0-9]{2}$/i

  include Manufacture
  include InstanceCounter

  TYPE = {cargo: "грузовой", passenger: "пассажирский"}
  START_SPEED = 0

  attr_accessor  :current_station, :carriages, :typ_train
  attr_reader :number, :speed

    @@trains = {}

  def initialize(number)
    @number = number.to_s
    validate!
    self.carriages = []
    self.speed = START_SPEED
    @@trains[number.to_sym] = self
    register_instance
  end

  def self.all
    # @@trains raise "Сначала создайте поезд" if @@trains.size==0
    !@@trains.empty? ? @@trains : (raise "Сначала создайте поезд")
  end


  def add_carriage(carriage)
    if carriage.typ_carriage == typ_train
    @speed.zero? ?  @carriages << carriage  :  (raise "Данная операция возможно только при остановке поезда")
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
    @current_station.outgo_train(self)
   index  < @route.size ? self.current_station = @route[index] : (raise "Поезд, находится на конечной станции маршрута. Движение возможно только назад!")
  end

  def backward
    index = @route.index(@current_station)  - 1
    @current_station.outgo_train(self)
    index  >= 0 ? self.current_station = @route[index] : (raise "Поезд находится на начальной станции маршрута. Движение возможно только вперед")
  end


  def self.find(number)
      @@trains[number]
  end

  def valid?
    validate!
  rescue
    false
  end

  def each_carriages(&block)
    @carriages.each.with_index(1) {|carriage, index|  block.call(carriage, index)}
  end

# нет прямого доступа к скорости из интерфейса
  protected
  attr_writer :speed
    def stop
      self.speed = 0
    end

    def validate!
      raise "поезд должен иметь номер" if number.nil?
      raise "Поезд  #{number} уже существует" if @@trains.has_key?(number.to_sym)
      raise  "Допустимый формат номера:  ###-## (# - цифра или буква), дефис может быть заменен пробелом" if number !~ NUMBER_FORMAT
    end
end
