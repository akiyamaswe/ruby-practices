# frozen_string_literal: true

require_relative 'shot'
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
      total += frame.base_frame_score
      total += frame.bonus_score(@frames[index + NEXT_FRAME_START..NEXT_FRAME_END])
    end
    total
  end

  private

  def process_shots(shots)
    while shots.size > LAST_FRAME_MAX_SHOTS
      first_shot = Shot.new(shots.first)
      @frames << (first_shot.strike_mark? ? Frame.new(shots.shift) : Frame.new(*shots.shift(NORMAL_FRAME_SHOTS)))
    end
    @frames << Frame.new(*shots.shift(LAST_FRAME_MAX_SHOTS))
  end
end
