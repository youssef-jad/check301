#!/usr/bin/env ruby
require "curl"
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'colorize'

def checkLinks(links_file)
  file = File::open(links_file, 'r');
  if File.zero?(links_file)
    puts "Cannot Use Empty File For Checks Kindly Provide Some Links ".red
    exit
  end
      file.each_line do |line|
        begin
        encoded_url = URI.encode(line)
        agent = Mechanize.new
        agent.redirect_ok = false
        page = agent.get(URI.parse(encoded_url))
        puts "------------------------Start------------------------------"
        puts  page.code.red + ' ' + URI.decode(page.uri.to_s).magenta
        agent.redirect_ok = true
        page = agent.get(URI.parse(encoded_url))
          puts  page.code.red + ' ' + URI.decode(page.uri.to_s).magenta
        puts "-------------------------End-----------------------------"
        rescue SystemExit, Interrupt
            puts ' Pressed Script Termeinate .. '
            exit
        
        rescue Exception => e
          puts "*****************************************************"
          puts URI.decode(e.to_s).colorize(:color => :white, :background => :light_black)
          puts "*****************************************************"

        end
      end
end

checkLinks("urls.txt")
