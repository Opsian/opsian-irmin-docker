FROM ubuntu:20.04
ENV DEBIAN_FRONTEND="noninteractive" TZ="Europe/London"
RUN apt update && apt install -y opam curl ubuntu-dbgsym-keyring lsb-release
RUN echo "deb http://ddebs.ubuntu.com $(lsb_release -cs) main restricted universe multiverse" >> /etc/apt/sources.list.d/ddebs.list
RUN echo "deb http://ddebs.ubuntu.com $(lsb_release -cs)-updates main restricted universe multiverse" >> /etc/apt/sources.list.d/ddebs.list
RUN echo "deb http://ddebs.ubuntu.com $(lsb_release -cs)-proposed main restricted universe multiverse" >> /etc/apt/sources.list.d/ddebs.list
RUN apt update
WORKDIR /
RUN opam init --disable-sandboxing -a --yes --bare && opam switch create 4.12.0
RUN opam install dune
RUN mkdir ~/.ssh
RUN touch ~/.ssh
RUN ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
RUN git clone --recurse-submodules https://github.com/Opsian/opsian-ocaml
RUN git clone https://github.com/mirage/irmin
workdir irmin
# a released version that will reliably build
RUN git checkout 2.7.2
# pin and build opsian
RUN apt install -y autoconf libc6-dev libpthread-stubs0-dev libtool liblzma-dev
RUN opam pin -y --debug -vv add opsian git+file:///opsian-ocaml#main
RUN opam install -y --debug -vv opsian
# TODO: COPY ./irmin.patch .
RUN apt install -y gnuplot-x11
RUN apt install -y pkg-config
RUN apt install -y libffi-dev libgmp-dev
RUN opam install -y .

