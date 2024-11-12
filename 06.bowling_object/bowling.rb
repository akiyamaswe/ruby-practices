#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'

shots = ARGV.first.split(',')
game_score = Game.new(shots)
puts game_score.calculate_total_score
