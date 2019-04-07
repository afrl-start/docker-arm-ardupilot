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
      python \
      python-pip \
      python-dev \
      wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
