require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(9) { ('A'..'Z').to_a.sample }
  end

  def score
    @score = message(params[:word])
  end

  def included?(attempt)
    attempt.chars.all? { |letter| attempt.count(letter) <= params[:letters].count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def message(attempt)
    if included?(attempt.upcase)
      if english_word?(attempt)
        "Congratulations! #{attempt} is a valid English word!"
      else
        "Sorry but #{attempt} does not seem to be a valid English word"
      end
    else
      "Sorry but #{attempt} cannot be built out of #{@letters}"
    end
  end
end
