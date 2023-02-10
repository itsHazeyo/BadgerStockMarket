fx_version 'bodacious'
games { 'gta5' }

description 'ESX Badger Stocks'

server_script '@mysql-async/lib/MySQL.lua'

client_script 'client.lua'
server_script "server.lua"
client_script "config.lua"
server_script "config.lua"

ui_page "NUI/panel.html"

files {
	"NUI/panel.js",
	"NUI/panel.html",
	"NUI/panel.css",
	"NUI/iphone.png",
	"NUI/robinhood-logo.png",
}
