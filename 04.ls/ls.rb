# frozen_string_literal: true

files = Dir.glob('*').sort
COL_COUNT = 3
LIST_WIDTH = 20

def output_in_col_format(files, col_count)
  fill_to_multiple_with_nil(files, col_count)
  row_count = files.size / col_count
  output = files.each_slice(row_count).to_a.transpose
  output.each do |inner_array|
    inner_array.each do |element|
      print element.to_s.ljust(LIST_WIDTH)
    end
    print "\n"
  end
end

def fill_to_multiple_with_nil(files, col_count)
  surplus = files.size % col_count
  number_of_nils = surplus.zero? ? 0 : col_count - surplus
  number_of_nils.times { files << nil }
  files
end

output_in_col_format(files, COL_COUNT)
