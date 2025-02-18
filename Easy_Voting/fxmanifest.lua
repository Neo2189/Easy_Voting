fx_version 'cerulean'
game 'gta5'

author 'Einfach_Neo'
description 'Voting script'
version '1.0.0'
lua54 'yes'

ui_page 'html/index.html'

server_scripts {
    '@es_extended/locale.lua',
    '@mysql-async/lib/MySQL.lua',
    'locales/locales.lua',

    'server/server.lua',

}

client_scripts {
    '@ox_lib/init.lua', -- Initialize ox_lib

    '@es_extended/locale.lua',
    'locales/locales.lua',
    'client/client.lua'
}

shared_scripts {
    'config.lua',
}

files {
    'html/index.html',
    'html/style.css',
    'html/img/*.png',

}

