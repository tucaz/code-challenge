require 'nokogiri'
require 'json'
require_relative 'base_parser'
require_relative 'google_carousel_parser'
require_relative 'google_mosaic_gallery_parser'

class HtmlParser
  BASE_URL = "https://www.google.com"
  
  def initialize(html, base_url = BASE_URL)
    @html = html
    @base_url = base_url
    @parser = determine_parser
  end

  def parse
    {
      artworks: @parser.extract_artwork
    }
  end

  private

  def determine_parser
    if @html.include?('g-scrolling-carousel')
      GoogleCarouselParser.new(@html, @base_url)
    elsif @html.include?('kc:/visual_art/visual_artist:works')
      GoogleMosaicGalleryParser.new(@html, @base_url)
    else
      raise "Unknown HTML structure"
    end
  end
end