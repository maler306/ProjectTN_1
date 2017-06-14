class CargoTrain < Train

  def initialize(number)
    super
    self.typ_train = :cargo
  end

end
