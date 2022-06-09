FROM happymonkey/php-nginx:8.0

# Start init scripts #
COPY docker/docker-php-entrypoint /usr/local/bin/
COPY docker/init.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-php-entrypoint
RUN chmod +x /usr/local/bin/init.sh
# End init scripts #

# Start project build
ENV PROJECT_DIR='/var/www/app'

# Run composer
RUN mkdir -p $PROJECT_DIR
COPY composer.json $PROJECT_DIR/composer.json
RUN cd $PROJECT_DIR && composer install --optimize-autoloader && rm -rf /root/.composer

# Copy files
COPY ./ $PROJECT_DIR
RUN chown -R www-data:www-data $PROJECT_DIR

WORKDIR $PROJECT_DIR
VOLUME $PROJECT_DIR

RUN chmod -R 0777 writable
