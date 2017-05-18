puts "Введите ваше имя"
name = gets.chomp.capitalize

puts "Введите ваш рост в сантиметрах:"
height = gets.chomp.to_i

puts "Введите ваш вес в килограммах:"
weight = gets.chomp.to_i

ideal_weight = height- 110

if weight - ideal_weight >=0
  puts "#{name}, ваш идельный вес: #{ideal_weight} кг"
else
  puts "#{name}, ваш вес уже оптимальный"
end
