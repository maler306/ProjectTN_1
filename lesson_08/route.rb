class Route < Station
  attr_accessor :route, :first_station, :last_station

  @@routes = []

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    validate!
    @route = [first_station, last_station]
    @@routes << self
  end

  def self.all
    !@@routes.empty? ? @@routes : (raise 'Сначала создайте маршрут')
  end

  def add(station)
    @route.insert(-2, station)
  end

  def delete(station)
    @route.delete(station) if station != @route.first || @route.last # unless
  end

  def index
    @route.each { |station| puts "№#{@route.index(station) + 1} - #{station}" }
  end

  def valid?
    validate!
  rescue
    false
  end

  protected

  def validate!
    raise 'Для создания маршрута нужны две станции' if first_station == last_station
    raise 'Сначала создайте станции' if @@stations.size < 2
    true
  end
end
