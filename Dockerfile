FROM debian:bookworm

RUN apt update
RUN apt install -yy build-essential debhelper pkg-config libsndfile1-dev doxygen uuid-dev libasound2-dev libjack-jackd2-dev dssi-dev lv2-dev libsqlite3-dev

RUN mkdir /debs
COPY debs/*.deb /debs/

RUN dpkg -i /debs/libgig-dev_4.4.1_arm64.deb /debs/libgig11_4.4.1_arm64.deb && rm -rf /debs


WORKDIR /build
