FROM ubuntu:latest
RUN apt-get update && apt-get install -y \
    apache2 \
    && rm -rf /var/lib/apt/lists/*

COPY index.html /var/www/html/

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
