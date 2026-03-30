-- fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

author 'Nibi'
description 'COAST.NET Behoerden-Terminal'
version '3.3.0'

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/app.html',
  'html/login.html',
  'html/livemap.html',
  'html/PDDoc.css',
  'html/tablet.css',
  'html/gtamap.png'
}

client_script 'client.lua'

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server.lua'
}
