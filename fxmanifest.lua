fx_version 'cerulean'
game 'gta5'

author 'HydroScripts'
version '1.0.0'

lua54 'yes'
use_experimental_fxv2_oal 'yes'

shared_scripts {
	'@ox_lib/init.lua'
}

server_scripts {
	'server/*.lua'
}

client_scripts {
	'client/*.lua'
}

files {
	'config.lua'
}

dependencies {
	'ox_lib',
	'ox_inventory'
}