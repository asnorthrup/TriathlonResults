#class that acts as primary client interface to the API

class TriResultsWS
	include HTTParty
	debug_output $stdout
	base_uri "http://localhost:3000"
end