require 'sinatra'
require 'shotgun'

get '/' do 
	"API ready to go"	
end

get '/car-details' do 
	"{make : \"audi\", model : \"A3\"}"
end
