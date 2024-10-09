# frozen_string_literal: true

require 'optparse'

COL_COUNT = 3
LIST_WIDTH = 20

def parse_options
  options = { all_files: false }
  opt = OptionParser.new
  opt.on('-a') { options[:all_files] = true }
  opt.parse!(ARGV)
  options
end

def get_files(options)
  options[:all_files] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
end

def output_in_col_format(files, col_count)
  arrays_added_nils = files.dup
  fill_to_multiple_with_nil!(files, col_count, arrays_added_nils)
  row_count = arrays_added_nils.size / col_count
  output = arrays_added_nils.each_slice(row_count).to_a.transpose
  output.each do |inner_array|
    inner_array.each do |element|
      print element.to_s.ljust(LIST_WIDTH)
    end
    print "\n"
  end
end

def fill_to_multiple_with_nil!(files, col_count, arrays_added_nils)
  surplus = files.size % col_count
  number_of_nils = surplus.zero? ? 0 : col_count - surplus
  number_of_nils.times { arrays_added_nils << nil }
end

files = get_files(parse_options)
output_in_col_format(files, COL_COUNT)
