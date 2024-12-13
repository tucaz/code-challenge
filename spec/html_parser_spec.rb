require 'spec_helper'
require_relative '../lib/html_parser'

RSpec.describe HtmlParser do
  describe '#determine_parser' do
    context 'when HTML contains g-scrolling-carousel tag (default.html)' do
      let(:html) { read_fixture('default.html') }
      
      it 'returns GoogleCarouselParser' do
        parser = HtmlParser.new(html)
        expect(parser.instance_variable_get(:@parser)).to be_a(GoogleCarouselParser)
      end
    end

    context 'when HTML contains tag indicating mosaic gallery (van_gogh.html)' do
      let(:html) { read_fixture('van_gogh.html') }
      
      it 'returns GoogleMosaicGalleryParser' do
        parser = HtmlParser.new(html)
        expect(parser.instance_variable_get(:@parser)).to be_a(GoogleMosaicGalleryParser)
      end
    end

    context 'when HTML contains tag indicating mosaic gallery (leonardo_da_vinci.html)' do
      let(:html) { read_fixture('leonardo_da_vinci.html') }
      
      it 'returns GoogleMosaicGalleryParser' do
        parser = HtmlParser.new(html)
        expect(parser.instance_variable_get(:@parser)).to be_a(GoogleMosaicGalleryParser)
      end
    end

    context 'when HTML matches no known pattern' do
      let(:html) { '<div>unknown content</div>' }
      
      it 'raises an error' do
        expect { HtmlParser.new(html) }.to raise_error(RuntimeError, "Unknown HTML structure")
      end
    end
  end
end 
