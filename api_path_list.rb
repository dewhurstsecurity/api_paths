#!/usr/bin/env ruby

# This script will use the apis.guru API to grab a list of Swagger API URLs.
# It will then call each API URL and extract the API paths, remove some stuff we don't want, then save the API paths to a file.
# The API paths file is useful to discover hidden, or undocumented, API endpoints.

require 'typhoeus'
require 'yaml'
require 'json'

paths = []
swagger_yaml_urls = []
api_list_response = Typhoeus.get('https://api.apis.guru/v2/list.json').response_body # thank you https://apis.guru/

# Get list of API URLs

JSON.parse(api_list_response).each do |api|
  api[1]['versions'].each do |version|
    swagger_yaml_urls << version[1]['swaggerYamlUrl']
  end
end

# Get each API's YAML file and extract paths

swagger_yaml_urls.each do |swagger_yaml_url|
  puts "Calling: #{swagger_yaml_url}"

  yaml       = Typhoeus.get(swagger_yaml_url).response_body
  yaml_paths = YAML.load(yaml)['paths']
  
  if yaml_paths
    yaml_paths.each do |path|
      unless path[0].match(/\{/) or path[0].match(/Microsoft/)
  	    paths << path[0].gsub(/\..+/, '').gsub('#', '').gsub('/api', '').gsub(/\/api\/v\d/i, '').gsub(/\/v\d/i, '')
  	  end
    end
  end
end

# Output paths to file

out_file = File.new('api_paths.txt', 'w')
out_file.puts(paths.uniq.join("\n"))
out_file.close
