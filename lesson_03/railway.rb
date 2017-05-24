
class Station
  @@stations = []

  attr_accessor :name

  def initialize(name)
    @name = name
    @@stations << name
  end

#список станций
def self.list
  @@stations.each { |name| puts "#{name}"}
end

#Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
  def movement(typ_train)
    if typ_train == "passenger"
      $trains.each { |number, params| puts "#{number} - #{params}" if params[0] == "passenger" &&  params[1] == @name}
   elsif typ_train == "cargo"
      $trains.each { |number, params| puts "#{number} - #{params}" if params[0] == "cargo" &&  params[1] == @name }
   else
      $trains.each { |number, params| puts "#{number} - #{params}" if   params[1] == @name}
    end
  end


#Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
  def departure(n_train)
    $trains.each do |number, params|
      if number == n_train.to_s
        params[1] = nil
      end
    end
  end

end

class Route < Station

  attr_accessor :route, :path

  #attr_reader :name

  def initialize (first, last)
    @path = []
    @route = [[first.name], @path, [last.name]]
    #@route = route
  end

#Может добавлять промежуточную станцию в список way1[1] = [st
  def add (n, station)
    @path.insert(n-2, station.name)
    @route [1] = @path
  end

  def delete (n)
    @path.delete_at(n-2)
    @route [1] = @path
  end

  def index
    # puts "Начальная станция маршрута №1: #{@route.flatten[0]}"
    # @path.each { |path| puts "№#{@path.index(path)+2} - #{path}"}
    # puts "Конечная станция маршрута № #{@path.size+2}: #{@route.flatten[-1]}"
    @route.flatten.each { |route| puts "№#{@route.flatten.index(route)+1} - #{route}"}
  end

end

class Train < Route
  $trains = {}

  attr_accessor   :size, :speed, :pathway, :location

  attr_reader :number, :typ_train

  def initialize ( number, typ_train, size)
    @number = number.to_s
    @typ_train = typ_train
    @size = size
    @pathway= []
    @location = location
    $trains [number.to_s] = [typ_train, location]

  end

  def stop
    self.speed = 0
  end

  def update_size
    puts "введите +/- для того чтобы увеличить/уменьшить количество вагонов"

       x= gets.chomp
      if x == "-"
        @size-=1
      elsif x == "+"
        @size+=1
      else
        puts "возможны только операции: увеличить +, уменьшить -"
      end
      puts "количество вагонов = #{@size}"
  end

#Может принимать маршрут следования (объект класса Route
#При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
  def departure(route)
    @route = route.route.flatten
    @pathway = @route #route.flatten!
    @location=@pathway[0]
    $trains[@number][1] = @location
  end


#Может перемещаться между станциями, указанными в маршруте.
#Перемещение возможно вперед и назад, но только на 1 станцию за раз. Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
  def traffic(selector)
    if selector == "-"
      @location =@pathway[@pathway.index(@location)-1]
      $trains[@number][1] = @location
    elsif selector == "+"
      @location =@pathway[@pathway.index(@location)+1]
      $trains[@number][1] = @location
    else
      puts "движение вперед:  +, назад - "
    end
    puts "поезд находится на станции: #{@location}"
  end

end


tr1=Train.new(1,"cargo", 20)
tr2=Train.new(2,"cargo", 25)
tr3=Train.new(3,"passenger", 15)
tr4=Train.new(4,"passenger", 10)
st1 = Station.new("sairan")
st2 = Station.new("abai")
st3 = Station.new("carnaval")
st4 = Station.new("silkway")
st5 = Station.new("astana")
st6 = Station.new("shu")
st7 = Station.new("kara")
st8 = Station.new("kok")
st9 = Station.new("korpe")
st10 = Station.new("merke")
way1 =Route.new(st1, st5)
way2 =Route.new(st6, st10)
way3 =Route.new(st1, st10)
way1.add(2,st2)
way1.add(3,st3)
way1.add(4,st4)
way2.add(2,st7)
way2.add(3,st9)
way2.add(4,st7)
way3.add(2,st2)
way3.add(2,st3)
tr1.departure(way1)
tr2.departure(way2)
tr3.departure(way3)
tr4.departure(way1)
tr1.traffic("+")
tr2.traffic("+")
tr3.traffic("+")
tr4.traffic("+")
