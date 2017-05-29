class Station
  attr_accessor :name#, :fleet

#Не очень удачное название. Назал бы проще - @trains, сразу понятно, что там в переменной содержится
  def initialize(name)
    @name = name
    @fleet = []
  end

  def arrive_train(train)
    @fleet << train
  end

  def outgo_train(train)
    @fleet.delete(train)
  end

#Тогда тут не нужен select, а нужен обычный each. А еще лучше здесь не делать вывод на экран
#(это должен делать вызвающий код), а просто возвращать данные, т.е. массив поездов.
#Пробелы после скобок и перед ними не ставятся,
  def show (type="all")
    if type.to_s == "all"
      @fleet.select {|train| puts "#{train.number} - #{train.typ_train}" }
    elsif
      @fleet.select {|train| puts "#{train.number} - #{train.typ_train}" if train.typ_train == type.to_s }
    else
      puts " введите cargo/passenger/all" #Это тоже лишнее
    end
  end

end

class Route < Station
  attr_accessor :route

  def initialize (first, last)
    @route = [first.name, last.name] #В маршруте должны объекты станций храниться, а не их имена.
  end

  def add (station)
    @route.insert(1, station.name)
  end

  def delete (n)
    @route.delete(n) if n!= @route[0] || @route[-1]
  end

  def index
    @route.each { |station| puts "№#{@route.index(station)+1} - #{station}"}
  end

end

class Train < Route

  attr_accessor  :typ_train, :size, :speed, :location

  attr_reader :number

#также между названием метода и открывающей скобкой пробел тоже не нужен
  def initialize ( number, typ_train, size)
    @number = number.to_s
    @typ_train = typ_train
    @size = size
    @route #Не нужно объявлять пустые переменные, считай, что все переменные, которые нужны уже есть.
    @location #И ты в любом методе можешь их использовать. По-умолчанию, перемнные инициализируются значением nil
  end

  def stop
    self.speed = 0
  end

#Я же писал - нужно разделить это на 2 отдельных метода: один для удаления, другой для добавления вагонов
  def update_size(x)
      if x == "-" && @size > 0 && @speed==0
        @size-=1
      elsif x == "+" && @speed==0
        @size+=1
      else
        puts "добавить+/убавить- только, если скорость =0 "
      end
  end

  def departure(route)
    @route = route.route
    @location = 0
  end

  def forward
    @location+=1 if @location< @route.size
  end

  def backward
    @location -=1 if @location>0
  end

  def current_station
    @route[@location]
  end

  def previous_station
    @route[@location-1] if @location !=0
  end

  def next_station
    @route[@location+1]
  end

  end
