# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  TOTAL_PINS = 10

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def base_frame_score
    @first_shot.score + @second_shot.score + @third_shot.score
  end

  def strike?
    @first_shot.score == TOTAL_PINS
  end

  def spare?
    !strike? && (@first_shot.score + @second_shot.score == TOTAL_PINS)
  end

  def second_next_frame_present?(next_frames)
    next_frames.length >= 2
  end

  def bonus_score(next_frames)
    return 0 if next_frames.empty?

    if strike?
      calculate_strike_bonus(next_frames)
    elsif spare?
      calculate_spare_bonus(next_frames)
    else
      0
    end
  end

  def calculate_strike_bonus(next_frames)
    next_frame = next_frames.first
    bonus = next_frame.first_shot.score

    if next_frame.strike? && second_next_frame_present?(next_frames)
      second_next_frame = next_frames[1]
      bonus += second_next_frame.first_shot.score
    else
      bonus += next_frame.second_shot.score
    end
    bonus
  end

  def calculate_spare_bonus(next_frames)
    next_frames.first.first_shot.score
  end
end
