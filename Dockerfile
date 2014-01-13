FROM stackbrew/ubuntu:saucy
MAINTAINER "Kasumi Hanazuki"

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
  ca-certificates git build-essential cmake scons \
  python nodejs default-jre-headless clang llvm

RUN git clone --depth=1 https://github.com/kripken/emscripten /opt/emscripten

ENV PATH /opt/emscripten:/usr/local/bin:/usr/bin:/bin
RUN emcc -V

VOLUME ["/src"]
WORKDIR /src
