require 'miro'
require 'byebug'
require 'net/http'
require 'json'
require 'sinatra'
require 'pry'
IMAGE_FILE = "/Users/lauriermantel/src/github.com/Shopify/palette_gen/homepage_1_.jpg".freeze
PALETTE_API_URL = "http://www.colourlovers.com/api/palettes"

def get_palette(colour)
  uri = URI(PALETTE_API_URL)
  params = { format: "json", hex: colour}
  uri.query = URI.encode_www_form(params)
  res = Net::HTTP.get_response(uri)
  values = JSON.parse(res.body).map do |palette|
    palette["colors"]
  end
  return values
end

get "/" do
  erb :index
end

post "/colour/" do
  colour = params["colour"]
  palettes = get_palette(colour)
  erb :index, locals: { palette_array: palettes, colour: colour }
end
