<?php

return
[
    'paths' => [
        'migrations' => '%%PHINX_CONFIG_DIR%%/app/Database/Migrations',
        'seeds' => '%%PHINX_CONFIG_DIR%%/app/Database/Seeds'
    ],
    'environments' => [
        'default_migration_table' => 'phinxlog',
        'default_database' => 'production',
        'production' => [
            'adapter' => 'mysql',
            'host' => getenv('MYSQL_HOST'),
            'name' => getenv('MYSQL_DATABASE'),
            'user' => getenv('MYSQL_USER'),
            'pass' => getenv('MYSQL_PASSWORD'),
            'port' => getenv('MYSQL_PORT') ?: 3306,
            'charset' => 'utf8',
        ]
    ],
    'version_order' => 'creation'
];