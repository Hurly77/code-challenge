require "nokogiri"
require "json"
require "pry"

OPTIONS = {
  "a": { # For Van Gogh
    file: "files/van-gogh-paintings.html",
    selectors: {
      carousel: "#_c2yRXMvVOs3N-QazgILgAg93 > div > div > div",
      image: "img",
      name: ".kltat",
      year: ".ellip",
    },
  },
  "b": {
    file: "files/leonardo_da_vinci_paintings.html",
    selectors: { # For Da Vinci
      carousel: ".Cz5hV > div",
      name: ".KHK6lb",
      year: ".cxzHyb",
    },
  },
}

class GoogleArtWorkScraper
  def initialize(option = "a")
    @options = OPTIONS[option.to_sym]
    @html_content = File.read(@options[:file])
    @doc = Nokogiri::HTML(@html_content)
    @images = get_image_hash(@html_content)
    @selectors = @options[:selectors]
  end

  def extract_paintings
    @doc.css(@selectors[:carousel]).map do |element|
      image_element = element.at_css("img")
      image = image_element ? @images[image_element.attr("id")] : nil
      name = element.at_css(@selectors[:name])&.text&.strip
      year = element.at_css(@selectors[:year])&.text&.strip
      link_search_path = element.at_css("a")&.[]("href")

      # binding.pry

      result = {
        name: name,
        link: link_search_path ? "https://www.google.com#{link_search_path}" : nil,
        image: image,
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

  def get_image_hash(html_content)
    images = {}
    html_content.scan(/s='(data:image\/jpeg;base64,[a-zA-Z0-9\/+=\\x]+)'.*?ii=\['(.*?)'\]/) do |base64, id|
      # Replace escaped sequences
      base64.gsub!(/\\x([0-9A-Fa-f]{2})/) { |match| [$1].pack("H*") }
      images[id] = base64
    end
    images
  end
end
