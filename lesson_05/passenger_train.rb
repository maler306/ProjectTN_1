class PassengerTrain < Train

  def initialize(number)
    super(number)
    self.typ_train = :passenger
  end

end
