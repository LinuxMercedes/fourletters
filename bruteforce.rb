require 'set'

sides = 2

words = []

File.open('words_small.txt', 'r') do |f|
	f.each_line do |word|
		word.chomp!

		words << word
	end
end

words = Set.new(words)

dies = ('A'..'Z').to_a.combination(sides).to_a

puts "dies"

possible_dies = dies.repeated_combination(4).map { |dies|
	{
		:dies => dies,
		:words => dies[0].product(dies[1..3]).permutation(4).map { |w| words.include?(w) ? 1 : 0 }.reduce(&:+)
	}
}

puts "possible dies"

tops = possible_dies.sort { |x,y| y[:words] <=> x[:words] } [0]

puts "Dice:"
tops[:dies].each do |top|
	p top.to_a
end

match = tops[:words]

puts match.to_s + " words made by dice"
puts words.length.to_s + " total four-letter words"
puts ((match.to_f / sides ** 4) * 100.0).to_s + "% chance of rolling a word"

