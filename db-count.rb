#!/usr/bin/env ruby
require 'sequel'

ARGV.each do |arg|
	db_file = arg
	begin
		db = Sequel.connect("sqlite://#{db_file}")
	rescue Exception => e
		puts e
		raise "** Failed to connect database #{db_file}"
	end

	db.tables.each do |tbl|
		ds = db[tbl]
		a = ds.all
		puts "%s: %d" % [tbl, a.count]
	end
end
