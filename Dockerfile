FROM stackbrew/ubuntu:13.04
MAINTAINER "Kasumi Hanazuki"

RUN apt-get update
RUN apt-get install -y --no-install-recommends ca-certificates git
RUN apt-get install -y --no-install-recommends build-essential clang-3.2 llvm-3.2-dev python2.7 nodejs

RUN git clone --depth=1 https://github.com/kripken/emscripten /opt/emscripten

ENV PATH /opt/emscripten:/usr/local/bin:/usr/bin:/bin
RUN emcc -V

VOLUME ["/src"]
WORKDIR /src
