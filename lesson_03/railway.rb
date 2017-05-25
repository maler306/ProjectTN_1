class Station
  attr_accessor :name#, :fleet

  def initialize(name)
    @name = name
    @fleet = []
  end

  def arrive_train(train)
    @fleet << train
  end

  def outgo_train(train)
    @fleet .delete(train)
  end

  def show (type="all")
    if type.to_s == "all"
      @fleet.select  {|train| puts "#{train.number} - #{train.typ_train}" }
    elsif
      @fleet.select  { |train| puts "#{train.number} - #{train.typ_train}" if train.typ_train == type.to_s }
    else
      puts " введите cargo/passenger/all"
    end
  end

end

class Route < Station
  attr_accessor :route

  def initialize (first, last)
    @route = [first.name, last.name]
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

  def initialize ( number, typ_train, size)
    @number = number.to_s
    @typ_train = typ_train
    @size = size
    @route
    @location
  end

  def stop
    self.speed = 0
  end

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
