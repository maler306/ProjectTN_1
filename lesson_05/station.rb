class Station
  TYPE = {cargo: "грузовой", passenger: "пассажирский"}
  NAME_FORMATE = /^[а-яa-z]{2,10}(\s[а-яА-Яa-zA-Z]{2,10})?(\-[0-9])?$/i
  attr_accessor :name

  @@stations = []

  def self.all
   !@@stations.empty? ? @@stations : (raise "Нет станций для отображения, создайте станцию")

  end

  def initialize(name)
    @name = name.capitalize.to_s
    validate!
    @trains = []
    @@stations << self
  end

  def arrive_train(train)
    @trains << train
  end

  def outgo_train(train)
    @trains.delete(train)
  end

  def station_trains(&block)
    @trains.each {|train| block.call(train)}
  end

  def show_trains
    if @trains.size > 0
      station_trains do |train|
        puts "поезд №#{train.number} - тип: #{TYPE[train.typ_train]}, маршрут следования: #{train.route[0].name} - #{train.route[-1].name}, количество вагонов: #{train.carriages.size}"
        #carriages info
        train.each_carriages {|carriage, index| puts "вагон№ #{index}: общий ресурс: #{carriage.total_capacity}, продано: #{carriage.occupied_capacity}, свободный ресурс: #{carriage.free_capacity}"}
      end
    else
      puts "Нет поездов на станции"
    end
  end



  def valid?
    validate!
  rescue
    false
  end

  protected

  def validate!
    raise "Станция должна иметь название" if name.nil?
    @@stations.each {|station| raise "Станция  #{station.name} уже существует" if station.name == self.name}
    raise "Неверный формат, название станции может состоять из одного или двух слов, а также содержать цифру через дефис" if name !~ NAME_FORMATE
    true
  end

end
