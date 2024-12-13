class BaseParser
  def initialize(html, base_url = "https://www.google.com")
    @document = Nokogiri::HTML(html)
    @base_url = base_url
  end

  def extract_artwork
    raise NotImplementedError, "#{self.class} must implement extract_artwork"
  end
end
