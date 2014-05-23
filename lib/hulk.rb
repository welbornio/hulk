require "hulk/version"
require 'colorize'
require 'yaml'
require 'optparse'
require 'ostruct'

module Hulk
	class Runner

		def smash
			puts 'this is hulk. byah!'
		end

		def self.parse_yaml
			@builds = nil
			begin
				@builds = YAML::load( File.open( './hulk.yml' ) )
			rescue Exception
				puts "Hulk no like your hulk.yml".green
				puts "#{$!}, #{$@}".red
				exit
			end
			exit if !@builds
			@builds
		end


		def self.get_builds
			@builds = parse_yaml
			@builds
		end


		def self.list_builds
			@builds = parse_yaml
			puts "Hulk show you builds!".green if @builds.length > 0
			count = 1
			@builds.each do |key, value|
				puts " [#{count}] >> #{key}"
				count += 1
			end
		end


		def self.run_build build, commands
			puts "Hulk run build: #{build}".green
			commands.each do |command|
				if command =~ /^--/
					cmds = []
					cmds << command[2..-1]
					run_builds cmds
				else
					puts "Hulk run command: #{command}".green
					system( command )
					puts
				end
			end
		end


		def self.run_builds args
			@builds = parse_yaml
			args.each do |arg|
				run_build arg, @builds[arg] if @builds.has_key? arg
			end
		end


		def self.parse(args)
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
	    options
		end


		def self.hulk_smash
			options = self.parse(ARGV)
			list_builds if options.list == true
			run_builds ARGV if ARGV and ARGV.length > 0
			puts "Hulk no given arguments.".green if ARGV and ARGV.length == 0
		end

	end

end
