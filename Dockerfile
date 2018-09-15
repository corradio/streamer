FROM ubuntu:trusty

RUN apt-get update

# Install common
RUN apt-get install -y git-core wget

# Install nginx dependencies
RUN apt-get -y install build-essential libpcre3 libpcre3-dev libssl-dev

# Download nginx
RUN wget http://nginx.org/download/nginx-1.14.0.tar.gz
RUN tar -xf nginx-1.14.0.tar.gz

# Git clone rtmp module
RUN git clone https://github.com/sergey-dryabzhinsky/nginx-rtmp-module.git

# Compile nginx
WORKDIR nginx-1.14.0
RUN ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module && \
	make -j 1 && \
	sudo make install

ADD nginx.conf /usr/local/nginx/conf/nginx.conf

EXPOSE 8080
EXPOSE 1935
CMD /usr/local/nginx/sbin/nginx -g 'daemon off;'
