# main.rb
require_relative "lib/van_gogh_image_scraper"
require "fileutils"

def run_scraper
  scraper = VanGoghImageScraper.new("files/van-gogh-paintings.html")
  scraper.save_to_json("results.json")
  puts "Paintings extracted successfully!"
end

def run_tests
  system("bundle exec rspec")
end

case ARGV[0]
when "scrape"
  run_scraper
when "test"
  run_tests
else
  puts "Usage: ruby main.rb [scrape|test]"
end
