puts "Введите последовательно размеры (см) сторон треугольника"
a = gets.chomp.to_f
b = gets.chomp.to_f
c = gets.chomp.to_f


if a>b && a>c
  hypotenuse = a
  katet1 = b
  katet2 = c
elsif b>c && b>a
  hypotenuse = b
  katet1 = a
  katet2 = c
else
  hypotenuse = c
  katet1 = a
  katet2 = b
end

puts "Треугольник прямоугольный" if (katet1**2+katet2**2).round==(hypotenuse**2).round

puts "Треугольник равнобедренный" if katet1 == katet2

puts "Треугольник равносторонний" if a==b && b==c
