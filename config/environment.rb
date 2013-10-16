require 'pry'
require 'awesome_print'
require 'erb'

ProjectRoot ||= "#{File.dirname(__FILE__)}/.."

# samy question as line 7
Dir.foreach("#{ProjectRoot}/lib/models") do |file|
  next if file.start_with?('.')
  require_relative "../lib/models/#{file}" if file.end_with?(".rb")
end