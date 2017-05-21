alphabet = Hash[("a".."z").to_a.zip((1..26).to_a)] #Hash[(:a..:z).to_a.zip((1..26).to_a)]
vowels = alphabet.select { |k,v| k =~ /[aeiouy]/ }
puts vowels
