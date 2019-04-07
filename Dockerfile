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

# Copter-3.6.4
# TODO use build arg
WORKDIR /opt/ardupilot
RUN mkdir -p /opt \
 && git clone https://github.com/ArduPilot/ardupilot /opt/ardupilot \
 && cd /opt/ardupilot \
 && git checkout Copter-3.6.4 \
 && ./waf configure \
 && ./waf configure \
 && bear ./waf build -j8
