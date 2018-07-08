#!/usr/bin/env ruby
require 'sequel'
require 'pstore'

DB_FILE_OLD = ARGV[0]
DB_FILE_NEW = ARGV[1]
begin
	old = Sequel.connect("sqlite://#{DB_FILE_OLD}")
	new = Sequel.connect("sqlite://#{DB_FILE_NEW}")
rescue Exception => e
	puts e
	raise "** Failed to connect database #{DB_FILE}"
end

STDERR.puts("Comparing ... older: %s newer: %s" % [DB_FILE_OLD, DB_FILE_NEW])
new.tables.each do |tbl|
	puts ''
	newer = new[tbl].all
	older = old[tbl].all
  if newer != older
    puts "@ #{tbl}: Both tables differ"
    if newer.size > older.size
      max = newer; min = older
    else
      max = older; min = newer
    end
    max.zip(min).each do |a, b|
      next if a == b
      if b
        puts "## Old record"
        (a.keys & b.keys).each do |k|
          if a[k] == b[k]
            puts " %s: {%s}" % [k, a[k]]
          else
            puts "*%s: {%s} != {%s}" % [k, a[k], b[k]]
          end
        end
      else
        puts "## New record"
        a.each do |k, v|
          puts "*%s: %s" % [k, v]
        end
      end
    end
  else
    puts "@ #{tbl}: Both tables are identical"
  end
end

