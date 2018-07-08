#!/usr/bin/env ruby
require 'sequel'
require 'yaml/store'

ARGV.each do |arg|
	db_file = arg
	begin
		db = Sequel.connect("sqlite://#{db_file}")
	rescue Exception => e
		puts e
		raise "** Failed to connect database #{db_file}"
	end

	db.tables.each do |table|
		STDERR.puts "Restoring ... #{table}"

		# Load stored records
		yaml_file = "#{db_file}.yml"
		begin
			ps = YAML::Store.new(yaml_file)
		rescue Exception => e
			puts e
			raise "** Data file does not exist. Run ./db-save.rb before restoring."
		end
		stores = nil
		ps.transaction do
			stores = ps[table]
		end

		unless stores
			raise "** Stored data does not exist. Make sure yaml file path."
		end

		# Delete previous records
		ds = db[table]
		ds.delete

		# Insert stored records
		stores.each do |s|
			ds.insert(s.values)
		end
	end
end
