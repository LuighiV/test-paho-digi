FROM ubuntu:trusty
MAINTAINER luighi

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y telnet \
	  curl \
	  openssh-client \
	  unzip \
	  make \
	  gcc


RUN curl https://ftp.openssl.org/source/old/1.0.2/openssl-1.0.2h.tar.gz -o /tmp/openssl1.0.2.tar.gz
RUN cd /tmp && tar zxvf openssl1.0.2.tar.gz
RUN cd /tmp/openssl-1.0.2h  \
      && ./config enable-shared \
      && make depend \
      && make \
      && make install
ENV LD_LIBRARY_PATH=/usr/local/ssl/lib/:$LD_LIBRARY_PATH

RUN curl https://www.python.org/ftp/python/2.6.1/Python-2.6.1.tgz -o /tmp/p261.tgz
RUN cd /tmp && tar zxvf p261.tgz
RUN cd /tmp/Python-2.6.1 && ./configure \
      && make \
      && make install 
