class Train < Route
  NUMBER_FORMAT = /^[а-я0-9]{3}(\s|\-)[а-я0-9]{2}$/i
  SPEED_ERROR = 'Данная операция возможно только при остановке поезда'.freeze
  DIRECTION_CHOICE_ERROR = 'Ошибка выбора направления движения поезда'.freeze
  NUMBER_FORMAT_ERROR = 'Допустимый формат номера:  ###-## (# - цифра или буква) или ### ##'.freeze

  include Manufacture
  include InstanceCounter

  TYPE = { cargo: 'грузовой', passenger: 'пассажирский' }.freeze
  START_SPEED = 0

  attr_accessor :current_station, :carriages, :typ_train
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
    !@@trains.empty? ? @@trains : (raise 'Сначала создайте поезд')
  end

  def add_carriage(carriage)
    raise 'Несоответствие типа вагона' unless carriage.typ_carriage == typ_train
    @speed.zero? ? @carriages << carriage : (raise SPEED_ERROR)
  end

  def remove_carriage(carriage)
    @speed.zero? ? @carriages.delete(carriage) : (raise SPEED_ERROR)
  end

  def departure(route)
    @route = route.route
    self.current_station = @route.first
  end

  def forward
    raise DIRECTION_CHOICE_ERROR if current_station == @route.last
    index = @route.index(@current_station)
    index += 1
    @current_station.outgo_train(self)
    self.current_station = @route[index]
  end

  def backward
    raise DIRECTION_CHOICE_ERROR if current_station == @route.first
    index = @route.index(@current_station)
    index -= 1
    @current_station.outgo_train(self)
    self.current_station = @route[index]
  end

  def self.find(number)
    @@trains[number]
  end

  def valid?
    validate!
  rescue
    false
  end

  def each_carriages
    @carriages.each.with_index(1) { |carriage, index| yield(carriage, index) }
  end

  protected

  attr_writer :speed
  def stop
    self.speed = 0
  end

  def validate!
    raise 'поезд должен иметь номер' if number.nil?
    raise "Поезд  #{number} уже существует" if @@trains.key?(number.to_sym)
    raise NUMBER_FORMAT_ERROR if number !~ NUMBER_FORMAT
  end
end
