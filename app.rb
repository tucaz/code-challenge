require 'sinatra'
require 'sinatra/json'
require 'sinatra/cors'
require_relative 'lib/html_parser'

class App < Sinatra::Base
  helpers Sinatra::JSON

  # Enable CORS
  set :allow_origin, "*"
  set :allow_methods, "GET,HEAD,POST"
  set :allow_headers, "content-type,if-modified-since"
  set :bind, '0.0.0.0'
  set :port, 4567

  # Serve Swagger UI
  get '/api-docs' do
    content_type :json
    {
      openapi: '3.0.0',
      info: {
        title: 'Google Search API',
        version: '1.0.0',
        description: 'API for parsing artwork information from Google search results'
      },
      paths: {
        '/search': {
          get: {
            summary: 'Searches Google for Artwork',
            parameters: [
              {
                name: 'scenario',
                in: 'query',
                schema: { type: 'string', default: 'default' },
                description: 'Scenario to parse (valid values: default, van_gogh, leonardo_da_vinci)'
              }
            ],
            responses: {
              '200': {
                description: 'Success',
                content: {
                  'application/json': {
                    schema: {
                      type: 'object',
                      properties: {
                        artworks: {
                          type: 'array',
                          items: {
                            type: 'object',
                            properties: {
                              name: { type: 'string', description: 'Name of the artwork' },
                              extensions: { 
                                type: 'array', 
                                items: { type: 'string' }, 
                                description: 'Additional information like dates' 
                              },
                              link: { type: 'string', description: 'Link to Google search' },
                              image: { type: 'string', description: 'Image data for thumbnail' }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }.to_json
  end
  
  get '/search' do
    content_type :json
    scenario = params[:scenario] || 'default'
    filename = "#{scenario}.html"
    
    html = File.read(File.join(__dir__, 'spec/fixtures', filename))
    parser = HtmlParser.new(html)
    result = parser.parse
    
    json result
  end

  # Add a route to serve the Swagger UI
  get '/' do
    erb :swagger
  end

  run! if app_file == $0
end