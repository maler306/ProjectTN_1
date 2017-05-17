puts "Введите последовательно коэффициенты квадратного уравнения: a, b и с"
a = gets.chomp
b = gets.chomp
c = gets.chomp

a=a.to_f
b=b.to_f
c=c.to_f

d = b**2 - 4*a*c

if d<0

	puts "Корней нет, D=#{d}!"
else
	if d==0
		puts "D=#{d}, один корень: x=#{-b/(2*a)}!"
	else
		puts "D=#{d}, два корня: x1=#{(-b+Math.sqrt(d))/(2*a)}, x1=#{(-b-Math.sqrt(d))/(2*a)}!"
	end
end