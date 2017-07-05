class Station
  include Validation
  NAME_FORMATE = /^[а-яa-z]{2,10}(\s[а-яА-Яa-zA-Z]{2,10})?(\-[0-9])?$/i
  attr_accessor :name

  validate :name, :presence
  validate :type,  :type, Station
  validate :name, :format, NAME_FORMATE
  validate :name, :uniqueness

  @@stations = []

  def initialize(name)
    @name = name.capitalize.to_s
    validate!
    @trains = []
    @@stations << self
  end

  def self.all
    !@@stations.empty? ? @@stations : (raise 'Нет станций для отображения, создайте станцию')
  end

  def arrive_train(train)
    @trains << train
  end

  def outgo_train(train)
    @trains.delete(train)
  end

  def station_trains
    @trains.each { |train| yield(train) }
  end

  # rubocop :disable Metrics/LineLength
  def show_trains
    raise 'Нет поездов на станции' if @trains.empty?
    station_trains do |train|
      puts "поезд №#{train.number} - тип: #{Train::TYPE[train.typ_train]},  количество вагонов: #{train.carriages.size}"
      puts "маршрут следования: #{train.route.first.name} - #{train.route.last.name},"
      train.each_carriages { |carriage, index| puts "вагон№ #{index}: общий ресурс: #{carriage.total_capacity}, продано: #{carriage.occupied_capacity}, свободный ресурс: #{carriage.free_capacity}" }
    end
  end
  # rubocop :enable Metrics/LineLength

  def valid?
    validate!
  rescue
    false
  end
end
