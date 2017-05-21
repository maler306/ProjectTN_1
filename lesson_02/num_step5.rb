#ar=Array.new(100-5)/5+1, 1).map.with_index{|x, i| x*i*5 }#начинается с нуля
#arr55 =Array.new(100) { |i|  i+1 }.reject! { |i| i % 5 !=0 }#work
#arr5 = Array.new((100-5)/5+1) { |i|  i+1 }.map {|a| 5*a}#work
#arr55 =Array.new(20) { |i|  i*=5 }#начинается с нуля

arr5_100= (5..100).to_a.select { |num|  num% 5 ==0 }
p arr5_100


