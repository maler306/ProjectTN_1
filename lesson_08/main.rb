require_relative 'manufacture'
require_relative 'instance_counter'
require_relative 'accessors'
require_relative 'validation'
require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'carriage'
require_relative 'cargo_carriage'
require_relative 'passenger_carriage'

class Main
  OBJECT_ERROR = 'Ошибка ввода!'.freeze
  MAIN_ACTIONS = { '1' => :create_station,
                   '2' => :create_train,
                   '3' => :create_route,
                   '4' => :add_remove_station_to_route,
                   '5' => :add_route_to_train,
                   '6' => :move_train_back_forth,
                   '7' => :add_remove_carriage,
                   '8' => :display_all,
                   '9' => :show_train_carriages_list,
                   '10' => :station_train_list,
                   '11' => :carriage_take_capacity,
                   '12' => :abort }.freeze

  # rubocop :disable Metrics/MethodLength:
  def choices
    puts 'Выберите действие'
    puts '1-- создать станцию.'
    puts '2-- создать поезд.'
    puts '3-- создать маршрут.'
    puts '4-- маршрут: добавить/удалить станцию.'
    puts '5-- Назначать маршрут поезду.'
    puts '6-- переместить поезд по маршруту вперед и назад.'
    puts '7-- поезд: прицепить/отцепить вагоны.'
    puts '8-- карта станций и передвижений поездов.'
    puts '9-- отобразить список вагонов у поезда'
    puts '10-- отобразить список поездов на станции'
    puts '11-- продать ресурс'
    puts '12-- выход.'
    puts 'Выберите  от 1 до 11'
  end
  # rubocop :enable Metrics/MethodLength:

  def action(user_choice)
    act = MAIN_ACTIONS.fetch(user_choice) { puts 'Некорректный ввод, выберите  от 1 до 11' }
    render(act)
  end

  private

  def render(method)
    send(method)
  rescue RuntimeError, TypeError => e
    puts e.message
  end

  def list_stations
    puts 'Список станций:'
    Station.all.each.with_index(1) { |station, index| puts "#{index} станция - #{station.name}" }
  end

  def list_routes
    puts 'Список маршрутов:'
    Route.all.each.with_index(1) do |route, index|
      puts "#{index} - #{route.route.first.name}/#{route.route.last.name}"
    end
  end

  def list_trains
    puts 'Список поездов:'
    Train.all.each.with_index(1) do |(_number, train), index|
      puts "#{index} - поезд номер №#{train.number} - тип: #{Train::TYPE[train.typ_train]},
      количество вагонов: #{train.carriages.size}"
    end
  end

  def display_route_station
    puts "Маршрут: #{@way.first_station.name - @way.last_station.name}"
    @way.route.each.with_index(1) { |station, index| puts "#{index} - #{station.name}" }
  end

  def select_train
    puts 'введите номер поезда'
    n = gets.chomp.to_sym
    @selected_train = Train.all[n]
    p @selected_train
    raise 'Такого номера поезда не существует' if @selected_train.nil?
  end

  def selected_train_display
    puts "поезд № #{@selected_train.number} - тип: #{Train::TYPE[@selected_train.typ_train]}"
    puts "маршрут: #{route.first_station.name}-#{route.last_station.name}"
    # rubocop :disable Metrics/LineLength
    puts "текущая станция: #{@selected_train.current_station.name}, количество вагонов: #{@selected_train.carriages.size}"
    # rubocop :enable Metrics/LineLength
  end

  def display_all
    puts '8-- карта станций и передвижений поездов.'
    Station.all.each.with_index(1) do |station, index|
      puts "№- #{index} - Станция: #{station.name}"
      station.show_trains
    end
  end

  def create_station
    # rubocop :enable Metrics/LineLength'
    puts 'Введите название новой станции'
    puts 'название может состоять из одного или двух слов, а также содержать цифру через дефис'
    # rubocop :enable Metrics/LineLength
    name = gets.chomp.downcase.capitalize!
    station = Station.new(name)
    puts "Станция #{station.name} создана!"
    list_stations
  end

  def create_train
    puts 'выберите тип поезда: 1 - пассажирский, 2- грузовой'
    n = gets.to_i
    puts 'Введите номер поезда:'
    puts 'Допустимый формат номера:  ###-## (# - цифра или буква) или ### ##'
    number = gets.chomp
    [1, 2].include?(n) ? create_train!(number) : (raise OBJECT_ERROR)
    list_trains
  end

  def create_train!(number)
    train =
      if n == 1
        PassengerTrain.new(number)
      else
        CargoTrain.new(number)
      end
    puts "Поезд №#{train.number} тип: #{Train::TYPE[train.typ_train]} создан!"
  end

  def create_route
    list_stations
    puts 'введите номер начальной станции'
    n = gets.chomp.to_i - 1
    first = Station.all[n]
    puts 'введите номер конечной станции'
    n =  gets.chomp.to_i - 1
    last = Station.all[n]
    @way = Route.new(first, last)
    puts "Создан маршрут  #{first.name} - #{last.name}"
    list_routes
  end

  def add_remove_station_to_route
    list_routes
    puts 'выберите номер маршрута'
    number = gets.chomp.to_i - 1
    @way = Route.all[number]
    puts 'введите 1 - для добавления станции в маршрут, 2 - для удаления станции из маршрута'
    n = gets.chomp.to_s
    raise OBJECT_ERROR unless %w[1 2].include?(n)
    add_station_route if n == '1'
    remove_station_route if n == '2'
    puts "Маршрут: #{@way.first_station.name} - #{@way.last_station.name}"
    @way.route.each.with_index(1) { |station, index| puts "#{index} - #{station.name}" }
  end

  def add_station_route
    @available_stations = Station.all - @way.route
    raise 'Нет станций для добавления в маршрут, создайте станцию!' if @available_stations.empty?
    puts 'Список станций для добавления в маршрут:'
    @available_stations.each.with_index(1) { |station, index| puts "#{index} - #{station.name}" }
    puts 'введите номер выбранной станции'
    n = gets.chomp.to_i - 1
    (0...@available_stations.size).cover?(n) ? station = @available_stations[n] : (raise OBJECT_ERROR)
    @way.add(station)
    puts "Станция #{station.name} успешно добавлена"
  end

  def remove_station_route
    removable_stations = @way.route - [@way.route.first] - [@way.route.last]
    !removable_stations.empty? ? (puts 'Список станций:') : (raise 'Нет станций для удаления')
    removable_stations.each.with_index(1) { |station, index| puts "#{index} - #{station.name}" }
    puts 'введите номер выбранной станции'
    n = gets.chomp.to_i - 1
    (0...removable_stations.size).cover?(n) ? station = removable_stations[n] : (raise OBJECT_ERROR)
    @way.delete(station)
    puts 'Станция  успешно удалена'
  end

  def add_route_to_train
    list_trains
    select_train
    list_routes
    puts 'введите номер маршрута'
    n = gets.chomp.to_i - 1
    route = Route.all[n]
    @selected_train.departure(route)
    @selected_train.current_station.arrive_train(@selected_train)
    selected_train_display
  end

  def move_train_back_forth
    list_trains
    select_train
    selected_train_display
    @selected_train.route.map { |station|  print "#{station.name}/ " }
    puts 'выберите направление движение: 1 -  вперед, 2- назад'
    n = gets.chomp.to_s
    raise OBJECT_ERROR unless %w[1 2].include?(n)
    @selected_train.forward if n == '1'
    @selected_train.backward if n == '2'
    @selected_train.current_station.arrive_train(@selected_train)
  end

  # rubocop :disable Metrics/LineLength
  def add_remove_carriage
    trains_on_station = Train.all.reject { |_number, train| train.current_station.nil? }
    trains_on_station.each.with_index(1) do |(_number, train), index|
      puts "#{index} - поезд №#{train.number} - #{Train::TYPE[train.typ_train]}, вагонов: #{train.carriages.size}"
    end
    select_train
    selected_train_display
    add_remove_carriage!
    puts "поезд номер № #{@selected_train.number}, количество вагонов: #{@selected_train.carriages.size}"
  end
  # rubocop :enable Metrics/LineLength

  def add_remove_carriage!
    puts 'выберите действие: 1 -  прицепить вагон, 2- отцепить вагон'
    n = gets.chomp.to_s
    if n == '1'
      create_carriage
      @selected_train.add_carriage(@carriage)
    elsif n == '2'
      carriage = @selected_train.carriages.last
      @selected_train.remove_carriage(carriage)
    else
      puts OBJECT_ERROR
    end
  end

  def create_carriage
    @typ_carriage = @selected_train.typ_train
    puts 'Введите грузоподъемность вагона в кг' if @typ_carriage == :cargo
    puts 'Введите количество пассажирских мест в вагоне' if @typ_carriage == :passenger
    total_capacity = gets.chomp
    @carriage = CargoCarriage.new(total_capacity) if @typ_carriage == :cargo
    @carriage = PassengerCarriage.new(total_capacity) if @typ_carriage == :passenger
  end

  def train_carriages_list
    @selected_train.each_carriages do |carriage, index|
      puts "вагон№ #{index}: общий ресурс: #{carriage.total_capacity}"
      puts "продано: #{carriage.occupied_capacity}, свободный ресурс: #{carriage.free_capacity}"
    end
  end

  def show_train_carriages_list
    list_trains
    select_train
    train_carriages_list
  end

  def station_train_list
    list_stations
    puts 'введите номер выбранной станции'
    n = gets.chomp.to_i - 1
    station = Station.all[n]
    station.show_trains
  end

  def carriage_take_capacity
    show_train_carriages_list
    puts 'введите номер выбранного вагона'
    n = gets.chomp.to_i - 1
    @carriage = @selected_train.carriages[n]
    carriage_take_capacity!
    train_carriages_list
  end

  def carriage_take_capacity!
    if @carriage.typ_carriage == :cargo
      puts 'введите объем груза в кг'
      volume = gets.chomp.to_i
      @carriage.take_capacity(volume)
    elsif @carriage.typ_carriage == :passenger
      @carriage.take_capacity
    else
      OBJECT_ERROR
    end
  end
end

main = Main.new

loop do
  main.choices
  user_choice = gets.chomp
  main.action(user_choice)
end
