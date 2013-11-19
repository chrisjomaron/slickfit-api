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












