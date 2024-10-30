# frozen_string_literal: true

require 'optparse'
require 'etc'

COL_COUNT = 3
LIST_WIDTH = 20
LINUX_BYTES_PER_BLOCK = 512
DISPLAY_BYTES_PER_BLOCK = 1024
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

def fetch_files(options)
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

def output_in_long_format(files)
  puts calculate_total_blocks(files)
  files.each { |file| puts file_details(file) }
end

def calculate_total_blocks(files)
  total_blocks = files.reduce(0) { |sum, file| sum + File::Stat.new(file).blocks }
  total_fixed_blocks = (total_blocks * LINUX_BYTES_PER_BLOCK) / DISPLAY_BYTES_PER_BLOCK
  "total #{total_fixed_blocks}"
end

def file_details(file)
  stat = File.stat(file)
  ftype = file_type(stat)
  permissions = file_permissions(stat)
  nlink = stat.nlink
  owner = file_owner(stat)
  group = file_group(stat)
  size = file_size(stat)
  mtime = file_mtime(stat)
  "#{ftype}#{permissions} #{nlink} #{owner} #{group} #{size} #{mtime} #{file}"
end

def file_type(stat)
  case stat.ftype
  when 'directory' then 'd'
  when 'file' then '-'
  else '?'
  end
end

def file_permissions(stat)
  format('%o', stat.mode)[-3, 3].chars.map { |ch| PERMISSIONS[ch.to_i] }.join
end

def file_owner(stat)
  Etc.getpwuid(stat.uid).name
end

def file_group(stat)
  Etc.getgrgid(stat.gid).name.to_s.rjust(6, ' ')
end

def file_size(stat)
  stat.size.to_s.rjust(4, ' ')
end

def file_mtime(stat)
  stat.mtime.strftime('%b %e %H:%M')
end

options = parse_options
files = fetch_files(options)
options[:detailed_long_format] ? output_in_long_format(files) : output_in_col_format(files, COL_COUNT)
