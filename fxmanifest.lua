fx_version 'cerulean'
game 'gta5'

description 'society for jobs'

version '1.5.0'

shared_script {
    'config.lua',
    '@qb-core/import.lua',
}

server_scripts {
    'server/*.lua',
}

client_scripts {
    'client/*.lua'
}
