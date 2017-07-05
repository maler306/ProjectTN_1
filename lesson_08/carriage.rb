class Carriage < Train
  include Manufacture
  include Validation

  attr_accessor :occupied_capacity, :free_capacity
  attr_reader :typ_carriage, :total_capacity

  validate :total_capacity, :presence

  def initialize(total_capacity)
    @total_capacity = total_capacity.to_i
    @occupied_capacity = 0
    @free_capacity = @total_capacity
    validate!
  end

  def take_capacity(volume = 1)
    if volume <= @free_capacity
      @occupied_capacity += volume
      @free_capacity = @total_capacity - @occupied_capacity
    else
      raise "Свободных мест в этом вагоне: #{@free_capacity}" if @typ_carriage == :passenger
      raise "Вагон не может принять груз более: #{@free_capacity}" if @typ_carriage == :cargo
    end
  end

end
