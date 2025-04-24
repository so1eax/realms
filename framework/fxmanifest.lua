fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

client_script {
    'client/cl_main.lua'
}

server_script {
    'server/sv_main.lua',
    'server/sv_exports.lua',
    '@oxmysql/lib/MySQL.lua',
}
server_exports {
    'GetPlayerData'
}

shared_script {
    'config.lua',
    '@ox_lib/init.lua'
}

dependencies {
	'oxmysql',
    'ox_lib'
}