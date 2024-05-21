require "spec_helper"
require_relative "../lib/google_art_work_scraper"

describe GoogleArtWorkScraper do
  ["a", "b"].each do |option|
    context "when option is #{option}" do
      before(:all) do
        @scraper = GoogleArtWorkScraper.new(option)
      end

      describe "#extract_paintings" do
        it "extracts paintings to a hash" do
          paintings = @scraper.extract_paintings
          expect(paintings).to all(be_a(Hash))
        end

        it "extracts image" do
          paintings = @scraper.extract_paintings
          paintings.each do |painting|
            expect(painting[:image]).to satisfy { |value| value.is_a?(String) || value.nil? }
          end
        end

        it "extracts extensions or doesn't exist" do
          paintings = @scraper.extract_paintings
          paintings.each do |painting|
            if painting[:extensions]
              expect(painting[:extensions]).to all(be_a(String))
            end
          end
        end

        it "extracts links" do
          paintings = @scraper.extract_paintings
          paintings.each do |painting|
            expect(painting[:link]).to be_a(String)
            expect(painting[:link]).to_not be_empty
          end
        end

        it "extracts name" do
          paintings = @scraper.extract_paintings
          paintings.each do |painting|
            expect(painting[:name]).to be_a(String)
            expect(painting[:name]).to_not be_empty
          end
        end

        it "extracts thumbnail" do
          paintings = @scraper.extract_paintings
          paintings.each do |painting|
            expect(painting[:thumbnail]).to satisfy { |value| value.is_a?(String) || value.nil? }
          end
        end
      end

      describe "#save_to_json" do
        it "saves the paintings to a JSON file" do
          output_file = "test_output_#{option}.json"
          @scraper.save_to_json(output_file)

          if File.exist?(output_file)
            saved_paintings = JSON.parse(File.read(output_file), symbolize_names: true)
            extracted_paintings = @scraper.extract_paintings

            expect(saved_paintings[:artworks]).to eq(extracted_paintings)
            File.delete(output_file) if File.exist?(output_file)
          else
            raise "File was not created: #{output_file}"
          end
        end
      end
    end
  end
end
