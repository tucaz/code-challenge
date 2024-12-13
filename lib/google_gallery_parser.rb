require 'nokogiri'
require 'json'

class GoogleGalleryParser < BaseParser
  def extract_artwork    
    # Gets the container of the artworks
    container = @document.css('#_c2yRXMvVOs3N-QazgILgAg93 > div:nth-child(1) > div:nth-child(1)')
    # Gets the array of elements containing each of the artworks
    items = container.css('.MiPcId.klitem-tr.mlo-c')
    
    # Iterates over every element of the array and extracts the data we want
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
    element.at_css('a:first-child')&.[]('aria-label')
  end

  def extract_image(element)
    # Images are stored in the scripts of the page
    # Each image has a unique ID that we can use to find it in the scripts
    
    # Get the img ID we're looking for in the current artwork
    img_id = element.at_css('img')&.attr('id')
    
    return nil unless img_id
    
    # Find all script tags and their content
    scripts = @document.css('script').map(&:text).join

    # Look for the specific JavaScript block that sets this image
    # Pattern: var ii = ['kximg0']; followed by _setImagesSrc(ii, s);
    # where s contains our base64 data
    image_match = scripts.match(/s\s*=\s*'(data:image\/[^']+)'[^']*var\s+ii\s*=\s*\['#{img_id}'\]/)
    
    if image_match
      # Extract the base64 data from the script
      base64_str = image_match[1].gsub(/\\x([0-9a-fA-F]{2})/) { 
        [$1].pack('H*') 
      }
      base64_str
    else
      nil
    end
  rescue => e
    puts "Error extracting image: #{e.message}"
    nil
  end

  def extract_link(element)
    link = element.at_css('a')&.attr('href')
    link&.start_with?('/') ? "#{@base_url}#{link}" : link
  end

  def extract_extensions(element)
    extensions = element.css('.ellip.klmeta')
    extensions.map(&:text).compact
  end
end 
