#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'

marks = ARGV.first.split(',')
game = Game.new(marks)
puts game.calculate_total_score
