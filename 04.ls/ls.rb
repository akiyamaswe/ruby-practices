# frozen_string_literal: true

require 'optparse'
require 'etc'

COL_COUNT = 3
LIST_WIDTH = 20
PERMISSIONS = {
  7 => 'rwx',
  6 => 'rw-',
  5 => 'r-x',
  4 => 'r--',
  3 => '-wx',
  2 => '-w-',
  1 => '--x',
  0 => '---'
}.freeze

def parse_options
  options = { all_files: false, reverse_files: false, detailed_long_format: false }
  opt = OptionParser.new
  opt.on('-a') { options[:all_files] = true }
  opt.on('-r') { options[:reverse_files] = true }
  opt.on('-l') { options[:detailed_long_format] = true }
  opt.parse!(ARGV)
  options
end

def get_files(options)
  list_hidden_files = options[:all_files] ? File::FNM_DOTMATCH : 0
  file_deta = Dir.glob('*', list_hidden_files)
  file_deta.reverse! if options[:reverse_files]
  file_deta
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

def get_file_details(file)
  stat = File.stat(file)
  ftype = get_file_type(stat)
  permissions = get_file_permissions(stat)
  nlink = stat.nlink
  owner = get_file_owner(stat)
  group = get_file_group(stat)
  size = get_file_size(stat)
  mtime = get_file_mtime(stat)
  "#{ftype}#{permissions} #{nlink} #{owner} #{group} #{size} #{mtime} #{file}"
end

def get_file_type(stat)
  case stat.ftype
  when 'directory' then 'd'
  when 'file' then '-'
  else '?'
  end
end

def get_file_permissions(stat)
  format('%o', stat.mode)[-3, 3].chars.map { |ch| PERMISSIONS[ch.to_i] }.join
end

def get_file_owner(stat)
  Etc.getpwuid(stat.uid).name
end

def get_file_group(stat)
  Etc.getgrgid(stat.gid).name.to_s.rjust(6, ' ')
end

def get_file_size(stat)
  stat.size.to_s.rjust(4, ' ')
end

def get_file_mtime(stat)
  stat.mtime.strftime('%b %e %H:%M')
end

def output_in_long_format(files)
  files.each { |file| puts get_file_details(file) }
end

options = parse_options
files = get_files(options)
options[:detailed_long_format] ? output_in_long_format(files) : output_in_col_format(files, COL_COUNT)

