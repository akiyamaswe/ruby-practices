# frozen_string_literal: true

files = Dir.glob('*').sort
COL_COUNT = 3
LIST_WIDTH = 20

def output_in_col_format(files, col_count)
  arrays_added_nils = files.dup
  fill_to_multiple_with_nil(files, col_count, arrays_added_nils)
  row_count = arrays_added_nils.size / col_count
  output = arrays_added_nils.each_slice(row_count).to_a.transpose
  output.each do |inner_array|
    inner_array.each do |element|
      print element.to_s.ljust(LIST_WIDTH)
    end
    print "\n"
  end
end

def fill_to_multiple_with_nil(files, col_count, arrays_added_nils)
  surplus = files.size % col_count
  number_of_nils = surplus.zero? ? 0 : col_count - surplus
  number_of_nils.times { arrays_added_nils << nil }
  arrays_added_nils
end

output_in_col_format(files, COL_COUNT)
