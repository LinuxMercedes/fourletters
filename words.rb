require 'set'

sides = 4

words = []
letters = Array.new(4) { |e| Hash.new(0) }

File.open('words.txt', 'r') do |f|
	f.each_line do |word|
		word.chomp!

		word.chars.zip(letters).each do |w, l|
			l[w] += 1
		end
		words << word
	end
end

tops = Array.new(4) { |e| Set.new }

letters.zip(tops) do |position, top|
	position.to_a.sort! { |x, y|
		y[1] <=> x[1]
	}.take(sides).each do |letter, freq|
		top.add(letter)
	end
end

puts "Dice:"
tops.each do |top|
	p top.to_a
end

match = 0
words.each do |word|
	if word.chars.zip(tops).all? { |c, t| t.include? c }
		match += 1
	end
end

puts match.to_s + " words made by dice"
puts words.length.to_s + " total four-letter words"
puts ((match.to_f / sides ** 4) * 100.0).to_s + "% chance of rolling a word"

