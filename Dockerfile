FROM debian:bookworm

RUN apt update
RUN apt install -yy build-essential debhelper pkg-config libsndfile1-dev doxygen uuid-dev \
                    libasound2-dev libjack-jackd2-dev dssi-dev lv2-dev libsqlite3-dev \
                    cmake libqt6svg6-dev qt6-base-dev qt6-tools-dev qt6-tools-dev-tools libx11-dev liblscp-dev

RUN mkdir /debs
COPY debs/*.deb /debs/

RUN apt install -yy libgig-dev libgtk2.0-dev liblrdf0-dev libxml2-dev

#RUN dpkg -i /debs/libgig-dev_4.4.1_arm64.deb /debs/libgig11_4.4.1_arm64.deb && rm -rf /debs


WORKDIR /build
