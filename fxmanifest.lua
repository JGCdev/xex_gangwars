fx_version "cerulean"
game "gta5"
lua54 "yes"

description 'Mod to enable territory conquer between gangs'
author "XeX#2501"

version '1.0.1'

shared_scripts{
	'locales.lua',
	'config.lua',
}

server_scripts {
	'server/*.lua'
}

client_scripts {
	'client/*.lua'
}