basket={}

loop do

  puts "Введите последовательно название товара, цену за единицу и количество купленного товара:"
  product_name = gets.chomp.downcase
  break if product_name == "stop"
  price = gets.chomp.to_f
  quantity = gets.chomp.to_f

  set = []
  set.push(price, quantity)

  basket[product_name.to_sym] = set
end

sum=0
basket.each do |k, v|
  puts "#{k.to_s} : цена: -#{v[0]} в количестве -#{v[1]} стоимость #{v[0]*v[1]}"
  sum += v[0]*v[1]
end
puts "Итоговая сумма равна #{sum}"

# basket.each {|k, v|  puts "#{k.to_s} : цена: -#{v[0]} в количестве -#{v[1]} стоимость #{v[0]*v[1]}"}
# sum=0
# basket.each {|k, v| sum += v[0]*v[1]}
#можно ли вставить обе операции в один блок, почему выдает ошибку?

