require 'open-uri'

class GamesController < ApplicationController
  ALPHABET = ('A'..'Z').to_a

  def new
    @letters = generate_grid(10)
  end

  def score
    @result = run_game(params[:word], params[:letters])
  end

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    grid = []
    grid_size.times { |_| grid << ALPHABET[rand(ALPHABET.length - 1)] }
    grid
  end

  def call_api(url)
    data_serialyzed = URI.parse(url).open.read
    JSON.parse(data_serialyzed, symbolize_names: true)
  end

  def in_grid?(attempt, grid)
    attempt.all? { |char| grid.count(char) >= attempt.count(char) }
  end

  def run_game(attempt, grid)
    # TODO: runs the game and return detailed hash of result
    data = call_api('https://wagon-dictionary.herokuapp.com/' << attempt)

    if in_grid?(attempt.upcase.chars, grid)
      score = data[:found] ? attempt.length : 0
      message = data[:found] ? 'good' : 'no'
    else
      score = 0
      message = 'grid'
    end

    session[:score] = session[:score] + score;
    { score: score, message: message }
  end
end
