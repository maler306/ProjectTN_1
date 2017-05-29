class Route < Station
  attr_accessor :route


  def initialize (first, last)
    @route = [first, last]
  end

  def add (station)
    #добавляет новую станцию 2-м объектом в массив, может 2-й с конца?
    @route.insert(1, station)
  end

  def delete (station)
    @route.delete(station) if station!= @route[0] || @route[-1]
  end

  def index
    @route.each { |station| puts "№#{@route.index(station)+1} - #{station}"}
  end

end
