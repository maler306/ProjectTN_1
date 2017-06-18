class Carriage < Train
  include Manufacture

  attr_accessor :occupied_capacity, :free_capacity
  attr_reader :typ_carriage, :total_capacity

  def initialize(total_capacity)
    @total_capacity = total_capacity.to_i
    @occupied_capacity = 0
    @free_capacity = @total_capacity
  end

  def take_capacity(volume=1)
    @occupied_capacity +=volume
    validate!
    @free_capacity = @total_capacity - @occupied_capacity
  end

  protected

  def validate!
    raise "Количество свободных мест в этом вагоне: #{@free_capacity}" if (@free_capacity == 0 && @typ_carriage = :passenger)
    raise  "Вагон не может принять груз в таком объеме, свободный объем: #{@free_capacity}" if  (@occupied_capacity > @total_capacity && @typ_carriage = :cargo)
  end

end

