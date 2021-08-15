FROM ubuntu:16.04

ENV DEVOPS="Samunashvili Goga"

LABEL org.opencontainers.image.source="https://github.com/GogaSam/forexadel.git"

RUN apt-get -y update && apt-get install -y \
    apache2 

COPY script.sh /usr/local/bin/script.sh

RUN chmod a+x /usr/local/bin/script.sh

CMD ["script.sh"]

EXPOSE 80
