module Manufacture
#позволит указывать название компании-производителя
#и получать его.
attr_reader :manufacture_name

  def add_manufacture(manufacture)
    @manufacture_name=manufacture
  end
#Подключить модуль к классам Вагон и Поезд
end
