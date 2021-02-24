#!/bin/bash
# start onetime setup

# make sure to have 'jq' installed
#   sudo snap install jq

mkdir BlazorWasmHeroku
cd BlazorWasmHeroku
dotnet new blazorwasm

heroku login
heroku plugins:install heroku-cli-static
AppId=$(heroku create --no-remote --json | jq -r '.id')
heroku buildpacks:set https://github.com/hone/heroku-buildpack-static -a $AppId

heroku static:init
# update static.json to including SPA routing
echo $(cat static.json | jq '.routes={"/**": "index.html"}') > static.json

# end onetime setup

dotnet publish -c Release -o release
heroku static:deploy -a $AppId