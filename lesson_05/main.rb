require_relative 'manufacture'
require_relative 'instance_counter'
require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'carriage'
require_relative 'cargo_carriage'
require_relative 'passenger_carriage'

class Main

    TYPE = {cargo: "грузовой", passenger: "пассажирский"}
    OBJECT_ERROR = "Ошибка ввода!"

    def choices
      puts "Выберите действие"
      puts "1-- создать станцию."#станция имя не должно быть пустым
      puts "2-- создать поезд."
      puts "3-- создать маршрут." #условие: минимум 2 станции
      puts "4-- маршрут: добавить/удалить станцию." #условие:  наличие маршрут, наличие станции
      puts "5-- Назначать маршрут поезду." #условие: наличие поезда, наличие маршрута
      puts "6-- переместить поезд по маршруту вперед и назад." #условие: наличие поезда, вперед - станция не конечная, назад станция не начальная
      puts "7-- поезд: прицепить/отцепить вагоны."#условие: наличие поезда, поезда, которые стоят на станции
      puts "8-- карта станций и передвижений поездов." #наличие станций
      puts "9-- выход."
      puts "Выберите  от 1 до 9"
    end

    def action(choice)
      case choice
        when '1'
          create_station
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

    #с интерфейса эти методы должны быть недоступны
    private

    def list_stations
      puts "Список станций:"
      Station.all.each.with_index(1) {|station, index| puts "#{index} - #{station.name}"}
    end

    def list_routes
        puts "Список маршрутов:"
        Route.all.each.with_index(1) {|route, index| puts "#{index} - #{route.route[0].name}/#{route.route[-1].name}"}
    end

    def list_trains
        puts "Список поездов:"
        Train.all.each.with_index(1) {|(number, train), index| puts "#{index} - поезд номер №#{train.number} - тип: #{TYPE[train.typ_train]}, количество вагонов: #{train.carriages.size}" }
    end

    def display_route_station
      puts "Маршрут: #{@way.first_station.name - @way.last_station.name}"
      @way.route.each.with_index(1){|station, index| puts "#{index} - #{station.name}" }
    end

    def select_train
      puts "введите номер поезда"
      n = gets.chomp.to_s
      @selected_train = Train.all[n]
      raise "Такого номера поезда не существует" if @selected_train.nil?
    end

    def display_all
        puts "8-- карта станций и передвижений поездов."
        Station.all.each.with_index(1) do   |station, index|
         puts "#{index} - #{station.name}"
         station.show
        end
    end

    def  create_station
      puts "Введите название новой станции"
      name = gets.chomp.downcase.capitalize!
      station=Station.new(name)
      puts "Станция #{station.name} создана!"
      list_stations

    end

    def create_train
      puts "выберите тип поезда: 1 - пассажирский, 2- грузовой"
      n = gets.chomp.to_s
      (n=="1" ||n== "2") ? (puts"Введите номер поезда:") : (raise OBJECT_ERROR)
      number = gets.chomp
      if n == "1"
        train = PassengerTrain.new(number)
      elsif n == "2"
        train = CargoTrain.new(number)
      else
        puts OBJECT_ERROR
      end
      puts "Поезд №#{train.number} тип: #{TYPE[train.typ_train]} создан!"
      list_trains
    end

    def create_route
        list_stations
        puts "введите номер начальной станции"
        n = gets.chomp.to_i - 1
        first = Station.all[n]
        puts "введите номер конечной станции"
        n =  gets.chomp.to_i - 1
        last = Station.all[n]
        way = Route.new(first, last)
        puts "Создан маршрут  #{first.name} - #{last.name}"
        list_routes
    end

    def add_remove_station_to_route
      list_routes
      puts "выберите номер маршрута"
      number = gets.chomp.to_i - 1
      @way=Route.all[number]
      puts "введите 1 - для добавления станции в маршрут, 2 - для удаления станции из маршрута"
      n = gets.chomp.to_s
      if n == "1"
        (Station.all - @way.route).size > 0 ? add_station_route :  (raise "\nНет станций для добавления в маршрут, создайте станцию!")
      elsif n == "2"
        @way.route.size > 2 ? remove_station_route : (raise "Нет станций для удаления")
      else
        OBJECT_ERROR
      end
      p @way
      puts "Маршрут: #{@way.first_station.name} - #{@way.last_station.name}"
      @way.route.each.with_index(1){|station, index| puts "#{index} - #{station.name}" }
    end

    def add_station_route
      puts "Список станций для добавления в маршрут:"
      @available_stations = Station.all - @way.route
      @available_stations.each.with_index(1) {|station, index| puts "#{index} - #{station.name}"}
      puts "введите номер выбранной станции"
      n = gets.chomp.to_i-1
        if n>=0 && n < @available_stations.size && @available_stations.size >= 2
          station =@available_stations[n]
          @way.add(station)
          puts "Станция #{station.name} успешно добавлена"
        else
          OBJECT_ERROR
        end
    end

    def remove_station_route
      puts "Список станций:"
      removable_stations = @way.route - [@way.route.first] - [@way.route.last]
      !removable_stations.empty? ? removable_stations.each.with_index(1) {|station, index| puts "#{index} - #{station.name}"} : (raise "Нет станций для удаления из маршрута")
      puts "введите номер выбранной станции"
      n = gets.chomp.to_i-1
        if n>= 0 && n < removable_stations.size
          station =removable_stations[n]
          @way.delete(station)
          puts "Станция  успешно удалена"
        else
          puts OBJECT_ERROR
        end
    end

    def add_route_to_train
      list_trains
      select_train
      list_routes
      puts "введите номер маршрута"
      n = gets.chomp.to_i-1
      route = Route.all[n]
      @selected_train.departure(route)
      @selected_train.current_station.arrive_train(@selected_train)
      @selected_train.inspect
      puts "поезд номер № #{@selected_train.number} - тип: #{TYPE[@selected_train.typ_train]} - маршрут: #{route.first_station.name}-#{route.last_station.name}, текущая станция: #{@selected_train.current_station.name}, количество вагонов: #{@selected_train.carriages.size}"
    end

    def move_train_back_forth
      list_trains
      select_train
      puts "поезд номер №#{@selected_train.number} - тип: #{TYPE[@selected_train.typ_train]} - текущая станция: #{@selected_train.current_station.name}, количество вагонов: #{@selected_train.carriages.size}"
      @selected_train.route.map { |station|  print "#{station.name}/ " }
      puts "выберите направление движение: 1 -  вперед, 2- назад"
      n = gets.chomp.to_s
      if n == "1"
        @selected_train.forward
        @selected_train.current_station.arrive_train(@selected_train)
      elsif n == "2"
        #условие: движение назад станция не начальная
        @selected_train.backward
        @selected_train.current_station.arrive_train(@selected_train)
      else
        OBJECT_ERROR
      end
    end

    def add_remove_carriage
      trains_on_station = Train.all.select{|number, train| !train.current_station.nil?}
      trains_on_station.each.with_index(1) {|(number, train), index| puts "#{index} - поезд номер №#{train.number} - тип: #{TYPE[train.typ_train]}, количество вагонов: #{train.carriages.size}" }
      select_train
      p @selected_train
      puts "поезд номер №#{@selected_train.number} - тип: #{TYPE[@selected_train.typ_train]}, количество вагонов: #{@selected_train.carriages.size}"
      puts "выберите действие: 1 -  прицепить вагон, 2- отцепить вагон"
      n = gets.chomp.to_s
      if n == "1"
        create_carriage
        @selected_train.add_carriage(@carriage)
      elsif n == "2"
        carriage = @selected_train.carriages[-1]
        @selected_train.remove_carriage(carriage)
      else
        puts OBJECT_ERROR
      end
    end

    def create_carriage
        @typ_carriage = @selected_train.typ_train
      if @typ_carriage == :cargo
        @carriage = CargoCarriage.new
      elsif @typ_carriage == :passenger
        @carriage = PassengerCarriage.new
      else puts OBJECT_ERROR
      end
    end

end

def self.user_choice
 choice = gets.chomp
end

main = Main.new

loop do
  main.choices
  main.action(user_choice)
end
