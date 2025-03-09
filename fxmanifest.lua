fx_version 'cerulean'
game 'gta5'

lua54 'yes'
use_experimental_fxv2_oal 'yes'

name 'hydro_weaponrepair'
author 'HydroScripts'
version '1.0.0'
decription 'A weapon reapir bench for ox_inventory utilizing ox_lib and ox_target'

shared_scripts {
	'@ox_lib/init.lua'
}

server_scripts {
	'bridge/server.lua',
	'server/*.lua'
}

client_scripts {
	'bridge/client.lua',
	'client/*.lua'
}

files {
	'config.lua'
}

dependencies {
	'ox_lib',
	'ox_target'
}