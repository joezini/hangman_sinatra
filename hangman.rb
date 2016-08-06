module Hangman
	Status = Struct.new(:ok, :message)

	def self.pick_word
		dictionary = File.readlines('5desk.txt')
		dictionary_size = dictionary.length
		word_found = false
		until word_found
			index = Random.new.rand(dictionary_size)
			if (5..12).include?(dictionary[index].length)
				word = dictionary[index]
				word_found = true
			end
		end
		word.downcase
	end

	def self.draw_word_so_far(word, guessed_letters=[])
		letters_not_guessed = ('a'..'z').to_a
		if guessed_letters.size > 0
			guessed_letters.each do |letter|
				letters_not_guessed.delete(letter)
			end
		end
		disguised_word = word.split(//).join(' ')
		letters_not_guessed.each do |letter|
			disguised_word.gsub!(letter, '_')
		end
		disguised_word
	end

	def self.check_entry(guess, guessed_letters)
		if guess.length != 1
			Status.new(false, "Too many letters!")
		elsif guessed_letters.include?(guess.downcase)
			Status.new(false, "You already guessed that!")
		elsif ('a'..'z').to_a.include?(guess.downcase)
			Status.new(true, "")
		else
			Status.new(false, "Not an alphabetical letter!")
		end
	end

	def self.check_guess(guess, game)
		game.guessed_so_far << guess

		if game.word.include?(guess)
			game.word_so_far = draw_word_so_far(game.word, game.guessed_so_far)
		else
			game.stage += 1
		end

		if !game.word_so_far.include?('_')
			game.game_over = true
			return [game, Status.new(true, "You won!")]
		elsif game.stage == 7
			game.game_over = true
			return [game, Status.new(false, "Too slow :( The answer was #{game.word}")]
		else
			return [game, Status.new(false, "Nope!")]
		end
	end
end
