#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

point = 0
frames.each_with_index do |frame, index|
  # ストライクやスペア時のボーナス計算など、特別ルールを適用
  # 9フレーム目まで
  if index < 9
    # ストライク
    if frame[0] == 10
      bonus = frames[index + 1].sum || 0
      if frames[index + 1][0] == 10
        # 次のフレームもストライクの場合
        bonus += frames[index + 2].first || 0
      end
      point += 10 + bonus
    # スペア
    elsif frame.sum == 10
      point += 10 + (frames[index + 1].first || 0)
    else
      point += frame.sum
    end
  # 10フレーム目以降
  else
    # 特別ルールなし、単純に3投の合計を計算
    point += frame.sum
  end
end
puts point
