class PassengerCarriage < Carriage
  def initialize(total_capacity)
    @typ_carriage = :passenger
    super(total_capacity)
  end
end
