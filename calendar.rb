#!/usr/bin/env ruby

require 'optparse'
require 'date'
# OptionParserを使用してオプションを設定＆解析
options = {}
opt = OptionParser.new

opt.on("-m MONTH",Integer) do |month|
  options[:month] = month
end

opt.on("-y YEAR",Integer) do |year|
  options[:year] = year
end

opt.parse!(ARGV)

month = options[:month] || Date.today.month
year = options[:year] || Date.today.year

# 最初の日と最後の日を求める
first_day = Date.new(year, month, 1)
last_day = Date.new(year, month, -1)

# カレンダーのフォーマットを表示
puts "#{first_day.strftime('%B %Y').rjust(15)}"
english_day = ["Su","Mo","Tu","We","Th","Fr","Sa"]
english_day.each do |name|
  print "#{name.rjust(2)}" 
  print " "
end

puts

# 第１週の始まりまで空白を挿入

print "   " * first_day.wday
# 日付を連続で表示、土曜日で改行
(first_day..last_day).each do |date|
  day_is_saturday =  date.saturday?
  print "#{date.day.to_s.rjust(2)}"
  print " "
  puts if day_is_saturday
end

puts

