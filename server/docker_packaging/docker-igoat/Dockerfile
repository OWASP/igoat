FROM ruby:2.3

RUN mkdir -p /usr/src/app

ENV RACK_ENV production

RUN git clone https://github.com/OWASP/igoat.git /tmp/

RUN mv /tmp/server/* /usr/src/app/

ADD startup.sh /

WORKDIR /usr/src/app

EXPOSE 8080

CMD ["/bin/bash", "/startup.sh"]
