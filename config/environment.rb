require 'pry'
require 'awesome_print'
require 'erb'
require 'sqlite3'
require 'nokogiri'
require 'open-uri'

ProjectRoot ||= "#{File.dirname(__FILE__)}/.."

Dir.foreach("#{ProjectRoot}/lib/concerns") do |file|
  next if file.start_with?('.')
  require_relative "../lib/concerns/#{file}" if file.end_with?(".rb")
end

# samy question as line 7
Dir.foreach("#{ProjectRoot}/lib/models") do |file|
  next if file.start_with?('.')
  require_relative "../lib/models/#{file}" if file.end_with?(".rb")
end
