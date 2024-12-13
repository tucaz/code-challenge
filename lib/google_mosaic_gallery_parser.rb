require 'nokogiri'
require 'json'
require_relative 'base_parser'
class GoogleMosaicGalleryParser < BaseParser
  def extract_artwork
    # Find all divs that match our gallery structure
    items = @document.css('div:has(a)').select do |div|
      # Check if div has exactly one direct <a> child
      next false unless div.elements.count == 1 && div.elements.first.name == 'a'
      
      # puts "div class: #{div['class']}"

      # if div['class'] == 'iELo6'
      #   puts "div class: #{div['class']}"
      #   puts "div children: #{div.children.count}"
      #   puts "div children name: #{div.children.first.name}"
      #   div.children.each do |child|
      #     puts "\tChild tag: #{child.name}"
      #     puts "\tChild tag contents: #{child.to_html}"
      #   end
      # end
      
      anchor = div.elements.first
      
      # <a> must have exactly one <img> and one <div> so it counts as 
      next false unless anchor.elements.count == 2
      next false unless anchor.elements[0].name == 'img'
      next false unless anchor.elements[1].name == 'div'
      
      true
    end

    # puts "Found #{items.count} gallery items"
    # items.take(10).each do |div|
    #   puts "div: #{div.to_html}"
    # end

    items.map do |div|
      {
        name: extract_title(div),
        extensions: extract_extensions(div),
        link: extract_link(div),
        image: extract_image(div)
      }
    end
  end

  private

  def extract_title(element)
    element.at_css('a > img')&.attr('alt')
  end
  
  def extract_extensions(element)
    extensions = element.at_css('a > div > div:last-child')
    [extensions&.text&.strip].compact
  end

  def extract_link(element)
    link = element.at_css('a')&.attr('href')
    link&.start_with?('/') ? "#{@base_url}#{link}" : link
  end

  def extract_image(element)
    src = element.at_css('a > img')&.attr('src')
    src
  end
end 
