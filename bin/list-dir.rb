#!/usr/bin/env ruby

require 'bundler/setup'

require 'bindata'
require 'date'

class FileHeader < BinData::Record
  endian :little

  string :filename, :length => 52
  string            :length => 28
  string :owner,    :length => 72
  string            :length => 8
  string :title,    :length => 67
  string            :length => 21
end

def list_header(dir_filename)
  file = File.open(dir_filename, 'r')
  until file.eof?
    header_entry  = FileHeader.read(file)
    filename = header_entry.filename
    title = header_entry.title.encode('UTF-8', 'Big5')
    date = Time.at(header_entry.filename.split('.')[1].to_i).to_date
    sender = header_entry.owner
    puts "#{filename} : #{date} #{sender} #{title}"
  end
  file.close
end

if ARGV.length != 1
  puts "Usage #{$0} <.DIR>"
else
  list_header(ARGV[0])
end
