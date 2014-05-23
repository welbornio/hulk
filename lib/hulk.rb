require "hulk/version"
require 'colorize'
require 'yaml'
require 'optparse'
require 'ostruct'

module Hulk
	class Runner

		def parse_yaml
			builds = nil

			begin
				builds = YAML::load( File.open( './hulk.yml' ) )
			rescue Exception
				STDERR.puts "#{$!}".colorize(:red)
				exit 1
			end

			if not builds
				puts "Hulk no find builds in hulk.yml".colorize(:green)
				exit 1
			else
				builds
			end

		end

		def list_builds
			builds = parse_yaml
			puts "Hulk show you builds!".colorize(:green) if builds.length > 0
			count = 1
			builds.each do |key, value|
				puts " [#{count}] >> #{key}"
				count += 1
			end
		end


		def run_build build, commands
			puts "Hulk run build: #{build}".colorize(:green)
			commands.each do |command|
				if command =~ /^--/
					cmds = []
					cmds << command[2..-1]
					spawn_builds cmds
				else
					run_command command
				end
			end
		end


		def run_command command
				puts "Hulk run command: #{command}".colorize(:green)
				if command.include? '$$'
					puts "Enter var for: #{command}: "
					input = gets.chomp
					command .sub! '$$', input
				end
				system( command )
				puts
		end


		def spawn_builds args
			builds = parse_yaml
			args.each do |arg|
				if builds.has_key? arg
					run_build arg, builds[arg]
				else
					puts "Hulk no find build: #{arg}".colorize(:green)
				end
			end
		end


		def parse args
			options = OpenStruct.new

			options.list = false

			opt_parser = OptionParser.new do |opts|
				opts.banner = "Usage: hulk [options]"

				opts.on('-l', '--list', 'List Builds') do |l|
					options[:list] = l
				end

			end

			begin
				opt_parser.parse!(args)
			rescue OptionParser::InvalidOption => e
				STDERR.puts "Invalid Hulk option: #{e}".colorize(:red)
				exit 1
			end
	    options
		end


		def bootstrap
			if ARGV and ARGV.empty?
				puts "Hulk no given arguments.".colorize(:green)
				exit 1
			end

			options = parse ARGV
			if ARGV.empty?
				list_builds if options.list == true
			else
				spawn_builds ARGV
			end
		end

	end

end
