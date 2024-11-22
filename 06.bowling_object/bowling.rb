#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'

mark = ARGV.first.split(',')
game = Game.new(mark)
puts game.calculate_total_score
