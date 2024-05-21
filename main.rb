# main.rb
require_relative "lib/google_art_work_scraper"
require "fileutils"

def run_scraper(option)
  scraper = GoogleArtWorkScraper.new(option)
  scraper.save_to_json("results.json")
  puts "Paintings extracted successfully!"
end

def run_tests
  system("bundle exec rspec")
end

if ARGV[0] == "scrape"
  option = ARGV[1] || "a"  # Default to "a" if no option is provided
  run_scraper(option)
elsif ARGV[0] == "test"
  run_tests
else
  puts "Usage: ruby main.rb [scrape|test] [option]"
  puts "Example: ruby main.rb scrape a results.json"
end
