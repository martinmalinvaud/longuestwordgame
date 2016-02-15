class GamesController < ApplicationController
  def game
    @grid = generate_grid(10)
  end

  def score
  end

private

def generate_grid(grid_size)
  grid_size.times.map { ('A'..'Z').to_a[rand(26)] }
end

def run_game(attempt, grid, start_time, end_time)
  ret = { time: end_time - start_time, score: 0 }
  translation = first_translation(attempt)
  no_error = !translation.nil?
  wig = word_in_grid?(attempt, grid)
  if no_error && word_in_grid?(attempt, grid)
    ret[:score] = attempt.length - (end_time - start_time).to_i
    ret[:translation] = translation
  end
  ret[:message] = message(no_error, wig)
  return ret
end

def word_in_grid?(word, grid)
  word.chars.reduce(true) { |a, e| a && (word.chars.count(e) <= grid.map(&:downcase).count(e)) }
end

def message(word_exists, word_in_grid)
  if !word_exists
    return "not an english word"
  elsif !word_in_grid
    return "not in the grid"
  else
    return "well done"
  end
end

def first_translation(word)
  path = %w(term0 PrincipalTranslations 0 FirstTranslation term)
  path.reduce(JSON
  .parse(open("http://api.wordreference.com/0.8/80143/json/enfr/#{word}")
  .read)) { |a, e| a.nil? ? nil : a[e] }
end


end





