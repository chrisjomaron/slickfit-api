require 'sinatra'
require 'shotgun'
require 'json' 
require './importio.rb'
require 'httpclient'
require "active_support/core_ext"
require 'date'

before do
	@http = ENV['environment'] == 'prod' ? HTTPClient.new : HTTPClient.new("http://10.10.2.100:3128")
end

get '/' do
	"API ready to go"	
end

get '/servicing/:reg/:postcode' do
	content_type :json

	servicing = nil
	servicing = servicing params[:reg], params[:postcode]

	JSON.pretty_generate({"results" => servicing["results"]})
end	

get '/car-details/:reg' do
	content_type :json

	car_details params[:reg]
end

get '/fitting-stations/:postcode' do 
	content_type :json

	fittings = nil
	fittings = fitting params[:postcode]

	fittings["results"].each do |item| 
		matches = item["detail"].match(/center=(.*),(.*)&amp;markers/)
		item["detail"] = {"lat" => matches[1], "long" => matches[2]}
	end

	JSON.pretty_generate({"results" => fittings["results"]})
end

get '/tyre-prices/:reg' do 
	content_type :json
	
	details = nil
	details = tyre_prices params[:reg]
	
	JSON.pretty_generate({"results" => details["results"]})
end

get '/tyre-sizes/:reg' do

	tyresizes = nil
	tyresizes = tyre_sizes params[:reg]
	
	JSON.pretty_generate({"results" => tyresizes["results"]})
end


get '/break-down-cover/:reg' do
	content_type :json			

	break_down_cover = nil
	break_down_cover = break_down_cover params[:reg]
	
	JSON.pretty_generate({"results" => break_down_cover["results"], "total_results" => break_down_cover["totalResults"]})
end

get '/mot/:postcode/?:distance?/?:num_of_results?' do
	content_type :json

	options = {}

	options[:distance] = params[:distance] unless params[:distance].nil?
	options[:num_results] = params[:num_of_results] unless params[:num_of_results].nil?

	mot_centers = mot params[:postcode], options

	JSON.pretty_generate("results" => mot_centers)

end

def servicing reg, postcode

	servicing = nil

	begin
    client = ImportIO::new("b4de693f-cc75-4296-af8e-eed8e79b76a2","Mh61jddfx39dBe+uNZ2KuX3w/By2VTx8knMzT8XMa0PSwERZLGWxdMFS8gYIuaeg2vA8Gb0j+1Bzr2Xmvba8EQ==")
    	set_proxy client
		client.connect()
 
		callback = lambda do |query, message|
  			if message["type"] == "MESSAGE"
    			servicing = (message["data"])
  			end
		end
	end

    client.query({"input"=>{"registration"=>"#{reg}", "postcode"=>"#{postcode}"},"connectorGuids"=>["8837b716-ed57-4a21-b16e-f7c8b03654c6"]}, callback )
	client.join
	servicing
end

def fitting postcode
	fittings = nil

	begin 
		client = ImportIO::new("01ab8bb6-e2a5-4d17-8fd2-ec9f289ca088","+2WYxx5fnhCB75vFF2R5o1HeAjms4lpz0lOZvjQxePh9R3SAMYX897j67NrPaT7hUia7eNwV0YEVjzRxVVRYrA==")
		set_proxy client
		client.connect()

		callback = lambda do |query, message|
			if message["type"] == "MESSAGE"
		    	fittings = message["data"]
		 	end
		end
	end

	# Query for widget blackcirclesGarage
	client.query({"input"=>{"fittingdate"=> date_of_next("Wednesday").strftime("%d-%m-%Y"), "postcode"=>"#{params[:postcode]}"},"connectorGuids"=>["4de1c2d0-ef03-432c-929e-772a5a99b8eb"]}, callback )
	client.join

	fittings
end

def car_details reg
	response = @http.get "https://cdl-elvis.cdlis.co.uk/cdl-elvis/elvis?vehicle_type=PC&userid=MONEYSV2&test_flag=Y&client_type=external&search_type=vrm&function_name=xml_MONEYSV2_fnc&search_string=#{reg}"

	Hash.from_xml(response.body.downcase!).to_json
end

def tyre_prices reg
	details = nil

	begin
		client = ImportIO::new("01ab8bb6-e2a5-4d17-8fd2-ec9f289ca088","+2WYxx5fnhCB75vFF2R5o1HeAjms4lpz0lOZvjQxePh9R3SAMYX897j67NrPaT7hUia7eNwV0YEVjzRxVVRYrA==")
		set_proxy client
		client.connect()

		callback = lambda do |query, message|
			if message["type"] == "MESSAGE"
				details = message["data"]
			end
		end
	end

	# Query for widget BlackCirclesMail
	client.query({"input"=>{"reg"=>"#{reg}"},"connectorGuids"=>["351c9a06-3651-4103-9c3f-820c146e7527"]}, callback)
	client.join

	details
end

def tyre_sizes reg
	tyresizes = nil

	begin
		client = ImportIO::new("67b7d192-7a45-4d27-9206-7aed30021346","cb6JqPScjrydwn5acMzp5LDSzj8uXcAVDg1K+mAe2Vf745cH4Mk5cs+Zxrhss4yhOm7mVJYQujH/cwzotTjiZQ==")	
		set_proxy client
		client.connect()

		callback = lambda do |query, message|
			if message["type"] == "MESSAGE"
				tyresizes = message["data"]
			end
		end
	end

	# Query for widget blackcircle-tyresizes
	client.query({"input"=>{"ra03tpy"=>"#{reg}"},"connectorGuids"=>["1f774562-0fc5-43df-a50a-0d44637063f6"]}, callback )
	client.join	

	tyresizes
end

def break_down_cover reg
	break_down_cover = nil

	begin
		client = ImportIO::new("b4de693f-cc75-4296-af8e-eed8e79b76a2","Mh61jddfx39dBe+uNZ2KuX3w/By2VTx8knMzT8XMa0PSwERZLGWxdMFS8gYIuaeg2vA8Gb0j+1Bzr2Xmvba8EQ==")
		set_proxy client
		client.connect()

		callback = lambda do |query, message|
		  if message["type"] == "MESSAGE"
		    break_down_cover = message["data"]
		  end
		end
	end

	# Query for widget msm_breakdown_cover
	client.query({"input"=>{"regno"=>"#{reg}"},"connectorGuids"=>["da1cce47-8638-4797-8837-6c375dc68043"]}, callback )
	client.join
	
	break_down_cover
end

def mot(postcode, options = {})
	distance = options[:distance] || "8046"
	num_of_results = options[:num_results]|| "5"

	api_key = "d30691fe-0a33-4114-a10c-3e9131e5713e"
	api_url = "http://services.toadpin.com/api/mot/forClassByPostcodeWithin?postcode=#{postcode}&distance=#{distance}&apiKey=#{api_key}&motclass=4"
	response = @http.get(api_url)

	returned_json = JSON.parse(response.body.downcase).slice(0, num_of_results.to_i)

	#404

end

def set_proxy client
	client.proxy("10.10.2.100",3128) unless ENV['environment'] == 'prod'
end

def date_of_next day
	date = Date.parse(day)

	delta = date > Date.today ? 0 : 7

	date + delta
end

