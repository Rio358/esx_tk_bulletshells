fx_version 'cerulean'

game 'gta5'

description 'ESX Bullet Shells'

author 'TuKeh_'

version '1.0.1'

shared_script '@es_extended/imports.lua'

client_scripts {
    '@es_extended/locale.lua',
    'config.lua',
    'client/main.lua',
    'locales/en.lua',
    'locales/fi.lua',
} 

server_scripts {
	'@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server/main.lua',
}