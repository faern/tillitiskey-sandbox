FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y build-essential clang lld bison flex libreadline-dev \
    gawk tcl-dev libffi-dev git mercurial graphviz   \
    xdot pkg-config python3 libftdi-dev \
    python3-dev libboost-dev libeigen3-dev \
    libboost-dev libboost-filesystem-dev \
    libboost-thread-dev libboost-program-options-dev \
    libboost-iostreams-dev cmake libhidapi-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/YosysHQ/icestorm && cd icestorm \
    && make -j$(nproc) && make install \
    && cd .. && rm -rf icestorm

RUN git clone -b interfaces https://github.com/tillitis/icestorm tillitis--icestorm \
    && cd tillitis--icestorm/iceprog \
    && make && make PROGRAM_PREFIX=tillitis- install \
    && cd ../.. && rm -rf tillitis--icestorm

RUN git clone https://github.com/YosysHQ/yosys \
    && cd yosys \
    && git checkout 06ef3f264afaa3eaeab45cc0404d8006c15f02b1 \
    && make -j$(nproc) && make install \
    && cd .. && rm -rf yosys

RUN git clone https://github.com/YosysHQ/nextpnr \
    && cd nextpnr \
    && cmake -DARCH=ice40 -DCMAKE_INSTALL_PREFIX=/usr/local . \
    && make -j$(nproc) && make install \
    && cd .. && rm -rf nextpnr

