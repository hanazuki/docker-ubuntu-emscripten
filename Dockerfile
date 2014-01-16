FROM stackbrew/ubuntu:saucy
MAINTAINER "Kasumi Hanazuki"

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
  ca-certificates git build-essential cmake scons \
  python nodejs default-jre-headless clang llvm

RUN git clone --depth=1 https://github.com/kripken/emscripten /opt/emscripten
RUN for prog in em++ em-config emar emcc emconfigure emmake emranlib emrun emscons; do \
  ln -sf /opt/emscripten/$prog /usr/local/bin; done

# build an example code in order to cache the standard libraries and relooper
RUN emcc --version && \
  mkdir -p /tmp/emscripten_temp && cd /tmp/emscripten_temp && \
  EMCC_FORCE_STDLIBS=1 em++ -O2 /opt/emscripten/tests/hello_world_sdl.cpp -o hello.js && \
  (nodejs hello.js 2> /dev/null | grep hello) && \
  rm -rf /tmp/emscripten_temp

VOLUME ["/src"]
WORKDIR /src
