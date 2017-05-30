class Station
  attr_accessor :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def arrive_train(train)
    @trains << train
  end

  def outgo_train(train)
    @trains.delete(train)
  end

  def show
    if @trains.size > 0
      @trains.each { |train| puts "поезд №#{train.number} - тип: #{TYPE[train.typ_train]}, маршрут следования: #{train.route[0].name} - #{train.route[-1].name}, количество вагонов: #{train.carriages.size}"}
    else
      puts "Нет поездов на станции"
    end
  end

end
