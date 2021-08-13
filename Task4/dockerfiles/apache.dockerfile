FROM ubuntu:16.04

ENV DEVOPS="Samunashvili Goga"

LABEL org.opencontainers.image.source="https://github.com/GogaSam/forexadel.git"

RUN apt-get -y update && apt-get install -y \
    apache2 \
    && echo "<html><h2>Goga Samunashvili Sandbox 2021!<br>$DEVOPS</h2><html>" > /var/www/html/index.html

CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
