# api_paths

## Ruby Script

The Ruby script will use the [apis.guru](https://apis.guru/) API to grab a list of Swagger API URLs.
It will then call each API URL and extract the API paths, remove some stuff we don't want, then save the API paths to a file.
The API paths file is useful to discover hidden, or undocumented, API endpoints.

## API Paths Txt File

The `api_paths.txt` file contains the output of the Ruby script; a list of real-world API paths that can be used to discover hidden, or undocumented, API endpoints during penetration tests.
