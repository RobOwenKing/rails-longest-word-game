require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    9.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].downcase
    @letters = params[:letters].downcase.split(' ')

    @valid_grid = valid_grid?(@word, @letters)
    @valid_english = valid_english?(@word)

    @round_score = @word.length**2

    if @valid_grid && @valid_english
      if cookies[:score].nil?
        cookies[:score] = @round_score
      else
        current = cookies[:score].to_i
        cookies[:score] = current + @round_score
      end
    end
  end

  private

  def valid_grid?(word, letters)
    word = word.split('')
    letters.each do |letter|
      match = word.index(letter)
      word.delete_at(match) unless match.nil?
    end
    word.empty?
  end

  def valid_english?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    api_call = open(url).read
    api_response = JSON.parse(api_call)
    api_response['found']
  end
end
