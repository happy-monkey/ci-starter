FROM happymonkey/php-fpm:7.4

COPY --from=composer /usr/bin/composer /usr/bin/composer

# Start init scripts #
COPY docker/env_secrets_expand /usr/local/bin/
COPY docker/docker-php-entrypoint /usr/local/bin/

RUN chmod +x /usr/local/bin/env_secrets_expand
RUN chmod +x /usr/local/bin/docker-php-entrypoint
# End init scripts #

ENV PROJECT_DIR='/usr/src/app'

RUN mkdir -p $PROJECT_DIR
COPY ./ $PROJECT_DIR
RUN chown -R www-data:www-data $PROJECT_DIR

WORKDIR $PROJECT_DIR
VOLUME $PROJECT_DIR

RUN composer install --optimize-autoloader
RUN chmod -R 0777 writable
