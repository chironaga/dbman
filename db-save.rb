#!/usr/bin/env ruby
require 'sequel'
require 'yaml/store'

Encoding.default_internal = 'ascii-8bit'
Encoding.default_external = 'ascii-8bit'

ARGV.each do |arg|
	db_file = arg
	begin
		db = Sequel.connect("sqlite://#{db_file}")
	rescue Exception => e
		puts e
		raise "** Failed to connect database #{db_file}"
	end

	db.tables.each do |table|
		STDERR.puts "Saving ... #{table}"
		ds = db[table]
		ps = YAML::Store.new("#{db_file}.yml")
		ps.transaction do
			ps[table] = ds.all
		end
	end
end
