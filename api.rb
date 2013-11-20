require 'sinatra'
require 'shotgun'
require 'json' 
require './importio.rb'


get '/' do
	"API ready to go"	
end

get '/fitting/:postcode' do 

	details = nil

	begin 
		client = ImportIO::new("01ab8bb6-e2a5-4d17-8fd2-ec9f289ca088","+2WYxx5fnhCB75vFF2R5o1HeAjms4lpz0lOZvjQxePh9R3SAMYX897j67NrPaT7hUia7eNwV0YEVjzRxVVRYrA==")
		client.proxy("10.10.2.100",3128)
		client.connect()

		callback = lambda do |query, message|
			if message["type"] == "MESSAGE"
		    	json = JSON.pretty_generate(message["data"])
		    	details = json
		 	end
		end
	end

	# Query for widget blackcirclesGarage
	client.query({"input"=>{"fittingdate"=>"21-11-2013", "postcode"=>"#{params[:postcode]}"},"connectorGuids"=>["4de1c2d0-ef03-432c-929e-772a5a99b8eb"]}, callback )
	client.join

	details
end

get '/car-details/:reg' do 
	
	details = nil

	begin
		client = ImportIO::new("01ab8bb6-e2a5-4d17-8fd2-ec9f289ca088","+2WYxx5fnhCB75vFF2R5o1HeAjms4lpz0lOZvjQxePh9R3SAMYX897j67NrPaT7hUia7eNwV0YEVjzRxVVRYrA==")
		client.proxy("10.10.2.100",3128)
		client.connect()

		callback = lambda do |query, message|
			if message["type"] == "MESSAGE"
				json = JSON.pretty_generate(message["data"])
				details = json
			end
		end
	end

	# Query for widget BlackCirclesMail
	client.query({"input"=>{"reg"=>"#{params[:reg]}"},"connectorGuids"=>["351c9a06-3651-4103-9c3f-820c146e7527"]}, callback )
	client.join

	details
end

get '/tyre-sizes/:reg' do

	tyresizes = nil

	begin
		client = ImportIO::new("67b7d192-7a45-4d27-9206-7aed30021346","cb6JqPScjrydwn5acMzp5LDSzj8uXcAVDg1K+mAe2Vf745cH4Mk5cs+Zxrhss4yhOm7mVJYQujH/cwzotTjiZQ==")	
		client.proxy("10.10.2.100",3128)
		client.connect()

		callback = lambda do |query, message|
			if message["type"] == "MESSAGE"
				json = JSON.pretty_generate(message["data"])
				tyresizes = json
			end
		end
	end

	# Query for widget blackcircle-tyresizes
	client.query({"input"=>{"ra03tpy"=>"RA03TBY"},"connectorGuids"=>["1f774562-0fc5-43df-a50a-0d44637063f6"]}, callback )
	client.join	

	tyresizes = tyresizes.sub('Select this option ', '')
	tyresizes
end













