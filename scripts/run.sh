#!/bin/sh
set -e
php artisan october:up

exec /usr/bin/supervisord -n -c /etc/supervisord.conf
