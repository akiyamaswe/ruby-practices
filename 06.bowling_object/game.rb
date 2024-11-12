# frozen_string_literal: true

require_relative 'frame'

class Game
  LAST_FRAME_MAX_SHOTS = 3
  NORMAL_FRAME_SHOTS = 2
  NEXT_FRAME_START = 1
  NEXT_FRAME_END = -1

  def initialize(shots)
    @frames = []
    process_shots(shots)
  end

  def calculate_total_score
    total = 0
    @frames.each_with_index do |frame, index|
      total += frame.frame_score
      total += frame.bonus_score(@frames[index + NEXT_FRAME_START..NEXT_FRAME_END])
    end
    total
  end

  private

  def process_shots(shots)
    @frames << (shots[0] == 'X' ? Frame.new(shots.shift) : Frame.new(*shots.shift(NORMAL_FRAME_SHOTS))) while shots.size > LAST_FRAME_MAX_SHOTS
    @frames << Frame.new(*shots.shift(LAST_FRAME_MAX_SHOTS))
  end
end
