require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'hangman'

enable :sessions

Game = Struct.new(:stage, :word, :word_so_far, :guessed_so_far, :game_over)

get '/' do
	# check for new game
	if params["new-game"] == "true" || !session[:game]
		new_word = Hangman.pick_word
		word_so_far = Hangman.draw_word_so_far(new_word)
		session['game'] = Game.new(1, new_word, word_so_far, [])
		session['game_over'] = false
	end
	# check guess against word
	guess = params['guess']
	if guess
		valid, message = Hangman.check_entry(guess, session['game'].guessed_so_far)
		session['game'], status = Hangman.check_guess(guess, session[:game])
		message = status.message
	else
		message = "Please guess a letter!"
	end
	# output erb passing stage, words so far and letters so far
	erb :index, locals: {game: session[:game], message: message}
end


