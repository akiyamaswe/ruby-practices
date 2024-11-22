# frozen_string_literal: true

class Shot
  def initialize(mark)
    @mark = mark
  end

  def score
    return 10 if strike_mark?

    @mark.to_i
  end

  def strike_mark?
    @mark == 'X'
  end
end
