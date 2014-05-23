require "hulk/version"
require 'colorize'
require 'yaml'
require 'optparse'
require 'ostruct'
require 'shellwords'

module Hulk
	class Runner

		def initialize
			@complete_command_list = Array.new
		end

		def parse_yaml
			builds = nil

			begin
				builds = YAML::load( File.open( './hulk.yml' ) )
			rescue Exception
				$stderr.puts "#{$!}".colorize(:red)
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


		def collect_build_commands build, commands
			puts "Hulk run build: #{build.colorize(:green)}"
			commands.each do |command|
				if command =~ /^--/
					cmds = []
					cmds << command[2..-1]
					collect_builds cmds
				else
					prep_command command
				end
			end
		end


		def prep_command command
				if command.include? '$$'
					input = [(print "Enter var for: #{command.colorize(:light_blue)}: "), $stdin.gets.rstrip][1] # Prompt and input on same line
					$stdin.flush
					command .sub! '$$', input
				end
				@complete_command_list << command
		end


		def collect_builds args
			builds = parse_yaml
			args.each do |arg|
				if builds.has_key? arg
					collect_build_commands arg, builds[arg]
				else
					puts "Hulk no find build: #{arg}".colorize(:green)
				end
			end
		end


		def run_builds
			@complete_command_list.each do |command|
				begin
					puts "Hulk run command: #{command.colorize(:green)}"
					system command
					puts
				rescue
					$stderr.puts "There was an error when attempting to run: #{command}".colorize(:red)
					exit
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
				$stderr.puts "Invalid Hulk option: #{e}".colorize(:red)
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
				collect_builds ARGV
				run_builds
			end
		end

	end

end
