# frozen_string_literal: true

class Shot
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end

  def score
    return 10 if strike_mark?

    mark.to_i
  end

  def strike_mark?
    @mark == 'X'
  end
end
