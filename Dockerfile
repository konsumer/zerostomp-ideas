FROM arm32v6/alpine

WORKDIR /zerostomp
VOLUME /zerostomp/patches

COPY app /zerostomp

RUN apk add build-base git jack-dev alsa-lib-dev
RUN cd /root && git clone --recursive https://github.com/libpd/libpd
RUN cd /root/libpd && make && make install
RUN cd /zerostomp/app && make

CMD /zerostomp/app/zerostomp