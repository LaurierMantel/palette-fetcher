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

def to_rgb(hex)
  hex.scan(/../).map{ |val| val.to_i(16) }
end

def to_hex(rgb)
  rgb.map{ |val| val.to_s(16) }.join
end

get "/" do
  erb :index
end

post "/colour/" do
  colour = params["colour"]
  palettes = get_palette(colour)
  erb :index, locals: { palette_array: palettes, colour: colour }
end


# dc_hex = Miro::DominantColors.new(IMAGE_FILE).to_hex
# dc_rgb = Miro::DominantColors.new(IMAGE_FILE).to_rgb
# yilun = [[33.90179555555555, 28.288097777777786, 28.00142222222222], [41.89066666666667, 35.05601111111112, 34.819311111111105]].first
# yilun_int = yilun.map{ |val| Integer(val) }
# palettes =  get_palette(to_hex(yilun_int))
# debugger
# puts palettes