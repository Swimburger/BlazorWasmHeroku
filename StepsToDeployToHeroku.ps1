# start onetime setup
mkdir BlazorWasmHeroku
cd BlazorWasmHeroku
dotnet new blazorwasm

heroku login
heroku plugins:install heroku-cli-static
$AppId = (heroku create --no-remote --json | ConvertFrom-Json).id
heroku buildpacks:set https://github.com/hone/heroku-buildpack-static -a $AppId
heroku static:init
# ? Enter the directory of your app:                  release/wwwroot
# ? Drop `.html` extensions from urls?                Yes
# ? Path to custom error page from root directory:    index.html

# update static.json to including SPA routing
$StaticConfig = Get-Content ./static.json | ConvertFrom-Json
$StaticConfig | Add-Member -NotePropertyName "routes" -NotePropertyValue @{"/**" = "index.html"}
Set-Content ./static.json -Value $($StaticConfig | ConvertTo-Json)

# end onetime setup

dotnet publish -c Release -o release
heroku static:deploy -a $AppId