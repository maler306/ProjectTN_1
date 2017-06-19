class Carriage < Train
  include Manufacture

  attr_accessor :occupied_capacity, :free_capacity
  attr_reader :typ_carriage, :total_capacity

  def initialize(total_capacity)
    validate!
    @total_capacity = total_capacity.to_i
    @occupied_capacity = 0
    @free_capacity = @total_capacity
  end

  def take_capacity(volume=1)
    validate!
    @occupied_capacity +=volume
    @free_capacity = @total_capacity - @occupied_capacity
  end

  protected

  def validate!
    raise "Введите количество пассажирских мест в вагоне" if (total_capacity.nil? && @typ_carriage == :passenger)
    raise "Введите грузоподъемность вагона в кг" if (total_capacity.nil? && @typ_carriage == :cargo)
    raise "Количество свободных мест в этом вагоне: #{@free_capacity}" if (@free_capacity == 0 && @typ_carriage == :passenger)
    raise  "Вагон не может принять груз в таком объеме, свободный объем: #{@free_capacity}" if  (volume > @free_capacity && @typ_carriage == :cargo)
  end

end

