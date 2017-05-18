puts "Введите последовательно коэффициенты квадратного уравнения: a, b и с"
a = gets.chomp.to_f
b = gets.chomp.to_f
c = gets.chomp.to_f

d = b**2 - 4*a*c
sqroot_d= Math.sqrt(d)

if d<0
  puts "Корней нет, D=#{d}!"
elsif d==0
  puts "D=#{d}, один корень: x=#{-b/(2*a)}!"
else
  puts "D=#{d}, два корня: x1=#{(-b+sqroot_d)/(2*a)}, x1=#{(-b-sqroot_d)/(2*a)}!"
end

