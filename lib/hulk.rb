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
				exit
			end
			exit if !builds
			return builds
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
					run_builds cmds
				else
					puts "Hulk run command: #{command}".colorize(:green)
					system( command )
					puts
				end
			end
		end


		def run_builds args
			builds = parse_yaml
			args.each do |arg|
				run_build arg, builds[arg] if builds.has_key? arg
			end
		end


		def parse(args)
			options = OpenStruct.new

			options.list = false
			options.command = ''

			opt_parser = OptionParser.new do |opts|
				opts.banner = "Usage: hulk [options]"

				opts.on('-l', '--[no-]list', 'List Builds') do |l|
					options[:list] = l
				end

			end

			opt_parser.parse!(args)
	    return options
		end


		def bootstrap
			options = parse(ARGV)
			list_builds if options.list == true
			run_builds ARGV if ARGV and ARGV.length > 0
			puts "Hulk no given arguments.".colorize(:green) if ARGV and ARGV.length == 0
		end

	end

end
