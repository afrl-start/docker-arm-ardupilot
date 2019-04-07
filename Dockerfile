# Parameters
# ----------
# VERSION: the GitHub release/tag/commit of ArduPilot that should be built.
#
FROM arm32v7/ubuntu:16.04
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      autoconf \
      automake \
      build-essential \
      ca-certificates \
      cmake \
      gcc \
      gfortran \
      git \
      g++ \
      libxml2-dev \
      libxslt-dev \
      libexpat1-dev \
      libtool \
      libfreetype6-dev \
      libpng-dev \
      liblapack-dev \
      make \
      openssl \
      pkg-config \
      python \
      python-pip \
      python-dev \
      wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install bear
RUN cd /tmp \
 && wget -nv https://github.com/rizsotto/Bear/archive/2.3.11.tar.gz \
 && tar -xf 2.3.11.tar.gz \
 && cd Bear-2.3.11 \
 && mkdir build \
 && cd build \
 && cmake .. \
 && make all \
 && make install \
 && rm -rf /tmp/*

# install python packages
RUN pip install --no-cache-dir --upgrade pip==9.0.3 \
 && pip install --user --no-cache-dir setuptools wheel \
 && pip install --user --no-cache-dir \
      pyserial \
      pexpect \
      future \
      mavproxy \
      gcovr \
      pymavlink==2.2.10

ARG VERSION
WORKDIR /opt/ardupilot
RUN mkdir -p /opt \
 && git clone https://github.com/ArduPilot/ardupilot /opt/ardupilot \
 && cd /opt/ardupilot \
 && git checkout "${VERSION}" \
 && ./waf configure \
 && ./waf configure \
 && bear ./waf build -j2
COPY copter.parm /opt/ardupilot/copter.parm

ENV PATH "${PATH}:/opt/ardupilot/Tools/autotest"

# Unfortunately, we need to build Dronekit from source to avoid the
# dependency hell created by the latest stable release on PyPI.
RUN git clone https://github.com/dronekit/dronekit-python /tmp/dronekit \
 && git clone https://github.com/dronekit/dronekit-sitl /tmp/dronekit-sitl \
 && cd /tmp/dronekit \
 && git checkout a20eadf92b5d30940a7533a8a57a39273cdf3938 \
 && pip install --no-cache-dir . \
 && cd /tmp/dronekit-sitl \
 && git checkout 9a2d6592f7844d7df17d417cd33a9de8386cdaae \
 && pip install --no-cache-dir . \
 && rm -rf /tmp/*
