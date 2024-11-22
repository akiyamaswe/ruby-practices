#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'

mark = ARGV.first.split(',')
game_score = Game.new(mark)
puts game_score.calculate_total_score
