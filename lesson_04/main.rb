class Main

    require_relative 'station'
    require_relative 'route'
    require_relative 'train'
    require_relative 'cargo_train'
    require_relative 'passenger_train'
    require_relative 'carriage'
    require_relative 'cargo_carriage'
    require_relative 'passenger_carriage'

    TYPE = {cargo: "грузовой", passenger: "пассажирский"}
    OBJECT_ERROR = "Ошибка ввода!"

    attr_reader :stations, :routes, :trains# :create_station
    #attr_writer :stations, :routes, :trains

    @stations = []
    @routes = []
    @trains = []

    users_choice = gets.chomp


    def self.choices (choice)
      loop do
      puts "Выберите действие"
      puts "1-- создать станцию."
      puts "2-- создать поезд."
      puts "3-- создать маршрут."
      puts "4-- маршрут: добавить/удалить станцию."
      puts "5-- Назначать маршрут поезду."
      puts "6-- переместить поезд по маршруту вперед и назад."
      puts "7-- поезд: прицепить/отцепить вагоны."
      puts "8-- карта станций и передвижений поездов."
      puts "9-- выход."
      puts "Выберите  от 1 до 9"
      choice = gets.chomp.downcase
      case choice
        when '1'
          Main.create_station
        when '2'
          create_train
        when '3'
          create_route
        when '4'
          add_remove_station_to_route
        when '5'
          add_route_to_train
        when  '6'
          move_train_back_forth
        when '7'
          add_remove_carriage
        when '8'
          display_all
        when '9'
          abort
        else
          puts OBJECT_ERROR
        end
      end
    end

  choices(users_choice)

    #с интерфейса эти методы должны быть недоступны
    private

    def list_stations
      puts "Список станций:"
      @stations.each.with_index(1) {|station, index| puts "#{index} - #{station.name}"}
    end

    def list_routes
      puts "Список маршрутов:"
      @routes.each.with_index(1) {|route, index| puts "#{index} - #{route.route[0].name}/#{route.route[-1].name}"}
    end

    def list_trains
      puts "Список поездов:"
      @trains.each.with_index(1) {|train, index| puts "#{index} - поезд номер №#{train.number} - тип: #{TYPE[train.typ_train]}, количество вагонов: #{train.carriages.size}" }
    end

    def display_all
      puts "8-- карта станций и передвижений поездов."
      @stations.each.with_index(1) do   |station, index|
        puts "#{index} - #{station.name}"
        station.show
      end
    end

    def  self.create_station
      puts "Введите название новой станции"
      title = gets.chomp.downcase.capitalize!
      station=Station.new(title)
      @stations << station
      puts "Станция #{station.name} создана!"
      #p @stations
      list_stations
    end

    def create_train
      puts "выберите тип поезда: 1 - пассажирский, 2- грузовой"
      n = gets.chomp.to_s
        puts "Введите номер поезда:"
      number = gets.chomp
      if n == "1"
        train = PassengerTrain.new(number)
      elsif n == "2"
        train = CargoTrain.new(number)
      else
        puts OBJECT_ERROR
      end
      @trains << train
      puts "Поезд №#{train.number} тип: #{TYPE[train.typ_train]} создан!"
      list_trains
    end

    def create_route
      list_stations
      puts "введите номер начальной станции"
      n = gets.chomp.to_i - 1
      first = @stations[n]
      puts "введите номер конечной станции"
      n =  gets.chomp.to_i - 1
      last = @stations[n]
      way = Route.new(first, last)
      @routes << way
      # p way
      # p way.route[0]
      puts "Создан маршрут  #{first.name} - #{last.name}"
      list_routes
    end

    def add_remove_station_to_route
      list_routes
      puts "выберите номер маршрута"
      number = gets.chomp.to_i - 1
      @way=@routes[number]
      # p @way
      puts "введите 1 - для добавления станции в маршрут, 2 - для удаления станции из маршрута"
      n = gets.chomp.to_s
      if n == "1"
        add_station_route
      elsif n == "2"
        remove_station_route
      else
        OBJECT_ERROR
      end
    end

    def add_station_route
      #для массива размер которого >2
      puts "Список станций для добавления в маршрут:"
      @available_stations = @stations - @way.route
      @available_stations.each.with_index(1) {|station, index| puts "#{index} - #{station.name}"}
      puts "введите номер выбранной станции"
      n = gets.chomp.to_i-1
        if n>=0 && n < @available_stations.size
          station =@available_stations[n]
          @way.add(station)
          #p @way
          puts "Станция #{station.name} успешно добавлена"
        else
          puts OBJECT_ERROR
        end
    end

    def remove_station_route
    #для массива размер которого >2
      p @way
      p @stations
      puts "Список станций:"
      removable_stations = @way.route - [@way.route.first] - [@way.route.last]
      p removable_stations
      removable_stations.each.with_index(1) {|station, index| puts "#{index} - #{station.name}"}
      puts "введите номер выбранной станции"
      n = gets.chomp.to_i-1
        if n>= 0 && n < removable_stations.size
          station =removable_stations[n]
          # p station
          # p @way
          @way.delete(station)
          puts "Станция  успешно удалена"
          # p @way
        else
          puts OBJECT_ERROR
        end
    end

    def add_route_to_train
      list_trains
      puts "введите номер, соответствующий нумерации поезда в списке"
      n = gets.chomp.to_i-1
      train = @trains[n]
      # p train
      list_routes
      puts "введите номер маршрута"
      n = gets.chomp.to_i-1
      route = @routes[n]
      # p route
      train.departure(route)
      # p train
      train.current_station.arrive_train(train)
      # p train
    end

    def move_train_back_forth
      list_trains
      puts "введите номер, соответствующий нумерации поезда в списке"
      n = gets.chomp.to_i - 1
      train = @trains[n]
      # train info
      puts "поезд номер №#{train.number} - тип: #{TYPE[train.typ_train]} - текущая станция: #{train.current_station.name}, количество вагонов: #{train.carriages.size}"
      train.route.map { |station|  print "#{station.name}/ " }
      puts "выберите направление движение: 1 -  вперед, 2- назад"
      n = gets.chomp.to_s
      if n == "1"
        train.forward
        train.current_station.arrive_train(train)
        # p train
      elsif n == "2"
        train.backward
        train.current_station.arrive_train(train)
        # p train
        # p train.current_station
      else
        puts OBJECT_ERROR
      end
    end

    def add_remove_carriage
      # выводить те поезда, которые стоят на станции
      list_trains
      puts "введите номер, соответствующий нумерации поезда в списке"
      n = gets.chomp.to_i - 1
      @train = @trains[n]
      puts "поезд номер №#{@train.number} - тип: #{TYPE[@train.typ_train]}, количество вагонов: #{@train.carriages.size}"
      puts "выберите действие: 1 -  прицепить вагон, 2- отцепить вагон"
      n = gets.chomp.to_s
      if n == "1"
        create_carriage
        # p @carriage
        @train.add_carriage(@carriage)
        # p @train
      elsif n == "2"
        # p @train
        carriage = @train.carriages[-1]
        @train.remove_carriage(carriage)
        # p @train
      else
        puts OBJECT_ERROR
      end
    end

    def create_carriage
        @typ_carriage = @train.typ_train
      if @typ_carriage == :cargo
        @carriage = CargoCarriage.new
      elsif @typ_carriage == :passenger
        @carriage = PassengerCarriage.new
      else puts OBJECT_ERROR
      end
    end




end
