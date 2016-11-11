#!/usr/bin/env ruby
require "curl"
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'colorize'
require "csv"
require 'pathname'

def checkLogFIle()
  checkFile = File.exist?('log.csv')
  if checkFile == false
    File.new("log.csv", "w")
  end
end

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

        puts "------------------------Start------------------------------ \n"
        puts  page.code.red + ' ' + URI.decode(page.uri.to_s).magenta

        @oldURI = URI.decode(page.uri.to_s)
        @oldCode = page.code

        agent.redirect_ok = true
        page = agent.get(URI.parse(encoded_url))


        puts  page.code.red + ' ' + URI.decode(page.uri.to_s).magenta
        puts "-------------------------End----------------------------- \n"


        @newURI = URI.decode(page.uri.to_s)
        @newCode = page.code
        CSV.open("log.csv", "a+") do |csv|
          csv << ["#{@oldURI}", "#{@newURI}", "#{@oldCode}" , "#{@newCode}"]
        end
        rescue SystemExit, Interrupt
            puts ' Pressed Script Termeinate .. '
            exit
        
        rescue Exception => e
          puts "***************************************************** \n"
          puts URI.decode(e.to_s).colorize(:color => :white, :background => :light_black)
          puts "***************************************************** \n"

          CSV.open("log.csv", "a+") do |csv|
            csv << ["#{@oldURI}", "#{URI.decode(e.to_s)}", "301" , "404"]
          end

        end
      end
end


checkLogFIle
checkLinks("urls.txt")
