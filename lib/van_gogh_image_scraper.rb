require "nokogiri"
require "json"

class VanGoghImageScraper
  def initialize(html_file)
    @html_content = File.read(html_file)
    @doc = Nokogiri::HTML(@html_content)
  end

  def extract_paintings
    @doc.css("#_c2yRXMvVOs3N-QazgILgAg93 > div > div > div").map do |element|
      image = element.at_css("img").attr("src")
      image = nil if image.nil? || image.strip.empty?
      name = element.at_css(".kltat")&.text&.strip
      year = element.at_css(".ellip")&.text&.strip
      link_search_path = element.at_css("a")&.[]("href")

      puts image

      result = {
        name: name,
        image: image,
        link: "https://www.google.com#{link_search_path}",
      }
      result[:extensions] = [year] if year && !year.empty?

      result
    end
  end

  def save_to_json(output_file)
    paintings = extract_paintings
    File.open(output_file, "w") do |f|
      f.write(JSON.pretty_generate({ artworks: paintings }))
    end
  end
end
