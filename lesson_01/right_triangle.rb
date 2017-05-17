puts "Введите последовательно размеры (см) сторон треугольника"
a = gets.chomp
b = gets.chomp
c = gets.chomp

a=a.to_f
b=b.to_f
c=c.to_f

puts "Треугольник прямоугольный" if (a**2+b**2).round==(c**2).round || (a**2+c**2).round==(b**2).round || (c**2+b**2).round==(a**2).round
puts "Треугольник равнобедренный" if (a==b && b!=c) || (b==c && a!=c) || (a==c && b!=c)
puts "Треугольник равносторонний" if a==b && b==c

# if a>b
# 	if a>c

# 	else
# 	end
# else
# 	if 
# 	else
# 	end
# end