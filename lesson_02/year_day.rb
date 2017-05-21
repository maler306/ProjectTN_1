puts "Введите последовательно число, месяц и год"
d = gets.chomp.to_i
m = gets.chomp.to_i
y = gets.chomp.to_i

ar_year= (1..12).to_a
day_month=[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

if m>1
  qty = (day_month[0..(m-1)].reduce :+) + d #not january
  qty +=1  if ((y % 4==0 && y%100!=0 ) ||  y%400==0 ) && m>2
else
  qty=d
end

puts "Порядковый номер даты #{qty}!"
