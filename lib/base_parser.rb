class BaseParser
  def initialize(html, base_url)
    @document = Nokogiri::HTML(html)
    @base_url = base_url
  end

  def extract_artwork
    raise NotImplementedError, "#{self.class} must implement extract_artwork"
  end

  protected

  def extract_title(element)
    raise NotImplementedError, "#{self.class} must implement extract_title"
  end

  def extract_extensions(element)
    raise NotImplementedError, "#{self.class} must implement extract_extensions"
  end

  def extract_link(element)
    raise NotImplementedError, "#{self.class} must implement extract_link"
  end

  def extract_image(element)
    raise NotImplementedError, "#{self.class} must implement extract_image"
  end
end
