# frozen_string_literal: true

files = Dir.glob('*').sort
COL_COUNT = 3
LIST_WIDTH = 20

def sort_output(files, col_count)
  output = add_nils(files, col_count).each_slice(@row_count).to_a.transpose
  output.each do |inner_array|
    inner_array.each do |element|
      print element.to_s.ljust(LIST_WIDTH)
    end
    print "\n"
  end
end

def add_nils(files, col_count)
  surplus = files.size % col_count
  cal_surplus_nils(col_count, surplus)
  dup_files(files)
  @number_of_nils.times { @add_nils_arrays << nil }
  @row_count = @add_nils_arrays.size / col_count
  @add_nils_arrays
end

def cal_surplus_nils(col_count, surplus)
  @number_of_nils = surplus.zero? ? 0 : col_count - surplus
end

def dup_files(files)
  @add_nils_arrays = files.dup
end

sort_output(files, COL_COUNT)
