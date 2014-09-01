require 'set'

sides = 4
popsize = 100
iters = 50

mutate_chance = 20
number_of_children = popsize / 2

srand 

$words = []

File.open('words.txt', 'r') do |f|
	f.each_line do |word|
		word.chomp!

		$words << word
	end
end

def fitness(elem)
	$words.map { |word| 
		word.chars.zip(elem[:dies]).all? { |w,e| e.include? w } ? 1 : 0
	}.reduce(:+)
end

## Build initial population
pop = Array.new(popsize) { |elem| 
	{
		:dies => Array.new(4) { |die| 
			Set.new(('A'..'Z').to_a.shuffle.take(sides))
		} 
	}
}

(0..iters).each { |iter|
	# Fitness eval
	pop.each { |elem|
		elem[:fitness] = fitness(elem)
	}

	# Mutate
	pop.each { |elem|
		if mutate_chance > rand(100)
			die = elem[:dies].shuffle[0]
			other_letters = Set.new(('A'..'Z').to_a) - die
			letter = die.to_a.shuffle[0]
			die.delete(letter)
			die.add(other_letters.to_a.shuffle[0])
		end
	}

	# Recombine
	children = pop.permutation(2).to_a.shuffle.take(popsize).map { |e1,e2|
		{
			:dies => e1[:dies].zip(e2[:dies]).map { |d1, d2| 
				Set.new((d1 + d2).to_a.shuffle.take(sides))
			}
		}
	}
	children.each { |child| 
		child[:fitness] = fitness(child)
	}

	pop = (pop + children).sort { |x,y| y[:fitness] <=> x[:fitness] }.take(popsize)

	p iter
}

# Fitness eval
pop.each { |elem|
	elem[:fitness] = fitness(elem)
}

tops = pop.sort { |x,y| y[:fitness] <=> x[:fitness] } [0]

puts "Dice:"
tops[:dies].each do |top|
	p top.to_a
end

match = 0
$words.each do |word|
	if word.chars.zip(tops[:dies]).all? { |c, t| t.include? c }
		match += 1
	end
end

puts match.to_s + " words made by dice"
puts $words.length.to_s + " total four-letter words"
puts ((match.to_f / sides ** 4) * 100.0).to_s + "% chance of rolling a word"

puts "Params:"
puts "sides = " + sides.to_s
puts "popsize = " + popsize.to_s
puts "iters = " + iters.to_s

puts "mutate_chance = " + mutate_chance.to_s
puts "number_of_children = " + number_of_children.to_s

