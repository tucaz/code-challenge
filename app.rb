require 'sinatra'
require 'sinatra/cors'
require 'json'
require_relative 'lib/html_parser'

set :bind, '0.0.0.0'  # Allow external connections
set :port, 4567       # Default Sinatra port

# Enable CORS for all routes
set :allow_origin, "*"
set :allow_methods, "GET,HEAD,POST"
set :allow_headers, "content-type,if-modified-since"

# Create endpoint to parse HTML
get '/parse' do
  content_type :json
  
  html = File.read(File.join(__dir__, 'spec/fixtures/working.html'))
  parser = HtmlParser.new(html)
  result = parser.parse
  
  result.to_json
end 