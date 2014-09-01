sides = 4

class Integer
  def fact
    (1..self).reduce(:*) || 1
  end
end

def combination(m,r)
	m.fact / (r.fact * (m-r).fact)
end

def repeated_combination(m,r)
	combination(m + r - 1, r)
end

def permutation(m,r)
	m.fact / (m-r).fact
end

def repeated_permutation(m,r)
	m ** r
end

num_dice = combination(26, sides)

puts "Number of dice: " + num_dice.to_s

dice_combos = repeated_combination(num_dice, 4)

puts "Number of die combinations: " + dice_combos.to_s

words_per_combo = repeated_permutation(sides,4) * 4.fact

puts "Possible words per die combination: " + words_per_combo.to_s

puts "Total number of possible words: " + (words_per_combo * dice_combos).to_s

