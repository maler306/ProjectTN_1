puts "Введите ваше имя"
name = gets.chomp

puts "Введите ваш рост"
height = gets.chomp

puts "Введите ваш вес"
weight = gets.chomp

ideal_weight = height.to_i - 110

if weight.to_i - ideal_weight >=0
	puts "#{name}, ваш идельный вес #{ideal_weight} кг"
else
	puts "#{name}, ваш вес уже оптимальный"
end
